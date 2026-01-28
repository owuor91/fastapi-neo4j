from app.models.post import (
    PostCreate,
    PostResponse,
    CommentCreate,
    CommentResponse,
)
from neo4j import AsyncSession
from datetime import datetime, timezone
import uuid
from typing import Optional, List


class PostService:

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_post(
        self, user_id: str, post_create: PostCreate
    ) -> PostResponse:
        post_id = str(uuid.uuid4())
        created_at = datetime.now(timezone.utc).isoformat()

        query = """
        MATCH (u:User {user_id: $user_id})

        CREATE (p:Post {
            post_id: $post_id,
            content: $content,
            image_url: $image_url,
            author_id: $user_id,
            author_username: u.username,
            created_at: datetime($created_at)
        })

        CREATE (u)-[:POSTED {created_at: datetime($created_at)}]->(p)
        RETURN p, u.user_id AS author_id, u.username AS author_username
        """

        result = await self.session.run(
            query,
            user_id=user_id,
            post_id=post_id,
            content=post_create.content,
            image_url=post_create.image_url,
            created_at=created_at,
        )

        record = await result.single()
        post_node = record["p"]

        return PostResponse(
            post_id=post_node["post_id"],
            content=post_node["content"],
            image_url=post_node.get("image_url"),
            author_id=record["author_id"],
            author_username=record["author_username"],
            created_at=post_node["created_at"],
            likes_count=0,
            comments_count=0,
            is_liked=False,
        )

    async def get_post(
        self, post_id: str, current_user_id: Optional[str] = None
    ) -> Optional[PostResponse]:
        query = """
        MATCH (u:User)-[:POSTED]->(p:Post {post_id: $post_id})

        OPTIONAL MATCH (liker:User)-[:LIKES]->(p)
        WITH p, u, COUNT(DISTINCT liker) AS likes_count

        OPTIONAL MATCH (p)<-[:COMMENTED_ON]-(c:Comment)
        WITH p, u, likes_count, COUNT(DISTINCT c) AS comments_count

        OPTIONAL MATCH (current_user:User {user_id: $current_user_id})-[like:LIKES]->(p)

        RETURN p, u.user_id AS author_id, u.username AS author_username, likes_count, comments_count, like IS NOT NULL AS is_liked

        """

        result = await self.session.run(
            query, post_id=post_id, current_user_id=current_user_id
        )

        record = await result.single()
        if not record:
            return None

        post_node = record["p"]
        return PostResponse(
            post_id=post_node["post_id"],
            content=post_node["content"],
            image_url=post_node.get("image_url"),
            author_id=record["author_id"],
            author_username=record["author_username"],
            created_at=post_node["created_at"],
            likes_count=record["likes_count"],
            comments_count=record["comments_count"],
            is_liked=record["is_liked"],
        )

    async def like_post(self, user_id: str, post_id: str) -> bool:
        query = """
        MATCH (u:User {user_id: $user_id})
        MATCH (p:Post {post_id: $post_id})

        MERGE (u)-[r:LIKES]->(p)
        ON CREATE SET r.created_at = datetime($created_at)
        RETURN r
        """
        result = await self.session.run(
            query,
            post_id=post_id,
            user_id=user_id,
            created_at=datetime.now(timezone.utc).isoformat(),
        )

        record = await result.single()
        if not record:
            return False

        return True

    async def unlike_post(self, user_id: str, post_id: str) -> bool:
        query = f"""
        MATCH (u:User {user_id: $user_id})-[r:LIKES]->(p:Post {post_id: $post_id})
        DELETE r
        RETURN COUNT(r) AS deleted_count
        """
        result = await self.session.run(
            query, post_id=post_id, user_id=user_id
        )

        record = await result.single()
        if not record:
            return False

        return record["deleted_count"] > 0

    async def create_comment(
        self, user_id: str, post_id: str, comment_create: CommentCreate
    ) -> CommentResponse:
        comment_id = str(uuid.uuid4())
        created_at = datetime.now(timezone.utc).isoformat()

        query = """
        MATCH (u:User {user_id: $user_id})
        MATCH (p:Post {post_id: $post_id})

        CREATE (c: Comment {
            comment_id: $comment_id,
            content: $content,
            author_id: $user_id,
            author_username: u.username,
            created_at: datetime($created_at)
        })

        CREATE (u)-[:COMMENTED]->(c)
        CREATE (c)-[:COMMENTED_ON]->(p)
        RETURN c, u.user_id AS author_id, u.username AS author_username
        """
        result = await self.session.run(
            query,
            comment_id=comment_id,
            content=comment_create.content,
            user_id=user_id,
            post_id=post_id,
            created_at=created_at,
        )

        record = await result.single()
        if not record:
            raise ValueError("Failed to create comment")

        comment_node = record["c"]
        return CommentResponse(
            comment_id=comment_node["comment_id"],
            content=comment_node["content"],
            author_id=record["author_id"],
            author_username=record["author_username"],
            created_at=comment_node["created_at"],
        )

    async def get_post_comments(
        self, post_id: str, limit: int = 50
    ) -> List[CommentResponse]:
        query = """
        MATCH (p:Post {post_id: $post_id})<-[:COMMENTED_ON]-(c:Comment)
        MATCH (u:User)-[:COMMENTED]->(c)

        RETURN c, u.user_id AS author_id, u.username AS author_username
        ORDER BY c.created_at DESC
        LIMIT $limit
        """

        result = await self.session.run(query, post_id=post_id, limit=limit)

        comments = []
        async for record in result:
            comment_node = record["c"]
            comments.append(
                CommentResponse(
                    comment_id=comment_node["comment_id"],
                    content=comment_node["content"],
                    author_id=record["author_id"],
                    author_username=record["author_username"],
                    created_at=comment_node["created_at"],
                )
            )
        return comments

    async def delete_post(self, user_id: str, post_id: str) -> bool:
        query = """
        MATCH (u:User {user_id: $user_id})-[:POSTED]->(p:Post {post_id: $post_id})
        DETACH DELETE p
        RETURN COUNT(p) AS deleted_count
        """
        result = await self.session.run(
            query, post_id=post_id, user_id=user_id
        )

        record = await result.single()
        if not record:
            return False

        return record["deleted_count"] > 0

from neo4j import AsyncSession
from datetime import datetime, timezone
from typing import Optional, List
from app.models.user import UserResponse
from app.models.post import PostResponse


class SocialService:

    def __init__(self, session: AsyncSession):
        self.session = session

    async def follow_user(self, follower_id: str, following_id: str) -> bool:
        if follower_id == following_id:
            raise ValueError("You cannot follow yourself")

        created_at = datetime.now(timezone.utc).isoformat()

        query = """
        MATCH (follower: User {user_id: $follower_id})
        MATCH (following: User {user_id: $following_id})

        MERGE (follower)-[r:FOLLOWS]->(following)
        ON CREATE SET r.created_at = datetime($created_at)
        return r
        """

        result = await self.session.run(
            query,
            follower_id=follower_id,
            following_id=following_id,
            created_at=created_at,
        )

        record = await result.single()
        return record is not None

    async def unfollow_user(self, follower_id: str, following_id: str) -> bool:
        if follower_id == following_id:
            raise ValueError("You cannot unfollow yourself")

        query = """
        MATCH (follower: User {user_id: $follower_id})-[r:FOLLOWS]->(following: User {user_id: $following_id})
        DELETE r
        RETURN count(r) AS deleted_count
        """

        result = await self.session.run(
            query,
            follower_id=follower_id,
            following_id=following_id,
        )

        record = await result.single()
        return record["deleted_count"] > 0

    async def get_followers(
        self, user_id: str, limit: int = 50
    ) -> List[UserResponse]:
        query = """
        MATCH (follower: User)-[:FOLLOWS]->(u:User {user_id: $user_id})
        return follower

        OPTIONAL MATCH (follower)-[:FOLLOWS]->(following)
        WITH follower, COUNT(DISTINCT following) AS following_count

        OPTIONAL MATCH (f:User)-[:FOLLOWS]->(follower)
        WITH follower, following_count, COUNT(DISTINCT f) AS follower_count

        RETURN follower, following_count, follower_count
        ORDER BY follower.username
        LIMIT $limit
        """

        result = await self.session.run(
            query,
            user_id=user_id,
            limit=limit,
        )

        followers = []

        async for record in result:
            user_node = record["follower"]
            followers.append(
                UserResponse(
                    user_id=user_node["user_id"],
                    email=user_node["email"],
                    username=user_node["username"],
                    full_name=user_node["full_name"],
                    bio=user_node["bio"],
                    created_at=user_node["created_at"],
                    follower_count=record["follower_count"],
                    following_count=record["following_count"],
                )
            )

        return followers

    async def get_following(
        self, user_id: str, limit: int = 50
    ) -> List[UserResponse]:
        query = f"""
        MATCH (u:User {user_id: $user_id})-[:FOLLOWS]->(following:User)
        return following
        """

        result = await self.session.run(
            query,
            user_id=user_id,
            limit=limit,
        )

        following = []
        async for record in result:
            user_node = record["following"]
            following.append(
                UserResponse(
                    user_id=user_node["user_id"],
                    email=user_node["email"],
                    username=user_node["username"],
                    full_name=user_node["full_name"],
                    bio=user_node["bio"],
                    created_at=user_node["created_at"],
                )
            )

        return following

    async def get_mutual_followers(
        self, user1_id: str, user2_id: str
    ) -> List[UserResponse]:
        query = """
        MATCH (mutual: User)-[:FOLLOWS]->(u1:User {user_id: $user1_id})
        MATCH (mutual)-[:FOLLOWS]->(u2:User {user_id: $user2_id})
        WHERE u1 <> u2
        RETURN DISTINCT mutual
        ORDER BY mutual.username
        """

        result = await self.session.run(
            query,
            user1_id=user1_id,
            user2_id=user2_id,
        )

        mutual_followers = []
        async for record in result:
            user_node = record["mutual"]
            mutual_followers.append(
                UserResponse(
                    user_id=user_node["user_id"],
                    email=user_node["email"],
                    username=user_node["username"],
                    full_name=user_node["full_name"],
                    bio=user_node["bio"],
                    created_at=user_node["created_at"],
                )
            )

        return mutual_followers

    async def get_feed(
        self, user_id: str, limit: int = 50
    ) -> List[PostResponse]:
        query = """
        MATCH (me:User {user_id: $user_id})

        MATCH (author: User)-[:POSTED]->(p:Post)
        WHERE author.user_id = me.user_id OR (me)-[:FOLLOWS]->(author)

        OPTIONAL MATCH (liker: User)-[:LIKES]->(p)
        WITH p, author, COUNT(DISTINCT liker) AS likes_count

        OPTIONAL MATCH (p) <-[:COMMENTED_ON]-(c:Comment)
        WITH p, author, likes_count, COUNT(DISTINCT c) AS comments_count

        OPTIONAL MATCH (me: User {user_id: $user_id})-[like:LIKES]->(p)

        RETURN p, author, likes_count, comments_count, like IS NOT NULL AS is_liked
        ORDER BY p.created_at DESC
        LIMIT $limit
        """

        result = await self.session.run(
            query,
            user_id=user_id,
            limit=limit,
        )

        feed = []
        async for record in result:
            post_node = record["p"]
            author_node = record["author"]
            feed.append(
                PostResponse(
                    post_id=post_node["post_id"],
                    content=post_node["content"],
                    image_url=post_node["image_url"],
                    author_id=author_node["user_id"],
                    author_username=author_node["username"],
                    created_at=post_node["created_at"],
                    likes_count=record["likes_count"],
                    comments_count=record["comments_count"],
                    is_liked=record["is_liked"],
                )
            )

        return feed

    async def suggest_users(
        self, user_id: str, limit: int = 50
    ) -> List[UserResponse]:
        query = """
        MATCH (me:User {user_id: $user_id})-[:FOLLOWS]->(friend)
        MATCH(friend)-[:FOLLOWS]->(suggestion: User)
        WHERE suggestion <> me AND NOT (me)-[:FOLLOWS]->(suggestion)

        WITH suggestion, COUNT(DISTINCT friend) AS common_connections_count

        OPTIONAL MATCH (follower: User)-[:FOLLOWS]->(suggestion)
        WITH suggestion, common_connections_count, COUNT(DISTINCT follower) AS follower_count

        OPTIONAL MATCH (suggestion)-[:FOLLOWS]->(following)
        WITH suggestion, common_connections_count, follower_count, COUNT(DISTINCT following) AS following_count

        RETURN suggestion, common_connections_count, follower_count, following_count
        ORDER BY common_connections_count DESC, follower_count DESC
        LIMIT $limit
        """

        result = await self.session.run(
            query,
            user_id=user_id,
            limit=limit,
        )

        suggestions = []
        async for record in result:
            user_node = record["suggestion"]
            suggestions.append(
                UserResponse(
                    user_id=user_node["user_id"],
                    email=user_node["email"],
                    username=user_node["username"],
                    full_name=user_node["full_name"],
                    bio=user_node["bio"],
                    created_at=user_node["created_at"],
                    common_connections_count=record[
                        "common_connections_count"
                    ],
                    follower_count=record["follower_count"],
                    following_count=record["following_count"],
                )
            )
        return suggestions

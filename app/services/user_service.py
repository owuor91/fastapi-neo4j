from neo4j import AsyncSession
from app.models.user import UserCreate, UserResponse
from app.utils.security import hash_password
from datetime import datetime, timezone
from typing import Optional, List
from app.utils.security import verify_password
import uuid


class UserService:

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_user(self, user_create: UserCreate) -> UserResponse:
        hashed_password = hash_password(user_create.password)
        user_id = str(uuid.uuid4())
        created_at = datetime.now(timezone.utc).isoformat()

        query = """
        //Query for existing user by email or username

        OPTIONAL MATCH (existing:User)
        WHERE existing.email = $email OR existing.username = $username
        WITH existing
        WHERE existing IS NULL

        CREATE (u:User{
            user_id: $user_id,
            email: $email,
            username: $username,
            full_name: $full_name,
            bio: $bio,
            password_hash: $hashed_password,
            created_at: datetime($created_at)
        })
        RETURN u
        """

        result = await self.session.run(
            query,
            user_id=user_id,
            email=user_create.email,
            username=user_create.username,
            full_name=user_create.full_name,
            bio=user_create.bio,
            hashed_password=hashed_password,
            created_at=datetime.now(timezone.utc).isoformat(),
        )

        record = await result.single()
        if not record:
            raise ValueError(
                "User with given email or username already exists."
            )

        user_node = record["u"]
        return UserResponse(
            user_id=user_node["user_id"],
            email=user_node["email"],
            username=user_node["username"],
            full_name=user_node["full_name"],
            bio=user_node["bio"],
            created_at=user_node["created_at"],
            follower_count=0,
            following_count=0,
        )

    async def authenticate_user(
        self, email: str, password: str
    ) -> Optional[dict]:
        query = """
        MATCH (u:User {email: $email})
        RETURN u
        """

        result = await self.session.run(query, email=email)
        record = await result.single()

        if not record:
            return None

        user_node = record["u"]

        if not verify_password(password, user_node["password_hash"]):
            return None

        return {
            "user_id": user_node["user_id"],
            "email": user_node["email"],
            "username": user_node["username"],
            "full_name": user_node["full_name"],
            "bio": user_node["bio"],
            "created_at": user_node["created_at"],
        }

    async def get_user_profile(self, user_id: str) -> Optional[UserResponse]:
        query = f"""
        MATCH (u:User {user_id: $user_id})

        //count followers
        OPTIONAL MATCH (follower: User)-[:FOLLOWS]->(u)
        WITH u, COUNT(DISTINCT follower) AS follower_count

        //count following
        OPTIONAL MATCH (u)-[:FOLLOWS]->(following: User)
        WITH u, follower_count, COUNT(DISTINCT following) AS following_count

        //return user profile
        RETURN u, follower_count, following_count
        """

        result = await self.session.run(query, user_id=user_id)
        record = await result.single()

        if not record:
            return None

        user_node = record["u"]
        return UserResponse(
            user_id=user_node["user_id"],
            email=user_node["email"],
            username=user_node["username"],
            full_name=user_node["full_name"],
            bio=user_node["bio"],
            created_at=user_node["created_at"],
            follower_count=record["follower_count"],
            following_count=record["following_count"],
        )

    async def search_users(
        self, query_str: str, limit: int = 20
    ) -> List[UserResponse]:
        query = f"""
        MATCH (u:User)
        WHERE toLower(u.username) CONTAINS toLower($query) OR toLower(u.full_name)
        CONTAINS toLower($query)

        OPTIONAL MATCH (follower: User)-[:FOLLOWS]->(u)
        WITH u, COUNT(DISTINCT follower) AS follower_count

        OPTIONAL MATCH (u)-[:FOLLOWS]->(following: User)
        WITH u, follower_count, COUNT(DISTINCT following) AS following_count

        RETURN u, follower_count, following_count
        ORDER BY follower_count DESC    
        LIMIT $limit
        """

        result = await self.session.run(query, query=query_str, limit=limit)

        users = []
        async for record in result:
            user_node = record["u"]
            users.append(
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
        return users

from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.database import neo4j_connection
from app.routers import auth, social, users, posts


@asynccontextmanager
async def lifespan(app: FastAPI):
    await neo4j_connection.connect()
    yield
    await neo4j_connection.close()


app = FastAPI(title="Neo4J Social net API", lifespan=lifespan)

app.include_router(auth.auth_router)
app.include_router(social.social_router)
app.include_router(users.users_router)
app.include_router(posts.posts_router)

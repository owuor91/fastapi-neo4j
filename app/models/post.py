from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field, field_validator

from app.utils.neo4j_helpers import to_python_datetime


class PostCreate(BaseModel):
    content: str = Field(min_length=1, max_length=2000)
    image_url: Optional[str] = None


class PostResponse(BaseModel):
    post_id: str
    content: str
    image_url: Optional[str] = None
    author_id: str
    author_username: str
    created_at: datetime
    likes_count: int = 0
    comments_count: int = 0
    is_liked: bool = False

    @field_validator("created_at", mode="before")
    @classmethod
    def parse_created_at(cls, v):
        return to_python_datetime(v)


class LikePostResponse(BaseModel):
    post_id: str
    user_id: str
    created_at: datetime
    success: bool

    @field_validator("created_at", mode="before")
    @classmethod
    def parse_created_at(cls, v):
        return to_python_datetime(v)


class UnlikePostResponse(BaseModel):
    post_id: str
    user_id: str
    created_at: datetime
    success: bool

    @field_validator("created_at", mode="before")
    @classmethod
    def parse_created_at(cls, v):
        return to_python_datetime(v)


class CommentCreate(BaseModel):
    content: str = Field(min_length=1, max_length=200)


class CommentResponse(BaseModel):
    comment_id: str
    content: str
    author_id: str
    author_username: str
    created_at: datetime

    @field_validator("created_at", mode="before")
    @classmethod
    def parse_created_at(cls, v):
        return to_python_datetime(v)

from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


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


class CommentCreate(BaseModel):
    content: str = Field(min_length=1, max_length=200)


class CommentResponse(BaseModel):
    comment_id: str
    content: str
    author_id: str
    author_username: str
    created_at: datetime

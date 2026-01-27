from pydantic import BaseModel, Field, EmailStr, field_validator
from typing import Optional
from datetime import datetime


class UserBase(BaseModel):
    email: EmailStr
    username: str = Field(min_length=3, max_length=30)
    full_name: Optional[str] = None
    bio: Optional[str] = Field(None, max_length=200)

    @field_validator("username")
    @classmethod
    def username_alphanumeric(cls, v):
        if not v.replace("_", "").isalnum():
            raise ValueError(
                "Username must contain only alphanumeric characters and underscores"
            )
        return v


class UserCreate(UserBase):
    password: str = Field(min_length=8, max_length=100)


class UserResponse(UserBase):
    user_id: str
    created_at: datetime
    follower_count: int = 0
    following_count: int = 0

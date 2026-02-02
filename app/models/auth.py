from datetime import datetime

from pydantic import BaseModel, field_validator

from app.utils.neo4j_helpers import to_python_datetime


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    user_id: str


class LoginRequest(BaseModel):
    email: str
    password: str


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    username: str
    email: str
    full_name: str
    bio: str
    created_at: datetime

    @field_validator("created_at", mode="before")
    @classmethod
    def parse_created_at(cls, v):
        return to_python_datetime(v)


class TokenRefreshRequest(BaseModel):
    refresh_token: str


class TokenRefreshResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    username: str
    email: str
    full_name: str
    bio: str
    created_at: datetime

    @field_validator("created_at", mode="before")
    @classmethod
    def parse_created_at(cls, v):
        return to_python_datetime(v)

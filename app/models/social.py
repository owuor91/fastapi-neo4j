from datetime import datetime
from pydantic import BaseModel


class FollowResponse(BaseModel):
    follower_id: str
    followed_id: str
    created_at: datetime
    success: bool


class UnfollowResponse(BaseModel):
    follower_id: str
    followed_id: str
    created_at: datetime
    success: bool

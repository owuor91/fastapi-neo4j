from fastapi import APIRouter, Depends, HTTPException, status
from neo4j import AsyncSession

from app.models.user import UserResponse
from app.utils.dependencies import get_db_session, get_current_user
from app.services.social_service import SocialService
from typing import List
from app.models.post import PostResponse
from app.models.social import FollowResponse, UnfollowResponse

social_router = APIRouter(prefix="/social", tags=["social"])


@social_router.post("/follow/{user_id}", status_code=status.HTTP_200_OK)
async def follow_user(
    user_id: str,
    session: AsyncSession = Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> FollowResponse:
    social_service = SocialService(session)
    followed = await social_service.follow_user(current_user, user_id)
    return followed


@social_router.post("/unfollow/{user_id}", status_code=status.HTTP_200_OK)
async def unfollow_user(
    user_id: str,
    session: AsyncSession = Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> UnfollowResponse:
    social_service = SocialService(session)
    unfollowed = await social_service.unfollow_user(current_user, user_id)
    return unfollowed


@social_router.get(
    "/followers/{user_id}",
    response_model=List[UserResponse],
    status_code=status.HTTP_200_OK,
)
async def get_followers(
    user_id: str,
    session: AsyncSession = Depends(get_db_session),
    limit: int = 50,
) -> List[UserResponse]:
    social_service = SocialService(session)
    followers = await social_service.get_followers(user_id, limit)
    return followers


@social_router.get(
    "/following/{user_id}",
    response_model=List[UserResponse],
    status_code=status.HTTP_200_OK,
)
async def get_following(
    user_id: str,
    session: AsyncSession = Depends(get_db_session),
    limit: int = 50,
) -> List[UserResponse]:
    social_service = SocialService(session)
    following = await social_service.get_following(user_id, limit)
    return following


@social_router.get(
    "/mutual-followers/{user1_id}/{user2_id}",
    response_model=List[UserResponse],
    status_code=status.HTTP_200_OK,
)
async def get_mutual_followers(
    user1_id: str,
    user2_id: str,
    session: AsyncSession = Depends(get_db_session),
) -> List[UserResponse]:
    social_service = SocialService(session)
    mutual_followers = await social_service.get_mutual_followers(
        user1_id, user2_id
    )
    return mutual_followers


@social_router.get(
    "/feed",
    response_model=List[PostResponse],
    status_code=status.HTTP_200_OK,
)
async def get_feed(
    user_id: str = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
    limit: int = 50,
) -> List[PostResponse]:
    social_service = SocialService(session)
    feed = await social_service.get_feed(user_id, limit)
    return feed


@social_router.get(
    "/suggestions/{user_id}",
    response_model=List[UserResponse],
    status_code=status.HTTP_200_OK,
)
async def get_suggestions(
    user_id: str,
    session: AsyncSession = Depends(get_db_session),
    limit: int = 50,
) -> List[UserResponse]:
    social_service = SocialService(session)
    suggestions = await social_service.suggest_users(user_id, limit)
    return suggestions

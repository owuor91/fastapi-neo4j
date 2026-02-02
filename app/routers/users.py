from fastapi import APIRouter, Depends, HTTPException, status
from app.models.user import UserResponse
from app.utils.dependencies import get_db_session, get_current_user
from app.services.user_service import UserService
from typing import List

users_router = APIRouter(prefix="/users", tags=["users"])


@users_router.get(
    "/me", response_model=UserResponse, status_code=status.HTTP_200_OK
)
async def get_current_user(
    session: Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> UserResponse:
    user_service = UserService(session)
    user = await user_service.get_user_profile(current_user)
    return user


@users_router.get(
    "/{user_id}", response_model=UserResponse, status_code=status.HTTP_200_OK
)
async def get_user_profile(
    session: Depends(get_db_session), user_id: str
) -> UserResponse:
    user_service = UserService(session)
    user = await user_service.get_user_profile(user_id)
    return user


@users_router.search(
    "/search",
    response_model=List[UserResponse],
    status_code=status.HTTP_200_OK,
)
async def search_users(
    session: Depends(get_db_session), q: str, limit: int = 20
):
    user_service = UserService(session)
    users = await user_service.search_users(q, limit)
    return users

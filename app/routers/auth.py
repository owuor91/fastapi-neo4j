from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from neo4j import AsyncSession

from app.models.user import UserCreate, UserResponse
from app.utils.dependencies import get_db_session, get_current_user
from app.services.user_service import UserService
from app.models.auth import (
    LoginRequest,
    LoginResponse,
    TokenRefreshRequest,
    TokenRefreshResponse,
)
from app.utils.security import create_access_token, create_refresh_token
from app.utils.security import decode_refresh_token

auth_router = APIRouter(prefix="/auth", tags=["authentication"])


@auth_router.post(
    "/signup", response_model=UserResponse, status_code=status.HTTP_201_CREATED
)
async def signup(
    user_create: UserCreate,
    session: AsyncSession = Depends(get_db_session),
) -> UserResponse:
    user_service = UserService(session)
    try:
        user = await user_service.create_user(user_create)
        return user
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail=str(e)
        )


@auth_router.post(
    "/login", response_model=LoginResponse, status_code=status.HTTP_200_OK
)
async def login(
    login_request: LoginRequest,
    session: AsyncSession = Depends(get_db_session),
) -> LoginResponse:
    user_service = UserService(session)
    try:
        user = await user_service.authenticate_user(
            login_request.email, login_request.password
        )
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid credentials",
            )
        return LoginResponse(
            access_token=create_access_token(user),
            refresh_token=create_refresh_token(user),
            token_type="bearer",
            user_id=user["user_id"],
            username=user["username"],
            email=user["email"],
            full_name=user["full_name"],
            bio=user["bio"],
            created_at=user["created_at"],
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail=str(e)
        )


@auth_router.post(
    "/refresh",
    response_model=TokenRefreshResponse,
    status_code=status.HTTP_200_OK,
)
async def refresh_token(
    refresh_request: TokenRefreshRequest,
    session: AsyncSession = Depends(get_db_session),
) -> TokenRefreshResponse:
    payload = decode_refresh_token(refresh_request.refresh_token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired refresh token",
        )
    user_id = payload["user_id"]
    user_service = UserService(session)
    user = await user_service.get_user_profile(user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User no longer exists",
        )
    user_dict = {
        "user_id": user.user_id,
        "email": user.email,
        "username": user.username,
        "full_name": user.full_name,
        "bio": user.bio,
        "created_at": user.created_at,
    }
    return TokenRefreshResponse(
        access_token=create_access_token(user_dict),
        refresh_token=create_refresh_token(user_dict),
        token_type="bearer",
        user_id=user.user_id,
        username=user.username,
        email=user.email,
        full_name=user.full_name,
        bio=user.bio,
        created_at=user.created_at,
    )

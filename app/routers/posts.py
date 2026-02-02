from fastapi import APIRouter, Depends, HTTPException, status
from neo4j import AsyncSession

from app.models.post import (
    CommentCreate,
    CommentResponse,
    LikePostResponse,
    PostCreate,
    PostResponse,
    UnlikePostResponse,
)
from app.utils.dependencies import get_db_session, get_current_user
from app.services.post_service import PostService
from typing import List

posts_router = APIRouter(prefix="/posts", tags=["posts"])


@posts_router.post(
    "/", response_model=PostResponse, status_code=status.HTTP_201_CREATED
)
async def create_post(
    post_create: PostCreate,
    session: AsyncSession = Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> PostResponse:
    post_service = PostService(session)
    post = await post_service.create_post(current_user, post_create)
    return post


@posts_router.get(
    "/{post_id}", response_model=PostResponse, status_code=status.HTTP_200_OK
)
async def get_post(
    post_id: str, session: AsyncSession = Depends(get_db_session)
) -> PostResponse:
    post_service = PostService(session)
    post = await post_service.get_post(post_id)
    return post


@posts_router.post(
    "/{post_id}/like",
    response_model=LikePostResponse,
    status_code=status.HTTP_200_OK,
)
async def like_post(
    post_id: str,
    session: AsyncSession = Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> LikePostResponse:
    post_service = PostService(session)
    return await post_service.like_post(current_user, post_id)


@posts_router.post(
    "/{post_id}/unlike",
    response_model=UnlikePostResponse,
    status_code=status.HTTP_200_OK,
)
async def unlike_post(
    post_id: str,
    session: AsyncSession = Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> UnlikePostResponse:
    post_service = PostService(session)
    return await post_service.unlike_post(current_user, post_id)


@posts_router.post(
    "/{post_id}/comment",
    response_model=CommentResponse,
    status_code=status.HTTP_201_CREATED,
)
async def comment_on_post(
    post_id: str,
    comment_create: CommentCreate,
    session: AsyncSession = Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> CommentResponse:
    post_service = PostService(session)
    comment = await post_service.create_comment(
        current_user, post_id, comment_create
    )
    return comment


@posts_router.get(
    "/{post_id}/comments",
    response_model=List[CommentResponse],
    status_code=status.HTTP_200_OK,
)
async def get_post_comments(
    post_id: str,
    session: AsyncSession = Depends(get_db_session),
    limit: int = 50,
) -> List[CommentResponse]:
    post_service = PostService(session)
    comments = await post_service.get_post_comments(post_id, limit)
    return comments

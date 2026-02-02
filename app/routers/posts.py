from fastapi import APIRouter, Depends, HTTPException, status
from app.models.post import PostCreate, PostResponse
from app.utils.dependencies import get_db_session, get_current_user
from app.services.post_service import PostService
from typing import List
from app.models.post import CommentCreate, CommentResponse

posts_router = APIRouter(prefix="/posts", tags=["posts"])


@posts_router.post(
    "/", response_model=PostResponse, status_code=status.HTTP_201_CREATED
)
async def create_post(
    post_create: PostCreate,
    session: Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> PostResponse:
    post_service = PostService(session)
    post = await post_service.create_post(current_user, post_create)
    return post


@posts_router.get(
    "/{post_id}", response_model=PostResponse, status_code=status.HTTP_200_OK
)
async def get_post(
    post_id: str, session: Depends(get_db_session)
) -> PostResponse:
    post_service = PostService(session)
    post = await post_service.get_post(post_id)
    return post


@posts_router.post("/{post_id}/like", status_code=status.HTTP_200_OK)
async def like_post(
    post_id: str,
    session: Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> bool:
    post_service = PostService(session)
    liked = await post_service.like_post(current_user, post_id)
    return liked


@posts_router.post("/{post_id}/unlike", status_code=status.HTTP_200_OK)
async def unlike_post(
    post_id: str,
    session: Depends(get_db_session),
    current_user: str = Depends(get_current_user),
) -> bool:
    post_service = PostService(session)
    unliked = await post_service.unlike_post(current_user, post_id)
    return unliked


@posts_router.post(
    "/{post_id}/comment",
    response_model=CommentResponse,
    status_code=status.HTTP_201_CREATED,
)
async def comment_on_post(
    post_id: str,
    comment_create: CommentCreate,
    session: Depends(get_db_session),
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
    session: Depends(get_db_session), post_id: str, limit: int = 50
) -> List[CommentResponse]:
    post_service = PostService(session)
    comments = await post_service.get_post_comments(post_id, limit)
    return comments

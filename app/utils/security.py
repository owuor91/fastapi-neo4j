from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta, timezone

from app.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> str:
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict) -> str:
    expire = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )
    to_encode = {"user_id": data["user_id"], "exp": expire}
    return jwt.encode(
        to_encode, settings.secret_key, algorithm=settings.algorithm
    )


def decode_access_token(token: str) -> dict:
    try:
        payload = jwt.decode(
            token, settings.secret_key, algorithms=[settings.algorithm]
        )
        return payload
    except JWTError as e:
        raise e


def decode_refresh_token(token: str) -> dict | None:
    """Decode and validate refresh token. Returns payload if valid, else None."""
    try:
        payload = jwt.decode(
            token, settings.secret_key, algorithms=[settings.algorithm]
        )
        if payload.get("type") != "refresh":
            return None
        if "user_id" not in payload:
            return None
        return payload
    except JWTError:
        return None


def create_refresh_token(data: dict) -> str:
    now = datetime.now(timezone.utc)
    expire = now + timedelta(days=7)
    to_encode = {
        "user_id": data["user_id"],
        "exp": expire,
        "iat": now,
        "type": "refresh",
    }
    return jwt.encode(
        to_encode, settings.secret_key, algorithm=settings.algorithm
    )

from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta, timezone

from app.config import settings
from app.utils.neo4j_helpers import to_python_datetime

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def _serialize_for_jwt(data: dict) -> dict:
    """Build JSON-serializable dict, excluding password_hash."""
    result = {}
    for k, v in data.items():
        if k == "password_hash":
            continue
        dt = to_python_datetime(v)
        result[k] = dt.isoformat() if isinstance(dt, datetime) else v
    return result


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> str:
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict) -> str:
    to_encode = _serialize_for_jwt(data)
    expire = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )
    to_encode["exp"] = expire
    encoded_jwt = jwt.encode(
        to_encode, settings.secret_key, algorithm=settings.algorithm
    )
    return encoded_jwt


def decode_access_token(token: str) -> dict:
    try:
        payload = jwt.decode(
            token, settings.secret_key, algorithms=[settings.algorithm]
        )
        return payload
    except JWTError as e:
        raise e


def create_refresh_token(data: dict) -> str:
    to_encode = _serialize_for_jwt(data)
    expire = datetime.now(timezone.utc) + timedelta(days=7)
    to_encode.update(
        {
            "exp": expire,
            "iat": datetime.now(timezone.utc),
            "type": "refresh",
        }
    )
    encoded_jwt = jwt.encode(
        to_encode, settings.secret_key, algorithm=settings.algorithm
    )
    return encoded_jwt

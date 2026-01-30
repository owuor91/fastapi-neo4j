from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from neo4j import AsyncSession
from app.database import neo4j_connection
from app.utils.security import decode_access_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")


async def get_db_session() -> AsyncSession:
    driver = neo4j_connection.get_driver()

    async with driver.session() as session:
        try:
            yield session
        finally:
            pass


async def get_current_user(token: str = Depends(oauth2_scheme)) -> str:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    token_data = decode_access_token(token)
    if not token_data:
        raise credentials_exception

    return token_data["user_id"]

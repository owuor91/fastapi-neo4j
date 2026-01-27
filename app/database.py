import logging
from neo4j import AsyncGraphDatabase
from app.config import settings

logger = logging.getLogger(__name__)

class Neo4jConnection:

    def __init__(self):
        self._driver = None

    async def connect(self):
        try:
            self._driver = AsyncGraphDatabase.driver(
                settings.neo4j_uri,
                auth=(settings.neo4j_user, settings.neo4j_password)
            )

            await self._driver.verify_connectivity()

            logger.info("Connected to Neo4j database")
        except Exception as e:
            logger.error(f"Failed to connect to Neo4j database: {e}")
            raise e
    

    async def close(self):
        if self._driver:
            await self._driver.close()
            logger.info("Disconnected from Neo4j database")

    
    def get_driver(self):
        return self._driver
        

neo4j_connection = Neo4jConnection()
        
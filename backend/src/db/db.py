from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from config.config import settings

async_engine = create_async_engine(
    settings.database_url_async,
    echo=True,
    pool_size=10,
    max_overflow=20,
)

async_session = async_sessionmaker(
    async_engine,
    expire_on_commit=False,
)

class Base(DeclarativeBase):
    pass

async def get_async_session():
    async with async_session() as session:
        yield session

from abc import ABC, abstractmethod
from sqlalchemy import select, text, insert, Uuid
from db.db import async_session
from uuid import UUID

class AbstractRepository(ABC):
    @abstractmethod
    async def get(self, id: UUID):
        pass

    @abstractmethod
    async def create(self, data: dict) -> UUID | None:
        pass

    @abstractmethod
    async def update(self, id: UUID, data):
        pass

    @abstractmethod
    async def delete(self, id: UUID):
        pass

class SQLAlchemyRepository(AbstractRepository):
    model = None
        
    async def get(self, id: UUID):
        async with async_session() as session:
            result = await session.execute(
                select(self.model).where(self.model.id == id))
            return result.scalar_one_or_none()

    async def create(self, data: dict) -> UUID | None:
        async with async_session() as session:
            new_record = self.model(**data)
            session.add(new_record)
            await session.commit()
            return new_record.id

    async def update(self, id: UUID, data):
        async with async_session() as session:
            await session.execute(
                text(f"UPDATE {self.model.__tablename__} SET {', '.join(f'{k} = :{k}' for k in data.keys())} WHERE id = :id"),
                {**data, 'id': id}
            )
            await session.commit()

    async def delete(self, id: UUID):
        async with async_session() as session:
            await session.execute(text(f"DELETE FROM {self.model.__tablename__} WHERE id = :id"), {'id': id})
            await session.commit()
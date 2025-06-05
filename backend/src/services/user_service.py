from utils.repository import AbstractRepository
from schemas.users import UserAdd
from uuid import UUID as uuid


class UsersService:
    def __init__(self, user_repository: AbstractRepository):
        self.user_repository: AbstractRepository = user_repository

    async def add_user(self, user_data: UserAdd) -> uuid | None:
        user_dict = user_data.model_dump()
        user_uuid = await self.user_repository.create(user_dict)
        return user_uuid
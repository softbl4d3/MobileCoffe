from utils.repository import SQLAlchemyRepository
from models.users import UserDb

class UsersRepository(SQLAlchemyRepository):
    model = UserDb
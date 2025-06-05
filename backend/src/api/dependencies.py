from repositories.users import UsersRepository
from services.user_service import UsersService

def users_service():
    return UsersService(UsersRepository())
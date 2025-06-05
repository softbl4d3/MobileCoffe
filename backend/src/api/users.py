from fastapi import FastAPI, Depends
from fastapi.routing import APIRouter
from schemas.users import UserAdd
from typing import Annotated
from api.dependencies import users_service
from services.user_service import UsersService

router = APIRouter( prefix="/users", tags=["users"])

@router.get("/")
async def get_users():
    return {"message": "List of users"}
    
@router.post("/")
async def create_user(
    user: UserAdd,
    user_service: Annotated[UsersService, Depends(users_service)]
    ):

    user_id = await user_service.add_user(user)
    return {"message": "User created", "user_id": user_id}
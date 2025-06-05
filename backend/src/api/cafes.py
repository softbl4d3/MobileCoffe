from fastapi import APIRouter

router = APIRouter(prefix="/cafes", tags=["cafes"])

@router.get("/")
async def get_cafes():
    return [{"id": 1, "name": "Cafe Rio"}]
from fastapi import FastAPI
import uvicorn
from api import users_router, cafes_router

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

app.include_router(users_router)
app.include_router(cafes_router)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)

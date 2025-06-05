from pydantic import BaseModel, Field
from uuid import UUID, uuid4
from datetime import datetime
from typing import Optional


class UserSchema(BaseModel):
    id: UUID
    name: str = Field(min_length=1, max_length=25)
    device: str | None = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: Optional[datetime] = None

class UserAdd(BaseModel):
    id: UUID
    name: str = Field(min_length=1, max_length=25)
    device: Optional[str] = None


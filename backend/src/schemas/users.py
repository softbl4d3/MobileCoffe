from pydantic import BaseModel, Field
from uuid import UUID
from datetime import datetime
from typing import Optional


class UserSchema(BaseModel):
    id: UUID
    name: str = Field(min_length=1, max_length=25)
    device: str | None = None
    created_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    updated_at: Optional[datetime] = None

    def to_db_model(self):
        from models.users import UserDb  
        return UserDb(
            id=self.id,
            name=self.name,
            device=self.device,
            created_at=self.created_at or datetime.utcnow(),
            updated_at=self.updated_at
        )

class UserAdd(BaseModel):
    id: UUID
    name: str = Field(min_length=1, max_length=25)
    device: Optional[str] = None


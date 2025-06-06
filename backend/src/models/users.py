from sqlalchemy.orm import mapped_column, Mapped
from db.db import Base
from schemas.users import UserSchema
from typing import Annotated
from uuid import UUID
from sqlalchemy import text, UUID as SA_UUID
from datetime import datetime

class UserDb(Base):
    __tablename__ = "users"
    id: Mapped[UUID] = mapped_column(SA_UUID(as_uuid=True), primary_key=True, unique=True)
    name: Mapped[str]= mapped_column(default="", nullable=True)
    device: Mapped[str] = mapped_column(nullable=False)
    created_at: Mapped[datetime] = mapped_column(nullable=False, server_default=text("TIMEZONE('utc', now())"))
    updated_at: Mapped[datetime] = mapped_column(nullable=False, server_default=text("TIMEZONE('utc', now())"), onupdate=text("TIMEZONE('utc',  now())"))
    def to_read_model(self) -> UserSchema:
        return UserSchema(
            id=self.id,
            name=self.name,
            device=self.device,
            created_at=self.created_at,
            updated_at=self.updated_at,
        )
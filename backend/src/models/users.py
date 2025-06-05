from sqlalchemy import (
    UUID,
    MetaData,
    text,
)
from sqlalchemy.orm import mapped_column, Mapped
from db.db import Base
import uuid
from datetime import datetime
from schemas.users import UserSchema

metadata = MetaData()

class UserDb(Base):
    __tablename__ = "users"
    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True),primary_key=True, unique=True,)
    name: Mapped[str]= mapped_column(default="", nullable=True)
    device: Mapped[str] = mapped_column(nullable=False)
    created_at: Mapped[datetime] = mapped_column(server_default=text("CURRENT_TIMESTAMP"))
    updated_at: Mapped[datetime] = mapped_column(server_default=text("CURRENT_TIMESTAMP"), onupdate=text("CURRENT_TIMESTAMP"))

    def to_read_model(self) -> UserSchema:
        return UserSchema(
            id=self.id,
            name=self.name,
            device=self.device,
            created_at=self.created_at,
            updated_at=self.updated_at,
        )
from sqlalchemy.orm import mapped_column, Mapped
from db.db import Base
from schemas.users import UserSchema
from datetime import datetime
from decimal import Decimal as decimal
from uuid import UUID
from sqlalchemy import text, UUID as SA_UUID
from datetime import datetime

class CafeDb(Base):
    __tablename__ = "cafes"
    id: Mapped[UUID] = mapped_column(SA_UUID(as_uuid=True), primary_key=True, unique=True)
    name: Mapped[str] = mapped_column(nullable=False, unique=True)
    address: Mapped[str] = mapped_column(nullable=False)
    opening_time: Mapped[datetime] = mapped_column(nullable=False)
    closing_time: Mapped[datetime] = mapped_column(nullable=False)
    latitude: Mapped[decimal] = mapped_column(nullable=False)
    longitude: Mapped[decimal] = mapped_column(nullable=False)
    created_at: Mapped[datetime] = mapped_column(nullable=False, server_default=text("TIMEZONE('utc', now())"))
    updated_at: Mapped[datetime] = mapped_column(nullable=False, server_default=text("TIMEZONE('utc', now())"), onupdate=text("TIMEZONE('utc',  now())"))

    
    def to_read_model(self):
        from schemas.cafes import CafeSchema
        return CafeSchema(
            id=self.id,
            name=self.name,
            address=self.address,
            opening_time=self.opening_time,
            closing_time=self.closing_time,
            latitude=self.latitude,
            longitude=self.longitude,
            created_at=self.created_at,
            updated_at=self.updated_at,
        )
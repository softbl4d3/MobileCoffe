from pydantic import BaseModel, Field
from uuid import UUID
from datetime import datetime
from typing import Optional
from decimal import Decimal as decimal



class CafeSchema(BaseModel):
    id: UUID
    name: str = Field(min_length=1, max_length=100)
    address: str = Field(min_length=1, max_length=255)
    opening_time: datetime
    closing_time: datetime
    latitude: decimal
    longitude: decimal
    created_at: Optional[datetime]
    updated_at: Optional[datetime] = None

    def to_db_model(self):
        from models.cafes import CafeDb
        return CafeDb(
            id=self.id,
            name=self.name,
            address=self.address,
            opening_time=self.opening_time,
            closing_time=self.closing_time,
            latitude=self.latitude,
            longitude=self.longitude,
            created_at=self.created_at or datetime.utcnow(),
            updated_at=self.updated_at
        )

class CafeAdd(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    address: str = Field(min_length=1, max_length=255)
    opening_time: datetime
    closing_time: datetime
    latitude: decimal
    longitude: decimal


from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from uuid import UUID

class ContactResponse(BaseModel):
    id: UUID
    name: str
    email: Optional[str]
    title: Optional[str]
    company: Optional[str]
    enrichment_status: str
    enrichment_data: Optional[dict] = None
    apex_score: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True

class ContactListResponse(BaseModel):
    success: bool
    contacts: list[ContactResponse]
    total: int
    limit: int
    offset: int

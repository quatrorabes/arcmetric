from sqlalchemy import Column, String, DateTime, JSON
from sqlalchemy.dialects.postgresql import UUID
from app.database import Base
from datetime import datetime
import uuid

class Contact(Base):
    __tablename__ = "contacts"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String, nullable=False)
    email = Column(String, nullable=True)
    title = Column(String, nullable=True)
    company = Column(String, nullable=True)
    phone = Column(String, nullable=True)
    linkedin_url = Column(String, nullable=True)
    
    enrichment_status = Column(String, default="pending")
    enrichment_data = Column(JSON, nullable=True)
    apex_score = Column(String, nullable=True)
    
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

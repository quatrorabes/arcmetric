import os
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))

from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
from uuid import UUID
import logging
import uvicorn

from app.database import engine, SessionLocal, Base, get_db
from app.config import settings
from app.models.contact import Contact
from app.schemas.contact import ContactResponse, ContactListResponse
from app.services.enrichment_engine import EnhancedEnrichmentEngine
from app.services.enrichment_integration import (
    integrate_enrichment_result,
    ContactNotFound,
)

# Logging
logger = logging.getLogger("arcmetric")
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

# Database
Base.metadata.create_all(bind=engine)

# FastAPI
app = FastAPI(
    title="ArcMetric Backend",
    description="AI-powered sales intelligence",
    version="1.0.0",
    docs_url="/docs",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

enrichment_engine = EnhancedEnrichmentEngine()

# Routes
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "arcmetric-backend",
        "timestamp": datetime.utcnow().isoformat()
    }

@app.get("/")
async def root():
    return {
        "service": "ArcMetric Backend",
        "docs": "/docs",
    }

@app.get("/api/v2/contacts")
async def list_contacts(limit: int = 100, offset: int = 0):
    db = SessionLocal()
    try:
        contacts = db.query(Contact).limit(limit).offset(offset).all()
        total = db.query(Contact).count()
        return {
            "success": True,
            "contacts": [ContactResponse.from_orm(c) for c in contacts],
            "total": total,
            "limit": limit,
            "offset": offset
        }
    finally:
        db.close()

@app.get("/api/v2/contacts/{contact_id}")
async def get_contact(contact_id: UUID):
    db = SessionLocal()
    try:
        contact = db.query(Contact).filter(Contact.id == contact_id).first()
        if not contact:
            raise HTTPException(status_code=404, detail="Contact not found")
        return {
            "success": True,
            "contact": ContactResponse.from_orm(contact)
        }
    finally:
        db.close()

@app.post("/api/v2/contacts/{contact_id}/enrich")
async def enrich_contact(
    contact_id: UUID,
    background_tasks: BackgroundTasks,
):
    db = SessionLocal()
    try:
        contact = db.query(Contact).filter(Contact.id == contact_id).first()
        if not contact:
            raise HTTPException(status_code=404, detail="Contact not found")
        
        if contact.enrichment_status == "processing":
            return {
                "success": True,
                "status": "processing",
                "contact_id": contact_id,
                "message": "Enrichment already in progress"
            }
        
        contact.enrichment_status = "processing"
        db.add(contact)
        db.commit()
        
        background_tasks.add_task(_run_enrichment, contact_id=contact_id)
        
        return {
            "success": True,
            "status": "processing",
            "contact_id": contact_id,
            "message": "Enrichment started"
        }
    finally:
        db.close()

async def _run_enrichment(contact_id: UUID):
    db = SessionLocal()
    try:
        logger.info(f"🚀 Enrichment started: {contact_id}")
        contact = db.query(Contact).filter(Contact.id == contact_id).first()
        if not contact:
            return
        
        result = await enrichment_engine.enrich(
            name=contact.name,
            email=contact.email or "",
            company=contact.company or "",
            title=contact.title or "",
            linkedin_url=contact.linkedin_url or ""
        )
        
        contact = integrate_enrichment_result(contact_id, result, db)
        logger.info(f"✅ Enrichment completed: {contact.name}")
    except Exception as e:
        logger.error(f"❌ Enrichment failed: {str(e)}")
    finally:
        db.close()

@app.on_event("startup")
async def startup():
    logger.info("🚀 ArcMetric Backend Starting...")

@app.on_event("shutdown")
async def shutdown():
    logger.info("🛑 ArcMetric Backend Shutting Down...")

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        reload=(settings.ENVIRONMENT != "production")
    )

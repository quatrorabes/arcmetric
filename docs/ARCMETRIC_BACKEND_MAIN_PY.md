# backend/main.py
# ArcMetric - Production FastAPI Backend
# Entry point for Render deployment

import os
import sys
from pathlib import Path

# Add app directory to path
sys.path.insert(0, str(Path(__file__).parent))

from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
from uuid import UUID
import logging

# ============================================================================
# IMPORTS FROM APP PACKAGE
# ============================================================================

from app.database import engine, SessionLocal, get_db
from app.config import settings
from app.models.contact import Base
from app.schemas.contact import ContactResponse, ContactListResponse
from app.services.enrichment_engine import EnhancedEnrichmentEngine
from app.services.enrichment_integration import (
    integrate_enrichment_result,
    ContactNotFound,
    IntegrationError,
    EnrichmentError
)
from app.models.contact import Contact

# ============================================================================
# LOGGING
# ============================================================================

logger = logging.getLogger("arcmetric")
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

# ============================================================================
# DATABASE SETUP
# ============================================================================

Base.metadata.create_all(bind=engine)

# ============================================================================
# FASTAPI APP
# ============================================================================

app = FastAPI(
    title="ArcMetric Backend",
    description="AI-powered sales intelligence platform",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# ============================================================================
# MIDDLEWARE
# ============================================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================================
# SERVICES
# ============================================================================

enrichment_engine = EnhancedEnrichmentEngine()

# ============================================================================
# PYDANTIC MODELS
# ============================================================================

class EnrichmentResponse(BaseModel):
    success: bool
    status: str
    contact_id: UUID
    message: str
    estimated_completion: Optional[datetime] = None

class ContactDetailResponse(BaseModel):
    success: bool
    contact: ContactResponse

# ============================================================================
# ENDPOINTS
# ============================================================================

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "arcmetric-backend",
        "version": "1.0.0",
        "environment": settings.ENVIRONMENT,
        "timestamp": datetime.utcnow().isoformat()
    }

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "service": "ArcMetric Backend",
        "version": "1.0.0",
        "docs": "/docs",
        "health": "/health"
    }

# ============================================================================
# CONTACT ENDPOINTS
# ============================================================================

@app.post("/api/v2/contacts/{contact_id}/enrich")
async def enrich_contact(
    contact_id: UUID,
    background_tasks: BackgroundTasks,
    db = next(get_db())
):
    """
    POST /api/v2/contacts/{contact_id}/enrich
    
    Triggers enrichment pipeline for a contact.
    Returns immediately, enrichment happens in background (~60-90 seconds).
    """
    try:
        # 1. FETCH CONTACT
        contact = db.query(Contact).filter(Contact.id == contact_id).first()
        if not contact:
            raise ContactNotFound(f"Contact {contact_id} not found")
        
        # 2. CHECK IF ALREADY PROCESSING
        if contact.enrichment_status == "processing":
            logger.info(f"⏳ Enrichment already in progress: {contact_id}")
            return EnrichmentResponse(
                success=True,
                status="processing",
                contact_id=contact_id,
                message="Enrichment already in progress. Please wait.",
                estimated_completion=datetime.utcnow() + timedelta(minutes=2)
            )
        
        # 3. MARK AS PROCESSING
        contact.enrichment_status = "processing"
        db.add(contact)
        db.commit()
        db.refresh(contact)
        
        logger.info(f"🔍 Enrichment triggered: {contact.name} ({contact_id})")
        
        # 4. QUEUE BACKGROUND TASK
        background_tasks.add_task(_run_enrichment, contact_id=contact_id)
        
        return EnrichmentResponse(
            success=True,
            status="processing",
            contact_id=contact_id,
            message="Enrichment in progress - check status endpoint in 60-90 seconds",
            estimated_completion=datetime.utcnow() + timedelta(minutes=2)
        )
    
    except ContactNotFound as e:
        logger.error(f"❌ Contact not found: {contact_id}")
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        logger.error(f"❌ Enrich endpoint error: {str(e)}")
        raise HTTPException(status_code=500, detail="Enrichment error")
    finally:
        db.close()

@app.get("/api/v2/contacts/{contact_id}")
async def get_contact(contact_id: UUID):
    """GET /api/v2/contacts/{contact_id} - Fetch single contact"""
    db = SessionLocal()
    try:
        contact = db.query(Contact).filter(Contact.id == contact_id).first()
        if not contact:
            raise HTTPException(status_code=404, detail="Contact not found")
        
        logger.info(f"📬 Fetched contact: {contact.name}")
        
        return ContactDetailResponse(
            success=True,
            contact=ContactResponse.from_orm(contact)
        )
    finally:
        db.close()

@app.get("/api/v2/contacts")
async def list_contacts(limit: int = 100, offset: int = 0):
    """GET /api/v2/contacts - List all contacts"""
    db = SessionLocal()
    try:
        contacts = db.query(Contact).limit(limit).offset(offset).all()
        total = db.query(Contact).count()
        
        logger.info(f"📋 Listed {len(contacts)} contacts (total: {total})")
        
        return ContactListResponse(
            success=True,
            contacts=[ContactResponse.from_orm(c) for c in contacts],
            total=total,
            limit=limit,
            offset=offset
        )
    finally:
        db.close()

# ============================================================================
# BACKGROUND TASKS
# ============================================================================

async def _run_enrichment(contact_id: UUID):
    """Background enrichment pipeline (~60-90 seconds)"""
    db = SessionLocal()
    try:
        logger.info(f"🚀 ENRICHMENT START: {contact_id}")
        
        # 1. FETCH CONTACT
        contact = db.query(Contact).filter(Contact.id == contact_id).first()
        if not contact:
            raise ContactNotFound(f"Contact {contact_id} not found")
        
        logger.info(f"   📋 {contact.name} @ {contact.company}")
        
        # 2. RUN PIPELINE
        logger.info(f"   📡 Stage 1: Person profile...")
        logger.info(f"   📡 Stage 2: Company intelligence...")
        logger.info(f"   📡 Stage 3: Sales context...")
        logger.info(f"   🧠 Stage 4: GPT-4 parsing...")
        
        enrichment_result = await enrichment_engine.enrich(
            name=contact.name,
            email=contact.email,
            company=contact.company,
            title=contact.title or "",
            linkedin_url=contact.linkedin_url or ""
        )
        
        # 3. INTEGRATE
        contact = integrate_enrichment_result(
            contact_id=contact_id,
            enrichment_result=enrichment_result,
            session=db
        )
        
        logger.info(f"✅ ENRICHMENT SUCCESS: {contact.name} | Score: {contact.apex_score}")
    
    except Exception as e:
        logger.error(f"❌ ENRICHMENT FAILED: {str(e)}")
        _handle_enrichment_failure(contact_id, str(e), db)
    
    finally:
        db.close()

def _handle_enrichment_failure(contact_id: UUID, error: str, session):
    """Handle enrichment failure"""
    try:
        contact = session.query(Contact).filter(Contact.id == contact_id).first()
        if contact:
            contact.enrichment_status = "failed"
            contact.enrichment_data = {
                "error": error,
                "timestamp": datetime.utcnow().isoformat(),
                "retry_at": (datetime.utcnow() + timedelta(hours=24)).isoformat()
            }
            session.add(contact)
            session.commit()
    except Exception as e:
        logger.error(f"❌ Failed to handle error: {str(e)}")

# ============================================================================
# STARTUP/SHUTDOWN
# ============================================================================

@app.on_event("startup")
async def startup_event():
    logger.info("=" * 70)
    logger.info("🚀 ArcMetric Backend Starting...")
    logger.info("=" * 70)
    logger.info(f"✅ Environment: {settings.ENVIRONMENT}")
    logger.info(f"✅ Database: PostgreSQL configured")
    logger.info(f"✅ Enrichment Engine: {enrichment_engine.__class__.__name__}")
    logger.info("✅ All systems ready")
    logger.info("=" * 70)

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("🛑 ArcMetric Backend Shutting Down...")

# ============================================================================
# ENTRY POINT
# ============================================================================

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 5000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        log_level="info",
        reload=settings.ENVIRONMENT != "production"
    )

from datetime import datetime
from sqlalchemy.orm import Session
from uuid import UUID
from app.models.contact import Contact

class ContactNotFound(Exception):
    pass

class IntegrationError(Exception):
    pass

class EnrichmentError(Exception):
    pass

def integrate_enrichment_result(
    contact_id: UUID,
    enrichment_result: dict,
    session: Session
) -> Contact:
    """Integrate enrichment results into contact"""
    contact = session.query(Contact).filter(Contact.id == contact_id).first()
    if not contact:
        raise ContactNotFound(f"Contact {contact_id} not found")
    
    contact.enrichment_status = "completed"
    contact.enrichment_data = enrichment_result
    contact.apex_score = str(enrichment_result.get("score", 0))
    contact.updated_at = datetime.utcnow()
    
    session.add(contact)
    session.commit()
    session.refresh(contact)
    
    return contact

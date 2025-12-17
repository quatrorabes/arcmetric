export const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:5000';

export const API_ENDPOINTS = {
  CONTACTS_LIST: `${API_BASE}/api/v2/contacts`,
  CONTACT_DETAIL: (id: string) => `${API_BASE}/api/v2/contacts/${id}`,
  CONTACT_ENRICH: (id: string) => `${API_BASE}/api/v2/contacts/${id}/enrich`,
};

export const ENRICHMENT_CONFIG = {
  POLL_INTERVAL: 2000,
  MAX_ATTEMPTS: 45,
};

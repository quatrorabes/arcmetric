export interface Contact {
  id: string;
  name: string;
  title?: string;
  email?: string;
  phone?: string;
  company?: string;
  enrichment_status: 'pending' | 'processing' | 'completed' | 'failed';
  enrichment_data?: any;
  apex_score?: string;
}

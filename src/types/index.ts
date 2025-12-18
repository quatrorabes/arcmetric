export interface Contact {
  id: number | string;
  name?: string;
  email?: string | null;
  phone?: string | null;
  company?: string | null;
  title?: string | null;
  linkedinurl?: string | null;
  enrichmentstatus?: string | null;
  enrichedat?: string | null;
  apexscore?: number | null;
  unifiedqualificationscore?: number | null;
}

export interface ContactsResponse {
  success: boolean;
  contacts: Contact[];
  total: number;
  limit: number;
  offset: number;
}

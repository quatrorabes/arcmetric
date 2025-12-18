export type UUID = string;

export interface Contact {
  id: UUID | number;
  name?: string;
  firstname?: string;
  lastname?: string;
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

export interface ContactsV2Response {
  success: boolean;
  contacts: Contact[];
  total: number;
  limit: number;
  offset: number;
}

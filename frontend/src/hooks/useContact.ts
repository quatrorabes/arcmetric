import { useState, useEffect } from 'react';
import { API_ENDPOINTS } from '../config/api';
import { Contact } from '../types';

export const useContact = (contactId: string) => {
  const [contact, setContact] = useState<Contact | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchContact = async () => {
      try {
        const res = await fetch(API_ENDPOINTS.CONTACT_DETAIL(contactId));
        const data = await res.json();
        setContact(data.contact);
      } catch (e) {
        setError('Error loading contact');
      } finally {
        setLoading(false);
      }
    };
    fetchContact();
  }, [contactId]);

  return { contact, loading, error };
};

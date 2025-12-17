import { useParams, useNavigate } from 'react-router-dom';
import { useContact } from '../hooks/useContact';
import { useState } from 'react';
import { API_ENDPOINTS, ENRICHMENT_CONFIG } from '../config/api';
import { Card } from '../components/Card';

export default function ContactDetail() {
  const { contactId } = useParams<{ contactId: string }>();
  const navigate = useNavigate();
  const { contact, loading, error } = useContact(contactId!);
  const [enriching, setEnriching] = useState(false);

  const handleEnrich = async () => {
    setEnriching(true);
    try {
      await fetch(API_ENDPOINTS.CONTACT_ENRICH(contactId!), {
        method: 'POST',
      });
      
      // Poll for completion
      let attempts = 0;
      const interval = setInterval(async () => {
        attempts++;
        const res = await fetch(API_ENDPOINTS.CONTACT_DETAIL(contactId!));
        const data = await res.json();
        
        if (data.contact.enrichment_status === 'completed' || attempts > ENRICHMENT_CONFIG.MAX_ATTEMPTS) {
          clearInterval(interval);
          setEnriching(false);
          window.location.reload();
        }
      }, ENRICHMENT_CONFIG.POLL_INTERVAL);
    } catch (e) {
      console.error(e);
      setEnriching(false);
    }
  };

  if (loading) return <div className="p-8">Loading...</div>;
  if (error || !contact) return <div className="p-8 text-red-500">{error || 'Contact not found'}</div>;

  return (
    <div className="p-8 max-w-4xl mx-auto">
      <button onClick={() => navigate('/')} className="mb-6 px-4 py-2 bg-blue-600 text-white rounded">
        ← Back
      </button>

      <div className="space-y-6">
        <Card title={contact.name}>
          <div className="space-y-2 text-gray-300">
            <p><strong>Email:</strong> {contact.email}</p>
            <p><strong>Title:</strong> {contact.title}</p>
            <p><strong>Company:</strong> {contact.company}</p>
          </div>
        </Card>

        {contact.enrichment_status === 'completed' && contact.enrichment_data && (
          <Card title="Enrichment Results">
            <pre className="text-sm overflow-auto bg-gray-900 p-4 rounded">
              {JSON.stringify(contact.enrichment_data, null, 2)}
            </pre>
          </Card>
        )}

        <button
          onClick={handleEnrich}
          disabled={enriching || contact.enrichment_status === 'processing'}
          className={`px-6 py-2 rounded font-semibold ${
            enriching || contact.enrichment_status === 'processing'
              ? 'bg-gray-600 text-gray-300 cursor-not-allowed'
              : 'bg-green-600 text-white hover:bg-green-700'
          }`}
        >
          {enriching || contact.enrichment_status === 'processing' ? 'Enriching...' : 'Enrich Profile'}
        </button>
      </div>
    </div>
  );
}

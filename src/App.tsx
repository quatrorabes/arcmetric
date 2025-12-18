import { BrowserRouter, Routes, Route, Link } from 'react-router-dom'
import { useState, useEffect } from 'react'

const API_URL = import.meta.env.VITE_API_URL || 'https://arcmetric.onrender.com'

interface Contact {
  id: number
  name: string
  email?: string
  company?: string
  title?: string
}

function Dashboard() {
  const [contacts, setContacts] = useState<Contact[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetch(`${API_URL}/api/v2/contacts?limit=10`)
      .then(res => res.json())
      .then(data => {
        setContacts(data.contacts || [])
        setLoading(false)
      })
      .catch(() => setLoading(false))
  }, [])

  if (loading) return <div style={{ padding: 20 }}>Loading...</div>

  return (
    <div style={{ padding: 20 }}>
      <h1>ArcMetric Dashboard</h1>
      <p>Connected to: {API_URL}</p>
      <h2>Contacts ({contacts.length})</h2>
      <ul>
        {contacts.map(c => (
          <li key={c.id}>
            <Link to={`/contact/${c.id}`}>{c.name}</Link> - {c.company || 'No company'}
          </li>
        ))}
      </ul>
    </div>
  )
}

function ContactDetail() {
  return <div style={{ padding: 20 }}><h1>Contact Detail</h1><Link to="/">Back</Link></div>
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/contact/:id" element={<ContactDetail />} />
      </Routes>
    </BrowserRouter>
  )
}

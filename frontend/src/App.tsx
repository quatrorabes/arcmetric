import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import ContactDetail from './pages/ContactDetail'

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/contacts/:contactId" element={<ContactDetail />} />
        <Route path="/" element={<div className="p-8">Welcome to ArcMetric</div>} />
      </Routes>
    </Router>
  )
}

export default App

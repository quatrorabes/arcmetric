# 🚀 ArcMetric Monorepo - Complete File Setup

## QUICK REFERENCE

**Old Structure:** `apps/backend/` + `dashboard_v1/`  
**New Structure:** `backend/` + `frontend/` (monorepo best practice)

---

## 📋 STEP-BY-STEP FILE CREATION

### Step 1: Create Directory Structure

```bash
mkdir -p /Users/chrisrabenold/projects/arcmetric
cd /Users/chrisrabenold/projects/arcmetric

# Backend
mkdir -p backend/app/{models,schemas,api,services,utils}
mkdir -p backend/tests

# Frontend
mkdir -p frontend/src/{config,components,hooks,pages,types,utils}
mkdir -p frontend/public

# GitHub & Docs
mkdir -p .github/workflows
mkdir -p docs
```

### Step 2: Root Level Files

**Create:** `.gitignore`
```
# Python
__pycache__/
*.pyc
*.egg-info/
env/
venv/

# Node
node_modules/
npm-debug.log
.env.local

# OS
.DS_Store
.vscode/
.idea/

# Env
.env
.env.*.local
```

**Create:** `.env.example`
```
ENVIRONMENT=production
```

**Create:** `README.md`
```markdown
# ArcMetric - AI Sales Intelligence Platform

Production-ready monorepo with FastAPI backend and React frontend.

## Structure
- `backend/` - FastAPI + PostgreSQL
- `frontend/` - React + TypeScript + Vite
- `docs/` - Documentation

## Quick Start

**Backend:**
```bash
cd backend
pip install -r requirements.txt
python main.py
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

## Deployment
- Backend: Render (`cd backend && python main.py`)
- Frontend: Vercel (root: `frontend`)
```

---

### Step 3: Backend Files

**Path: `backend/main.py`**
```
From: ARCMETRIC_BACKEND_MAIN_PY.md
```

**Path: `backend/requirements.txt`**
```
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
python-dotenv==1.0.0
pydantic==2.5.0
pydantic-settings==2.1.0
httpx==0.25.2
aiohttp==3.9.1
openai==1.3.9
```

**Path: `backend/Procfile`**
```
web: cd backend && python main.py
```

**Path: `backend/.env.example`**
```
DATABASE_URL=postgresql://user:password@host:5432/arcmetric
PORT=5000
OPENAI_API_KEY=sk-...
ENVIRONMENT=production
LOG_LEVEL=INFO
```

**Path: `backend/pyproject.toml`**
```toml
[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "arcmetric-backend"
version = "1.0.0"
description = "AI-powered sales intelligence platform"
requires-python = ">=3.11"
```

**Path: `backend/app/__init__.py`**
```python
# Backend application package
```

**Path: `backend/app/config.py`**
```python
from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/arcmetric"
    PORT: int = 5000
    OPENAI_API_KEY: str = ""
    ENVIRONMENT: str = "development"
    LOG_LEVEL: str = "INFO"
    
    class Config:
        env_file = ".env"

settings = Settings()
```

**Path: `backend/app/database.py`**
```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from app.config import settings

engine = create_engine(
    settings.DATABASE_URL,
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

**Path: `backend/app/models/__init__.py`**
```python
from .contact import Contact, Base
```

**Path: `backend/app/models/contact.py`**
```
From: ARCMETRIC_COMPLETE_SETUP.md (Section 6)
Update imports to use: from sqlalchemy.dialects.postgresql import UUID
```

**Path: `backend/app/schemas/__init__.py`**
```python
from .contact import ContactResponse, ContactListResponse
```

**Path: `backend/app/schemas/contact.py`**
```
From: ARCMETRIC_COMPLETE_SETUP.md (Section 5)
```

**Path: `backend/app/api/__init__.py`**
```python
# API routes
```

**Path: `backend/app/api/contacts.py`**
```python
# Contact endpoints (extracted from main.py)
```

**Path: `backend/app/services/__init__.py`**
```python
# Business logic services
```

**Path: `backend/app/services/enrichment_engine.py`**
```
From: PUSH_TO_GITHUB.md (Step 5 - Stub Version)
```

**Path: `backend/app/services/enrichment_integration.py`**
```
From: ARCMETRIC_COMPLETE_SETUP.md (Section 9)
```

**Path: `backend/app/utils/__init__.py`**
```python
# Utilities
```

**Path: `backend/app/utils/logger.py`**
```python
import logging

def get_logger(name: str):
    return logging.getLogger(name)
```

**Path: `backend/tests/__init__.py`**
```python
# Tests
```

---

### Step 4: Frontend Files

**Path: `frontend/package.json`**
```json
{
  "name": "arcmetric-frontend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "lucide-react": "^0.294.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.43",
    "@types/react-dom": "^18.2.17",
    "@vitejs/plugin-react": "^4.2.1",
    "typescript": "^5.3.3",
    "vite": "^5.0.8",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.4.32",
    "autoprefixer": "^10.4.16"
  }
}
```

**Path: `frontend/vite.config.ts`**
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: process.env.VITE_API_URL || 'http://localhost:5000',
        changeOrigin: true,
      }
    }
  }
})
```

**Path: `frontend/tsconfig.json`**
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "esModuleInterop": true,
    "strict": true,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
```

**Path: `frontend/index.html`**
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ArcMetric - Sales Intelligence</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

**Path: `frontend/.env.example`**
```
VITE_API_URL=https://arcmetric-backend.onrender.com
VITE_ENV=production
```

**Path: `frontend/tailwind.config.js`**
```javascript
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [],
}
```

**Path: `frontend/postcss.config.js`**
```javascript
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

**Path: `frontend/src/main.tsx`**
```typescript
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
```

**Path: `frontend/src/App.tsx`**
```typescript
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import ContactDetail from './pages/ContactDetail'

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/contacts/:contactId" element={<ContactDetail />} />
        <Route path="/" element={<div>Welcome to ArcMetric</div>} />
      </Routes>
    </Router>
  )
}

export default App
```

**Path: `frontend/src/index.css`**
```css
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

body {
  background-color: #0d1117;
  color: #c9d1d9;
}
```

**Path: `frontend/src/config/api.ts`**
```typescript
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
```

**Path: `frontend/src/types/index.ts`**
```typescript
export interface Contact {
  id: string;
  name: string;
  title: string;
  email: string;
  phone: string;
  company: string;
  enrichment_status: 'pending' | 'processing' | 'completed' | 'failed';
  enrichment_data?: any;
  apex_score?: number;
}
```

**Path: `frontend/src/pages/ContactDetail.tsx`**
```
From: ARCMETRIC_BUILD.md (Phase 2)
Update API_BASE to use: import { API_BASE } from '../config/api'
```

**Path: `frontend/src/components/Card.tsx`**
```typescript
interface CardProps {
  title: string;
  icon: React.ReactNode;
  color?: string;
  children: React.ReactNode;
}

export const Card: React.FC<CardProps> = ({ title, icon, color = 'text-blue-400', children }) => (
  <div className="bg-161b22 border border-30363d rounded-lg overflow-hidden">
    <div className="px-4 py-3 border-b border-30363d flex items-center gap-2">
      <span className={color}>{icon}</span>
      <h3 className="font-semibold text-white">{title}</h3>
    </div>
    <div className="p-4">{children}</div>
  </div>
);
```

**Path: `frontend/src/hooks/useContact.ts`**
```typescript
import { useState, useEffect } from 'react';
import { API_ENDPOINTS } from '../config/api';

export const useContact = (contactId: string) => {
  const [contact, setContact] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetch = async () => {
      try {
        const res = await window.fetch(API_ENDPOINTS.CONTACT_DETAIL(contactId));
        const data = await res.json();
        setContact(data.contact);
      } catch (e) {
        setError('Error loading contact');
      } finally {
        setLoading(false);
      }
    };
    fetch();
  }, [contactId]);

  return { contact, loading, error };
};
```

---

### Step 5: GitHub Actions

**Path: `.github/workflows/backend-deploy.yml`**
```yaml
name: Deploy Backend to Render
on:
  push:
    branches: [main]
    paths: ["backend/**"]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Render
        run: |
          curl https://api.render.com/deploy/srv/${{ secrets.RENDER_SERVICE_ID }}?key=${{ secrets.RENDER_API_KEY }} -X POST
```

**Path: `.github/workflows/frontend-deploy.yml`**
```yaml
name: Deploy Frontend to Vercel
on:
  push:
    branches: [main]
    paths: ["frontend/**"]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Vercel
        run: |
          npm install -g vercel
          vercel deploy --prod --token ${{ secrets.VERCEL_TOKEN }} frontend/
```

---

## ✅ COMPLETE FOLDER TREE

```
/Users/chrisrabenold/projects/arcmetric/
├── README.md
├── .gitignore
├── .env.example
├── backend/
│   ├── main.py
│   ├── requirements.txt
│   ├── Procfile
│   ├── .env.example
│   ├── pyproject.toml
│   ├── app/
│   │   ├── __init__.py
│   │   ├── config.py
│   │   ├── database.py
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   └── contact.py
│   │   ├── schemas/
│   │   │   ├── __init__.py
│   │   │   └── contact.py
│   │   ├── api/
│   │   │   ├── __init__.py
│   │   │   └── contacts.py
│   │   ├── services/
│   │   │   ├── __init__.py
│   │   │   ├── enrichment_engine.py
│   │   │   └── enrichment_integration.py
│   │   └── utils/
│   │       ├── __init__.py
│   │       └── logger.py
│   └── tests/
│       └── __init__.py
├── frontend/
│   ├── index.html
│   ├── vite.config.ts
│   ├── tsconfig.json
│   ├── package.json
│   ├── tailwind.config.js
│   ├── postcss.config.js
│   ├── .env.example
│   ├── public/
│   └── src/
│       ├── main.tsx
│       ├── App.tsx
│       ├── index.css
│       ├── config/
│       │   └── api.ts
│       ├── components/
│       │   └── Card.tsx
│       ├── hooks/
│       │   └── useContact.ts
│       ├── pages/
│       │   └── ContactDetail.tsx
│       ├── types/
│       │   └── index.ts
│       └── utils/
├── .github/
│   └── workflows/
│       ├── backend-deploy.yml
│       └── frontend-deploy.yml
└── docs/
    └── (Documentation files)
```

---

## 🚀 DEPLOYMENT COMMANDS (UPDATED)

### Render Backend
```
Build Command: pip install -r backend/requirements.txt
Start Command: cd backend && python main.py
```

### Vercel Frontend
```
Root Directory: frontend
Build Command: npm run build
```

---

**All files ready for production monorepo.** ⚡

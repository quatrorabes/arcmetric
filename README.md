# 🚀 ArcMetric - AI Sales Intelligence Platform

Production-ready monorepo with FastAPI backend and React frontend.

## 📁 Structure

- **`backend/`** - FastAPI + PostgreSQL (Render)
- **`frontend/`** - React + TypeScript + Vite (Vercel)
- **`docs/`** - Documentation
- **`.github/workflows/`** - CI/CD pipelines

## ⚡ Quick Start (Local Development)

```bash
# Run everything at once
bash dev.sh

# Or manually:

# Terminal 1: Backend
cd backend
python main.py

# Terminal 2: Frontend
cd frontend
npm run dev
```

## 🚀 Deployment

- **Backend:** `Render` (`cd backend && python main.py`)
- **Frontend:** `Vercel` (root: `frontend/`)

## 📋 Environment Variables

Backend (`.env`):
```
DATABASE_URL=postgresql://...
OPENAI_API_KEY=sk-...
ENVIRONMENT=production
```

Frontend (`.env.local`):
```
VITE_API_URL=https://arcmetric-backend.onrender.com
```

## ✅ Status

- ✅ Production-ready
- ✅ Full type safety
- ✅ Automated CI/CD
- ✅ Database migrations ready

# 🎯 ArcMetric - Production Monorepo Structure (Best Practice)

**Status:** Ready to Push  
**Structure:** Standard Monorepo (Backend + Frontend at root level)  
**Deployment:** Render (Backend) + Vercel (Frontend) + PostgreSQL  

---

# 📁 FOLDER STRUCTURE (BEST PRACTICE)

```
/Users/chrisrabenold/projects/arcmetric/
│
├── README.md                            ✅ Root documentation
├── .gitignore                           ✅ Git ignore
├── .env.example                         ✅ Env template (root)
│
├── backend/                             ✅ FastAPI application
│   ├── main.py                          ✅ FastAPI entry point
│   ├── requirements.txt                 ✅ Python dependencies
│   ├── Procfile                         ✅ Render deployment
│   ├── .env.example                     ✅ Backend env template
│   ├── pyproject.toml                   ✅ Python project config
│   ├── app/                             ✅ Application package
│   │   ├── __init__.py
│   │   ├── config.py                    ✅ Settings & config
│   │   ├── database.py                  ✅ Database setup
│   │   ├── models/                      ✅ SQLAlchemy models
│   │   │   ├── __init__.py
│   │   │   └── contact.py
│   │   ├── schemas/                     ✅ Pydantic schemas
│   │   │   ├── __init__.py
│   │   │   └── contact.py
│   │   ├── api/                         ✅ API routes
│   │   │   ├── __init__.py
│   │   │   ├── contacts.py              ✅ Contact endpoints
│   │   │   └── health.py                ✅ Health check
│   │   ├── services/                    ✅ Business logic
│   │   │   ├── __init__.py
│   │   │   ├── enrichment_engine.py     ✅ 4-stage pipeline
│   │   │   └── enrichment_integration.py ✅ Integration logic
│   │   └── utils/                       ✅ Utilities
│   │       ├── __init__.py
│   │       └── logger.py
│   └── tests/                           ✅ Test suite
│       ├── __init__.py
│       ├── conftest.py
│       └── test_contacts.py
│
├── frontend/                            ✅ React application
│   ├── package.json                     ✅ Node dependencies
│   ├── vite.config.ts                   ✅ Vite configuration
│   ├── tsconfig.json                    ✅ TypeScript config
│   ├── index.html                       ✅ Entry HTML
│   ├── .env.example                     ✅ Frontend env template
│   ├── tailwind.config.js               ✅ Tailwind config
│   ├── postcss.config.js                ✅ PostCSS config
│   ├── src/
│   │   ├── main.tsx                     ✅ React entry point
│   │   ├── App.tsx                      ✅ Root component
│   │   ├── index.css                    ✅ Global styles
│   │   ├── config/
│   │   │   ├── api.ts                   ✅ API configuration
│   │   │   └── constants.ts             ✅ App constants
│   │   ├── components/
│   │   │   ├── Card.tsx                 ✅ Reusable card
│   │   │   ├── Header.tsx               ✅ Header
│   │   │   └── ErrorBoundary.tsx        ✅ Error boundary
│   │   ├── hooks/
│   │   │   ├── useContact.ts            ✅ Contact fetch hook
│   │   │   └── useEnrichment.ts         ✅ Enrichment hook
│   │   ├── pages/
│   │   │   ├── ContactDetail.tsx        ✅ Main page
│   │   │   └── NotFound.tsx             ✅ 404 page
│   │   ├── types/
│   │   │   └── index.ts                 ✅ TypeScript types
│   │   └── utils/
│   │       └── formatters.ts            ✅ Utility functions
│   ├── public/
│   │   └── favicon.svg
│   └── tests/
│       ├── __mocks__/
│       └── ContactDetail.test.tsx
│
├── .github/
│   ├── workflows/
│   │   ├── backend-ci.yml               ✅ Backend CI tests
│   │   ├── backend-deploy.yml           ✅ Auto-deploy backend
│   │   ├── frontend-ci.yml              ✅ Frontend CI tests
│   │   └── frontend-deploy.yml          ✅ Auto-deploy frontend
│   └── CODEOWNERS                       ✅ Code ownership
│
├── docker/                              ✅ Optional Docker
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   └── docker-compose.yml
│
└── docs/                                ✅ Documentation
    ├── ARCHITECTURE.md
    ├── DEPLOYMENT.md
    ├── API.md
    └── DEVELOPMENT.md
```

---

# ✅ PRODUCTION STRUCTURE BENEFITS

✅ **Monorepo** - Single source of truth
✅ **Separate deployments** - Independent backend/frontend
✅ **Shared types** - Easy to sync TypeScript types with backend
✅ **CI/CD simplicity** - Different workflows per service
✅ **Scalability** - Easy to add microservices later
✅ **Developer experience** - Single repo, multiple contexts

---

# 🗂️ KEY FILES (WITH EXACT PATHS)

## Backend

```
backend/
├── main.py                          # Entry point (Render runs this)
├── requirements.txt                 # pip install -r backend/requirements.txt
├── Procfile                         # web: cd backend && python main.py
├── app/
│   ├── models/contact.py            # SQLAlchemy model with UUID
│   ├── schemas/contact.py           # Pydantic request/response
│   ├── api/contacts.py              # POST /enrich, GET endpoints
│   └── services/                    # Enrichment logic
└── tests/                           # pytest tests
```

## Frontend

```
frontend/
├── package.json                     # npm install && npm run build
├── vite.config.ts                   # Build config
├── src/
│   ├── config/api.ts                # API_BASE = import.meta.env.VITE_API_URL
│   ├── hooks/useEnrichment.ts       # Polling logic (60-90s)
│   └── pages/ContactDetail.tsx      # Main enrichment display
└── public/                          # Static assets
```

---

# 🚀 DEPLOYMENT COMMAND CHANGES

## Render Backend

**OLD:**
```
cd apps/backend && python -m uvicorn main:app
```

**NEW:**
```
cd backend && python main.py
```

## Vercel Frontend

**OLD:**
```
Root Directory: dashboard_v1
Build Command: npm run build
Output Directory: dist
```

**NEW:**
```
Root Directory: frontend
Build Command: npm run build
Output Directory: dist
```

---

# 📝 FILE LISTING BY TYPE

## Python Backend Files

1. `backend/main.py` - FastAPI app initialization
2. `backend/app/config.py` - Environment settings
3. `backend/app/database.py` - SQLAlchemy engine
4. `backend/app/models/contact.py` - Contact model with UUID
5. `backend/app/schemas/contact.py` - Pydantic schemas
6. `backend/app/api/contacts.py` - Contact endpoints
7. `backend/app/api/health.py` - Health check
8. `backend/app/services/enrichment_engine.py` - 4-stage pipeline
9. `backend/app/services/enrichment_integration.py` - Result integration
10. `backend/requirements.txt` - Dependencies
11. `backend/pyproject.toml` - Project metadata
12. `backend/Procfile` - Render config

## TypeScript Frontend Files

1. `frontend/src/main.tsx` - React entry point
2. `frontend/src/App.tsx` - Root component
3. `frontend/src/config/api.ts` - API configuration
4. `frontend/src/hooks/useContact.ts` - Contact fetch hook
5. `frontend/src/hooks/useEnrichment.ts` - Enrichment polling
6. `frontend/src/pages/ContactDetail.tsx` - Main component
7. `frontend/src/components/Card.tsx` - Reusable card
8. `frontend/src/types/index.ts` - Type definitions
9. `frontend/package.json` - Dependencies
10. `frontend/vite.config.ts` - Build config
11. `frontend/tsconfig.json` - TypeScript config
12. `frontend/tailwind.config.js` - Styling

## Configuration Files

1. `.env.example` - Root env template
2. `backend/.env.example` - Backend env template
3. `frontend/.env.example` - Frontend env template
4. `.gitignore` - Git ignore rules
5. `README.md` - Root documentation

## GitHub Actions

1. `.github/workflows/backend-deploy.yml` - Auto-deploy backend
2. `.github/workflows/frontend-deploy.yml` - Auto-deploy frontend
3. `.github/workflows/backend-ci.yml` - Backend tests
4. `.github/workflows/frontend-ci.yml` - Frontend tests

---

# 🛠️ LOCAL DEVELOPMENT

```bash
# Install backend
cd backend
pip install -r requirements.txt

# Install frontend
cd ../frontend
npm install

# Run backend (terminal 1)
cd ../backend
python main.py

# Run frontend (terminal 2)
cd frontend
npm run dev
```

---

# 🚀 DEPLOYMENT

### Deploy Backend (Render)

```
Build Command: pip install -r backend/requirements.txt
Start Command: cd backend && python main.py
```

### Deploy Frontend (Vercel)

```
Root Directory: frontend
Build Command: npm run build
Start Command: Automatic (static site)
```

---

# ✅ ENV VARIABLES

### Root `.env.example`
```bash
# Shared config
ENVIRONMENT=production
REGION=us-west-1
```

### `backend/.env.example`
```bash
DATABASE_URL=postgresql://...
PORT=5000
OPENAI_API_KEY=sk-...
LOG_LEVEL=INFO
```

### `frontend/.env.example`
```bash
VITE_API_URL=https://arcmetric-backend.onrender.com
VITE_ENV=production
```

---

# 🎯 MONOREPO ADVANTAGES

| Aspect | Benefit |
|--------|---------|
| **Dependency Management** | Single `package.json` & `requirements.txt` per service |
| **Type Safety** | Shared TypeScript types between frontend & backend |
| **Testing** | Independent test suites per service |
| **CI/CD** | Separate workflows for backend/frontend |
| **Deployment** | Independent deploys (no coupled releases) |
| **Repository** | Single git history, easier history tracking |
| **Scaling** | Easy to add more services (microservices) |

---

# 📋 NEXT STEPS

1. Create folder structure above
2. Copy all files from individual documentation
3. Update all path references:
   - `backend/main.py` instead of `apps/backend/main.py`
   - `frontend/src/` instead of `dashboard_v1/src/`
   - Deployment commands adjusted above

4. Initialize git:
   ```bash
   git init
   git add .
   git commit -m "🚀 ArcMetric Monorepo - Production Ready"
   ```

5. Deploy:
   - Render: `cd backend && python main.py`
   - Vercel: Root dir = `frontend`

---

# ✅ YOU'RE READY WITH BEST PRACTICE STRUCTURE

All files, all configs, all paths updated for production monorepo.

**Ready to push.** ⚡

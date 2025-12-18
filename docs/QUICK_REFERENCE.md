# 🚀 ArcMetric - QUICK REFERENCE CARD

**Everything you need to know in one place**

---

## ⚡ ONE COMMAND SETUP

```bash
cd /Users/chrisrabenold/projects
bash setup-arcmetric.sh
```

**Waits:** 5-10 minutes  
**Creates:** 50+ files  
**Installs:** Backend + Frontend deps  
**Result:** Ready to run  

---

## 🎯 ONE COMMAND RUN (After Setup)

```bash
cd arcmetric
bash dev.sh
```

**Starts:**
- ✅ Backend (FastAPI) on port 5000
- ✅ Frontend (React) on port 3000
- ✅ Logs to `.logs/`
- ✅ Auto health checks

**Stops:** Ctrl+C (graceful shutdown)

---

## 🔗 ACCESS URLS

| Service | URL | Purpose |
|---------|-----|---------|
| Backend | `http://localhost:5000` | API |
| Docs | `http://localhost:5000/docs` | Swagger |
| Health | `http://localhost:5000/health` | Status |
| Frontend | `http://localhost:3000` | App |
| Contact | `http://localhost:3000/contacts/{uuid}` | Main page |

---

## 📋 WHAT GETS CREATED

```
arcmetric/
├── backend/              ← FastAPI app (port 5000)
├── frontend/             ← React app (port 3000)
├── .github/workflows/    ← CI/CD pipelines
├── .logs/                ← Runtime logs
├── .env                  ← Backend config
├── dev.sh                ← Start everything
├── setup-db.sh           ← DB setup
└── README.md             ← Documentation
```

---

## 🔑 KEY FILES CREATED

### Backend
- `backend/main.py` - FastAPI entry point
- `backend/app/models/contact.py` - SQLAlchemy model (UUID)
- `backend/app/services/enrichment_engine.py` - 4-stage pipeline
- `backend/requirements.txt` - Python dependencies

### Frontend
- `frontend/src/pages/ContactDetail.tsx` - Main page
- `frontend/src/config/api.ts` - API client config
- `frontend/src/hooks/useContact.ts` - Data fetching hook
- `frontend/package.json` - NPM dependencies

### Config
- `.github/workflows/backend-deploy.yml` - Render deployment
- `.github/workflows/frontend-deploy.yml` - Vercel deployment
- `dev.sh` - Development runner (both services)
- `setup-db.sh` - PostgreSQL setup

---

## 🚀 DEPLOYMENT

```bash
# 1. Push to GitHub
cd arcmetric
git remote add origin https://github.com/YOUR_USERNAME/arcmetric.git
git push -u origin main

# 2. Set up Render (Backend)
# Build: pip install -r backend/requirements.txt
# Start: cd backend && python main.py

# 3. Set up Vercel (Frontend)
# Root: frontend
# Build: npm run build
```

**Result:** Auto-deploy on every git push

---

## 🧪 QUICK TESTS

```bash
# Backend health
curl http://localhost:5000/health

# Backend docs
open http://localhost:5000/docs

# Frontend
open http://localhost:3000

# View logs
tail -f .logs/backend.log
tail -f .logs/frontend.log
```

---

## ⚙️ ENVIRONMENT VARIABLES

### Backend (.env)
```
DATABASE_URL=postgresql://user:password@localhost:5432/arcmetric
OPENAI_API_KEY=sk-your-key-here
PORT=5000
ENVIRONMENT=production
```

### Frontend (.env.local)
```
VITE_API_URL=http://localhost:5000
```

---

## 🆘 TROUBLESHOOTING

| Issue | Solution |
|-------|----------|
| Port 5000 in use | `sudo lsof -i :5000` then `kill -9 <PID>` |
| Port 3000 in use | `sudo lsof -i :3000` then `kill -9 <PID>` |
| Dependencies fail | `pip install --force-reinstall -r requirements.txt` |
| Frontend won't load | `cd frontend && rm -rf node_modules && npm install` |
| Backend won't start | Check `DATABASE_URL` in `.env` |
| CORS errors | Backend has CORS enabled for all origins |

---

## 📊 WHAT'S AUTOMATED

✅ Create all folders  
✅ Generate all 50+ files  
✅ Create Python venv  
✅ Install pip dependencies  
✅ Install npm dependencies  
✅ Create .env files  
✅ Initialize git  
✅ Start both services simultaneously  
✅ Health check both services  
✅ Log everything to .logs/  
✅ Graceful shutdown  

---

## 🎯 TYPICAL WORKFLOW

### First Time
```bash
cd /Users/chrisrabenold/projects
bash setup-arcmetric.sh
# Answer: y (start services)
```

### Subsequent Times
```bash
cd arcmetric
bash dev.sh
```

### Deploy
```bash
git push origin main
# Auto-deploys to Render + Vercel
```

---

## 📝 IMPORTANT NOTES

- ❌ Do NOT create files manually
- ✅ Run `bash setup-arcmetric.sh` (does everything)
- ✅ Use `bash dev.sh` to start (does everything)
- ✅ Use `Ctrl+C` to stop (graceful)
- ✅ Check `.logs/` if something breaks

---

## 💡 TIPS & TRICKS

**Run on remote server:**
```bash
nohup bash dev.sh > /dev/null 2>&1 &
```

**Check if services running:**
```bash
ps aux | grep python   # Backend
ps aux | grep node     # Frontend
```

**View backend logs real-time:**
```bash
tail -f .logs/backend.log | grep ERROR
```

**Rebuild frontend:**
```bash
cd frontend
npm run build
npm run dev
```

**Reset everything:**
```bash
git clean -fd          # Remove generated files
git reset --hard HEAD  # Reset to last commit
bash setup-arcmetric.sh # Start over
```

---

## ✅ CHECKLIST

After running `bash dev.sh`:

- [ ] Backend starts
- [ ] Frontend starts
- [ ] Both running simultaneously
- [ ] `http://localhost:5000/health` → 200
- [ ] `http://localhost:3000` → loads
- [ ] API docs at `/docs`
- [ ] `.logs/` directory created
- [ ] No CORS errors
- [ ] No port conflicts

---

## 🚀 YOU'RE READY

```bash
cd /Users/chrisrabenold/projects
bash setup-arcmetric.sh
```

**Everything else is automatic.** ⚡

---

**Version:** 1.0  
**Status:** Production Ready ✅  
**Setup Time:** 5-10 minutes  
**Support:** Check `.logs/` directory  


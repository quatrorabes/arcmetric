#!/bin/bash
# ============================================================================
# ArcMetric - Complete Setup & Run (All-In-One)
# ============================================================================

set -e

cd /Users/chrisrabenold/projects/arcmetric

echo "🔧 Completing ArcMetric Setup..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================================
# STEP 1: Install Backend Dependencies
# ============================================================================

echo -e "${YELLOW}📦 Installing Backend Dependencies...${NC}"
cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate venv
source venv/bin/activate

# Install requirements
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt > /dev/null 2>&1

echo -e "${GREEN}✅ Backend dependencies installed${NC}"

cd ..

# ============================================================================
# STEP 2: Install Frontend Dependencies
# ============================================================================

echo -e "${YELLOW}⚛️  Installing Frontend Dependencies...${NC}"
cd frontend

npm install > /dev/null 2>&1

echo -e "${GREEN}✅ Frontend dependencies installed${NC}"

cd ..

# ============================================================================
# STEP 3: Create Environment Files
# ============================================================================

echo -e "${YELLOW}⚙️  Creating environment files...${NC}"

# Backend .env
if [ ! -f "backend/.env" ]; then
    cat > backend/.env << 'EOF'
DATABASE_URL=postgresql://user:password@localhost:5432/arcmetric
PORT=5000
OPENAI_API_KEY=sk-your-key-here
ENVIRONMENT=development
LOG_LEVEL=INFO
EOF
    echo -e "${GREEN}✅ Created backend/.env${NC}"
fi

# Frontend .env.local
if [ ! -f "frontend/.env.local" ]; then
    echo "VITE_API_URL=http://localhost:5000" > frontend/.env.local
    echo -e "${GREEN}✅ Created frontend/.env.local${NC}"
fi

# ============================================================================
# STEP 4: Create Logs Directory
# ============================================================================

mkdir -p .logs
echo -e "${GREEN}✅ Created .logs directory${NC}"

# ============================================================================
# STEP 5: Start Services
# ============================================================================

echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}🚀 Starting ArcMetric Services${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════${NC}"
echo ""

# Create empty log files
> .logs/backend.log
> .logs/frontend.log

# Start Backend
cd backend
source venv/bin/activate
python3 main.py >> ../.logs/backend.log 2>&1 &
BACKEND_PID=$!
cd ..

echo -e "${GREEN}✅ Backend started (PID: $BACKEND_PID)${NC}"

# Wait for backend to start
sleep 3

# Check if backend is running
if kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${GREEN}✅ Backend is running${NC}"
    
    # Try health check
    if curl -s http://localhost:5000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Backend health check passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Backend health check pending (wait a few seconds)${NC}"
    fi
else
    echo -e "${RED}❌ Backend failed to start${NC}"
    echo "Check logs: tail -f .logs/backend.log"
fi

echo ""

# Start Frontend
cd frontend
npm run dev >> ../.logs/frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..

echo -e "${GREEN}✅ Frontend started (PID: $FRONTEND_PID)${NC}"

sleep 2

if kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${GREEN}✅ Frontend is running${NC}"
else
    echo -e "${RED}❌ Frontend failed to start${NC}"
    echo "Check logs: tail -f .logs/frontend.log"
fi

# ============================================================================
# STEP 6: Display URLs & Instructions
# ============================================================================

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 ArcMetric is Running!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${YELLOW}Backend:${NC}   http://localhost:5000"
echo -e "  ${YELLOW}Docs:${NC}      http://localhost:5000/docs"
echo -e "  ${YELLOW}Health:${NC}    http://localhost:5000/health"
echo ""
echo -e "  ${YELLOW}Frontend:${NC}  http://localhost:3000"
echo ""
echo -e "  ${YELLOW}Logs:${NC}"
echo -e "    Backend:  tail -f .logs/backend.log"
echo -e "    Frontend: tail -f .logs/frontend.log"
echo ""
echo -e "  ${YELLOW}Stop:${NC}      Press Ctrl+C"
echo ""

# ============================================================================
# STEP 7: Cleanup on Exit
# ============================================================================

cleanup() {
    echo ""
    echo -e "${YELLOW}Shutting down...${NC}"
    kill $BACKEND_PID 2>/dev/null || true
    kill $FRONTEND_PID 2>/dev/null || true
    echo -e "${GREEN}✅ Services stopped${NC}"
    exit 0
}

trap cleanup EXIT INT TERM

# Wait indefinitely
wait

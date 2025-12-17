#!/bin/bash
# Run both backend and frontend simultaneously

echo "🚀 Starting ArcMetric (Backend + Frontend)"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Backend
echo -e "${YELLOW}📦 Starting Backend (port 5000)...${NC}"
cd backend
python main.py &
BACKEND_PID=$!
cd ..

# Frontend
echo -e "${YELLOW}⚛️  Starting Frontend (port 3000)...${NC}"
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo -e "${GREEN}✅ Both services running:${NC}"
echo -e "   Backend:  http://localhost:5000"
echo -e "   Frontend: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all services"

# Handle Ctrl+C
trap "kill $BACKEND_PID $FRONTEND_PID" EXIT

# Wait for both processes
wait

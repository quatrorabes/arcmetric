#!/usr/bin/env bash
set -euo pipefail

echo "[boot] python=$(python --version)"
echo "[boot] pwd=$(pwd)"
echo "[boot] PORT=${PORT:-<missing>}"
echo "[boot] DATABASE_URL=${DATABASE_URL:+<set>}${DATABASE_URL:-<missing>}"

: "${PORT:?Render must provide PORT}"
: "${DATABASE_URL:?Set DATABASE_URL in Render Environment}"

cd "$(dirname "$0")"

# IMPORTANT:
# If your FastAPI instance isn't named "app" in main.py,
# change "main:app" to whatever it is (e.g., "main:api").
exec gunicorn \
  -k uvicorn.workers.UvicornWorker \
  main:app \
  --bind "0.0.0.0:${PORT}" \
  --workers "${WEB_CONCURRENCY:-1}" \
  --timeout 120

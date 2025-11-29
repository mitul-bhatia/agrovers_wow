#!/bin/bash
# Optimized backend startup for Render (memory-efficient)

cd backend

# Start server with minimal workers to save memory
# Using 1 worker instead of 2 to stay under 512MB limit
gunicorn app.main:app \
  --workers 1 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:${PORT:-8000} \
  --timeout 120 \
  --max-requests 1000 \
  --max-requests-jitter 50

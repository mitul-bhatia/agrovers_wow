#!/bin/bash
# Backend startup script
# For LOCAL development only (Render doesn't use this file)

echo "🚀 Starting Agrovers Backend..."
echo ""

cd backend

# Check if virtual environment exists (local development)
if [ ! -d ".venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment (local development)
echo "🔧 Activating virtual environment..."
source .venv/bin/activate

# Install dependencies if needed (local development)
if [ ! -f ".venv/installed" ]; then
    echo "📥 Installing dependencies..."
    pip install -r requirements.txt
    touch .venv/installed
fi

# Check if preprocessed files exist
if [ ! -f "app/data/embeddings/kb_index.faiss" ]; then
    echo "⚠️  Warning: Preprocessed files not found!"
    echo "   Run: python preprocess_kb.py"
    echo ""
fi

# Start server
echo "✅ Starting server on http://localhost:8001"
echo ""
gunicorn app.main:app \
  --workers 1 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8001 \
  --reload \
  --timeout 120

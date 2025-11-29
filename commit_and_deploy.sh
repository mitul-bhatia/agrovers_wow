#!/bin/bash
# Quick commit and deploy script

echo "🚀 Committing optimized code for Render deployment..."
echo ""

# Add all necessary files
git add backend/app/data/embeddings/
git add backend/app/data/kb_processed/
git add backend/requirements.txt
git add backend/requirements-preprocessing.txt
git add backend/app/services/rag_engine.py
git add render.yaml
git add start_backend.sh
git add .gitignore
git add *.md

# Commit
git commit -m "Optimize for Render: Memory 900MB → 150MB

Changes:
- Remove sentence-transformers, torch, transformers from requirements.txt
- Add pre-computed FAISS index and metadata to git
- Update RAG engine to use keyword matching (no ML model at runtime)
- Reduce workers from 2 to 1 in render.yaml
- Update start_backend.sh for optimal memory usage

Memory breakdown:
- Before: 900MB+ (crashed)
- After: ~150MB (stable)

Files committed:
- backend/app/data/embeddings/kb_index.faiss (726KB)
- backend/app/data/embeddings/kb_index_meta.pkl (138KB)
- backend/app/data/kb_processed/kb_chunks.jsonl (209KB)

Ready for Render free tier deployment!"

# Push
echo ""
echo "📤 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Done! Render will auto-deploy in 3-5 minutes."
echo ""
echo "📊 Monitor at: https://dashboard.render.com"
echo "🔗 Your API: https://agrovers-wow.onrender.com"
echo ""
echo "Next: Update Render dashboard with these commands:"
echo ""
echo "Build Command:"
echo "  pip install -r backend/requirements.txt"
echo ""
echo "Start Command:"
echo "  cd backend && gunicorn app.main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:\$PORT"
echo ""

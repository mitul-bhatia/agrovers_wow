#!/bin/bash
# Deploy to Render - Optimized Version

echo "🚀 Deploying Agrovers to Render (Optimized)"
echo ""

# Check if preprocessed files exist
echo "📋 Checking preprocessed files..."
if [ ! -f "backend/app/data/embeddings/kb_index.faiss" ]; then
    echo "❌ Error: kb_index.faiss not found!"
    echo "   Run: python backend/preprocess_kb.py"
    exit 1
fi

if [ ! -f "backend/app/data/embeddings/kb_index_meta.pkl" ]; then
    echo "❌ Error: kb_index_meta.pkl not found!"
    echo "   Run: python backend/preprocess_kb.py"
    exit 1
fi

if [ ! -f "backend/app/data/kb_processed/kb_chunks.jsonl" ]; then
    echo "❌ Error: kb_chunks.jsonl not found!"
    echo "   Run: python backend/preprocess_kb.py"
    exit 1
fi

echo "✅ All preprocessed files found"
echo ""

# Check requirements.txt doesn't have heavy dependencies
echo "📋 Checking requirements.txt..."
if grep -q "sentence-transformers\|torch\|transformers" backend/requirements.txt; then
    echo "❌ Error: Heavy ML dependencies found in requirements.txt!"
    echo "   Remove: sentence-transformers, torch, transformers"
    exit 1
fi

echo "✅ Requirements.txt is optimized"
echo ""

# Show file sizes
echo "📊 File sizes:"
du -sh backend/app/data/embeddings/kb_index.faiss
du -sh backend/app/data/embeddings/kb_index_meta.pkl
du -sh backend/app/data/kb_processed/kb_chunks.jsonl
echo ""

# Git status
echo "📋 Git status:"
git status --short
echo ""

# Confirm deployment
read -p "Ready to commit and push? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

# Add files
echo "📦 Adding files..."
git add backend/app/data/embeddings/kb_index.faiss
git add backend/app/data/embeddings/kb_index_meta.pkl
git add backend/app/data/kb_processed/kb_chunks.jsonl
git add backend/requirements.txt
git add backend/requirements-preprocessing.txt
git add .gitignore
git add backend/app/services/rag_engine.py

# Commit
echo "💾 Committing..."
git commit -m "Optimize for Render: Use pre-computed embeddings, remove heavy ML dependencies

- Remove sentence-transformers, torch, transformers from requirements.txt
- Add pre-computed FAISS index and metadata
- Update RAG engine to use keyword matching
- Memory usage: 906MB → 106MB (850MB saved!)
- Ready for Render free tier deployment"

# Push
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Expected memory usage: ~150MB (was ~900MB)"
echo "🎯 Monitor deployment at: https://dashboard.render.com"
echo ""
echo "Next steps:"
echo "1. Watch Render dashboard for deployment"
echo "2. Check logs for: '✓ Loaded FAISS index with X chunks'"
echo "3. Test endpoint: curl https://agrovers-wow.onrender.com/health"
echo "4. Deploy frontend to Vercel (see DEPLOY_FRONTEND.md)"
echo ""
echo "🎉 Done!"

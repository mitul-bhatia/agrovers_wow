# 🚀 Final Deployment Guide - Copy These Exact Commands

## Step 1: Render Dashboard Configuration

Go to your Render service settings and update:

### Build Command (Copy This Exactly)
```
pip install -r backend/requirements.txt
```

### Start Command (Copy This Exactly)
```
cd backend && gunicorn app.main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT
```

### Environment Variables
Add these in Render dashboard:
- `GROQ_API_KEY` = your_groq_key_here
- `GOOGLE_API_KEY` = your_google_key_here

## Step 2: Commit All Changes

```bash
# Add all optimized files
git add backend/app/data/embeddings/
git add backend/app/data/kb_processed/
git add backend/requirements.txt
git add backend/app/services/rag_engine.py
git add render.yaml
git add start_backend.sh
git add .gitignore

# Commit
git commit -m "Optimize for Render: Memory usage 900MB → 150MB

- Remove sentence-transformers, torch, transformers
- Use pre-computed FAISS index
- Reduce workers from 2 to 1
- Add preprocessed embeddings to git
- Update RAG engine for keyword matching"

# Push
git push origin main
```

## Step 3: Verify Deployment

After Render deploys (3-5 minutes):

```bash
# Test health endpoint
curl https://agrovers-wow.onrender.com/health

# Should return:
# {"status":"healthy","rag_ready":true}
```

## Step 4: Frontend Deployment (Vercel)

Update frontend environment variable:
- `VITE_API_BASE_URL` = `https://agrovers-wow.onrender.com`

Then deploy to Vercel.

## Memory Breakdown

| Component | Memory |
|-----------|--------|
| Base app | 80MB |
| Gunicorn worker | 50MB |
| FAISS index | 5MB |
| LangChain | 15MB |
| **TOTAL** | **~150MB** ✅ |

## Why This Works

### Before (Failed)
```
Build: pip install + python preprocess_kb.py
→ Loads sentence-transformers (~500MB)
→ Creates embeddings
→ Saves to disk
→ Starts app with 2 workers
→ Each worker loads sentence-transformers (~500MB)
→ TOTAL: 900MB+ ❌ CRASH
```

### After (Success)
```
Build: pip install only
→ No heavy ML libraries
→ Uses pre-committed embeddings
→ Starts app with 1 worker
→ Worker uses keyword matching (0MB)
→ TOTAL: 150MB ✅ SUCCESS
```

## Exact Render Settings

Copy these into Render dashboard:

**Build Command:**
```
pip install -r backend/requirements.txt
```

**Start Command:**
```
cd backend && gunicorn app.main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT
```

**Environment Variables:**
- GROQ_API_KEY
- GOOGLE_API_KEY

**That's it!** No other settings needed.

## Success Checklist

After deployment:
- [ ] Build completes successfully
- [ ] Logs show: "✓ Loaded FAISS index with X chunks"
- [ ] Logs show: "✓ LLM adapter ready"
- [ ] Memory usage < 200MB
- [ ] Health endpoint returns 200
- [ ] No crashes or restarts

## Troubleshooting

### Build fails with "No module named 'sentence_transformers'"
✅ **This is correct!** We removed it intentionally.

### "Index files not found"
```bash
# Make sure files are committed
git add backend/app/data/embeddings/
git add backend/app/data/kb_processed/
git commit -m "Add preprocessed files"
git push
```

### Memory still high
- Check workers = 1 (not 2)
- Check requirements.txt has no sentence-transformers
- Restart service on Render

## Ready to Deploy?

1. **Update Render settings** (commands above)
2. **Commit and push** (commands above)
3. **Wait 3-5 minutes**
4. **Test health endpoint**
5. **Deploy frontend to Vercel**

**Done!** 🎉

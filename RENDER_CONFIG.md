# Render Configuration Guide

## Exact Commands for Render Dashboard

### Build Command
```bash
pip install -r backend/requirements.txt
```

**Important:** Do NOT run `python preprocess_kb.py` in build command!
The preprocessed files are already committed to git.

### Start Command
```bash
cd backend && gunicorn app.main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT
```

**Why 1 worker?** To stay under 512MB memory limit.

## Environment Variables

Set these in Render dashboard:

### Required
- `GROQ_API_KEY` - Your Groq API key
- `GOOGLE_API_KEY` - Your Google Gemini API key

### Optional
- `PORT` - Auto-set by Render (usually 10000)
- `PYTHON_VERSION` - 3.11.0 (or leave default)

## Memory Optimization

### Workers Configuration
- **1 worker** = ~150MB RAM ✅ (recommended)
- **2 workers** = ~250MB RAM ✅ (if you need more throughput)
- **3+ workers** = Risk exceeding 512MB ❌

### Why This Works
- No sentence-transformers (~500MB saved)
- No torch (~200MB saved)
- Pre-computed FAISS index (~1MB)
- Lightweight keyword matching (0MB)
- **Total: ~150MB per worker**

## Deployment Steps

1. **Update Render Settings:**
   - Build Command: `pip install -r backend/requirements.txt`
   - Start Command: `cd backend && gunicorn app.main:app --workers 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT`

2. **Set Environment Variables:**
   - Add GROQ_API_KEY
   - Add GOOGLE_API_KEY

3. **Commit and Push:**
   ```bash
   git add .
   git commit -m "Optimize for Render deployment"
   git push origin main
   ```

4. **Render Auto-Deploys:**
   - Watch logs for: "✓ Loaded FAISS index"
   - Check memory usage: Should be ~150MB

## Verification

After deployment:

```bash
# Test health
curl https://agrovers-wow.onrender.com/health

# Expected response:
# {"status":"healthy","rag_ready":true}
```

## Troubleshooting

### "Out of memory"
- Reduce workers to 1
- Check requirements.txt has no sentence-transformers

### "Index files not found"
- Make sure preprocessed files are committed:
  ```bash
  git add backend/app/data/embeddings/
  git add backend/app/data/kb_processed/
  git push
  ```

### "Port binding failed"
- Make sure start command uses `$PORT` variable
- Render sets this automatically

## Success Criteria

✅ Build completes in ~3 minutes
✅ Memory usage ~150MB
✅ No crashes or restarts
✅ Health endpoint returns 200
✅ RAG engine ready

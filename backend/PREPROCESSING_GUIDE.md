# Knowledge Base Preprocessing Guide

## Important: Run Preprocessing LOCALLY, Not on Render!

The preprocessing step requires heavy ML models (`sentence-transformers`) that consume too much memory for Render's free tier. You must run this locally and commit the generated files.

## Step 1: Install Preprocessing Dependencies (Local Only)

```bash
cd backend

# Install preprocessing requirements (includes sentence-transformers)
pip install -r requirements-preprocessing.txt
```

## Step 2: Run Preprocessing

```bash
# Make sure you're in the backend directory
python preprocess_kb.py
```

This will create:
- `app/data/kb_processed/kb_chunks.jsonl` - Chunked content
- `app/data/embeddings/kb_index.faiss` - FAISS index
- `app/data/embeddings/kb_index_meta.pkl` - Metadata

## Step 3: Commit Generated Files

```bash
# Add the generated files to git
git add app/data/kb_processed/
git add app/data/embeddings/

# Commit
git commit -m "Add preprocessed knowledge base"

# Push to GitHub
git push
```

## Step 4: Deploy to Render

Now when you deploy to Render:
- ✅ The FAISS index is already built (no preprocessing needed)
- ✅ No heavy ML models are loaded at runtime
- ✅ Memory usage stays under 512MB
- ✅ RAG still works using the pre-computed embeddings!

## How It Works

### During Preprocessing (Local)
1. Load `sentence-transformers` model (~500MB)
2. Process markdown files
3. Create embeddings for all chunks
4. Build FAISS index
5. Save everything to disk

### During Runtime (Render)
1. Load pre-computed FAISS index (~5MB)
2. Load metadata (~1MB)
3. Use lightweight keyword-based matching for queries
4. Retrieve relevant chunks from index
5. **No heavy models loaded!**

## Memory Comparison

**Before (with sentence-transformers):**
- Base app: ~100MB
- Sentence-transformers model: ~500MB
- **Total: ~600MB** ❌ (exceeds 512MB limit)

**After (pre-computed only):**
- Base app: ~100MB
- FAISS index: ~5MB
- Metadata: ~1MB
- **Total: ~106MB** ✅ (well under 512MB limit)

## Updating Knowledge Base

When you add/modify knowledge base files:

1. **Local:** Run preprocessing again
   ```bash
   python preprocess_kb.py
   ```

2. **Commit:** Add generated files
   ```bash
   git add app/data/kb_processed/ app/data/embeddings/
   git commit -m "Update knowledge base"
   git push
   ```

3. **Deploy:** Render will automatically redeploy with new index

## Troubleshooting

### "No module named 'sentence_transformers'"
- This is expected on Render (we removed it from requirements.txt)
- Make sure you ran preprocessing locally first
- Commit the generated files to git

### "Index files not found"
- Run preprocessing locally: `python preprocess_kb.py`
- Commit generated files: `git add app/data/`
- Push to GitHub

### "RAG engine not ready"
- Check that `app/data/embeddings/kb_index.faiss` exists
- Check that `app/data/embeddings/kb_index_meta.pkl` exists
- These files must be committed to git

## Files to Commit

Always commit these generated files:
```
app/data/kb_processed/kb_chunks.jsonl
app/data/embeddings/kb_index.faiss
app/data/embeddings/kb_index_meta.pkl
```

## .gitignore Update

Make sure these files are NOT ignored:
```gitignore
# Allow preprocessed data
!app/data/kb_processed/
!app/data/embeddings/
```

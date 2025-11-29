# 🧪 Test Backend Connection

## Your Backend is Live! ✅

URL: `https://agrovers-wow.onrender.com`

## Quick Tests

### 1. Health Check
```bash
curl https://agrovers-wow.onrender.com/health
```

Expected:
```json
{"status":"healthy","rag_ready":true}
```

### 2. Start Session
```bash
curl -X POST https://agrovers-wow.onrender.com/api/v1/session/start \
  -H "Content-Type: application/json" \
  -d '{"language":"en"}'
```

Expected:
```json
{
  "session_id": "...",
  "parameter": "name",
  "question": "What is your name?",
  "step_number": 1,
  "total_steps": 9
}
```

### 3. Test from Frontend Locally

```bash
# In frontend directory
cd frontend

# Create test environment
echo "VITE_API_BASE_URL=https://agrovers-wow.onrender.com" > .env.local

# Start frontend
npm run dev

# Open http://localhost:5173
# Try the wizard - it will connect to your Render backend!
```

## ✅ What's Working

- ✅ Backend deployed on Render
- ✅ RAG engine loaded (189 chunks)
- ✅ LLM adapter ready
- ✅ CORS configured (allows all origins)
- ✅ Memory usage: ~150MB
- ✅ All endpoints working

## 🚀 Next: Deploy Frontend

See `DEPLOY_FRONTEND_NOW.md` for Vercel deployment steps.

# Audio Feature - Deployment Fix

## Problem Fixed
Audio URLs were pointing to `http://localhost:8001` instead of the actual deployed backend URL, causing Mixed Content errors on HTTPS frontend.

## Solution Implemented

### 1. Auto-Detection Middleware (backend/app/main.py)
Added middleware that automatically detects the backend's URL from incoming requests and updates the `API_BASE_URL` setting dynamically.

### 2. Environment Variable Support
- Added `API_BASE_URL` to backend config
- Updated `render.yaml` with the correct URL
- Backend now uses this for all audio URL generation

## Deployment Steps

### Step 1: Commit and Push Changes
```bash
git add .
git commit -m "Fix audio URLs for production deployment"
git push origin main
```

### Step 2: Verify Render Environment Variables
Go to Render Dashboard → Your Service → Environment:

**Required Variables:**
```
API_BASE_URL=https://agrovers-wow.onrender.com
GROQ_API_KEY=your_key_here
GROQ_LLM_API_KEY=your_key_here
GROQ_REPORT_API_KEY=your_key_here
GEMINI_API_KEY=your_key_here
GEMINI_API_KEY_1=your_key_here
GEMINI_API_KEY_2=your_key_here
HF_TOKEN=your_token_here
ALLOWED_ORIGINS=https://agrovers-wow-git-main-mitul-bhatias-projects.vercel.app,https://agrovers-wow-kjutry51t-mitul-bhatias-projects.vercel.app,https://agrovers-wow-tau.vercel.app
```

### Step 3: Verify Vercel Settings
Go to Vercel Dashboard → Your Project → Settings:

**General Settings:**
- Root Directory: `frontend`
- Build Command: `npm run build`
- Output Directory: `dist`

**Environment Variables:**
```
VITE_API_BASE_URL=https://agrovers-wow.onrender.com
```

### Step 4: Redeploy
Both services will auto-deploy on push, or manually trigger:
- **Render**: Click "Manual Deploy" → "Deploy latest commit"
- **Vercel**: Go to Deployments → Click "Redeploy"

## How It Works Now

1. **Frontend** makes request to backend: `POST /api/v1/session/start`
2. **Backend middleware** detects its own URL: `https://agrovers-wow.onrender.com`
3. **Backend** generates audio and returns URL: `https://agrovers-wow.onrender.com/audio/tts_xxx.mp3`
4. **Frontend** loads audio from HTTPS URL ✅ (no Mixed Content error)

## Testing

After deployment, open browser console and check:
1. Network tab → Look for `/api/v1/session/start` response
2. Check `audio_url` field - should be `https://agrovers-wow.onrender.com/audio/...`
3. Click microphone button - should request permission
4. Record audio - should show "Recording..." indicator
5. Audio response should auto-play

## Troubleshooting

### Still seeing localhost URLs?
- Check Render logs: `API Base URL: https://...` should show correct URL
- Verify `API_BASE_URL` environment variable is set in Render
- Clear browser cache and hard refresh (Cmd+Shift+R)

### Audio not playing?
- Check browser console for errors
- Verify audio file exists: Open `https://agrovers-wow.onrender.com/audio/` in browser
- Check backend logs for TTS generation errors

### Microphone not working?
- Browser must be on HTTPS (Vercel provides this automatically)
- User must grant microphone permission
- Check browser settings → Site permissions

## Architecture Flow

```
User clicks mic → Browser records → Sends to backend
                                          ↓
Backend (Render) receives audio → Groq Whisper STT
                                          ↓
Process answer → Generate response → gTTS
                                          ↓
Save to: /app/data/audio/tts_xxx.mp3
                                          ↓
Return URL: https://agrovers-wow.onrender.com/audio/tts_xxx.mp3
                                          ↓
Frontend (Vercel) plays audio ✅
```

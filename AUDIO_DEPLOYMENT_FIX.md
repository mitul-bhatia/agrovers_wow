# Audio Feature Deployment Fix

## Problem
The audio/voice recording feature is not working in the deployed frontend.

## Root Causes

### 1. **Browser Security Requirements**
- Browsers require **HTTPS** to access the microphone (getUserMedia API)
- HTTP sites (except localhost) cannot use audio recording
- ✅ Vercel automatically provides HTTPS, so this is solved

### 2. **Backend Audio URL Configuration**
- Backend was hardcoded to use `http://localhost:8001` for audio URLs
- This needs to be the actual deployed backend URL

## Solution Applied

### Backend Changes

1. **Added `API_BASE_URL` environment variable** in `backend/.env`:
   ```env
   API_BASE_URL=http://localhost:8001
   ```

2. **Updated `backend/app/config.py`**:
   - Added `api_base_url` setting

3. **Updated audio URL generation** in:
   - `backend/app/routes/sessions.py`
   - `backend/app/services/orchestrator_enhanced.py`
   
   Now uses: `settings.api_base_url` instead of hardcoded localhost

### Deployment Steps

#### For Render (Backend)

1. Go to your Render dashboard → Your backend service
2. Go to **Environment** tab
3. Add new environment variable:
   ```
   Key: API_BASE_URL
   Value: https://agrovers-wow.onrender.com
   ```
4. Click **Save Changes**
5. Render will automatically redeploy

#### For Vercel (Frontend)

1. Go to Vercel dashboard → Your project
2. Go to **Settings** → **General**
3. Set **Root Directory** to: `frontend`
4. Go to **Settings** → **Environment Variables**
5. Add:
   ```
   Key: VITE_API_BASE_URL
   Value: https://agrovers-wow.onrender.com
   ```
6. Redeploy

## Verification

After deployment, the audio feature should work:

1. **Microphone button** appears in the chat interface (large circular button)
2. Clicking it requests microphone permission
3. Recording shows red pulsing indicator
4. Audio is sent to backend for transcription
5. AI responses include audio playback

## Testing Locally

```bash
# Backend
cd backend
source .venv/bin/activate
export API_BASE_URL=http://localhost:8001
uvicorn app.main:app --reload --port 8001

# Frontend
cd frontend
npm run dev
```

Open https://localhost:5174 (note HTTPS) or use ngrok for HTTPS testing.

## Common Issues

### "Microphone access denied"
- User needs to grant permission in browser
- Check browser settings → Site permissions

### "Audio not playing"
- Check backend logs for TTS errors
- Verify audio files are being generated in `backend/audio/` folder
- Check browser console for audio playback errors

### "Recording but no transcription"
- Check Groq API key is set: `GROQ_API_KEY`
- Check backend logs for STT errors
- Verify audio file is being received (check backend logs)

## Architecture

```
User speaks → Browser records (WebM) → POST /api/v1/session/next
                                       ↓
Backend receives audio → Groq Whisper (STT) → Text
                                       ↓
Process answer → Generate response → gTTS (TTS) → Audio file
                                       ↓
Return: { question, audio_url: "https://backend/audio/tts_xxx.mp3" }
                                       ↓
Frontend plays audio automatically
```

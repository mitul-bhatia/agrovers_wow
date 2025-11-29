# 🚀 Deploy Frontend to Vercel - Quick Guide

## ✅ Backend is Running!

Your backend is live at: `https://agrovers-wow.onrender.com`

Status: `{"message":"Argovers Soil Assistant API","status":"running","rag_ready":true}`

## 📦 Deploy Frontend to Vercel

### Option 1: Vercel Dashboard (Easiest)

1. **Go to** [vercel.com](https://vercel.com)
2. **Click** "Add New" → "Project"
3. **Import** your GitHub repository
4. **Configure:**
   - Framework Preset: **Vite**
   - Root Directory: **frontend**
   - Build Command: `npm run build`
   - Output Directory: `dist`
   
5. **Add Environment Variable:**
   - Name: `VITE_API_BASE_URL`
   - Value: `https://agrovers-wow.onrender.com`

6. **Click** "Deploy"

### Option 2: Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy from frontend directory
cd frontend
vercel --prod

# When prompted, set:
# - Root directory: ./
# - Build command: npm run build
# - Output directory: dist
# - Environment variable: VITE_API_BASE_URL=https://agrovers-wow.onrender.com
```

## 🔧 Local Testing First (Optional)

Test locally with production backend:

```bash
# Create .env.local for testing
cd frontend
echo "VITE_API_BASE_URL=https://agrovers-wow.onrender.com" > .env.local

# Start frontend
npm run dev

# Open http://localhost:5173
# It will connect to your Render backend!
```

## ✅ Verification

After Vercel deployment:

1. **Visit your Vercel URL** (e.g., `https://your-app.vercel.app`)
2. **Test the wizard:**
   - Select language (Hindi/English)
   - Start soil test
   - Answer questions
   - Check if helper mode works
   - Generate report

3. **Check browser console:**
   - No CORS errors
   - API calls go to `https://agrovers-wow.onrender.com`
   - Responses come back successfully

## 🐛 Troubleshooting

### CORS Errors
Your backend already allows all origins (`allow_origins=["*"]`), so this should work!

### API Connection Failed
- Check backend is running: `curl https://agrovers-wow.onrender.com/health`
- Check environment variable in Vercel dashboard
- Redeploy frontend if needed

### Build Fails
```bash
# Test build locally first
cd frontend
npm run build

# If successful, commit and push
git add .
git commit -m "Ready for Vercel deployment"
git push
```

## 📝 Environment Variables Summary

### Development (.env.development)
```
VITE_API_BASE_URL=http://localhost:8001
```

### Production (Vercel Dashboard)
```
VITE_API_BASE_URL=https://agrovers-wow.onrender.com
```

## 🎉 Success!

Once deployed:
- ✅ Frontend on Vercel
- ✅ Backend on Render
- ✅ Full app working
- ✅ RAG-powered assistance
- ✅ Voice features
- ✅ Report generation

---

**Deploy now and your app will be live!** 🚀

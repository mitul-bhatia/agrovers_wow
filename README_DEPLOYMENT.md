# Agrovers Soil Assistant - Deployment Ready 🌾

## Quick Install (One Command)

```bash
chmod +x install.sh && ./install.sh
```

Then edit `backend/.env` with your API keys and start the servers.

## Manual Installation

### Backend
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your API keys
uvicorn app.main:app --host 0.0.0.0 --port 8001
```

### Frontend
```bash
cd frontend
npm install
npm run dev
```

## Required API Keys

1. **Groq API** (Required)
   - Get from: https://console.groq.com/keys
   - Free tier: 30 requests/minute
   - Used for: LLM, STT, Report Generation

2. **Google Gemini API** (Optional)
   - Get from: https://makersuite.google.com/app/apikey
   - Free tier: 60 requests/minute
   - Used for: Backup LLM

## File Structure
```
agrovers/
├── backend/
│   ├── app/
│   │   ├── routes/          # API endpoints
│   │   ├── services/        # Business logic
│   │   ├── models.py        # Data models
│   │   └── main.py          # FastAPI app
│   ├── data/                # Knowledge base & FAISS index
│   ├── audio/               # Generated TTS files
│   ├── requirements.txt     # Python dependencies
│   ├── requirements-prod.txt # Production dependencies
│   └── .env                 # Configuration (create from .env.example)
├── frontend/
│   ├── src/
│   │   ├── pages/           # React pages
│   │   ├── components/      # React components
│   │   └── api/             # API client
│   ├── package.json
│   └── vite.config.ts
├── install.sh               # Quick installation script
└── DEPLOYMENT_GUIDE.md      # Detailed deployment guide
```

## Key Features

✅ Multilingual (Hindi & English)
✅ Voice input/output (STT/TTS)
✅ AI-powered soil analysis
✅ Crop recommendations
✅ Fertilizer suggestions
✅ PDF report generation
✅ RAG-based knowledge base
✅ Real-time progress tracking

## Technology Stack

**Backend:**
- FastAPI (Python web framework)
- LangChain (LLM orchestration)
- Groq API (Fast LLM inference)
- FAISS (Vector search)
- Sentence Transformers (Embeddings)
- ReportLab (PDF generation)

**Frontend:**
- React + TypeScript
- Vite (Build tool)
- TailwindCSS (Styling)
- Axios (HTTP client)

## Production Deployment

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed instructions on:
- Docker deployment
- Cloud platform deployment (Render, Railway, Vercel)
- Traditional server setup
- Nginx configuration
- SSL/HTTPS setup
- Performance optimization

## Environment Variables

All configuration is in `backend/.env`:

```env
# Required
GROQ_LLM_API_KEY=your_key
GROQ_STT_API_KEY=your_key
GROQ_REPORT_API_KEY=your_key

# Optional
GEMINI_API_KEY=your_key
HOST=0.0.0.0
PORT=8001
```

## Troubleshooting

**Backend won't start:**
- Check Python version (3.9+ required)
- Verify API keys in `.env`
- Check if port 8001 is available

**Frontend won't build:**
- Check Node.js version (18+ required)
- Clear cache: `rm -rf node_modules && npm install`

**API errors:**
- Verify Groq API key is valid
- Check API rate limits
- Review backend logs

## Support

- Documentation: See DEPLOYMENT_GUIDE.md
- Issues: GitHub Issues
- Email: support@agrovers.com

## License

[Add your license]

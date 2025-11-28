# Agrovers Deployment Guide 🚀

## Prerequisites

- Python 3.9 or higher
- Node.js 18+ and npm
- Git
- 4GB+ RAM recommended
- API Keys: Groq API, Google Gemini API (optional)

## Quick Start (Local Development)

### 1. Clone Repository
```bash
git clone https://github.com/Shreyashgol/agri_agrovers.git
cd agri_agrovers
```

### 2. Backend Setup
```bash
cd backend

# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env
# Edit .env and add your API keys

# Run backend
uvicorn app.main:app --host 0.0.0.0 --port 8001 --reload
```

### 3. Frontend Setup
```bash
cd frontend

# Install dependencies
npm install

# Run frontend
npm run dev
```

### 4. Access Application
- Frontend: http://localhost:5174
- Backend API: http://localhost:8001
- API Docs: http://localhost:8001/docs

## Environment Variables

Create `backend/.env` file:

```env
# Required
GROQ_LLM_API_KEY=your_groq_api_key_here
GROQ_STT_API_KEY=your_groq_api_key_here
GROQ_REPORT_API_KEY=your_groq_api_key_here

# Optional
GEMINI_API_KEY=your_gemini_api_key_here
GEMINI_REPORT_API_KEY=your_gemini_api_key_here

# Server Config
HOST=0.0.0.0
PORT=8001
```

## Production Deployment

### Option 1: Docker (Recommended)

Coming soon - Docker configuration will be added.

### Option 2: Traditional Server

#### Backend (Ubuntu/Debian)

```bash
# Install system dependencies
sudo apt update
sudo apt install python3.9 python3-pip python3-venv nginx

# Setup application
cd /var/www/agrovers/backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Install gunicorn for production
pip install gunicorn

# Run with gunicorn
gunicorn app.main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8001 \
  --timeout 120 \
  --access-logfile /var/log/agrovers/access.log \
  --error-logfile /var/log/agrovers/error.log
```

#### Frontend (Build & Serve)

```bash
cd frontend

# Build for production
npm run build

# Serve with nginx or any static server
# The build output is in frontend/dist
```

#### Nginx Configuration

```nginx
# /etc/nginx/sites-available/agrovers
server {
    listen 80;
    server_name your-domain.com;

    # Frontend
    location / {
        root /var/www/agrovers/frontend/dist;
        try_files $uri $uri/ /index.html;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:8001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 120s;
    }

    # Audio files
    location /audio {
        proxy_pass http://localhost:8001;
    }
}
```

### Option 3: Cloud Platforms

#### Render.com
1. Create new Web Service
2. Connect GitHub repository
3. Build Command: `cd backend && pip install -r requirements.txt`
4. Start Command: `cd backend && uvicorn app.main:app --host 0.0.0.0 --port $PORT`
5. Add environment variables

#### Railway.app
1. Create new project from GitHub
2. Add environment variables
3. Railway will auto-detect and deploy

#### Vercel (Frontend only)
1. Import GitHub repository
2. Framework: Vite
3. Build Command: `cd frontend && npm run build`
4. Output Directory: `frontend/dist`

## System Requirements

### Minimum
- CPU: 2 cores
- RAM: 2GB
- Storage: 5GB
- Bandwidth: 100GB/month

### Recommended
- CPU: 4 cores
- RAM: 4GB
- Storage: 10GB
- Bandwidth: 500GB/month

## Troubleshooting

### Backend won't start
```bash
# Check Python version
python3 --version  # Should be 3.9+

# Check if port is in use
lsof -i :8001

# Check logs
tail -f backend/backend.log
```

### Frontend build fails
```bash
# Clear cache
rm -rf node_modules package-lock.json
npm install

# Check Node version
node --version  # Should be 18+
```

### API Keys not working
- Verify keys are correct in `.env`
- Check if `.env` file is in `backend/` directory
- Restart backend after changing `.env`

## Performance Optimization

### Backend
- Use Redis for session storage (currently in-memory)
- Enable response caching
- Use CDN for static files
- Implement rate limiting

### Frontend
- Enable gzip compression
- Use CDN for assets
- Implement lazy loading
- Optimize images

## Security Checklist

- [ ] Change default secrets
- [ ] Enable HTTPS (SSL certificate)
- [ ] Set up CORS properly
- [ ] Implement rate limiting
- [ ] Add authentication (if needed)
- [ ] Regular security updates
- [ ] Backup database/sessions
- [ ] Monitor error logs

## Monitoring

### Recommended Tools
- **Uptime**: UptimeRobot, Pingdom
- **Errors**: Sentry
- **Analytics**: Google Analytics, Plausible
- **Logs**: Papertrail, Loggly

## Support

For issues or questions:
- GitHub Issues: [Create an issue](https://github.com/Shreyashgol/agri_agrovers/issues)
- Email: support@agrovers.com

## License

[Add your license here]

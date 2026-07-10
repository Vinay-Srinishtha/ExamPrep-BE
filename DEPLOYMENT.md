# ExamPrep Backend Deployment Guide

## Quick Start

### 1. Environment Setup

```bash
# Copy the example and fill in production values
cp .env.production.example .env.production

# Required environment variables:
# DB_URL: PostgreSQL connection string (e.g., postgresql://user:pass@host:5432/jee_prep_db)
# JWT_SECRET: Generate with: openssl rand -hex 32
# API_ORIGIN: Frontend domain (e.g., https://examprep.example.com)
```

### 2. Database (Production)

**Option A: Neon (Recommended - serverless PostgreSQL)**
- Sign up at https://neon.tech
- Create a project, copy the `postgresql://...` connection string
- Set as `DB_URL` in .env.production

**Option B: Railway**
- Sign up at https://railway.app
- Create PostgreSQL plugin, copy connection string

**Option C: Heroku Postgres** (legacy, paid)
- `heroku addons:create heroku-postgresql:standard`

**Once DB is provisioned:**

```bash
# Run migrations
DB_URL=<your-prod-db-url> bundle exec rake db:migrate

# Seed demo accounts (OPTIONAL - prod should typically skip this)
DB_URL=<your-prod-db-url> bundle exec rake db:seed
```

### 3. Backend Deployment

**Option A: Render (Recommended)**
- Connect GitHub repo to Render
- Create new "Web Service"
- Set Environment:
  ```
  RACK_ENV=production
  DB_URL=<from-above>
  JWT_SECRET=<your-secret>
  API_ORIGIN=https://your-frontend-domain.com
  ```
- Render auto-runs migrations from `Procfile`

**Option B: Railway**
- Connect repo, add PostgreSQL plugin
- Environment variables auto-setup

**Option C: Heroku**
```bash
heroku create examprep-api
heroku config:set RACK_ENV=production
heroku config:set DB_URL=$(heroku config:get DATABASE_URL)
heroku config:set JWT_SECRET=<your-secret>
heroku config:set API_ORIGIN=https://your-frontend-domain.com
git push heroku master
```

### 4. Verify Deployment

```bash
curl https://your-api-domain.com/api/version
# Should return: {"status": "success", "version": 1}
```

## Architecture

- **Language**: Ruby 3.4
- **Framework**: Roda (lightweight routing) + Sequel (ORM)
- **Database**: PostgreSQL (migrations in `/src/migrations`)
- **API**: RESTful with JWT auth, CORS enabled

## Key Endpoints

- `POST /api/login` - Student/parent/admin login
- `GET /api/syllabus/tree` - Full JEE exam syllabus
- `GET /api/progress` - Student progress tracking
- `PUT /api/progress/:id` - Update item completion
- `GET /api/parent/students` - Parent's linked children
- `GET /api/admin/*` - Admin CRUD endpoints

## Troubleshooting

**Migration errors:**
```bash
DB_URL=<prod-url> bundle exec rake db:rollback  # Rollback last migration
DB_URL=<prod-url> bundle exec rake db:migrate   # Re-run
```

**Database connection refused:**
- Check DB_URL format: `postgresql://user:password@host:port/dbname`
- Verify IP/firewall rules allow connection from deployment server

**500 errors:**
- Check application logs on Render/Railway/Heroku dashboard
- JWT_SECRET mismatch between frontend and backend will cause 401s

## Production Checklist

- [ ] Database provisioned and migrations run
- [ ] JWT_SECRET generated and set (use `openssl rand -hex 32`)
- [ ] API_ORIGIN points to actual frontend domain
- [ ] Backend deployed and health check passes
- [ ] Frontend `.env.production.local` points to backend API
- [ ] Frontend deployed
- [ ] Custom domain configured with HTTPS
- [ ] Monitoring/logging configured (optional)

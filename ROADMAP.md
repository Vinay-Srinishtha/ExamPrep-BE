# ExamPrep Full Deployment Roadmap

**Project Status:** Backend & Frontend fully built, wired together, ready for production deployment

---

## 🎯 Phase 1: Foundation (COMPLETED ✅)

### Backend Core
- [x] Sequel ORM + PostgreSQL schema (16 migrations)
  - Roles, Users, Student Profiles, Parent Links
  - Exams, Subjects, Chapters, Sections, Subtopics, Learning Items
  - Progress tracking (StudentLearningStatus, StudySessions)
  - Readiness scoring, Audit logs
- [x] Role-based access control (STUDENT, PARENT, ADMIN, SUPER_ADMIN)
- [x] JWT authentication (email/password login)
- [x] Seed script with full JEE syllabus + 11 demo users

### API Endpoints
- [x] Public: `/api/login`, `/api/forgot-password`, `/api/reset-password`, `/api/version`
- [x] Student: `/api/syllabus/tree`, `/api/progress` (read/write), `/api/readiness`, `/api/study-sessions`
- [x] Parent: `/api/parent/students`, `/api/parent/students/:id/progress`
- [x] Admin: Full CRUD for users, exams, subjects, chapters, sections, subtopics, learning-items, parent-links
- [x] Admin: `/api/admin/students/:id/progress`

### Frontend Core
- [x] Next.js React SPA with 3000+ line dashboard
- [x] Three role-based views: Student Dashboard, Parent Dashboard, Admin Console
- [x] Client-side state management with localPlannerDb
- [x] JWT token storage + authentication guard
- [x] API client with Bearer token injection
- [x] Data hydration layer (fetches real backend data post-login)

### Local Testing
- [x] Backend running on localhost:9292
- [x] Frontend running on localhost:3000
- [x] All three login flows tested (Student, Parent, Admin)
- [x] Real data flowing from backend to frontend
- [x] Progress updates write back to backend via PUT /api/progress/:id

---

## 🚀 Phase 2: Deployment (IN PROGRESS 🔄)

### Step 1: Database Setup ✅ DONE
- [x] Neon PostgreSQL provisioned
- [x] Connection string obtained
- [x] Ready for migrations

### Step 2: Backend Deployment (Vercel) — START HERE
**Time estimate: 10-15 minutes**

- [ ] Go to https://vercel.com
- [ ] Import ExamPrep-BE GitHub repo
- [ ] Add environment variables:
  ```
  DB_URL = postgresql://neondb_owner:npg_Gt6dpBkJjZW5@ep-nameless-unit-aicz5r3b.c-4.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
  JWT_SECRET = 3acaf371ac39c2ff6791e5b970f05e08f07ce13a1530fc84f9911d3f77e7c0a5
  API_ORIGIN = * (will update after frontend deploys)
  ```
- [ ] Deploy (Vercel will auto-run migrations)
- [ ] Copy backend URL from deployment (e.g., `https://examprep-be-xxx.vercel.app`)
- [ ] Test: `curl https://examprep-be-xxx.vercel.app/api/version`

### Step 3: Frontend Deployment (Vercel)
**Time estimate: 5-10 minutes**

- [ ] In Vercel dashboard, import ExamPrep-UI repo
- [ ] Add environment variable:
  ```
  NEXT_PUBLIC_API_BASE = https://examprep-be-xxx.vercel.app/api
  ```
- [ ] Deploy
- [ ] Copy frontend URL (e.g., `https://examprep-ui-xxx.vercel.app`)

### Step 4: Connect Frontend → Backend
- [ ] Go back to ExamPrep-BE Project Settings → Environment Variables
- [ ] Update `API_ORIGIN` to: `https://examprep-ui-xxx.vercel.app`
- [ ] Trigger redeploy on ExamPrep-BE
- [ ] Test login: visit frontend URL, try credentials:
  - **Student:** aarav.patel@student.com / student123
  - **Parent:** suresh.patel@parent.com / parent123
  - **Admin:** admin.rahul@jeeprep.com / admin123

### Step 5: Custom Domain (Optional but Recommended)
**Time estimate: 15 minutes**

- [ ] Buy domain (if needed)
- [ ] In Vercel Dashboard:
  - ExamPrep-BE: Domain settings → add `api.yourdomain.com`
  - ExamPrep-UI: Domain settings → add `yourdomain.com`
- [ ] Update DNS records (Vercel shows exact steps)
- [ ] Wait for DNS propagation (~5-30 min)
- [ ] Update env vars:
  - Backend: `API_ORIGIN = https://yourdomain.com`
  - Frontend: `NEXT_PUBLIC_API_BASE = https://api.yourdomain.com/api`

---

## 📋 Phase 3: Post-Deployment Tasks (NEXT)

### Testing & Validation
- [ ] Smoke test all three login flows in production
- [ ] Verify student progress updates write to prod database
- [ ] Check parent can see linked students
- [ ] Verify admin can view/manage all users
- [ ] Test password reset flow
- [ ] Monitor error logs (Vercel → Function Logs)

### Security Hardening
- [ ] Review CORS settings (currently `API_ORIGIN = *` or specific domain)
- [ ] Enable HTTPS only (Vercel auto-does this)
- [ ] Rotate JWT_SECRET (generate new one, update both repos)
- [ ] Set up error monitoring (Sentry, Datadog, or similar)
- [ ] Add rate limiting to `/api/login` endpoint
- [ ] Review database credentials (Neon allows IP whitelisting)

### Database Backup & Recovery
- [ ] Set up automated Neon backups (Neon handles this, check settings)
- [ ] Test restore procedure
- [ ] Document backup location

### Monitoring & Logging
- [ ] Set up Vercel function logs alerts
- [ ] Configure database query monitoring
- [ ] Add application-level logging (currently basic Rails logging)
- [ ] Set up uptime monitoring (e.g., UptimeRobot)

---

## 🎓 Phase 4: Feature Completeness (BACKLOG)

### Features Marked as "Local-Only" (Not Yet Wired to Backend)
- [ ] **Today's Plan Scheduling Heuristic**
  - Currently: Client-side algorithm
  - Needed: Backend endpoint `/api/today-plan` or similar
  - Impact: Medium (nice-to-have, works locally for now)

- [ ] **Readiness Calculation**
  - Currently: UI computes heuristic from completion %
  - Backend has: `/api/readiness` endpoint but UI doesn't consume it
  - Needed: Wire frontend to real readiness API
  - Impact: Medium (accuracy improvement)

- [ ] **Dependency Manager**
  - Currently: UI shows empty view
  - Needed: Seed `topic_dependencies` data + frontend wiring
  - Impact: Low (feature not yet in scope)

### Email/Communication Features (Not Yet Implemented)
- [ ] Password reset email notifications
- [ ] Parent approval notifications
- [ ] Study session reminders
- [ ] Progress milestones/achievements

### Admin Features (Stubbed but Not Fully Tested)
- [ ] CSV import for bulk student data
- [ ] CSV export for progress reports
- [ ] Syllabus version management
- [ ] Audit log queries

### Parent Features (Working but Could Enhance)
- [ ] Parent-student link approval workflow (backend done, UI basic)
- [ ] Parent notifications for low progress
- [ ] Parent-to-student messaging

---

## 📊 Current Deployment Status

| Component | Status | Location | Health Check |
|-----------|--------|----------|---------------|
| Backend Code | ✅ Ready | GitHub: ExamPrep-BE | `GET /api/version` |
| Frontend Code | ✅ Ready | GitHub: ExamPrep-UI | Login page loads |
| Database (Neon) | ✅ Ready | Neon Console | Connection test |
| Backend Deploy | 🔄 In Progress | Vercel | Awaiting step 2 |
| Frontend Deploy | ⏳ Waiting | Vercel | Awaiting step 3 |
| Domain | ⏳ Optional | - | Awaiting step 5 |
| End-to-End Test | ⏳ Blocked | - | After steps 2-4 |

---

## 🎯 Quick Deployment Checklist

**Backend (Vercel):**
```
[ ] vercel.com login
[ ] Import ExamPrep-BE
[ ] Set 3 env vars (DB_URL, JWT_SECRET, API_ORIGIN)
[ ] Deploy → note backend URL
[ ] Test: curl https://examprep-be-xxx.vercel.app/api/version
```

**Frontend (Vercel):**
```
[ ] Import ExamPrep-UI
[ ] Set NEXT_PUBLIC_API_BASE = https://examprep-be-xxx.vercel.app/api
[ ] Deploy → note frontend URL
[ ] Test: Login with demo credentials
```

**Cross-Repo Connection:**
```
[ ] Go back to ExamPrep-BE env vars
[ ] Update API_ORIGIN = https://examprep-ui-xxx.vercel.app
[ ] Redeploy ExamPrep-BE
[ ] Re-test login on frontend
```

---

## 📞 Support & Troubleshooting

### Common Issues

**Backend build fails on Vercel:**
- Check Vercel logs (Function Logs tab)
- Ensure `vercel.json` exists (it does, committed)
- Verify DB_URL and JWT_SECRET are set

**Frontend blank page:**
- Check browser console (DevTools)
- Verify NEXT_PUBLIC_API_BASE is set
- Check Network tab — API calls should go to backend URL

**Login fails with 401:**
- Backend JWT_SECRET mismatch with frontend
- Ensure both are using the same secret
- Check API logs for validation errors

**Database migration timeout:**
- Vercel may need longer build timeout (rare)
- Check if Neon is reachable from Vercel's servers
- Neon may have connection limits — verify in console

---

## 📈 Post-Launch Enhancements (Phase 5+)

**Short-term (1-2 weeks):**
- Wire remaining local-only features to backend
- Add email notifications
- Set up monitoring & alerting

**Medium-term (1 month):**
- Mobile app (React Native using same API)
- Offline sync capability
- Enhanced analytics dashboard

**Long-term (Q2+):**
- Live collaboration (multiple students studying together)
- AI-powered personalized study recommendations
- Integration with coaching platforms
- Video lesson embedding

---

## 💾 GitHub Repos

- **Backend:** https://github.com/Vinay-Srinishtha/ExamPrep-BE (public)
- **Frontend:** https://github.com/Vinay-Srinishtha/ExamPrep-UI (private)

**Current Branch Status:**
- Backend: `master` (latest: df42ea9 - Add Vercel config)
- Frontend: `main` (latest: ad80a37 - Add deployment guide)

---

## 🚦 Next Immediate Action

**START HERE:** Complete Phase 2, Step 2 (Backend Deployment on Vercel)
- Open https://vercel.com
- Import ExamPrep-BE
- Follow the 5 steps outlined in Phase 2

**Estimated total time to live:** 20-30 minutes

---

Generated: 2026-07-11 | Last Updated: Phase 2 In Progress

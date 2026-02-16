# 🚀 ATTENDANCE FUSION — Migration & Sanitization Context

> **Created:** 2026-02-15
> **Origin:** Forked from `seagma-presensi` (commercial client project)
> **Purpose:** Competition-ready version with ALL client branding & secrets removed
> **Status:** ⚠️ UNSANITIZED — Do NOT publish until all tasks below are complete

---

## 1. WHAT IS THIS PROJECT?

This is a **clean copy** of the "Seagma Presence" attendance app, stripped of Git history (`.git` deleted, fresh `git init` done). The codebase is functionally identical to the original but needs **full rebranding and secret removal** before it can be submitted for competition.

### Tech Stack (LOCKED — Do Not Change)

- **Framework:** Flutter (Dart SDK >=3.2.0)
- **State Management:** GetX 4.6.6
- **Local Database:** Isar 3.1.0
- **Remote Backend:** PocketBase 0.19.0
- **Maps:** flutter_map + OpenStreetMap (free)
- **Android:** AGP 8.7.0, compileSdk 35, minSdk 24
- **Architecture:** Clean Architecture (core → data → modules)

---

## 2. CRITICAL: WHAT MUST BE DONE (Checklist)

### 🔴 Phase 1: Secret Removal (HIGHEST PRIORITY)

- [ ] **Replace `.env` file** — Contains production S3 keys, admin password, PocketBase URL
  - Current secrets: `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `PB_ADMIN_PASSWORD=Sagamuda585858`
  - Replace with demo values pointing to new PocketBase instance
  - Template:
    ```env
    POCKETBASE_URL=http://127.0.0.1:8090
    S3_ENDPOINT=
    S3_ACCESS_KEY=
    S3_SECRET_KEY=
    S3_BUCKET_NAME=
    S3_REGION=
    PB_ADMIN_EMAIL=admin@attendancefusion.demo
    PB_ADMIN_PASSWORD=Demo123456
    OSM_TILE_URL=https://tile.openstreetmap.org/{z}/{x}/{y}.png
    SENTRY_DSN=
    APP_ENV=development
    ```

- [ ] **Fix 2 hardcoded production URLs** (bypass .env, directly reference client server):
  - `lib/data/models/leave_request_model.dart` line 36:
    `'https://db-seagmapresence.sagamuda.cloud/api/files/...'` → use `AppConstants.pocketBaseUrl`
  - `lib/modules/admin/analytics/widgets/analytics_employee_row.dart` line 25:
    `"https://db-seagmapresence.sagamuda.cloud/api/files/..."` → use `AppConstants.pocketBaseUrl`

### 🟡 Phase 2: Rebranding ("Seagma" → "Attendance Fusion")

- [ ] **`pubspec.yaml`:**
  - `name: seagma_presensi` → `name: attendance_fusion`
  - `description: Aplikasi Presensi Seagma` → `description: Attendance Fusion - Smart HR Attendance`
  - Update `flutter_icons` paths after replacing images

- [ ] **`android/app/build.gradle.kts`:**
  - `namespace = "com.seagma.seagma_presence"` → `"com.attendancefusion.app"`
  - `applicationId = "com.seagma.seagma_presence"` → `"com.attendancefusion.app"`

- [ ] **`lib/main.dart`:**
  - `SeagmaPresenceApp` class → `AttendanceFusionApp`
  - `runApp(const SeagmaPresenceApp())` → `runApp(const AttendanceFusionApp())`

- [ ] **`lib/core/constants/app_constants.dart`:**
  - `appName = 'Seagma Presence'` → `appName = 'Attendance Fusion'`
  - Comment line 1: `SEAGMA PRESENCE` → `ATTENDANCE FUSION`

- [ ] **`lib/modules/attendance/checkin/widgets/checkin_map.dart`:**
  - `userAgentPackageName: 'com.seagma.seagma_presence'` → `'com.attendancefusion.app'`

- [ ] **All 498+ Dart imports:**
  - Global find & replace: `package:seagma_presensi/` → `package:attendance_fusion/`

- [ ] **Android package structure:**
  - Rename `android/app/src/main/kotlin/com/seagma/seagma_presence/` folder → `com/attendancefusion/app/`
  - Update `AndroidManifest.xml` if needed

- [ ] **Delete/rename `seagma_presensi.iml`** → `attendance_fusion.iml`

### 🟡 Phase 3: Asset Replacement

- [ ] Replace ALL 9 images in `assets/images/` (all say "seagma"):
  - `seagma logo.png`, `seagma logo - hitam.png`, `seagma logo - putih.png`
  - `seagma logo.svg`, `seagma logo - hitam.svg`, `seagma logo - putih.svg`
  - `seagma_icon.png`, `seagma_adaptive_fg.png`, `seagma_splash.png`
- [ ] Create new "Attendance Fusion" branding assets
- [ ] Update `pubspec.yaml` icon paths
- [ ] Run `flutter pub run flutter_launcher_icons` after replacing icons

### 🟢 Phase 4: Documentation Cleanup

- [ ] Rewrite `README.md` for competition
- [ ] Review/rewrite `ONBOARDING_REKAN.md` (references client onboarding)
- [ ] Review `docs/` folder — remove any client-specific documentation
- [ ] Delete `find_large_files.py` (utility, not needed)
- [ ] Delete `tool/generate_logo_variants.dart` or update references

### 🟢 Phase 5: Database Migration

- [ ] Setup new PocketBase instance (local or PocketHost.io)
- [ ] Import `pb_schema.json` (exported from production — structure only, no data)
- [ ] Seed dummy data: 1 admin user, 1 office location, 1 shift
- [ ] Update `.env` with new PocketBase URL
- [ ] Test login + basic attendance flow

### 🔵 Phase 6: AI Feature (LATER — After sanitization complete)

- [ ] Integrate Gemini API (`google_generative_ai` package)
- [ ] Create `AiInsightDataSource` + `AiInsightRepository`
- [ ] Build `AiSummaryCard` widget with typing animation
- [ ] System prompt: "Professional HR Consultant" analyzing JSON attendance data
- [ ] Privacy guard: anonymize names before sending to API (User A, User B, etc.)

---

## 3. COMPETITION NARRATIVE (SDG 8, 9, 16)

**Pitch:** "Attendance Fusion — AI-powered, Offline-First attendance management for underserved communities and SMEs in areas with poor internet connectivity"

- **SDG 8:** Decent Work & Economic Growth (enterprise-grade HR for small businesses)
- **SDG 9:** Industry, Innovation & Infrastructure (works offline via Isar)
- **SDG 16:** Peace, Justice & Strong Institutions (anti-fraud via geolocation + device binding)

**Demo Killer Feature:** Turn off internet → do attendance → turn on → show sync. "Even in remote villages, productivity is recorded."

---

## 4. ARCHITECTURE REFERENCE

```
lib/
├── app/          → Bindings, Routes, Theme
├── core/         → Constants, Errors, Utils, Widgets
├── data/         → Models (9 Isar collections), Repositories, Providers
├── modules/      → Feature modules (admin, auth, attendance, home, etc.)
└── services/     → Auth, Isar, Sync, Device, Location, WiFi, Time
```

**9 Isar Collections:** Attendance, DailyRecap, SyncQueue, User, Shift, OfficeLocation, Notification, LeaveRequest, DynamicOutpost

**8 PocketBase Collections:** users, attendance, office_locations, shifts, ganas_tickets, overtime_requests, departments, leave_requests

---

## 5. AUDIT REPORTS

Detailed audit reports are in `docs/migrasi/`:

- `1_identity_and_structure.md` — Project identity, dependencies, folder tree
- `2_sensitive_data_audit.md` — ALL secret/branding locations with line numbers
- `3_architecture_snapshot.md` — Database schema, sync flow, architecture diagram
- `4_assets_inventory.md` — Asset list with replacement actions

---

> **⚠️ DO NOT `git add` or `git push` UNTIL Phase 1 & 2 are COMPLETE.**
> The `.env` file currently contains PRODUCTION SECRETS.    
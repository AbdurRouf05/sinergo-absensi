# TASK C: Database & Architecture Snapshot

> Audit Date: 2026-02-15
> Auditor: Antigravity (Automated)
> Source: `d:\coding\flutter\presensi\seagma-presensi`

---

## 1. Architecture Pattern: Clean Architecture (Modified)

```
┌─────────────────────────────────────────────────┐
│                  PRESENTATION                    │
│  modules/                                        │
│  ├── admin/     (controllers, views, widgets)    │
│  ├── auth/      (login flow)                     │
│  ├── attendance/ (checkin, checkout)              │
│  ├── home/      (dashboard)                      │
│  ├── history/   (attendance records)             │
│  ├── leave/     (leave requests)                 │
│  ├── notifications/                              │
│  ├── profile/                                    │
│  ├── security/  (device security checks)         │
│  ├── analytics/ (employee analytics)             │
│  └── splash/    (splash screen)                  │
├─────────────────────────────────────────────────┤
│                     DOMAIN                       │
│  core/                                           │
│  ├── constants/ (AppConstants, ApiEndpoints)      │
│  ├── errors/    (AppExceptions)                  │
│  ├── utils/     (GeoUtils)                       │
│  └── widgets/   (BaseNetworkImage)               │
├─────────────────────────────────────────────────┤
│                      DATA                        │
│  data/                                           │
│  ├── models/      (Isar models + DTOs)           │
│  ├── mappers/     (UserMapper)                   │
│  ├── managers/    (SessionManager)               │
│  ├── providers/   (AuthProvider)                 │
│  └── repositories/                               │
│      ├── [remote] (PocketBase CRUD)              │
│      ├── interfaces/ (Abstractions)              │
│      └── local/   (Isar CRUD)                    │
├─────────────────────────────────────────────────┤
│                    SERVICES                      │
│  services/ (AuthService, IsarService,            │
│             SyncService, DeviceService,           │
│             LocationService, WiFiService,         │
│             TimeService)                          │
└─────────────────────────────────────────────────┘
```

---

## 2. State Management: **GetX**

**Evidence:**
| File | Line | Evidence |
|------|------|---------|
| `pubspec.yaml` | 14 | `get: 4.6.6` |
| `lib/main.dart` | 3 | `import 'package:get/get.dart';` |
| `lib/main.dart` | 47 | `return GetMaterialApp(...)` |
| `lib/main.dart` | 62 | `initialBinding: InitialBinding()` |

**Pattern:** Menggunakan `GetxController` + `Bindings` per module.

---

## 3. Database: Isar (Local) + PocketBase (Remote)

### 3.1 Isar Collections (9 total)

| #   | Collection            | File                                     | Purpose              |
| --- | --------------------- | ---------------------------------------- | -------------------- |
| 1   | `AttendanceModel`     | `data/models/attendance_model.dart`      | Rekaman absensi      |
| 2   | `DailyRecapModel`     | `data/models/daily_recap_model.dart`     | Rekap harian         |
| 3   | `SyncQueueModel`      | `data/models/sync_queue_model.dart`      | Antrian sync offline |
| 4   | `UserModel`           | `data/models/user_model.dart`            | Data karyawan        |
| 5   | `ShiftModel`          | `data/models/shift_model.dart`           | Data shift kerja     |
| 6   | `OfficeLocationModel` | `data/models/office_location_model.dart` | Lokasi kantor        |
| 7   | `NotificationModel`   | `data/models/notification_model.dart`    | Notifikasi           |
| 8   | `LeaveRequestModel`   | `data/models/leave_request_model.dart`   | Permohonan izin/cuti |
| 9   | `DynamicOutpostModel` | `data/models/dynamic_outpost_model.dart` | Posko dinamis        |

> [!NOTE]
> Semua model memiliki generated file `.g.dart` (Isar code generation). Saat migrasi, jalankan ulang `dart run build_runner build`.

### 3.2 PocketBase Collections (dari ApiEndpoints)

| Collection          | Endpoint                             |
| ------------------- | ------------------------------------ |
| `users`             | `/api/collections/users`             |
| `attendance`        | `/api/collections/attendance`        |
| `office_locations`  | `/api/collections/office_locations`  |
| `shifts`            | `/api/collections/shifts`            |
| `ganas_tickets`     | `/api/collections/ganas_tickets`     |
| `overtime_requests` | `/api/collections/overtime_requests` |
| `departments`       | `/api/collections/departments`       |

Tambahan (dari hardcoded URL):

- `leave_requests` (ditemukan di `leave_request_model.dart`)

**Total PocketBase collections: 8**

### 3.3 Local Repositories (Isar Access)

| Repository                    | File                                                            |
| ----------------------------- | --------------------------------------------------------------- |
| AttendanceLocalRepository     | `data/repositories/local/attendance_local_repository.dart`      |
| DynamicOutpostLocalRepository | `data/repositories/local/dynamic_outpost_local_repository.dart` |
| HrLocalRepository             | `data/repositories/local/hr_local_repository.dart`              |
| NotificationLocalRepository   | `data/repositories/local/notification_local_repository.dart`    |
| OfficeLocalRepository         | `data/repositories/local/office_local_repository.dart`          |
| SyncQueueRepository           | `data/repositories/local/sync_queue_repository.dart`            |
| UserLocalRepository           | `data/repositories/local/user_local_repository.dart`            |

### 3.4 Remote Repositories (PocketBase Access)

| Repository               | File                                                |
| ------------------------ | --------------------------------------------------- |
| AdminRepository          | `data/repositories/admin_repository.dart`           |
| AdminActionRepository    | `data/repositories/admin_action_repository.dart`    |
| AdminAnalyticsRepository | `data/repositories/admin_analytics_repository.dart` |
| AttendanceRepository     | `data/repositories/attendance_repository.dart`      |
| DynamicOutpostRepository | `data/repositories/dynamic_outpost_repository.dart` |
| LeaveRepository          | `data/repositories/leave_repository.dart`           |

---

## 4. Key Configuration Points

### Config File: `lib/core/constants/app_constants.dart`

- `pocketBaseUrl` — reads dari `.env` → **Titik utama ganti URL backend**
- `s3Endpoint` — reads dari `.env` → **Ganti ke empty/local saat migrasi**
- `s3BucketName` — reads dari `.env`
- `appName = 'Seagma Presence'` → **Ganti ke 'Attendance Fusion'**

### Config File: `.env`

- Semua konfigurasi runtime dibaca dari sini via `flutter_dotenv`
- **Ini satu-satunya file yang perlu diganti untuk switch backend** (kecuali 2 hardcoded URL)

---

## 5. Sync Architecture (Offline-First)

```
                    ┌──────────────┐
                    │  PocketBase   │
                    │   (Cloud)     │
                    └──────┬───────┘
                           │ HTTP/REST
                    ┌──────┴───────┐
                    │  SyncService  │
                    │  (2-way Sync) │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
        ┌─────┴────┐ ┌────┴────┐ ┌────┴─────┐
        │ Isar DB  │ │SyncQueue│ │ Services │
        │ (Local)  │ │(Offline)│ │(Auth,NTP)│
        └──────────┘ └─────────┘ └──────────┘
```

- Data ditulis ke Isar terlebih dahulu (offline-safe)
- SyncQueue menampung operasi yang belum terkirim
- SyncService menjalankan sync 2 arah saat online

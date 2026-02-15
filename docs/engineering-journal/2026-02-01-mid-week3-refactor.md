# Engineering Log: Mid-Week 3 Documentation Audit

**Date:** 2026-02-01
**Author:** AI Assistant (Antigravity)
**Sprint:** Week 3 - Data Management & HR Features

---

## 🚨 Critical Decisions & Warnings

This document serves as a **PERMANENT RECORD** of architectural decisions made during the Week 2-3 transition. Future developers **MUST NOT** revert these changes without understanding the context.

---

### 1. Database Field Rename: `user` → `employee`

**Collection:** `attendances`

**Problem:**
When syncing attendance records to PocketBase, API calls returned `HTTP 400 Bad Request`. The root cause was that `user` is a **reserved keyword** in PocketBase's filter/sort syntax.

**Example of Failure:**
```
GET /api/collections/attendances/records?filter=(user="xyz")
// Returns: Error 400 - Invalid filter syntax
```

**Solution:**
The field was renamed from `user` to `employee` in:
1.  **PocketBase Schema:** `attendances.employee` (Relation to `users` collection).
2.  **Flutter Model:** `AttendanceLocal.userId` remains for local storage, but API body maps to `employee`.
3.  **Repository:** `AttendanceRepository.syncToCloud()` explicitly uses `'employee': userId`.

**Affected Files:**
- `lib/data/repositories/attendance_repository.dart`
- `lib/modules/history/history_controller.dart`

> [!CAUTION]
> **DO NOT** rename this field back to `user`. It will break all sync operations.

---

### 2. Client-Side Sorting for History

**Problem:**
Attempting to use server-side sorting (`sort=-check_in_time`) or filtering with special characters caused `URL encoding errors` or `invalid sort field` errors from PocketBase.

**Solution:**
All sorting and filtering for the History module is now performed **client-side** in Dart after fetching raw data from PocketBase.

**Implementation:**
```dart
// In HistoryController.fetchRemoteHistory()
final result = await _authService.pb.collection('attendances').getList(
  page: 1,
  perPage: 50,
  filter: 'employee = "${user.odId}"', // Filter only
  sort: '-created', // Basic sort on safe field
);

// Client-side sort by check_in_time (more reliable)
final records = result.items;
records.sort((a, b) => b.created.compareTo(a.created));
```

**Rationale:**
- PocketBase's free tier has limitations on complex queries.
- Client-side sorting is performant for the expected data volume (<500 records/user).

---

### 3. MinIO/S3 Integration Abort

**Original Plan (from MASTER_ROADMAP):**
> Photo storage with CDN prefix -> MinIO (S3-Compatible)

**Decision (2026-02-01):**
MinIO integration is **CANCELLED**. All file uploads (attendance photos, medical documents for GANAS) will use **PocketBase's built-in file storage**.

**Rationale:**
1.  Reduces infrastructure complexity (no separate S3 server to manage).
2.  PocketBase file storage is sufficient for the expected load.
3.  Simplifies Flutter implementation (use PocketBase SDK directly).

**Impact on GANAS Module:**
- Document uploads for Leave Requests will use `pb.collection('leave_requests').create(..., files: [...])`.
- No separate CDN URL management needed.

---

## ✅ Completed Items (Week 2-3)

| Module | Status | Notes |
|--------|--------|-------|
| Attendance Check-In | ✅ Done | GPS, WiFi, Photo, Time validation |
| Attendance Check-Out | ✅ Done | Simple confirmation flow |
| Sync Engine (Up) | ✅ Done | Local -> Server with Retry |
| Sync Engine (Down) | ✅ Done | Server -> Local for History |
| History Module | ✅ Done | List, Filter, Sync Indicator |
| UI/UX Polish | ✅ Done | Match %, Live Clock, Permission Dialogs |

---

## ⏳ Pending Items (Week 3)

| Module | Status | Priority |
|--------|--------|----------|
| Shift Management | ❌ Not Started | HIGH |
| GANAS (Leave Request) | ❌ Not Started | MEDIUM |

---

## 🔮 Next Steps: Shift Module Architecture

**Requirements:**
1.  **Isar Entity:** `ShiftLocal` with fields: `id`, `name`, `startTime`, `endTime`, `graceMinutes`.
2.  **Sync Logic:** Download shift config from PocketBase upon login. Cache in Isar.
3.  **Validation Logic:** In `CheckinController.calculateStatus()`, compare `checkInTime` against `user.assignedShift.startTime + graceMinutes`.

**PocketBase Schema (Proposed):**
```
Collection: shifts
Fields:
  - name: text (e.g., "Shift Pagi", "Shift Siang")
  - start_time: text (e.g., "08:00")
  - end_time: text (e.g., "17:00")
  - grace_minutes: number (e.g., 15)

Collection: users (existing)
Fields:
  - ... existing fields ...
  - assigned_shift: relation (shifts) <- NEW
```

**Key Constraint:**
- The `attendances` API filter uses `employee`, not `user`. Any new queries involving user attendance **MUST** use this field name.

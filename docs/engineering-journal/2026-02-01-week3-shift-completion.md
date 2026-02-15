# 📔 Engineering Journal: Week 3 - Shift Completion & GANAS Kickoff
**Date:** 2026-02-01
**Author:** Antigravity (Senior AI Engineer)
**Status:** Shift Module Implemented

## 🚀 Achievements (Shift Module)
We have successfully integrated the Shift Management logic into the core attendance flow.

### 1. Dynamic Late Logic
- **Algorithm:** `CheckinController.calculateStatus()` now fetches the `ShiftLocal` assigned to the user.
- **Formula:** 
  ```dart
  Late Threshold = Shift Start Time + Grace Period
  IF CheckInTime > Late Threshold THEN Status = Late
  ELSE Status = Present
  ```
- **Fallback:** If no shift is assigned, defaults to 08:30 threshold.

### 2. Database Architecture (Isar v3)
- **New Entity:** `ShiftLocal` created.
- **Relationship:** `UserLocal` now has a `shiftId` field (FK).
- **Schema Update:** This change is **breaking**.
  > [!WARNING]
  > Since column types/names changed in `UserLocal`, `Isar.open()` might fail on existing installs.
  > **Fix:** Added auto-reset logic in `IsarService` to clear DB on schema mismatch, but manual "Clear Data" or Uninstall is recommended for clean testing.

### 3. UI & UX Improvements
- **Dashboard:** "Jam Kerja" section now updates dynamically to show the Shift Name and Time range (e.g., "Regular (08:00-17:00)").
- **Icons Fixed:** Added `uses-material-design: true` to `pubspec.yaml` to resolve missing icons.

## 🎯 Next Focus: GANAS (Leave Request)
We are moving to "Gerakan Anti-Nakal & Absen Sembarangan" (GANAS).

### Strategy Adjustment
- **Storage:** We strictly follow the decision to **ABANDON MinIO**.
- **New Approach:** use **PocketBase Native File Storage**.
- **Implementation:**
  - Use `http.MultipartFile` or PocketBase SDK `files` service.
  - Upload happens during `SyncService` execution (Offline-First).
  - Local file paths stored in `LeaveRequestLocal.attachmentPath`.

## 🛠️ Technical Debt & Notes
- **Test Mocks:** `checkin_controller_test.dart` and `checkout_controller_test.dart` required manual updates to `PureMockIsarService` to support the new `saveShift` methods.
- **Sync Engine:** Ensure `LeaveRequest` sync handles file uploads robustly (retry logic for large files).

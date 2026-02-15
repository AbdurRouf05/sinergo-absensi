# Engineering Journal: Security Hardening & Shift Logic Enforcement

**Date:** 2026-02-14 (Evening Session)
**Author:** AbdurRouf05 (Assisted by Antigravity)
**Focus:** Triple-Lock Security, Shift-Based Check-In Blocking, Employee Detail Enhancements

---

## 🚀 Summary

Evening session focused on three major areas: (1) hardening the security system with time manipulation and emulator blocking, (2) enforcing shift-based business rules for check-in, and (3) enhancing the Employee Detail page with shift picker and relocated reset device button.

## 🛠️ Changes Made

### 1. Employee Detail Page — Shift Picker & Reset Device

**Files:** `admin_controller.dart`, `employee_detail_view.dart`, `employee_manager_view.dart`

- Added `allShifts` RxList + `fetchAllShifts()` + `updateEmployeeShift()` to `AdminController`
- Rewrote `EmployeeDetailView` with 3 sections:
  - **Shift Kerja** — dropdown to change employee's assigned shift
  - **Akses Kantor** — multi-office checkbox (existing)
  - **Zona Berbahaya** — red danger zone with "Reset Device Binding" button
- Commented out old reset device `IconButton` in `EmployeeManagerView` (safety-first approach)
- Single "Simpan Perubahan" button saves both shift and office changes

### 2. Reset Device Performance Fix

**File:** `admin_employee_manager.dart`

- **Problem:** After resetting device, `syncMasterData()` was called — downloading ALL master data from PocketBase (slow)
- **Fix:** Direct Isar update of `UserLocal.registeredDeviceId = ''` instead of full sync
- Falls back to `syncMasterData()` only if direct update fails

### 3. Security — Triple Lock System

**File:** `security_service.dart`

Upgraded from "Double Lock" to "Triple Lock + Time Check":

| #   | Check                       | Result if Detected                                  |
| --- | --------------------------- | --------------------------------------------------- |
| 1   | Root / Jailbreak            | 🔴 Violation Page                                   |
| 2   | Mock Location (Double Lock) | 🔴 Violation Page                                   |
| 3   | **Emulator**                | 🔴 Violation Page ← **UPGRADED** (was warning-only) |
| 4   | **Time Manipulation**       | 🔴 Violation Page ← **NEW**                         |

- Time manipulation check uses `TimeService.detectTimeManipulation()` (NTP vs device time)
- Guarded with `Get.isRegistered<ITimeService>()` to avoid crash during early init
- Runs on **app startup** AND **every app resume** (`didChangeAppLifecycleState`)

### 4. Shift-Based Check-In Blocking

**Files:** `checkin_validator.dart`, `checkin_controller.dart`

Two new validation rules added to `CheckInValidator`:

| Rule                | Condition                           | Error Message                                    |
| ------------------- | ----------------------------------- | ------------------------------------------------ |
| **Work Day Check**  | Today not in `ShiftLocal.workDays`  | "Hari ini (minggu) bukan hari kerja shift Anda." |
| **Shift End Check** | Current time > `ShiftLocal.endTime` | "Jam kerja shift Anda telah berakhir (17:00)."   |

**Key design decisions:**

- Shift data fetched dynamically from Isar via `AuthService.currentUser.shiftOdId` → `IsarService.getShiftByOdId()` → per-user, per-shift enforcement
- **Check-out is NOT affected** — can happen anytime (supports overtime/lembur)
- Checkout crossing midnight (e.g. Sabtu → Minggu) is allowed since record started on a work day
- Manual overtime request feature intentionally deferred — current overtime claim at checkout is sufficient

### 5. Full Check-In Validation Pipeline (Final State)

```
1. Security (root/mock/emulator/time manipulation)
2. Device integrity
3. GPS location + mock detection
4. Geofence radius
5. Work Day check        ← NEW
6. Shift End Time check  ← NEW
7. Photo selfie
```

## 📝 Lessons Learned

1. **Dynamic > Hardcoded:** Using `ShiftLocal.endTime` and `workDays` from Isar instead of hardcoded values (17:00) ensures multi-shift support works automatically
2. **Security checks need guards:** `Get.isRegistered<T>()` prevents crashes when services aren't ready during app init sequence
3. **Comment before delete:** Old reset device button code preserved as comments for safe rollback — user's preferred safety strategy
4. **Direct DB update > Full sync:** For single-field changes, direct Isar update is significantly faster than triggering a full `syncMasterData()` round-trip

---

## ✅ Status

- `flutter analyze` = **0 errors**
- All changes compile clean
- Ready for manual testing on physical device

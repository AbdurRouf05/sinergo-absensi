# Engineering Journal: Schema Alignment & Stabilization

Date: 2026-02-08

## Context

User reported persistent crashes in Employee Management ("Red Screen") and 400 Bad Request errors in Admin Approval, despite initial fixes. A deep audit revealed significant discrepancies between the PocketBase database schema and the application code.

## Issues Identified & Fixes

### 1. Schema Mismatch (`MasterDataSyncManager.dart`)

**Issue:** The sync manager attempted to expand `assigned_shift` and `assigned_office_location`.
**Reality:** The database fields are simply `shift` and `office_id`.
**Fix:** Updated `expand` parameter to `office_id,shift`.

### 2. Invalid Sort Field (`AdminAnalyticsRepository.dart`)

**Issue:** `postLeaveRequestsByStatus` sorted by `-created`.
**Reality:** The `leave_requests` collection does not support sorting by `created` (or index is missing/restricted).
**Fix:** Changed sort to `-start_date`.
**Secondary Fix:** `getAllEmployees` sorted by `-created`. Changed to `-updated` for safety.

### 3. Null Safety Crashes (`UserModel.dart` & `AdminAnalyticsRepository.dart`)

**Issue:** "Null is not subtype of String" crash. Caused by `UserLocal.fromRecord` not handling nulls locally, or `Null` values passing through from DB.
**Fixes:**

- **Paranoid Parsing:** strict null checks added to `UserLocal.fromRecord`.
- **Crash Loop Prevention:** `getAllEmployees` now wraps individual record parsing in a try-catch block to skip malformed records instead of crashing the entire batch.
- **Remote First:** Bypassed potentially corrupt local Isar data by fetching directly from PocketBase.

### 4. Phantom Fields (`nip`, `job_title`)

**Audit:** User reported code attempting to read `nip` and `job_title`.
**Result:** Codebase search (`grep`) yielded NO results for these terms in `lib/`.
**Conclusion:** These fields likely existed in older versions or were removed previously. Current `UserLocal` and `UserMapper` do not reference them.

## Verification

- **Sync:** Verify `MasterDataSyncManager` runs without "Failed to expand" errors.
- **Admin Approval:** Verify list loads without 400 error.
- **Employee List:** Verify list loads without Red Screen.

## Next Steps

- Monitor logs for any other "Failed to expand" errors.
- Consider adding `nip` and `job_title` to schema if required by Business Logic (currently treated as non-existent).

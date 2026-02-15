# Engineering Journal: Operational Hotfixes & Data Privacy

**Date:** 2026-02-14
**Author:** AbdurRouf05 (Assisted by Gemini)
**Focus:** Critical Fixes for Admin Operations & App Stability

---

## 🚀 Summary

Today's session focused on resolving operational blockers reported during UAT (User Acceptance Testing) for the Admin Dashboard and Check-in features. The main issues involved data synchronization, app stability (crashes), and API restrictions.

## 🛠️ Critical Fixes

### 1. Check-in Dropdown Crash (Red Screen)

- **Issue:** The "Presensi Masuk" screen crashed with a red screen error (`Value not in items`) when reloading data.
- **Cause:** The `DropdownButton` was using `OfficeLocationLocal` objects as values. When `refreshOffices()` ran, it replaced the list with _new_ objects. Even if the data was identical, `Object A (Limit 1)` != `Object B (Limit 1)`, causing the dropdown to think the selected value was missing from the list.
- **Fix:** Refactored `OfficeSelectorDropdown` to use `odId` (String) as the value. Strings are compared by value, not reference, ensuring stability across reloads.
- **Code:**
  ```dart
  // Before: Value = object
  value: selectedOffice,
  // After: Value = string ID
  value: offices.any((o) => o.odId == selected?.odId) ? selected?.odId : null,
  ```

### 2. "Add Employee" Stuck Loading / Error 400

- **Issue:** The "Simpan Karyawan" button kept loading indefinitely or returned a generic error.
- **Cause 1 (Stuck):** Exception handling was incomplete, swallowing errors without turning off `isLoading`.
- **Cause 2 (Error 400):** The payload included `"verified": true`. PocketBase (v0.22+) by default restricts setting `verified` during creation for non-superusers (even Admins), unless specifically allowed in API rules.
- **Fix:**
  - Added `finally { isLoading.value = false }` block.
  - Removed `"verified": true` from the creation payload.
  - Improved error message parsing to show specific validation errors (e.g., "Email invalid").

### 3. Sync Not Updating Office Permissions

- **Issue:** Changing an employee's allowed offices in Admin Panel didn't reflect in their App until re-login.
- **Cause:** The `syncData()` method only refreshed Master Data (Offices/Shifts) but did _not_ reload the `currentUser` record from local DB (which contains the updated `office_id` list).
- **Fix:** Added `_isarService.getCurrentUser()` reload step inside `CheckinController.syncData()` and triggered `officeSelectionManager.refreshOffices()`.

### 4. Admin API Access (Missing Emails)

- **Issue:** Admin login on mobile resulted in hidden emails (`***`) and inability to create users.
- **Cause:** PocketBase `users` collection API rules were set to "Superusers Only" (Empty/Locked). Admin users (role='admin') are technically "regular users" in the eyes of the API unless rules explicitly allow them.
- **Fix:** Updated API Rules in PocketBase Dashboard:
  - List/View: `id = @request.auth.id || @request.auth.role = 'admin'`
  - Create/Delete: `@request.auth.role = 'admin'`

## 📝 Lessons Learned

1.  **Dropdowns Hate Objects:** Always use primitive types (String ID, int Index) for Dropdown values in Flutter, especially when the list data is mutable or refreshable.
2.  **API Rules are Strict:** "Empty" API Rule in PocketBase `users` collection means **Blocked**, not Public. Always define explicit rules.
3.  **Silent Failures:** Always use `finally` blocks for loading states. A stuck loading spinner is worse than an error message.
4.  **Local State vs. Remote Truth:** When syncing, ensure the _Session_ logic (Current User) is also refreshed, not just the _Data_ logic (Lists).

---

## ✅ Next Steps

- Validate fairness logic for Late vs. Overtime.
- Hardening "Admin Edit Employee" (currently only Add is fixed).
- Finalize "Phase 6" items in Roadmap.

# Engineering Journal - 2026-02-14

## 🩹 The "Zombie Data" & "Ghost Email" Fix (Isar Unique Index Violation)

**Context:**
Despite implementing a "Check-Then-Upsert" pattern in `UserLocalRepository` to prevent duplicate user inserts, the application continued to crash with `IsarError: Unique index violated` during the `syncEmployees` process. This persisted even after attempting to clear local data manually.

### 1. The "Zombie Data" Problem (Error #13)

**Symptoms:**

- App crashes on startup or sync.
- Logs show `Unique index violated`.
- Occurs even if code logic for `saveUsers` is correct (upsert).

**Root Cause:**
The local Isar database contained **corrupted or "zombie" data** from previous failed syncs. These records had internal Isar IDs that didn't match the new logic's expectations, causing conflicts. The data was "stubborn"—it couldn't be simply updated because the unique index constraint was already violated by existing hidden duplicates.

**Solution: The "Self-Healing" Mechanism**
We implemented a `try-catch-nuke-retry` pattern in `MasterDataSyncManager`:

```dart
try {
  await _isarService.saveUsers(users); // Try normal sync
} catch (e) {
  if (e.toString().contains('Unique index violated') && !isRetry) {
    // 1. Detect the specific error
    _logger.w('⚠️ Unique index violation detected. Clearing local users and retrying...');

    // 2. NUKE: Clear strictly the Users collection (Safe because relations are loosely coupled via Strings)
    await _isarService.clearUsers();

    // 3. RETRY: Recursive call to sync again with a clean slate
    await syncEmployees(isRetry: true);
  }
}
```

This acts as an automatic "Factory Reset" for the user data whenever corruption is detected, without affecting other data like Attendance History (which uses `userId` string references, not direct links).

---

### 2. The "Ghost Email" Problem (Error #14)

**Symptoms:**

- Even after the "Self-Healing" wipe, the error persisted immediately upon re-syncing.
- Logs showed the error happened _after_ fetching new data.

**Root Cause:**
The `users` collection in PocketBase has a `unique` constraint on the `email` field.
However, **API Rules or Visibility settings** caused some users to return an **empty string** (`""`) for their email.

- User A: Email = `""` (Hidden by visibility rule)
- User B: Email = `""` (Hidden by visibility rule)
- Isar: _"Error! User A and User B have the same email ('')! PROHIBITED!"_ -> **Unique Index Violation**.

**Solution: Placeholder Emails**
We modified the `UserMapper` (`UserLocal.fromRecord`) to ensure the email field is **never empty**, even if the API returns null/empty.

```dart
..email = (() {
  final e = getSafeString('email');
  // If email is empty (hidden/missing), generate a unique placeholder
  return e.isNotEmpty ? e : 'missing_${record.id}@local.placeholder';
})()
```

**Result:**

- User A: `missing_abc123@local.placeholder`
- User B: `missing_xyz789@local.placeholder`
- Isar: _"Emails are different. Valid!"_ ✅

### 3. Conclusion

The combination of **Self-Healing** (to clean old corruption) and **Robust Parsing** (to handle empty/hidden fields) has fully resolved the critical sync crash. All employee data now appears correctly in Live Monitoring, Analytics, and Employee Management.

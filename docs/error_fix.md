# Error Fix Log - Seagma Presensi

Dokumen ini mencatat semua error kritis dan cara penanganannya selama development aplikasi Seagma Presensi.

---

## Error #1: Auth Login Crash - Null Safety Violation

**Tanggal:** 2026-02-06  
**Severity:** ⛔ Critical  
**Status:** ✅ Resolved  
**Modul Terdampak:** Authentication, User Mapping, Data Providers

### Deskripsi Error

Aplikasi crash saat login dengan pesan:

```
type 'Null' is not a subtype of type 'String'
```

**Langkah Reproduksi:**

1. User baru melakukan login di device baru
2. Autentikasi PocketBase berhasil
3. Device binding berhasil
4. **CRASH** saat membuat `UserModel` dari record

**Lokasi Error:**

- `AuthService.dart` (login method)
- `UserMapper.dart` (\_parseAndSaveShift)
- `UserLocal.fromRecord` factory

### Root Cause (Akar Masalah)

Setelah audit mendalam, ditemukan **3 penyebab utama**:

#### 1. Inkonsistensi Nama Field Relasi

Database schema menggunakan field `shift`, tetapi kode menggunakan `assigned_shift`.

| File                | Expand Key Lama            | Status   |
| ------------------- | -------------------------- | -------- |
| `AuthService.dart`  | `assigned_shift,office_id` | ❌ SALAH |
| `AuthProvider.dart` | `assigned_shift,office_id` | ❌ SALAH |
| `UserMapper.dart`   | `assigned_shift`           | ❌ SALAH |

**Dampak:** PocketBase mengembalikan `expand: null` karena field tidak ditemukan.

#### 2. Unsafe Parsing di UserMapper

Kode lama melakukan cast langsung tanpa pengaman:

```dart
// BEFORE (UNSAFE)
final shift = ShiftLocal()
  ..odId = shiftData['id']           // CRASH jika null
  ..name = shiftData['name']         // CRASH jika null
  ..startTime = shiftData['start_time'];
```

#### 3. Tidak Ada Default Fallback

`UserLocal.fromRecord` tidak memiliki mekanisme fallback untuk data relasi kosong.

### Solusi

#### 1. Standardisasi Key Relasi

Semua file diubah menggunakan key yang benar: `expand: 'shift,office_id'`

**Files Modified:**

- `lib/services/auth_service.dart` (Line 126)
- `lib/data/providers/auth_provider.dart` (Line 18, 45)
- `lib/data/mappers/user_mapper.dart` (Line 14 - dual check)

#### 2. Crash-Proof Parsing

Implementasi defensive parsing dengan default values:

```dart
// AFTER (SAFE)
final shift = ShiftLocal()
  ..odId = shiftData['id']?.toString() ?? ''
  ..name = shiftData['name']?.toString() ?? 'Regular Shift'
  ..startTime = shiftData['start_time']?.toString() ?? '08:00'
  ..endTime = shiftData['end_time']?.toString() ?? '17:00'
  ..graceMinutes = (shiftData['grace_minutes'] is int)
      ? shiftData['grace_minutes']
      : int.tryParse(shiftData['grace_minutes']?.toString() ?? '0') ?? 0;
```

**Prinsip:**

- Semua field menggunakan `.toString() ?? defaultValue`
- Tidak ada cast langsung yang berbahaya
- Default value sesuai business logic

#### 3. Enhanced Factory Pattern

Tambahkan helper functions di `UserLocal.fromRecord`:

```dart
String getSafeExpandName(String key, String defaultVal) {
  if (expand.containsKey(key)) {
    final items = expand[key];
    if (items != null && items.isNotEmpty) {
       return items.first.data['name']?.toString() ?? defaultVal;
    }
  }
  return defaultVal;
}
```

### Validation

**Manual Testing:**

- ✅ Login user baru di device baru
- ✅ Login user existing di device yang sama
- ✅ Login dengan data shift kosong
- ✅ Login dengan data office kosong

**Expected Behavior:**

- Tidak ada crash `Null subtype String`
- Default values muncul jika data tidak lengkap:
  - Shift: "Regular Shift"
  - Office: "Kantor Pusat"
  - Name: "User"

### Lessons Learned

1. **Field Naming Consistency:** Pastikan nama field di kode selalu match dengan schema database
2. **Defensive Parsing:** Selalu gunakan `.toString() ?? default` untuk parsing data dari API
3. **Factory Pattern Safety:** Factory constructors harus crash-proof, tidak boleh assume data lengkap
4. **Audit Trail:** Refactoring besar (200 LOC limit) bisa menyebabkan inkonsistensi jika tidak diaudit menyeluruh

---

## Error #2: Isar Unique Index Violation - Login Idempotency

**Tanggal:** 2026-02-06  
**Severity:** ⛔ Critical  
**Status:** ✅ Resolved  
**Modul Terdampak:** Isar Database, User/Office/Shift Repositories

### Deskripsi Error

Aplikasi crash saat login kedua kali (re-login) atau setelah logout dengan pesan:

```
IsarError: Unique index violated
```

**Langkah Reproduksi:**

1. Login pertama dengan user → SUCCESS
2. Logout (data Isar TIDAK dihapus)
3. Login lagi dengan user yang sama → **CRASH**

**Lokasi Error:**

- `UserLocalRepository.saveUser()` (saat `put` operation)
- Terjadi juga di `OfficeLocalRepository` dan `ShiftLocalRepository`

### Root Cause (Akar Masalah)

**Arsitektur Bermasalah:**

```dart
class UserLocal {
  Id id = Isar.autoIncrement;  // Generates NEW id every time

  @Index(unique: true)
  late String odId;  // PocketBase ID (unique constraint)
}
```

**Alur Login:**

1. **Login Pertama:** `UserLocal(id: 1, odId: "abc123")` → INSERT SUCCESS
2. **Login Kedua:** `UserLocal.fromRecord()` membuat objek BARU dengan `id: 2` (autoIncrement)
3. Isar mencoba INSERT record baru dengan `id: 2` tetapi `odId: "abc123"` sudah ada
4. **UNIQUE CONSTRAINT VIOLATION** → CRASH

**Kesimpulan:** `put()` hanya upsert jika Isar ID sama. Karena kita selalu buat ID baru, Isar selalu coba INSERT alih-alih UPDATE.

### Solusi

Implementasi **Check-Then-Upsert Pattern**:

```dart
Future<int> saveUser(UserLocal user) async {
  return await _isar.writeTxn(() async {
    // IDEMPOTENCY FIX: Check if user exists by unique odId
    final existing = await _isar.userLocals
        .filter()
        .odIdEqualTo(user.odId)
        .findFirst();

    if (existing != null) {
      user.id = existing.id;  // Reuse existing ID
    }
    // else: user.id stays as autoIncrement for new users

    return await _isar.userLocals.put(user);  // Now triggers UPDATE
  });
}
```

**Prinsip:**

1. Sebelum save, cari record existing berdasarkan `odId` (unique index)
2. Jika ada, reuse Isar ID yang lama
3. `put()` sekarang melakukan UPDATE (bukan INSERT)

**Files Modified:**

- `lib/data/repositories/local/user_local_repository.dart` (saveUser, saveUsers)
- `lib/data/repositories/local/office_local_repository.dart` (saveOfficeLocation)
- `lib/data/repositories/local/hr_local_repository.dart` (saveShift)

### Validation

**Manual Testing:**

- [ ] Login pertama dengan `test@test.com` → SUCCESS
- [ ] Logout (data Isar tetap ada)
- [ ] Login kedua dengan `test@test.com` → SUCCESS (no crash)
- [ ] Cek Isar DB: hanya 1 record user (tidak duplikat)
- [ ] Login dengan user berbeda (`admin@test.com`) → SUCCESS (insert baru)

**Expected Behavior:**

- Tidak ada crash `Unique index violated`
- Same user selalu reuse Isar ID yang sama
- Tidak ada duplikasi data di Isar
- Offline-first tetap berjalan (data historical preserved)

### Lessons Learned

1. **Idempotency is Critical:** Operasi database harus idempoten untuk offline-first apps
2. **Don't Trust autoIncrement:** autoIncrement generates NEW ID every time, not suitable for upsert scenarios
3. **Use Unique Indexes as Source of Truth:** Query by unique index sebelum save untuk cek existing record
4. **Apply Pattern Consistently:** Jika ada unique constraint `odId`, apply check-then-upsert di semua repository

---

## Error #3: Offline Checkout Tidak Sync ke Server (Trawl Net Fix)

**Tanggal:** 2026-02-07  
**Severity:** ⛔ Critical  
**Status:** ✅ Resolved  
**Modul Terdampak:** Sync Service, Checkout Controller, Notification Sync

### Deskripsi Error

Setelah user melakukan checkout dalam kondisi offline, data `out_time` tidak pernah tersync ke PocketBase meskipun koneksi sudah kembali. Terminal log menunjukkan:

```
ClientException: {
  url: .../notifications/records?filter=target_user_id+%3D+...
  statusCode: 400,
  response: {message: Something went wrong...}
}
⛔ Failed to sync notifications
```

**Langkah Reproduksi:**

1. User sudah check-in (online)
2. Matikan WiFi/Data (offline)
3. User checkout → Sukses lokal
4. Nyalakan WiFi kembali
5. **Checkout TIDAK PERNAH sync** → `out_time` di PocketBase tetap kosong

### Root Cause (Akar Masalah)

Audit mendalam menemukan **3 penyebab utama**:

#### 1. Notification Sync Blocking (Error 400)

```dart
// BEFORE: Server-side filter menyebabkan error 400
final filter = 'target_user_id = "${user.odId}" || target_user_id = null';
```

**Masalah:**

- Field name salah (`target_user_id` vs `user_id`)
- Syntax `= null` tidak valid untuk PocketBase relation fields
- Error ini **memblokir** seluruh sync process (sequential execution)

#### 2. Checkout TIDAK Masuk SyncQueue

```dart
// CheckoutController.validateAndSubmit() BEFORE:
await _isarService.updateCheckout(...);
await _attendanceRepository.syncToCloud();  // Fire-and-forget!
// ❌ Tidak ada retry jika gagal
```

Berbeda dengan check-in yang masuk SyncQueue, checkout hanya memanggil `syncToCloud()` secara langsung. Jika gagal (offline), data hilang selamanya.

#### 3. Sequential Sync tanpa Error Isolation

```dart
// SyncService.syncNow() BEFORE:
await _queueSync.processSyncQueue();        // Jika error disini...
await _notificationSync.syncNotifications(); // ...ini tidak jalan!
```

### Solusi

#### 1. Trawl Net Strategy untuk Notification Sync

Sesuai rekomendasi Engineering Journal 2026-02-04:

```dart
// AFTER: Fetch ALL, filter CLIENT-SIDE
final allRecords = await pb.collection('notifications').getFullList(sort: '-created');

final myRecords = allRecords.where((r) {
  final uid = r.data['user_id']?.toString() ?? '';  // Fixed: user_id
  return uid == user.odId || uid.isEmpty;
}).toList();
```

**Prinsip:** Jangan gunakan server-side filter untuk avoid 400 error.

#### 2. Checkout Masuk SyncQueue

```dart
// CheckoutController AFTER:
await _isarService.updateCheckout(...);

// ADD TO SYNC QUEUE for retry
await _isarService.addToSyncQueue(SyncQueueItem()
  ..collection = 'attendance'
  ..localId = todayAttendance.value!.id
  ..operation = SyncOperation.update
  ..status = SyncStatus.pending
  ...);
```

#### 3. Error Isolation di SyncService

```dart
// AFTER: Try-catch terpisah
try { await _queueSync.processSyncQueue(); } catch (e) { _logger.e('Queue sync failed'); }
try { await _notificationSync.syncNotifications(); } catch (e) { _logger.e('Notif sync failed'); }
```

#### 4. Auto-Recovery untuk Data Lama

Fungsi baru `recoverUnsyncedAttendance()` di SyncQueueManager:

- Scan semua attendance dengan `isSynced = false`
- Otomatis tambahkan ke SyncQueue untuk retry
- Dipanggil saat app startup

### Files Modified

| File                             | Perubahan                               |
| -------------------------------- | --------------------------------------- |
| `notification_sync_manager.dart` | Trawl Net strategy, fix field `user_id` |
| `checkout_controller.dart`       | Add to SyncQueue after update           |
| `sync_service.dart`              | Error isolation + recovery call         |
| `sync_queue_manager.dart`        | + `recoverUnsyncedAttendance()`         |

### Validation

**Manual Testing:**

- ✅ Notification sync tidak error 400 lagi
- ✅ Checkout offline masuk SyncQueue
- ✅ Data lama yang nyangkut ter-recover otomatis
- ✅ `out_time` muncul di PocketBase setelah online kembali

### Lessons Learned

1. **Selalu Gunakan SyncQueue:** Operasi penting WAJIB masuk queue, bukan fire-and-forget
2. **Error Isolation:** Satu sync failure tidak boleh block lainnya
3. **Client-Side Filtering:** Jika server filter problematic, filter di client (Trawl Net)
4. **Field Name Consistency:** Selalu verifikasi field name vs PocketBase schema
5. **Auto-Recovery:** Sediakan mekanisme untuk recover data lama yang stuck
6. **Dokumentasi Historis:** Baca engineering journal sebelum fix - solusi mungkin sudah ada!

---

<!-- Template untuk error selanjutnya:

## Error #4: [Judul Error]

**Tanggal:** YYYY-MM-DD
**Severity:** [Critical/High/Medium/Low]
**Status:** [Resolved/In Progress/Identified]
**Modul Terdampak:** [Nama Modul]

### Deskripsi Error
[Deskripsi detail error]

### Root Cause (Akar Masalah)
[Penyebab error]

### Solusi
[Cara mengatasi]

### Validation
[Testing yang dilakukan]

### Lessons Learned
[Pelajaran yang dipetik]

---

-->

## Error #4: PocketBase 400 Bad Request (Invalid Sort Field) & Sync Drama

**Tanggal:** 2026-02-08
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** Admin Leave Requests, Notification Sync

### Deskripsi Error

Aplikasi terus menerus mengalami error `400 Bad Request` saat mengambil data izin (Leave Requests), bahkan setelah filter server-side dihapus ("Trawl Net Strategy").

Log Error:

```json
"details": "invalid sort field \"created\"",
"url": ".../leave_requests/records?...&sort=-created..."
```

### Root Cause (Akar Masalah)

1.  **Invalid Sort Field:** Ternyata server PocketBase (config schema `leave_requests`) **MENOLAK** sorting berdasarkan field `created`. Default code kita menggunakan `sort: '-created'`. Ini adalah "Silent Killer" yang membuat semua request gagal.
2.  **Expand Param Rejected:** Parameter `expand: 'user_id'` juga dicurigai menyebabkan error pada beberapa kondisi (API Rules), sehingga strategi fetch data harus diubah.

### Solusi Bertahap (The Saga)

#### 1. Strategi "Trawl Net" (Gagal)

Mencoba menghapus filter (`filter: '...'`) dan fetch semua data. Masih Error 400.

#### 2. Strategi "Manual Join" (Stabilisasi)

Karena `expand` dicurigai bermasalah, kita ubah logika menjadi:

- Fetch Leave Requests (Murni/Polos)
- Fetch Users (Terpisah)
- Gabungkan (Join) data nama user secara manual di aplikasi (client-side).
  **Hasil:** App lebih stabil, tidak crash, tapi masih Error 400 karena sorting.

#### 3. Final Fix: Ganti Sort Field

Mengganti parameter sort dari `-created` menjadi `-start_date`.

**Code Fix (`admin_analytics_repository.dart`):**

```dart
// BEFORE (BOM)
final result = await pb.collection('leave_requests').getList(..., sort: '-created');

// AFTER (FIXED)
final result = await pb.collection('leave_requests').getList(..., sort: '-start_date');
```

### Lessons Learned

1.  **Check Logs Detail:** Jangan hanya lihat "400 Bad Request", lihat bagian `details` di JSON response. "Invalid sort field" tertulis jelas di sana.
2.  **Jangan Asumsi Default Field:** Field `created` biasanya aman untuk sort, tapi tidak selalu (tergantung config DB). Gunakan field business logic (`start_date`) yang pasti ada dan ter-index.
3.  **Manual Join > Complex Query:** Jika ragu dengan kemampuan API Rules untuk `expand`, lakukan join manual di client. Lebih ribet coding-nya, tapi jauh lebih tahan banting (robust).

---

## Error #5: Missing User ID in Notification (Silent Notification)

**Tanggal:** 2026-02-08
**Severity:** ⚠️ High
**Status:** ✅ Resolved
**Modul Terdampak:** Leave Approval Notification

### Deskripsi Error

Notifikasi `Izin Disetujui` berhasil dibuat di database, tetapi user (pemohon izin) tidak menerimanya di aplikasi.

**Log Data:**

```json
{
  "title": "Izin Disetujui",
  "user_id": "", // EMPTY (Harusnya ID pemohon)
  "target_user_id": "" // EMPTY
}
```

### Root Cause

`LeaveApprovalController` mencoba membuat notifikasi secara manual (`_notifRepo.createNotification`) sambil passing `userId`. Namun, value `userId` tersebut ternyata kosong/null dari list view yang sedang dirender.

### Solusi: Repository-First Pattern

Sesuai rekomendasi "Gemini User", kita memindahkan logika notifikasi ke tempat yang lebih aman: `AdminActionRepository`.

**Logic Baru (`admin_action_repository.dart`):**

1. Fetch record Leave Request berdasarkan ID.
2. Ambil `user_id` yang valid dari record tersebut.
3. Update status izin.
4. Create notifikasi menggunakan `user_id` hasil fetch.

**Hasil:**
User ID dijamin valid karena diambil langsung dari source of truth (database record), bukan dari state UI yang mungkin stale/kosong.

---

---

## Error #6: Employee List Crash (Red Screen of Death)

**Tanggal:** 2026-02-08
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** Employee Management (Admin)

### Deskripsi Error

Admin tidak bisa membuka halaman "Manajemen Karyawan". Layar merah dengan pesan error:

```
type 'Null' is not a subtype of type 'String'
```

### Root Cause (Akar Masalah)

1.  **Unsafe Model Parsing (`UserLocal.fromRecord`):** Model berasumsi data dari PocketBase selalu lengkap (tidak null). Ketika ada user dengan data tidak lengkap (misal: `avatar: null` atau `registered_device_id: null`), aplikasi crash saat mencoba convert ke String.
2.  **Direct UI Access:** View (`EmployeeManagerView`) mengakses `record.data['name']` secara langsung tanpa null check.
3.  **Corrupt Local Data:** Data di local caching (Isar) mungkin sudah corrupt karena schema mismatch sebelumnya.

### Solusi

1.  **Paranoid Model Parsing:**
    - Rewrite `UserLocal.fromRecord` untuk menangani semua kemungkinan null.
    - Default value `""` atau `"-"` untuk semua field string.
2.  **Safe UI Rendering:**
    - Refactor `EmployeeManagerView` untuk menggunakan `?.toString() ?? 'Default'` pada semua akses data.
3.  **Safe Fetch Loop:**
    - `getAllEmployees` dimodifikasi: Jika 1 user gagal diparsing, hanya user itu yang diskip (logged), tidak menghentikan seluruh proses / crash app.
4.  **Remote-First Strategy:** Priority fetch dari server, bypass local cache yang mungkin corrupt.

---

## Error #7: Schema Mismatch (Expand & Sort Chaos)

**Tanggal:** 2026-02-08
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** Sync Manager, Admin Analytics

### Deskripsi Error

- **Sync Gagal:** Log server penuh dengan `Failed to expand "assigned_shift"`.
- **Admin Approval Gagal:** `400 Bad Request` saat load leave requests.

### Root Cause

Codebase menggunakan nama field dan parameter yang **TIDAK SINKRON** dengan database schema aktual.

1.  **Expand Param Salah:** Code minta `assigned_shift`, DB punya `shift`. Code minta `assigned_office_location`, DB punya `office_id`.
2.  **Sort Field Salah:** Code minta sort by `-created` di `leave_requests`, DB menolak (index missing/restricted).
3.  **Phantom Fields:** Code mencoba akses `nip` dan `job_title` yang tidak ada di DB.

### Solusi (The Grand Audit Fix)

1.  **Sync Manager Correction:** Ubah `expand` menjadi `shift,office_id` di `MasterDataSyncManager`.
2.  **Sort Field Correction:** Ubah sort menjadi `-start_date` (Leave Requests) dan `-created` (Users - valid).
3.  **Code Cleanup:** Hapus referensi ke `nip` dan `job_title` atau beri default value aman.

### Lessons Learned

**"Trust No One, Verify Everything."**
Jangan percaya nama field di kode lama. Selalu cek schema database asli (via Admin UI / Screenshot) sebelum coding.

---

## Error #8: Notification Filter Gagal (Multiple Relation)

**Tanggal:** 2026-02-09
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** Notification Sync, User Inbox

### Deskripsi Error

User login dan buka Inbox Notifikasi. List kosong ("Belum ada notifikasi") meskipun di database ada record notifikasi untuk user tersebut.

### Root Cause

`NotificationSyncManager` menggunakan client-side filter: `uid == user.odId`. Namun field `user_id` di PocketBase sekarang adalah **Multiple Relation** (List), bukan Single Relation (String). Perbandingan `"tes1" == "[tes1, tes2]"` selalu `false`.

### Solusi

1.  Gunakan server-side filter dengan operator `~` (Contains): `filter: 'user_id ~ "${user.odId}"'`.
2.  Hapus client-side filter yang redundan.
3.  Update mapping `targetUserId` untuk handle `List<dynamic>` dari PocketBase response.

---

## Error #9: Posko Radius Tersimpan 0 (Field Name Mismatch)

**Tanggal:** 2026-02-10
**Severity:** 🟡 Major
**Status:** ✅ Resolved
**Modul Terdampak:** Posko (Admin), Office Locations

### Deskripsi Error

Admin membuat Posko dengan radius "100", tapi di database tersimpan sebagai `0`.

### Root Cause

`PoskoController` mengirim field `'radius_meters'` ke PocketBase, padahal kolom di database bernama `'radius'`. PocketBase mengabaikan field yang tidak dikenali → nilai default `0`.

### Solusi

Ubah `'radius_meters': radius` menjadi `'radius': radius` di payload `createPosko`.

---

## Error #10: Posko Tidak Muncul di Dropdown Karyawan

**Tanggal:** 2026-02-10
**Severity:** 🟡 Major
**Status:** ✅ Resolved
**Modul Terdampak:** Check-in Dropdown, OfficeSelectionManager

### Deskripsi Error

Admin berhasil membuat Posko (data masuk ke DB), tapi saat karyawan buka Presensi, Posko tidak muncul di dropdown lokasi.

### Root Cause

`OfficeSelectionManager._loadAndFilterOffices()` memfilter office berdasarkan `user.allowedOfficeIds`. Posko baru tidak ada di list `allowedOfficeIds` user manapun, sehingga selalu difilter keluar.

### Solusi

Setelah menampilkan office yang di-allow, tambahkan juga **semua office lain** yang tersinkron ke Isar (termasuk Posko). Urutan: office utama dulu, baru office tambahan.

---

## Error #11: Broadcast is_read Shared (Satu Baca, Semua Terbaca)

**Tanggal:** 2026-02-10
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** Broadcast, Notification

### Deskripsi Error

Admin kirim broadcast "Semua Karyawan". User A membuka notifikasi. Badge merah (unread) di User B langsung hilang, padahal User B belum baca.

### Root Cause

Broadcast membuat **1 record** notifikasi dengan `user_id: [A, B, C]` dan **1 field** `is_read`. Ketika A membaca → `is_read = true` → record yang sama berubah untuk semua user.

### Solusi: Personal Copy Strategy

Refactor `AdminBroadcastController.sendBroadcast()`: buat **1 record terpisah per user** menggunakan `Future.wait`. Setiap user punya record sendiri dengan `is_read` independen.

---

## Error #12: Admin Dashboard Data Inconsistency (Trawl Net Fix)

**Tanggal:** 2026-02-12  
**Severity:** ⛔ Critical  
**Status:** ✅ Resolved  
**Modul Terdampak:** Admin Analytics, Dashboard Recap

### Deskripsi Error

Dashboard Admin menampilkan data kehadiran dan izin yang tidak akurat. Angka "Hadir" dan "Alpha" seringkali tidak sesuai dengan kenyataan di database server. Selain itu, filtrasi izin di halaman admin sering mengalami `400 Bad Request`.

### Root Cause (Akar Masalah)

1. **Server-Side Filter Error**: Percobaan memfilter data di PocketBase v0.19 menggunakan rule yang kompleks (relation filter) sering kali ditolak dengan status 400.
2. **Local-First vs Server Accuracy**: Admin membutuhkan data yang 100% akurat dari server, namun sistem sebelumnya terlalu bergantung pada cache lokal (Isar) yang mungkin belum tersinkronisasi sempurna.
3. **Alpha Detection Logic**: Logika untuk menentukan siapa yang "Alpha" tidak mempertimbangkan status izin yang sudah disetujui (Approved Leave), sehingga terjadi False Positive.

### Solusi

1. **Remote-First Strategy**: Modul Admin Analytics sekarang secara default menarik data langsung dari server (`PocketBase`) untuk menjamin akurasi.
2. **Trawl Net Strategy (Client Filtering)**: Menarik semua record dalam satu page, lalu melakukan filtrasi status (`pending`/`approved`/`rejected`) di sisi client menggunakan Dart untuk menghindari error 400.
3. **Enhanced Stats Logic**: Memperbaiki `AdminAnalyticsRepository.getDailyRecap()` untuk melakukan pengecekan silang antara daftar user, absen hari ini, dan izin hari ini.

### Validation

- ✅ Dashboard menampilkan angka yang sinkron dengan database server.
- ✅ Tidak ada lagi error 400 saat berpindah tab status di halaman Izin/Kehadiran admin.
- ✅ Status "Alpha" dihitung dengan benar (Tidak hadir && Tidak sedang izin).

### Lessons Learned

1. **Context Matters**: Untuk User, offline-first/local-first adalah prioritas (speed). Untuk Admin, Remote-First adalah prioritas (accuracy).

---

## Error #13: Persistent Isar Unique Index Violation (Zombie Data)

**Tanggal:** 2026-02-14
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** MasterDataSyncManager, UserLocalRepository

### Deskripsi Error

Meskipun logic `saveUsers` sudah diperbaiki untuk menangani upsert (update/insert), error `IsarError: Unique index violated` tetap muncul secara persisten.

### Root Cause (Akar Masalah)

Data di database lokal (Isar) sudah dalam kondisi **tidak konsisten (corrupt/zombie state)** akibat kegagalan sync sebelumnya. ID internal Isar tidak sinkron dengan `odId` PocketBase, dan logic upsert gagal mencocokkan record yang benar, sehingga tetap mencoba INSERT duplikat (melanggar Unique Index).

### Solusi: Self-Healing Mechanism (Try-Catch-Nuke-Retry)

Implementasi mekanisme **Self-Healing** di `MasterDataSyncManager`:

1.  **Try:** Coba sync normal (`saveUsers`).
2.  **Catch:** Jika error mengandung `Unique index violated` DAN ini percobaan pertama (`!isRetry`):
    - **Log Warning:** Catat bahwa error terdeteksi.
    - **Nuke:** Panggil `_isarService.clearUsers()` untuk menghapus SEMUA data user lokal yang bermasalah.
    - **Retry:** Panggil fungsi sync sekali lagi secara rekursif dengan flag `isRetry=true`.
3.  **Success:** Sync kedua pasti berhasil karena database dalam keadaan kosong (clean slate).

### Validation

- App mendeteksi error saat startup.
- Log menampilkan: `⚠️ Unique index violation detected. Clearing local users and retrying...`
- Sync kedua sukses: `Successfully synced 3 employees to local DB`.

### Lessons Learned

1.  **Database Corruption Happens:** Jangan asumsikan database lokal selalu bersih.
2.  **Self-Healing is Essential:** Aplikasi offline-first harus bisa memperbaiki dirinya sendiri tanpa user re-install.

---

## Error #14: Ghost Email Violation (Empty String Uniqueness)

**Tanggal:** 2026-02-14
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** UserMapper, Isar Database

### Deskripsi Error

Setelah implementasi "Self-Healing" (Error #13), aplikasi masih mengalami `Unique index violated` saat menyimpan data baru hasil download.

### Root Cause (Akar Masalah)

Isar memiliki index `unique: true` pada field `email`.
Ternyata, API PocketBase mengembalikan string kosong `""` untuk field email pada beberapa user (karena setting `emailVisibility: false`).
Akibatnya:

- User A: Email = `""`
- User B: Email = `""`
- Isar menganggap ini **DUPLIKAT** (dua user punya email yang sama, yaitu kosong), sehingga menolak penyimpanan.

### Solusi: Placeholder Generation

Memodifikasi `UserLocal.fromRecord` untuk menjamin email tidak pernah kosong. Jika kosong, generate email unik sementara.

```dart
..email = (() {
  final e = getSafeString('email');
  return e.isNotEmpty ? e : 'missing_${record.id}@local.placeholder';
})()
```

### Validation

- Hot Restart aplikasi.
- Self-Healing membersihkan data lama.
- Data baru masuk dengan email `missing_XXXX@local.placeholder` untuk user yang emailnya hidden.
- Sync sukses, list karyawan muncul penuh.

### Lessons Learned

1.  **Unique Constraint on Optional Fields is Dangerous:** Hati-hati memasang `unique` index pada field yang mungkin kosong atau null, kecuali database mendukung `distinct nulls`.

---

## Error #15: PocketBase 400 Validation Error (Verified Field)

**Tanggal:** 2026-02-14

---

## Error #16: Analytics Timezone UTC (Missing "Today" Data)

**Tanggal:** 2026-02-15
**Severity:** 🟡 High
**Status:** ✅ Resolved
**Modul Terdampak:** Admin Analytics, Daily Recap

### Deskripsi Error

Saat Admin mengecek "Rekap Hari Ini" pada pagi hari (misal jam 06:00 WIB), data cuti/izin yang seharusnya berlaku hari ini **TIDAK MUNCUL**. Padahal data ada di database.

### Root Cause (Akar Masalah)

1.  **UTC Offset:** PocketBase menyimpan tanggal dalam UTC. "Hari Ini" (Tgl 15) dimulai jam 00:00 UTC = 07:00 WIB.
2.  **Future Trap:** Jam 06:00 WIB = 23:00 UTC (Kemarin). Saat query `date >= today` (00:00 UTC), sistem menganggap sekarang masih "kemarin", sehingga data hari ini (yang mulai 00:00 UTC) dianggap **Masa Depan** / Belum Mulai.

### Solusi: Full Day Window

Mengubah logika query dari sekadar `start >= now` menjadi rentang 24 jam penuh lokal:

```dart
// BEFORE:
.filter('start >= "$now"') // ❌ 06:00 WIB < 07:00 WIB (Start of Day UTC)

// AFTER:
final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0); // 00:00 Local
final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59); // 23:59 Local
.filter('start >= "$startOfDay" && start <= "$endOfDay"') // ✅ Covers entire day
```

### Validation

- ✅ Cek Rekap jam 06:00 Pagi -> Data muncul.
- ✅ Cek Rekap jam 23:00 Malam -> Data tetap muncul.

---

**Status:** ✅ Resolved
**Modul Terdampak:** Admin Employee Management (Add Employee)

### Deskripsi Error

Saat admin mencoba menambah karyawan baru via aplikasi, muncul error `400 Bad Request`. Log menunjukkan:
`message: Failed to create record., data: {verified: ...}`

### Root Cause (Akar Masalah)

Payload pengiriman data menyertakan field `"verified": true`.
PocketBase (versi terbaru) membatasi akses set field system seperti `verified` saat creation, kecuali oleh **Superuser**. Admin biasa (meskipun punya role admin) tidak diizinkan set verification status secara langsung via API default.

### Solusi

Hapus field `"verified": true` dari payload `create`. Biarkan default (false), nanti bisa diverifikasi lewat email atau dashboard jika perlu.

---

## Error #16: Dropdown Object Equality Crash (Red Screen)

**Tanggal:** 2026-02-14
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** Check-in Screen (Office Selector)

### Deskripsi Error

Saat user menekan tombol refresh/sync di halaman check-in, terjadi crash layar merah:
`"There should be exactly one item with [DropdownButton]'s value: Instance of 'OfficeLocationLocal'..."`

### Root Cause (Akar Masalah)

Dropdown menggunakan Objek `OfficeLocationLocal` sebagai `value`.
Saat refresh terjadi, list options diganti dengan objek-objek baru dari database.
Meskipun data di dalamnya sama (ID sama, Nama sama), Dart menganggap `Objek A (Old)` != `Objek B (New)`.
Akibatnya, dropdown merasa `value` yang sedang dipilih tidak ada di dalam `items` yang baru.

### Solusi

Gunakan **Primitive Type (String ID)** sebagai value, bukan Objek.
`value: office.odId`

String "abc" selalu sama dengan "abc", tidak peduli apakah itu instance string baru atau lama. Ini membuat dropdown stabil saat refresh data.

---

## Error #28: AuthService Stray Brace — Compilation Error

**Tanggal:** 2026-02-15
**Severity:** ⛔ Critical
**Status:** ✅ Resolved
**Modul Terdampak:** AuthService

### Deskripsi Error

Aplikasi gagal compile setelah menambahkan `DeviceBindingException` handler di `restoreSession()`:

```
Unexpected token '}'
```

### Root Cause (Akar Masalah)

Brace `}` ekstra tertinggal saat menambahkan blok `catch (e is DeviceBindingException)` di dalam method `restoreSession`. Brace menutup class `AuthService` terlalu dini.

### Solusi

Hapus brace yang salah tempat. Pastikan scope `try-catch` tertutup dengan benar.

---

## Error #29: Splash Logo Terlalu Besar / Terpotong

**Tanggal:** 2026-02-15
**Severity:** ⚠️ Medium
**Status:** ✅ Resolved
**Modul Terdampak:** Native Splash Screen, App Icon

### Deskripsi Error

Logo SEAGMA tampil terlalu besar di splash screen dan app icon, sehingga terlihat terpotong (cropped/zoomed in).

### Root Cause (Akar Masalah)

File logo asli (`seagma logo.png`, 667×638px) tidak memiliki padding/whitespace di sekelilingnya. Saat digunakan langsung sebagai splash image, logo memenuhi seluruh area yang tersedia.

### Solusi

1. Buat script Dart (`tool/generate_logo_variants.dart`) untuk generate 3 varian:
   - `seagma_splash.png` — 1200×1200, logo 40% dari canvas (banyak padding)
   - `seagma_icon.png` — 1024×1024, logo 60% dari canvas
   - `seagma_adaptive_fg.png` — 1024×1024, logo 45% (untuk safe zone Android adaptive icon)
2. Update `pubspec.yaml` untuk menggunakan gambar baru.
3. Regenerate: `dart run flutter_native_splash:create` & `dart run flutter_launcher_icons`.

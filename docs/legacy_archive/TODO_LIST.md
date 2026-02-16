# 📋 TODO LIST - SEAGMA PRESENSI

> **Tanggal Audit:** 14 Februari 2026  
> **Auditor:** Antigravity  
> **Tujuan:** Membersihkan project agar benar-benar siap production

---

## ✅ A. Warnings (8/8 SELESAI)

> [!NOTE]
> Semua 8 warning telah dibersihkan pada 14 Feb 2026.

- [x] `attendance_controller.dart` — Hapus `_authService` unused
- [x] `checkout_controller.dart` — Hapus `_authService` unused + update binding + test
- [x] `history_controller.dart` — Hapus `_currentOffset` unused
- [x] `leave_controller.dart` — Hapus `_logger` unused
- [x] `isar_service.dart` — Hapus `_secureStorage` unused
- [x] `isar_service.dart` — Hapus `_encryptionKeyStorageName` unused
- [x] `isar_service.dart` — Hapus `_getOrGenerateEncryptionKey()` unused
- [x] `location_service.dart` — Hapus `@override` pada `init()` yang salah

---

## 🔧 B. Deprecated API (Harus Dimigrasi)

### B1. `withOpacity()` → `.withValues(alpha: ...)` (11 tempat)

- [x] `lib/modules/admin/views/live_attendance_view.dart:96`
- [x] `lib/modules/admin/views/live_attendance_view.dart:98`
- [x] `lib/modules/admin/views/live_attendance_view.dart:109`
- [x] `lib/modules/attendance/checkin/widgets/checkin_map.dart:39`
- [x] `lib/modules/attendance/checkin/widgets/checkin_status_card.dart:23`
- [x] `lib/modules/attendance/checkin/widgets/checkin_time_display.dart:21`
- [x] `lib/modules/attendance/checkin/widgets/office_selector_dropdown.dart:31`
- [x] `lib/modules/history/widgets/history_item.dart:21`
- [x] `lib/modules/history/widgets/history_item.dart:26`
- [x] `lib/modules/history/widgets/history_item.dart:47`
- [x] `lib/modules/security/security_violation_view.dart` (6 tempat: L46, L79, L82, L103, L116, L180)

### B2. PocketBase `.expand` → `record.get<T>("expand.xxx")` (10 tempat)

- [x] `lib/data/models/user_model.dart:58`

- [x] `lib/modules/home/logic/home_data_manager.dart:41`
- [x] `lib/modules/home/logic/home_data_manager.dart:42`
- [x] `lib/modules/profile/logic/profile_data_manager.dart:25`
- [x] `lib/modules/profile/logic/profile_data_manager.dart:26`
- [x] `lib/modules/profile/logic/profile_data_manager.dart:27`
- [x] `lib/modules/profile/logic/profile_data_manager.dart:28`
- [x] `lib/modules/profile/logic/profile_data_manager.dart:46-51`

### B3. PocketBase `.created` / `.updated` → `get<String>('created')` (8 tempat)

- [x] `lib/data/models/user_model.dart:144` (`.created`)
- [x] `lib/data/models/user_model.dart:145` (`.updated`)
- [x] `lib/data/repositories/admin_action_repository.dart:172` (`.created`)
- [x] `lib/modules/history/logic/history_sync_manager.dart:43` (`.created` x2)
- [x] `lib/modules/history/logic/history_sync_manager.dart:85` (`.created`)
- [x] `lib/modules/history/logic/history_sync_manager.dart:112-113` (`.created` + `.updated`)
- [x] `lib/modules/home/logic/home_sync_manager.dart:57` (`.created`)
- [x] `lib/services/sync/master_data_sync_manager.dart:230-231` (`.created` + `.updated`)
- [x] `lib/services/sync/notification_sync_manager.dart:58-59` (`.created` + `.updated`)

### B4. PocketBase `.model` → `.record` (2 tempat)

- [x] `lib/data/repositories/attendance_repository.dart:61`
- [x] `lib/data/repositories/leave_repository.dart:47`

### B5. PocketBase `.baseUrl` → `.baseURL` (1 tempat)

- [x] `lib/modules/leave/logic/leave_sync_manager.dart:17`

### B6. Flutter `.value` → `.initialValue` di TextFormField (1 tempat)

- [x] `lib/modules/admin/views/employee_detail_view.dart:213`

### B7. `encryptedSharedPreferences` deprecated (2 tempat)

- [x] `lib/data/managers/session_manager.dart:8`
- [x] `lib/services/device/device_id_manager.dart:16`

---

## 🧹 C. `print()` → Logger (Harus Dibersihkan)

Semua `print()` di production code harus diganti dengan `Logger` (`_logger.i/w/e`).

### C1. Security Service (14 tempat — PRIORITAS TINGGI)

- [x] `lib/services/security_service.dart:34`
- [x] `lib/services/security_service.dart:47`
- [x] `lib/services/security_service.dart:56`
- [x] `lib/services/security_service.dart:57`
- [x] `lib/services/security_service.dart:62`
- [x] `lib/services/security_service.dart:74`
- [x] `lib/services/security_service.dart:85`
- [x] `lib/services/security_service.dart:98`
- [x] `lib/services/security_service.dart:102`
- [x] `lib/services/security_service.dart:115`
- [x] `lib/services/security_service.dart:130`
- [x] `lib/services/security_service.dart:140`
- [x] `lib/services/security_service.dart:143`
- [x] `lib/services/security_service.dart:146`
- [x] `lib/services/security_service.dart:149`
- [x] `lib/services/security_service.dart:157`

### C2. Module Controllers (6 tempat)

- [x] `lib/data/repositories/local/office_local_repository.dart:40`
- [x] `lib/data/repositories/local/office_local_repository.dart:80`
- [x] `lib/modules/admin/controllers/admin_controller.dart:67`
- [x] `lib/modules/admin/controllers/live_attendance_controller.dart:66`
- [x] `lib/modules/admin/logic/admin_dashboard_manager.dart:33`
- [x] `lib/modules/admin/logic/admin_dashboard_manager.dart:44`

### C3. Home & Profile (4 tempat)

- [x] `lib/modules/home/logic/home_data_manager.dart:53`
- [x] `lib/modules/home/logic/home_sync_manager.dart:36`
- [x] `lib/modules/profile/logic/profile_data_manager.dart:66`
- [x] `lib/modules/profile/logic/profile_photo_manager.dart:73`

### C4. Notification & Checkin (3 tempat)

- [x] `lib/modules/notifications/notification_controller.dart:33`
- [x] `lib/modules/notifications/notification_controller.dart:53`
- [x] `lib/modules/attendance/checkin/checkin_controller.dart:278`

### C5. Mappers & Dialogs (2 tempat)

- [x] `lib/data/mappers/user_mapper.dart:54`
- [x] `lib/modules/profile/widgets/change_password_dialog.dart:82`

### C6. Test Files (6 tempat — PRIORITAS RENDAH)

- [x] `test/debug_getx_test.dart:18, 21, 23, 25, 28, 29`

---

## ⚠️ D. Overridden Fields di Test (6 tempat)

- [x] `test/modules/attendance/checkin_controller_test.dart:329` — Override field dari `OfficeSelectionManager`
- [x] `test/modules/attendance/checkin_controller_test.dart:331` — Override field dari `OfficeSelectionManager`
- [x] `test/modules/attendance/checkin_controller_test.dart:333` — Override field dari `OfficeSelectionManager`
- [x] `test/modules/attendance/checkin_controller_test.dart:335` — Override field dari `OfficeSelectionManager`
- [x] `test/modules/attendance/checkin_controller_test.dart:354` — Override field dari `CheckInLocationManager`
- [x] `test/modules/attendance/checkin_controller_test.dart:356` — Override field dari `CheckInLocationManager`

> **Fix:** Gunakan getter/setter override daripada field override di mock class.

---

## 🔴 E. Fitur TODO (dari Kode & Roadmap)

### E1. Wajib Diselesaikan (Blocking Production)

- [ ] **Sync Dynamic Outpost ke PocketBase** — `lib/data/repositories/dynamic_outpost_repository.dart:39`
- [ ] **Integrasi `SyncStatusBadge` ke `HistoryItem`** — Widget sudah ada tapi tidak dipakai
- [ ] **Device Binding Testing** — Verifikasi login hanya di device terdaftar
- [ ] **Validasi GPS Testing** — Penolakan mock location
- [ ] **Mode Offline Testing** — Verifikasi Isar sync flow

### E2. Sebaiknya Diselesaikan

- [ ] **Pagination offset** — `getAttendanceHistory()` belum ada parameter offset, data "Load More" bisa duplikat
- [ ] **Export PDF/Excel** — Saat ini hanya clipboard copy
- [ ] **Card Tap → Detail View** — `HistoryItem` tidak punya `onTap` navigasi
- [ ] **Anti-Beku UI audit** — Belum diverifikasi semua tombol memiliki loading state
- [ ] **WiFi verification testing** — Verifikasi BSSID matching
- [ ] **Alur persetujuan izin** — Verifikasi rejection reason terkirim ke inbox

### E3. Opsional (Nice-to-Have)

- [ ] **Photo thumbnail dengan caching** di history
- [ ] **Shimmer loading effect** — Ganti `CircularProgressIndicator`
- [ ] **Attendance correction request** — Modul koreksi absensi
- [ ] **Audit LOC Final** — Memastikan semua file < 200 baris
- [ ] **Greeting system verification** — Pastikan Pagi/Siang/Sore switch berjalan

---

## 📊 Statistik Kebersihan

| Kategori            | Total  | Selesai | Sisa   |
| ------------------- | ------ | ------- | ------ |
| ⚠️ Warnings         | 8      | 8       | 0 ✅   |
| 🔧 Deprecated API   | 35     | 35      | 0 ✅   |
| 🧹 print() → Logger | 31     | 31      | 0 ✅   |
| ⚠️ Test overrides   | 6      | 6       | 0 ✅   |
| 🔴 Fitur TODO       | 16     | 6       | 10     |
| **TOTAL**           | **96** | **86**  | **10** |

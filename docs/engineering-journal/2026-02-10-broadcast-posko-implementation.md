# Engineering Journal: Broadcast & Posko Implementation

**Tanggal:** 2026-02-10
**Author:** Antigravity AI
**Scope:** Phase 6 — Broadcast Pengumuman, Posko Dinamis, Notification Fixes

---

## Ringkasan

Implementasi fitur Broadcast Pengumuman dan Posko (Titik Absen Sementara) untuk admin,
termasuk perbaikan 4 bug kritis yang ditemukan selama testing.

## Fitur Baru

### 1. AdminBroadcastController (NEW)

**File:** `lib/modules/admin/controllers/admin_broadcast_controller.dart`

- Dedicated controller, diekstraksi dari `AdminController` (Clean Architecture).
- Fetch semua user dari PocketBase untuk dropdown target.
- Support "Semua Karyawan" dan "Individual User" targeting.
- **Personal Copy Strategy:** Broadcast membuat 1 record notifikasi per user (bukan 1 shared record).
- Menggunakan `Future.wait` untuk batch processing paralel.

### 2. PoskoController & PoskoView (NEW)

**Files:**

- `lib/modules/admin/controllers/posko_controller.dart`
- `lib/modules/admin/views/posko_view.dart`

- Form input: Nama Posko, Latitude, Longitude, Radius (default 100m).
- GPS auto-fill: Tombol "Ambil Lokasi Saat Ini" mengisi koordinat otomatis.
- Membuat record baru di collection `office_locations` PocketBase.

### 3. Dashboard Integration

**File:** `lib/modules/admin/views/admin_dashboard_view.dart`

- "Broadcast Pengumuman" → navigasi ke `AdminBroadcastView` + binding.
- "Broadcast Titik Absen" → navigasi ke `PoskoView` + binding (sebelumnya langsung call fungsi).

## Bug Fixes

| #   | Error                    | Root Cause                               | Fix                        |
| --- | ------------------------ | ---------------------------------------- | -------------------------- |
| 8   | Notifikasi kosong        | Filter `=` gagal untuk Multiple Relation | Ganti ke `~` operator      |
| 9   | Posko radius = 0         | Field name `radius_meters` vs `radius`   | Sesuaikan dengan schema    |
| 10  | Posko tidak di dropdown  | `allowedOfficeIds` filter terlalu ketat  | Include ALL synced offices |
| 11  | Broadcast is_read shared | 1 record untuk semua user                | Personal Copy Strategy     |

## Files Modified

| File                              | Change                               |
| --------------------------------- | ------------------------------------ |
| `admin_broadcast_controller.dart` | NEW - Dedicated broadcast controller |
| `admin_broadcast_view.dart`       | Refactored to use new controller     |
| `posko_controller.dart`           | NEW - Posko creation logic           |
| `posko_view.dart`                 | NEW - Posko form UI                  |
| `admin_dashboard_view.dart`       | Updated navigation + bindings        |
| `notification_sync_manager.dart`  | Fixed filter + mapping               |
| `office_selection_manager.dart`   | Include ALL offices in dropdown      |
| `attendance_controller.dart`      | Added master data sync on ready      |

## Lessons Learned

1. **Schema First:** Selalu verifikasi nama field di PocketBase Admin UI sebelum coding.
2. **Shared State = Shared Problems:** Jangan pakai 1 record untuk banyak user jika ada state per-user (is_read).
3. **Filter Operators Matter:** `=` vs `~` di PocketBase sangat berbeda untuk Relation fields.

# Engineering Journal: Phase 4 - Leave Approval & Admin Hardening

**Tanggal:** 06 Februari 2026
**Author:** Antigravity Agent
**Kategori:** Feature Implementation / Data Layer Architecture

## Konteks & Tujuan
Implementasi modul persetujuan izin (Leave Approval) untuk admin dengan fokus pada:
1.  **Offline-First**: Admin harus bisa mengambil keputusan (Approve/Reject) meski tanpa koneksi.
2.  **Tabbed View**: Navigasi yang bersih antara status Pending, Approved, dan Rejected.
3.  **Security/Integritas**: Mengunci status yang sudah final dan mencatat alasan penolakan.
4.  **UX**: Feedback instan via item-level loading states.

## Keputusan Arsitektural

### 1. Unified Repository Implementation
Alih-alih membiarkan logic ada di Controller, semua operasi data dipindah ke `AdminRepository`. 
- Menjamin atomisitas antara update Isar dan penulisan ke `SyncQueue`.
- Centralized error handling untuk kegagalan sinkronisasi.

### 2. Notification Integration
Sistem notifikasi diintegrasikan langsung ke dalam alur `_updateStatus`. Setiap aksi admin akan men-trigger pembuatan `NotificationLocal` yang secara otomatis masuk ke antrian sync untuk dikirim ke user tujuan.

### 3. Separation of Models
UI sekarang sepenuhnya bergantung pada `LeaveRequestLocal` dan `UserLocal`. Ketergantungan pada `RecordModel` (PocketBase SDK) di layer view telah dihapus total untuk mendukung preview offline yang stabil.

## Tantangan & Solusi

### Tantangan: Missing Context in List Items
**Masalah:** Saat menampilkan list izin, UI butuh nama karyawan, namun model `LeaveRequestLocal` hanya menyimpan `userId`.
**Solusi:** Implementasi `userMap` di `LeaveApprovalController` yang dipopulasi saat `fetchAll`. Ini menghindari query berulang ke database (N+1 problem) saat rendering list.

### Tantangan: Concurrent Sync Conflict
**Masalah:** Risiko admin mengubah status saat sync sedang berjalan.
**Solusi:** Implementasi locking sederhana di repository yang mengecek status terakhir di Isar sebelum mengizinkan update.

## Hasil Audit
- **LOC Count:** `LeaveApprovalController` (~110 LOC), `LeaveRequestCard` (~200 LOC). Target <200 LOC per file tercapai.
- **Performance:** Rendering tabbed menu sangat responsif karena data dilayani langsung dari Isar.
- **Sync:** Berhasil diverifikasi sinkronisasi 2 arah untuk status `approved`/`rejected` dan `rejection_reason`.

---
*End of Journal Entry*

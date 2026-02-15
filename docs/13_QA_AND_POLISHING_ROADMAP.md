# 🧪 PETA JALAN QA & PEMOLESAN - SEAGMA PRESENCE

> **Fase:** 🛡️ **PENGERASAN & SIAP DEPLOY**
> **Fokus:** Pengujian Siklus Penuh, Migrasi Database, & Pemolesan UX
> **Status:** 🟢 AKTIF

---

## 🚀 1. Fitur Tertunda (TODO Prioritas Tinggi)

Fitur-fitur ini sebelumnya ditunda tetapi tetap kritis untuk rilis produksi.

- [ ] **Posko Dinamis (Presensi Mendadak)**
    - Logika untuk cek radius sementara terhadap GPS Admin.
- [ ] **Pelaporan Analitik**
    - Dashboard deteksi Alpha.
    - Ekspor absensi ke PDF/Excel.
- [ ] **Audit LOC Final**
    - Memastikan 100% file < 200 Baris (Pemeriksaan ketat).

---

## 🗄️ 2. Panduan Migrasi Database (PocketBase)

Berdasarkan Skema Isar yang diimplementasikan, Admin harus membuat field berikut di koleksi `attendances` secara manual.

| Field PocketBase | Tipe | Deskripsi |
|------------------|------|-------------|
| `employee` | relation | Relasi ke `users` (sebelumnya `user_id`) |
| `location` | relation | Relasi ke `offices` |
| `status` | select | `present`, `late`, `absent`, `leave`, `halfDay`, `pendingReview` |
| `created` | datetime | Gunakan sebagai Waktu Check-in |
| `out_time` | datetime | Waktu Check-out |
| `lat` / `long` | number | Koordinat GPS Check-in |
| `out_lat` / `out_long`| number | Koordinat GPS Check-out |
| `is_wifi_verified` | bool | Status Kecocokan BSSID WiFi |
| `is_ganas` | bool | **Fase 1:** True jika check-in dari lapangan |
| `ganas_notes` | text | **Fase 1:** Deskripsi tugas lapangan |
| `is_overtime` | bool | **Fase 2:** True jika klaim lembur |
| `overtime_duration`| number | **Fase 2:** Lembur dalam menit |
| `overtime_note` | text | **Fase 2:** Alasan/justifikasi lembur |
| `photo` | file | Foto Check-in |
| `photo_out` | file | Foto Check-out |

---

## ✅ 3. Checklist Pengujian Siklus Penuh (Full Cycle Testing)

### Minggu 1 & 2: Mesin Inti (Core Engine)
- [ ] **Device Binding:** Login hanya bekerja pada perangkat terdaftar.
- [ ] **Validasi GPS:** Status penolakan saat menggunakan lokasi palsu (mock locations).
- [ ] **Verifikasi WiFi:** Koneksi ke WiFi kantor diverifikasi dengan benar.
- [ ] **Mode Offline:** Absensi tersimpan di Isar saat tidak ada internet, sinkronisasi otomatis saat online.

### Minggu 3: Komunikasi & HR
- [ ] **Sinkronisasi Inbox:** Notifikasi muncul untuk Izin Disetujui/Ditolak.
- [ ] **Sistem Sambutan:** Pesan sambutan berubah (Pagi/Siang/Sore).
- [ ] **Anti-Beku UI:** Semua tombol menampilkan status loading dan mencegah ketukan ganda (*double-tap*).

### Minggu 4: Kontrol Admin
- [ ] **Pencarian Karyawan:** Admin dapat mencari dan mereset perangkat untuk user.
- [ ] **Akses Multi-Kantor:** User hanya bisa melihat kantor yang ditugaskan kepada mereka.
- [ ] **Sistem Broadcast:** Pengumuman diterima oleh semua user yang ditargetkan.
- [ ] **Alur Persetujuan:** Menolak izin memerlukan alasan, terlihat di inbox User.

### Minggu 5: Pengerasan Operasional
- [ ] **Mode GANAS:** Check-in di luar kantor bekerja jika "Tugas Luar" dipilih (wajib foto/catatan).
- [ ] **Jebakan Lembur:** Checkout >60 menit memicu dialog.
- [ ] **Time Capping:** Memilih "TIDAK" (Tidak Klaim) mencatat waktu akhir shift dengan benar.
- [ ] **Klaim Lembur:** Memilih "YA" memerlukan foto/catatan dan menetapkan status menjadi `pendingReview`.

---

## 📈 4. Progres Verifikasi

| Modul | Status | Diuji oleh |
|--------|--------|-----------|
| Core Auth | 🟢 Stabil | Antigravity |
| Logika Attendance| 🟡 Butuh Sync PB | - |
| Dashboard Admin | 🟡 Butuh Sync PB | - |
| Jebakan Lembur | 🟢 Logika Terverifikasi| Antigravity (Mock) |
| Mode GANAS | 🟢 Logika Terverifikasi| Antigravity (Mock) |

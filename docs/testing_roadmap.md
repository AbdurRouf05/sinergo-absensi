# ✅ FINAL QA & DEBUGGING CHECKLIST SEAGMA PRESENCE

> **Instruksi Penggunaan:**
> Dokumen ini adalah lembar kerja aktif. Centang `[x]` setiap item yang berhasil divalidasi.
> Jika ditemukan bug, biarkan `[ ]` kosong dan catat error-nya di bagian bawah dokumen atau di `docs/engineering-journal/`.

---

## 📅 MINGGU 1: PONDASI & KEAMANAN

### 🛠️ Fase 1.1: Setup & Database Lokal

- [x] **Instalasi Bersih:** Hapus aplikasi lama, install versi baru. Pastikan tidak ada crash saat pembukaan pertama.
- [x] **Izin Aplikasi:** Aplikasi meminta izin Lokasi (Foreground), Kamera, dan Penyimpanan saat diperlukan.
- [x] **Cek Isar DB (Inspektor):** (Jika bisa diakses) Pastikan file `default.isar` terbentuk di direktori aplikasi.
- [x] **Splash Screen:** Logo tampil, transisi mulus ke halaman Login.

### 🔐 Fase 1.2: Keamanan & Autentikasi

- [x] **Login Sukses:** Masuk dengan NIP & Password valid. Redirect ke Dashboard.
- [x] **Login Gagal:** Masuk dengan password salah. Muncul pesan error "Kredensial Salah".
- [x] **Device Binding (Eksisting):** Login di HP Baru menggunakan akun yang sudah terdaftar di HP lama. -> **Harus Gagal** (Pesan: Perangkat tidak terdaftar).
- [x] **Device Binding (Baru):** Login dengan akun baru di HP ini. -> **Sukses** & ID Android disimpan.
- [x] **Logout:** Tekan logout, lalu tekan tombol "Back" Android. -> Tidak bisa kembali ke Dashboard (Harus tetap di Login).

---

## 📅 MINGGU 2: PRESENSI INTI (THE CORE)

### 📍 Fase 2.1: Validasi Lokasi & Sensor

- [x] **Peta Check-in:** Peta memuat lokasi saat ini dengan akurat. Marker user terlihat.
- [x] **Radius Kantor:** Lingkaran radius kantor terlihat di peta (Warna Hijau/Merah jika diluar).
- [x] **Jarak Real-time:** Teks "Jarak: XX meter" berubah saat berjalan kaki menjauhi/mendekati kantor.
- [x] **Anti-Mock (Fake GPS):** Nyalakan Fake GPS. Buka halaman Check-in. -> **Muncul Peringatan Merah / Tombol Disable**.
- [x] **Validasi WiFi (Wajib):** (Setting Admin: Wajib WiFi) Matikan WiFi HP. -> Tombol Check-in terkunci.

### 📸 Fase 2.2: Proses Check-in

- [x] **Kamera Preview:** Kamera depan terbuka di dalam kotak preview (tidak full screen).
- [x] **Ambil Foto:** Tekan tombol check-in. Foto terambil tanpa freeze.
- [x] **Loading State:** Tombol disable dan loading berputar saat proses kirim data.
- [x] **Feedback Sukses:** Muncul Dialog / Snackbar sukses. Redirect ke Dashboard.
- [x] **Cek Data Masuk:** Di Dashboard, status berubah jadi "Hadir" dan jam masuk tercatat.

### 📡 Fase 2.3: Offline & Sinkronisasi

- [x] **Simulasi Offline:** Matikan Data & WiFi. Lakukan Check-in.
- [x] **Simpan Lokal:** Muncul pesan "Koneksi mati, data disimpan lokal".
- [x] **Background Sync:** Nyalakan Data kembali. Tunggu 10-30 detik. Cek apakah data terkirim ke server (Sync Worker).
- [x] **Checkout Offline Sync:** ✅ FIXED 2026-02-07 - Checkout offline sekarang masuk SyncQueue dan ter-recover otomatis. (Lihat: `error_fix.md` Error #3)

---

## 📅 MINGGU 3: UX & FITUR HR

### 📨 Fase 3.1: Inbox & Notifikasi

- [x] **Notifikasi Masuk:** Minta Admin reject/approve izin. Cek Inbox user.
- [x] **Badge Count:** Ikon lonceng di Home ada titik merah (indikator pesan belum dibaca).
- [x] **Baca Pesan:** Klik pesan di inbox -> Status pesan berubah jadi "Dibaca" (Titik merah hilang).
- [x] **Pull-to-Refresh:** Tarik layar ke bawah di Inbox untuk memuat pesan baru manual.

### 📝 Fase 3.2: Pengajuan Izin/Cuti

- [x] **Form Validasi:** Coba submit izin tanpa isi alasan/tanggal. -> Muncul error validasi.
- [x] **Upload Bukti:** Lampirkan foto surat dokter (Kamera/Galeri). Pastikan terupload.
- [x] **Kirim Pengajuan:** Pengajuan berhasil terkirim dan muncul di Dashboard.

### 👋 Fase 3.3: Greeting & Dashboard

- [x] **Greeting Pagi:** Ubah jam HP ke 07:00. Buka App. Header: "Selamat Pagi".
- [x] **Greeting Malam:** Ubah jam HP ke 19:00. Buka App. Header: "Selamat Malam".
- [x] **Double Tap Prevent:** Klik menu "Riwayat" 3x dengan cepat. -> Halaman hanya terbuka 1x (Tidak tumpuk).

---

## 📅 MINGGU 4: ADMIN & MANAJEMEN LANJUTAN

### 👥 Fase 4.1: Direktori Karyawan (Admin)

- [ ] **Pencarian:** Ketik nama karyawan "Budi". Hasil filter sesuai. -> **PENDING Implementation** (Client-side search missing).
- [x] **Detail Karyawan:** Klik nama karyawan. Muncul detail (Jabatan, NIP, Status).
- [x] **Reset Device:** Klik tombol "Reset Device ID". Coba login pakai akun karyawan tsb di HP lain -> **Harus Sukses**.

### [SUKSES] Daftar Izin Admin (Admin Leave List)

- [x] **[CRITICAL]** Fix Admin Approval 400 Error (Invalid Sort Field) -> **PASSED** (Fix: `sort: -start_date`)
- [x] **[CRITICAL]** Fix Employee List Crash (Red Screen) -> **PASSED** (Fix: Null Safety `fromRecord` + `try-catch` loop)
- [x] **[CRITICAL]** Fix Schema Mismatch (Sync Error) -> **PASSED** (Fix: `expand: shift,office_id`)
- [ ] **[Feature]** Employee Detail & Edit -> **PARTIAL** (Access Rights Only, Profile Edit Pending)
- [x] Ambil Data Ditolak
- [x] Penanganan Mode Offline (Fallback Aman)
- [x] Tampilan Nama User (Fixed: Manual Join)

### [SUKSES] Notifikasi Izin (Leave Notifications)

- [x] Notifikasi dibuat saat Setuju/Tolak (Fixed: Direct Send logic)
- [x] User menerima notifikasi di Inbox (Fixed: Fetched User ID from Repo)
- [x] Notifikasi sinkron ke server (Fixed: Populated SyncQueue JSON)

### [SUKSES] Fase 4.2: Broadcast & Pengumuman

- [x] **Kirim Broadcast:** Admin kirim pesan ke Semua. -> **PASSED** (Personal Copy Strategy: 1 record per user)
- [x] **Kirim ke Individual:** Admin kirim ke 1 user. -> **PASSED**
- [x] **Terima Broadcast:** Login sebagai User biasa. Cek Inbox. Pesan harus ada. -> **PASSED** (Fix: `user_id ~ "id"` filter)
- [x] **Read Status Independen:** User A baca, User B tetap unread. -> **PASSED**

### [SUKSES] Fase 4.3: Smart Dropdown

- [x] **Auto-Select:** Berdiri dlm radius Kantor A. Buka Check-in. Dropdown otomatis pilih "Kantor A". -> **PASSED**
- [x] **Posko Muncul:** Admin buat Posko. User refresh -> Posko muncul di dropdown. -> **PASSED** (Fix: Include ALL offices)
- [x] **Locking:** Berdiri jauh dari semua kantor. Dropdown tidak bisa dipilih (Kecuali GANAS aktif). -> **PASSED**

---

## 📅 MINGGU 5: OPERASIONAL FINAL & GANAS

### [SUKSES] Fase 5.1: Mode GANAS (Tugas Luar)

- [x] **Pilih GANAS:** Di dropdown lokasi, pilih "Tugas Luar / GANAS". -> **PASSED**
- [x] **Bypass Radius:** Validasi jarak merah hilang / diabaikan. -> **PASSED**
- [x] **Form Wajib:** Coba Check-in tanpa foto kegiatan. -> **Gagal** (Wajib isi). -> **PASSED**
- [x] **Submit Berhasil:** Foto tugas luar terkirim dengan tag "IsGanas: true". -> **PASSED**

### ⏰ Fase 5.2: Lembur Otomatis & Review Admin

- [x] **Trigger Lembur:** Checkout jam 18:00 (Jika pulang jam 17:00). -> **PASSED**
- [x] **Popup Konfirmasi:** Muncul tanya "Anda pulang telat, apakah ini lembur?". -> **PASSED**
- [x] **Tolak Lembur:** Klik "Tidak". Checkout biasa (Telat Pulang). -> **PASSED**
- [x] **Terima Lembur:** Klik "Ya". Isi form lembur -> Checkout sukses dengan status "Menunggu Review". -> **IMPLEMENTED**
- [x] **Admin Review:** Admin buka menu "Persetujuan Lembur". Lihat foto & catatan, lalu klik "Setujui". -> **IMPLEMENTED**
- [x] **Status Update:** Status User berubah jadi "Hadir" (Present) setelah disetujui. -> **IMPLEMENTED**

### 📊 Fase 5.3: Analytics & Operasional Final

- [x] **Buat Posko:** Admin buat Posko Sementara. -> **PASSED** (Fix: `radius` field mapping)
- [x] **Hapus Posko:** Admin masuk ke menu Posko -> Lihat list Posko Aktif -> Klik Hapus -> Posko hilang dariapp user. -> **IMPLEMENTED**
- [x] **Rekap Kinerja Lengkap:** Buka Dashboard Analitik -> Cek Rekap Kinerja. Pastikan SEMUA karyawan muncul dan angka Hadir, Telat, Izin, Lembur sesuai data asli. -> **PASSED** (Code Verified)
- [x] **Live Monitoring Sync:** Pastikan kartu "Siapa Belum Masuk" di Analitik sinkron dengan data Live Monitoring di Dashboard utama. -> **PASSED** (Code Verified)
- [x] **Export/Copy:** Klik tombol Export di rekap kinerja -> Paste ke WhatsApp -> Data harus rapi. -> **PASSED** (Implemented via Clipboard)

---

## 📅 MINGGU 6: STABILISASI & masih belum bisa menambah karyawan REGRESSION (CRITICAL FIXES)

### 🚨 Fase 6.1: Regresi Data & Sync (Must Pass)

- [x] **Live Monitoring Kosong:** (Regression Fix) Restart aplikasi dengan database bersih. Pastikan nama karyawan muncul.
- [x] **Unique Index Violation:** (Regression Fix) Tambah karyawan baru dengan Email kosong (`emailVisibility: false`). Pastikan Sync aman.
- [x] **Email Placeholder UX:** Di halaman Manajemen Karyawan, pastikan email `missing_...placeholder` TIDAK DITAMPILKAN mentah-mentah. Ganti dengan "Email Hidden" atau "-".

### 📍 Fase 6.2: Validasi Logika Lokasi (CRITICAL)

- [x] **Office Bypass Bug (User Report):**
  - [x] **Kasus 1: Office ID Kosong.** User tanpa assigned office -> Harusnya TIDAK BISA absen dimanapun (atau default kantor pusat?). Saat ini: BISA absen dimanapun.
  - [x] **Kasus 2: Multi-Office Assign.** User di-assign ke "Kantor A" & "Kantor B". Coba absen di "Kantor C". -> Harusnya DITOLAK. Saat ini: BISA absen.
  - [x] **Kasus 3: Radius Check.** Pastikan logic `isWithinRadius` benar-benar memblokir jika jarak > radius.
- [x] **Mock Location:** Verifikasi ulang deteksi Fake GPS dengan berbagai mode.

### 👥 Fase 6.3: Admin UI/UX & Analytics

- [x] **Feedback Simpan:** Di halaman Detail Karyawan > Edit Office. Saat klik "Simpan", HARUS muncul Snackbar/Dialog sukses. ✅ Sudah ada di `AdminController.updateEmployeeOffices`.
- [x] **Analytics Enhancement:**
  - [ ] **"Potensi Alpha":** Ganti label atau jelaskan maksudnya (User yang belum absen sampai jam sekian?).
  - [x] **Rekap Kinerja:** Kolom-kolom berikut sudah dihitung:
    - [x] Total Hadir (Hari)
    - [x] Telat: Frekuensi (kali) + Durasi (menit) -> `lateCount` + `totalLateMinutes`
    - [x] Lembur: Frekuensi (kali) + Durasi (menit) -> `overtimeCount` + `totalOvertimeMinutes`
    - [x] Total Izin (Hari)
    - [x] Tugas Luar (GANAS): Frekuensi (kali) -> `ganasCount`

### ⚖️ Fase 6.4: Fairness Logic & Approval Lembur

- [x] **Fairness Logic (Raw Data):**
  - [x] Pastikan `lateMinutes` disimpan MURNI (tidak dikurangi lembur). ✅ Dihitung di `CheckInStatusHelper`.
  - [x] Pastikan `overtimeMinutes` disimpan MURNI (tidak dikurangi telat). ✅ Dihitung di `CheckinActionManager`.
  - [x] Skenario: Masuk Telat 30m, Pulang Lembur 60m -> Database: Late=30, Overtime=60. ✅
- [x] **Admin Approval:**
  - [x] **Tombol Terima:** Set status `is_overtime_approved` = true + Kirim Notifikasi. ✅
  - [x] **Tombol Tolak:** Set status `is_overtime` = false, `overtimeMinutes` = 0 + Kirim Notifikasi. ✅
  - [x] **Approval Ganas:** Set `is_ganas_approved` = true/false + Kirim Notifikasi. ✅
- [x] **Dashboard Status Color:**
  - [x] Jam < Pulang & Data Kosong -> Kuning ("Belum Absen"). ✅ `LiveStatus.belumAbsen` + Amber color
  - [x] Jam > Pulang & Data Kosong -> Merah ("Alpha"). ✅ `LiveStatus.alpa` + Red color

### 👥 Fase 6.5: Fitur Tambah Karyawan (Mobile Admin)

- [x] **UI Form:** `AddEmployeeView` dengan input:
  - [x] Nama Lengkap, NIP, Email, Password.
  - [x] Dropdown Office (Wajib Pilih).
  - [x] Dropdown Shift (Wajib Pilih).
  - [x] Role (Employee/HR/Admin).
- [x] **Logic Create:** Implementasi `createEmployee` di `AdminController`.
  - [x] Validasi Input (Email unik, Password min 8 char).
  - [x] API Call ke PocketBase (`users.create`).
  - [x] Success Feedback (Snackbar/Dialog).
  - [x] Auto-Refresh List Karyawan setelah create.

### ✨ Fase 6.6: Final Polish (UI/UX Hardening)

- [x] **Shift Dropdown (Employee Detail):** Tampilan lebih bersih (OutlineBorder), tidak ada label redundant. ✅
- [x] **Home Shift Display:** Teks Shift tidak overflow. Format: Nama Shift (Atas) + Jam (Bawah). Font proporsional. ✅
- [x] **Logout Confirmation:** Klik Logout -> Muncul Dialog Konfirmasi "Apakah Anda yakin?". Tombol Merah untuk Keluar. ✅
- [x] **Dynamic Profile Data:** Halaman Profile menampilkan Shift & Kantor yang benar (Bukan "Non-Shift/Belum Diatur"). ✅

**Verifikator:** **AbdurRouf05**  
**Tanggal:** 15 Februari 2026

---

## 📅 MINGGU 8: KEAMANAN & BRANDING LANJUTAN

### 🛡️ Fase 8.1: Security Violation UI (Red Screen Detail)

- [x] **Root Detection:** Trigger root → Red Screen menampilkan "Akses Root/Jailbreak" + solusi spesifik. ✅
- [x] **Mock GPS:** Enable Fake GPS → Red Screen menampilkan langkah perbaikan (matikan Developer Options, dll). ✅
- [x] **Emulator:** Run di emulator → Red Screen menampilkan "Gunakan HP fisik". ✅
- [x] **Time Manipulation:** Ubah waktu manual → Red Screen menampilkan "Aktifkan Set Automatically". ✅
- [x] **Device Binding Mismatch:** Session restore di device berbeda → Red Screen "Perangkat Tidak Dikenali" + 3 langkah solusi. ✅
- [x] **Solution Card Widget:** `SecuritySolutionCard` menampilkan kotak putih dengan ikon lightbulb dan langkah perbaikan. ✅
- [x] **Scroll Support:** Konten panjang tidak overflow (SingleChildScrollView). ✅
- [x] **LOC Compliance:** `SecurityViolationView` < 200 LOC. ✅

### 🎨 Fase 8.2: Logo & Splash Fix

- [x] **Logo Splash:** Logo tidak lagi terpotong/kegedean (padded 40% dari canvas). ✅
- [x] **App Icon:** Ikon launcher proporsional (60% dari canvas). ✅
- [x] **Adaptive Icon:** Foreground 45% sesuai safe zone Android. ✅

### ✨ Fase 8.3: Animated Splash Screen

- [x] **Native Splash:** Hanya warna biru polos (#2E3D8A, tanpa logo statis). ✅
- [x] **Logo Animation:** Logo muncul dengan fade-in + scale (`easeOutBack`, 1200ms). ✅
- [x] **Text Animation:** "SEAGMA" slide-up + fade, "PRESENCE" staggered fade. ✅
- [x] **Status Animation:** Spinner + status text muncul terakhir (delayed 1500ms). ✅
- [x] **Status Transition:** `AnimatedSwitcher` untuk smooth crossfade saat teks berubah. ✅
- [x] **Minimum Display:** Splash tampil minimal 4 detik sebelum navigasi. ✅
- [x] **Seamless Transition:** Warna native splash = `AppColors.primary`, tidak ada "jeda putih". ✅

**Verifikator:** **AbdurRouf05**  
**Tanggal:** 15 Februari 2026

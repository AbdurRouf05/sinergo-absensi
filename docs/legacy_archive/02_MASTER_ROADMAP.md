# 🗺️ SEAGMA PRESENCE - PETA JALAN UTAMA (TERINTEGRASI)

> **Status:** ✅ **SELESAI: SIAP UNTUK QA & RILIS**
> **Tujuan:** Sistem Absensi Produksi dengan Mode GANAS & Pelaporan Komprehensif
> **Target Deadline:** +1 Minggu (Rilis Final)
> **Aturan Ketat:** Maks 200 Baris per File | Arsitektur Bersih | Offline-First

---

## 📊 Ringkasan Eksekutif

Roadmap ini menggabungkan pencapaian **Fase 1 (Pondasi)** dengan tujuan **Fase 2 (Pengerasan & Ekspansi)** untuk memastikan konsistensi antara perbaikan bug dan penambahan fitur.

| Stack Inti     | Spesifikasi                                                        |
| -------------- | ------------------------------------------------------------------ |
| **Arsitektur** | Flutter Clean Architecture + GetX Pattern (Micro-Modular)          |
| **Local DB**   | Isar v3 (Perubahan Skema = Wajib Migrasi)                          |
| **Remote DB**  | PocketBase (Rest API / SDK)                                        |
| **Peta**       | flutter_map (OpenStreetMap) - **Tanpa Google Maps**                |
| **Validasi**   | Hibrida (GPS + WiFi BSSID) + Pengikatan Perangkat (Device Binding) |
| **Min SDK**    | Android 8.1 (API 27) - **KOMPATIBILITAS KETAT**                    |

---

## 🛡️ PAGAR PENGAMAN (STANDAR ANTIGRAVITY)

1.  **Batas Baris File Ketat:** Jika sebuah file `.dart` mendekati **200 baris**, sistem **WAJIB** menolak penambahan fitur sebelum dilakukan ekstraksi menjadi sub-modul/komponen.
2.  **Tanpa Upgrade Library:** Tetap pada AGP 8.7.0, CompileSDK 35, Isar v3, dan PocketBase v0.19.0.
3.  **Aturan Validasi:** Semua input (terutama filter tanggal rekap) wajib melalui kelas model yang kuat (**Tanpa Dynamic**).
4.  **Siklus Refactor:** Setiap hari **Jumat** adalah "Hari Refactor". Tidak ada penambahan fitur, hanya fokus memecah kode menjadi lebih mikro.

---

## 🗓️ TIMELINE FASE 2: REFACTORING & EKSPANSI (AKTIF)

### 📁 MINGGU 1: Desain Ulang UI & Mesin Status (SELESAI)

- [x] **Kerangka Proyek & Setup** (Clean Arch, GetX, DI, Tema).
- [x] **Database Lokal (Isar)** (Skema User, Attendance, Office).
- [x] **Inti Keamanan** (Device Binding, Auth Service).
- [x] **Layanan Sensor** (GPS+Mock, WiFi, Time).
- [x] **Fase Refactor:** Audit file UI > 300 baris (Dashboard/Attendance) & Ekstraksi Widget (Selesai: stabilisasi 100%).
- [x] **Penyelarasan Antarmuka Global:** 100% _decoupling_ dengan `Get.find<IInterface>`. Deadlock Teratasi.

### 📁 MINGGU 2: Logika Inti & Validasi (SELESAI)

- [x] **UI Check-In/Out** (Tampilan Peta, Kamera, Penanganan State).
- [x] **Validasi Hibrida** (WiFi > GPS > Tolak).
- [x] **Mesin Aturan** (Deteksi Mock Loc & Manipulasi Waktu).
- [x] **Mesin Sinkronisasi Offline** (Background Service, Antrean/Queueing).
- [x] **Logika Absensi Detail:** Menghitung Telat/Lembur secara presisi (Terintegrasi Dashboard Live).

### 📁 MINGGU 3: Manajemen Data & Fitur HR (SELESAI)

- [x] **Fase 1: Visibilitas Sistem Persetujuan (Pivot ke Kotak Masuk/Inbox)**
  - [x] Sistem inbox notifikasi untuk status **Disetujui** dan **Ditolak**.
  - [x] Sinkronisasi real-time antara Isar & PocketBase.

- [x] **Fase 2: Sistem Sambutan (Greeting)**
  - [x] Implementasi **Pesan Sambutan** dinamis di Beranda berdasarkan waktu (Pagi/Siang/Malam) menggunakan `ITimeService`.

- [x] **Pengerasan UI/UX Global (Sapu Anti-Macet)**
  - [x] Implementasi state loading (`isLoading`) pada tombol aksi utama.
  - [x] Pencegahan ketukan ganda (_double-tap_) & redundansi request API/Database.

- [x] **⚠️ CHECKPOINT REFACTOR (STANDAR ANTIGRAVITY):**
  - [x] **STABILISASI ARSITEKTUR:** Migrasi 100% ke Penemuan Berbasis Antarmuka (Interface-based Discovery).
  - [x] **MITIGASI FILE GEMUK:** Pemecahan `AuthController`, `IsarService`, `SyncService` ke Sub-Managers.

### 📁 MINGGU 4: PUSAT MANAJEMEN & KOMUNIKASI (SELESAI)

- [x] **Fase 1: Direktori Karyawan & Kontrol Akses (Admin)**
  - [x] Setup struktur modul `lib/modules/admin/employee_list/`.
- [x] **Minggu 4 (Pengerasan Manajemen & Admin)**
  - [x] Fitur: Direktori Karyawan (Pencarian Penuh & Reset Perangkat)
  - [x] Fitur: Penugasan Multi-Kantor UI
  - [x] Fitur: Broadcast Pengumuman (Admin ke Inbox)
  - [x] Logika: Dropdown Jarak Cerdas (Pilih Otomatis saat Check-in)
  - [x] Logika: Sinkronisasi Alasan Penolakan ke Inbox
  - [x] Pengerasan: UI Anti-Macet (Logika IsLoading global)
  - [x] **Stabilisasi:** Fix Crash List Karyawan & Sortir Izin (Schema Sync)
  - [x] Audit: Pemindaian Clean Architecture (Maks 200 LOC per file)

- [x] **Fase 2: Sistem Inbox & Broadcast (Pengganti Polling)**
  - [x] **Inbox Pribadi:** Saluran 1-on-1 otomatis (Notifikasi Status Izin: Disetujui/Ditolak).
  - [x] **Broadcast Pengumuman:** Admin kirim pesan ke "Semua" atau "Target Divisi/User".
  - [x] **Badge UI:** Tanda merah di ikon lonceng jika ada pesan baru (Terintegrasi dengan Status Cuti).

- [x] **Fase 3: Dropdown Lokasi Cerdas (Persiapan GANAS)**
  - [x] **UI Dropdown** di Check-in: Menampilkan pilihan kantor yang diizinkan.
  - [x] **Pilih Otomatis:** Otomatis pilih kantor berdasarkan radius GPS terdekat.
  - [x] **Validasi:** Dropdown dikunci jika GPS tidak berada di radius kantor manapun (Kecuali Mode GANAS).

- [x] **Fase 4: Persetujuan Izin (Filter Tab)**
  - [x] Tampilan Tab: **Menunggu, Disetujui, Ditolak**.
  - [x] **Penguncian Status:** Data terkunci & otomatis kirim notifikasi ke Inbox User setelah aksi diambil.
  - [x] **Alasan Penolakan:** Dukungan alasan penolakan yang tersinkronisasi.

### 📁 MINGGU 5: OPERASIONAL & PERLINDUNGAN KECURANGAN (FREEZE)

- [x] **Fase 1: Mode GANAS (Tugas Luar via Dropdown) (SELESAI)**
  - [x] Opsi tambahan di Dropdown Cerdas: **"Tugas Luar / GANAS"**.
  - [x] **Logika Bypass:** Cek radius dimatikan -> Wajib Foto Kegiatan -> Wajib Deskripsi Tugas.
  - [x] Label khusus di laporan admin: **"Hadir (GANAS)"** (IsGanas tagging ditambahkan).

- [x] **Fase 2: Lembur Berbasis Klaim (Lembur Anti-Nakal) (SELESAI)**
  - [x] **Pemicu:** Checkout > 60 menit dari jam shift.
  - [x] **Jebakan (The Trap):** Popup konfirmasi "Apakah ini Lembur?".
  - [x] **Logika Klaim:** Jika "YA", wajib isi form & upload bukti foto. Butuh Persetujuan Admin.

- [x] **Fase 3: Posko Dinamis (Presensi Mendadak) (SELESAI)**
  - [x] Admin/Direktur generate "Titik Absen Sementara" berdasarkan GPS HP mereka.
  - [x] Karyawan di sekitar HP Admin bisa absen (Validasi radius mengacu ke koordinat Admin).
  - [x] **Keamanan:** Perlindungan Anti-Mocking terintegrasi.

- [x] **Fase 4: Analitik & Pelaporan Cerdas (Tanpa Peringkat) (SELESAI)**
  - [x] **Monitor Real-time:** Dashboard "Siapa Belum Masuk Hari Ini" (Deteksi Alpha).
  - [x] **Rekap Bersih (PDF/Tabel):** Total Hadir, Telat, Lembur (Jam).
  - [x] **Ketat 200 LOC:** Seluruh file UI analitik dipecah menjadi komponen mikro.
  - [x] **Ekspor:** Salin rekap ke clipboard, PDF, dan CSV (Excel).

- [x] **Fase 5: Pembersihan Kode (Legacy Cleanup) (SELESAI)**
  - [x] **Hapus Dead Code:** `DynamicOutpostRepository` & `AdminOutpostManager`.
  - [x] **Versi Kotlin:** Upgrade ke 1.9.25 untuk kompatibilitas plugin baru.

- [x] **⚠️ SAPU BERSIH REFACTOR FINAL (KETAT 200 LOC) (SELESAI):**
  - [x] **IsarService:** Ekstraksi interface `IIsarService` & `IsarConfig` (~100 LOC).
  - [x] **AdminController:** Dekomposisi menjadi Manajer `Dashboard`, `Employee`, `Outpost`.
  - [x] **CheckinController:** Ekstraksi `Validator`, `ActionManager`, `DialogHelper`.
  - [x] **Pembersihan:** Menghapus kode mati (`analytics_logic.dart`) & impor yang tidak terpakai.
  - [x] **Verifikasi:** `find_large_files.py` mengonfirmasi pengurangan masif.

---

## 🏗️ Arsitektur Teknis (Panduan Ketat)

### 1. Alur Data (Offline-First)

> **UI** ➔ **Controller** ➔ **Service** ➔ **Isar DB** ➔ (Async) ➔ **SyncService** ➔ **PocketBase**
> _UX tidak boleh blocking karena sinyal jelek._

### 2. Batas Struktur File & Aturan Modularitas

**Maksimal baris kode per file: 200 baris.**

```text
lib/
├── modules/          # Halaman UI & Controller
├── components/       # Reusable Widgets (Atomic)
├── services/         # Hardware & Background
├── data/
│   ├── providers/    # Panggilan API
│   └── local/        # Database Isar
└── core/             # Utils, Konstanta
```

### 📁 MINGGU 6: STABILISASI & FINAL POLISH (SELESAI)

- [x] **Fase 1: Akurasi Analitik (Timezone Fix)**
  - [x] **Full Day Window:** Mengubah query analitik menjadi range 00:00-23:59 (Local) untuk menangani offset UTC. ✅
  - [x] **Dynamic Data:** Memperbaiki expand keys (`shift`, `office_id`) di Profile & Home Manager. ✅

- [x] **Fase 2: UI/UX Hardening (User Feedback)**
  - [x] **Shift Dropdown:** Styling `OutlineInputBorder` yang bersih tanpa label redundant. ✅
  - [x] **Home Typography:** Split teks Shift menjadi 2 baris (Nama/Jam) dengan font proporsional. ✅
  - [x] **Logout Safety:** Dialog konfirmasi sebelum keluar aplikasi. ✅

- [x] **Logout Safety:** Dialog konfirmasi sebelum keluar aplikasi. ✅

### 📁 MINGGU 7: FINAL POLISH & MISSING FEATURES (PHASE 7)

- [x] **Advanced Analytics & Export**
  - [x] **Historical Alpha:** Perhitungan mundur untuk data masa lalu.
  - [x] **Ekspor Data:** PDF (Laporan Resmi) & CSV (Olah Data).

- [x] **Legacy Cleanup & Build Fixes**
  - [x] **Hapus Dead Code:** `DynamicOutpostRepository` & `AdminOutpostManager`.
  - [x] **Kotlin Upgrade:** Force vers 1.9.25 untuk kompatibilitas plugin.

- [x] **Branding & Assets**
  - [x] **Identitas:** Implementasi Logo SEAGMA (Launcher & Splash).
  - [x] **Visual:** Penyesuaian tema warna (jika ada).

### 📁 MINGGU 8: KEAMANAN & BRANDING LANJUTAN (SELESAI)

- [x] **Fase 1: Security Violation UI (Red Screen Enhancement)**
  - [x] **Pesan Detail:** Setiap ancaman (Root, Mock GPS, Emulator, Time, Device Binding) punya penjelasan & solusi spesifik.
  - [x] **Widget Solusi:** Ekstraksi `SecuritySolutionCard` (Langkah Perbaikan dengan ikon lightbulb).
  - [x] **Anti Session Cloning:** `AuthService.restoreSession()` mendeteksi `DeviceBindingException` → Red Screen.
  - [x] **ScrollView:** `SingleChildScrollView` untuk mencegah overflow pada layar kecil.
  - [x] **200 LOC Compliance:** `SecurityViolationView` ~190 LOC.

- [x] **Fase 2: Fix Logo Splash & Icon**
  - [x] **Resize:** Generate 3 varian logo (splash 40%, icon 60%, adaptive 45%).
  - [x] **Regenerate:** `flutter_native_splash:create` & `flutter_launcher_icons`.

- [x] **Fase 3: Animated Splash Screen**
  - [x] **Animasi Logo:** Fade-in + `easeOutBack` scale (1200ms).
  - [x] **Animasi Text:** Slide-up `SEAGMA` + staggered fade `PRESENCE`.
  - [x] **Status Text:** `AnimatedSwitcher` crossfade smooth.
  - [x] **Seamless Native:** Native splash warna polos `#2E3D8A` (tanpa logo).
  - [x] **Minimum Display:** `Stopwatch` — splash tampil minimal 4 detik.

---

> **Dokumen ini adalah sumber kebenaran tunggal untuk arsitektur SEAGMA PRESENCE.**
> **Setiap penyimpangan dari cetak biru ini memerlukan persetujuan dan dokumentasi eksplisit.**

# 🚀 Rencana Tambahan Fitur (Competition Booster)

Dokumen ini berisi fitur-fitur "Wow Factor" yang direncanakan untuk meningkatkan nilai jual aplikasi saat kompetisi.

## 1. Analisis AI (Smart Recap)

- **Status:** ⏳ Direncanakan
- **Deskripsi:** Menggunakan Google Gemini 1.5 Flash untuk menganalisis pola absensi karyawan.
- **Output:**
  - Insight keterlambatan (mis: "Sering terlambat di hari Senin").
  - Pujian konsistensi (mis: "Streak kehadiran 7 hari!").
  - Deteksi burnout (jam pulang terlalu larut).
- **Implementasi:** `SmartInsightCard` di Admin Dashboard.

## 2. Live Location Stream

- **Status:** ⏳ Pending
- **Deskripsi:** Marker lokasi karyawan bergerak real-time di peta admin.
- **Teknis:** Mengubah `Geolocator.getCurrentPosition` (one-shot) menjadi `getPositionStream`.

## 3. Offline-First Capability

- **Status:** ⏳ Pending
- **Deskripsi:** Absensi tetap bisa dilakukan tanpa internet, data disinkronkan otomatis saat online.
- **Teknis:**
  - Caching peta lokal (Tiles).
  - Queue management yang lebih robust untuk upload data offline.
  - Indikator UI "Mode Offline" yang elegan.

## 4. Smart Map Link Parsing

- **Status:** ⏳ Pending
- **Deskripsi:** Admin bisa copy-paste link Google Maps, dan sistem otomatis mengonversi ke koordinat Lat/Lng untuk Posko.
- **Teknis:** Regex parser untuk URL Google Maps.

## 5. System Tray Notifications

- **Status:** ⏳ Pending
- **Deskripsi:** Notifikasi muncul di system tray Android bahkan saat aplikasi ditutup.
- **Teknis:** Integrasi `flutter_local_notifications` dengan background fetch.

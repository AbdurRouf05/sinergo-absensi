# Jurnal Engineering: Stabilisasi Analitik Admin & Remote-First Fetch

**Tanggal:** 12 Februari 2026  
**Status:** ✅ IMPLEMENTED  
**Topik:** Admin Dashboard Accuracy & Remote Data Synchronization

## 1. Masalah (The Problem)

Dashboard Admin sebelumnya mengalami inkonsistensi data antara data lokal (Isar) dan server (PocketBase), terutama untuk modul Kehadiran dan Izin. Beberapa masalah yang diidentifikasi:

1. **Error 400 (Filter server-side)**: Mencoba memfilter izin berdasarkan status di sisi server sering kali gagal karena keterbatasan PocketBase v0.19.
2. **Crash Data Parsing**: Ketidaksesuaian skema terkadang menyebabkan aplikasi crash saat memetakan record dari server ke model lokal.
3. **Data Alpha Tidak Akurat**: Logika deteksi karyawan yang tidak hadir (Alpha) belum mature.

## 2. Solusi (The Solution)

### A. Strategi "Trawl Net" (Jaring Pukat)

Alih-alih memfilter di sisi server yang rawan error, kita sekarang mengambil semua record (per-page) dan melakukan filtrasi di sisi client menggunakan Dart.

- **File**: `AdminAnalyticsRepository.dart`
- **Metode**: `getLeaveRequestsByStatus`

### B. Remote-First Fetching

Untuk Dashboard Admin, akurasi adalah prioritas. Kita sekarang secara eksplisit menarik data dari server terlebih dahulu (`Remote-First`) sebelum jatuh kembali (`Fallback`) ke Isar.

### C. Paranoid Parsing

Implementasi pemetaan data dari server yang lebih aman untuk mencegah crash global jika ada satu field yang tidak valid.

## 3. Detail Implementasi

- **AdminAnalyticsRepository**: Logika sentral untuk menghitung rekap harian (Total Hadir, Izin, Alpha, Overtime).
- **AdminRecapDTO**: Model data baru untuk mentransfer statistik ke UI secara bersih.
- **UI Stabilization**: Memperbaiki `AdminDashboardView` agar tidak re-render berlebihan saat sinkronisasi data.

## 4. Hasil (Results)

- Dashboard Admin sekarang menampilkan angka yang akurat dan sinkron dengan server.
- Error "400 Bad Request" saat memfilter izin telah teratasi.
- Sistem deteksi Alpha sekarang mempertimbangkan status izin (Approved Leave) untuk menghindari False Positives.

---

_Dibuat oleh Antigravity Agent_

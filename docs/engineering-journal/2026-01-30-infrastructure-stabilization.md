# ENGINEERING JOURNAL

## 2026-01-30: 🚀 FIX: Infrastructure Stabilization & Android 16 Prevention Protocol

**Status:** ✅ SOLVED

### Rangkuman Masalah
1.  **Dependency Conflict (Android 16 Requirement):** Project gagal build karena Library Flutter terbaru (Geolocator v13+, Plus Plugins v10+) secara implisit meminta **Android 16 (SDK 36)** dan **AGP 8.9**.
2.  **Infrastructure Rejection:** Infrastruktur project saat ini (AGP 8.7, Android 15) menolak permintaan tersebut, menyebabkan error `CheckAarMetadata` dan `Transitive Dependency Conflict`.
3.  **Internal Version Conflict:** Terjadi konflik versi internal antara `device_info_plus` dan `package_info_plus` terkait dependensi transitif package `web`.

### Solusi Teknis (The Fix)
1.  **Downgrade Strategis:** Mengembalikan versi library ke "Generasi Stabil 2024/2025" di `pubspec.yaml` untuk memastikan kompatibilitas dengan Android 15:
    * `geolocator`: `^11.0.0`
    * `device_info_plus`: `^9.1.2`
    * `network_info_plus`: `^4.1.0`
    * `connectivity_plus`: `^5.0.2`
    * `package_info_plus`: `^5.0.1`

2.  **Gradle Resolution Strategy (The Guardian):** Menambahkan blok `configurations.all` di `android/app/build.gradle.kts` untuk memaksa library `androidx.core` dan `androidx.activity` tetap di versi stabil (masing-masing 1.13.1 & 1.9.0). Ini mencegah Gradle menarik versi Alpha/Beta yang membutuhkan Android 16 secara tidak sengaja.

3.  **NDK Stabilization:** Memastikan konfigurasi NDK terkunci di versi `27.0.12077973` dan `compileSdk` di set ke `35` (Android 15) di `android/app/build.gradle.kts`.

### Hasil Akhir
* **Build Success:** APK berhasil digenerate tanpa error.
* **Runtime Verification:** App berjalan lancar di Device Fisik (CPH2059).
* **Stability:** Pondasi project aman untuk diserahterimakan ke tim developer selanjutnya tanpa risiko "breaking changes" akibat update dependency otomatis yang agresif.

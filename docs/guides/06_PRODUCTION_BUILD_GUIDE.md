# Panduan Build Produksi 🚀

## Ringkasan
Dokumen ini merinci konfigurasi dan langkah-langkah yang diperlukan untuk membangun (build) APK produksi untuk `seagma-presensi`. Dokumen ini mencakup informasi kritis mengenai environment build, kredensial penandatanganan (signing), dan perbaikan spesifik yang diterapkan untuk mengatasi konflik dependensi.

## 🛠️ Environment Build
- **Flutter SDK**: Channel Stable (pastikan versi terbaru).
- **Java Version**: JDK 17 (Wajib untuk AGP 8+).
- **Android SDK**:
    - `compileSdk`: **34** (Android 14) - *Kritikal untuk stabilitas toolchain*.
    - `minSdk`: **24** (Android 7.0).
    - `targetSdk`: **34**.
    - `ndkVersion`: default.

## 🔑 Kredensial Signing
Build rilis ditandatangani dengan keystore yang dibuat khusus untuk proyek ini.

- **Lokasi**: `android/app/upload-keystore.jks`
- **File Properti**: `android/key.properties`
- **Alias**: `upload`
- **Password**: Didefinisikan di `key.properties` (Jangan commit `key.properties` ke version control).

> **⚠️ KRUSIAL**: Segera backup `upload-keystore.jks` dan `key.properties` ke tempat aman. Jika hilang, Anda tidak dapat mengupdate aplikasi di Play Store.

## 🧪 Perbaikan "Safe Nuclear" Build
Untuk mengatasi konflik antara plugin legacy (seperti `isar_flutter_libs`) dan dependensi Android modern (`androidx.core` dengan resource `lStar`), kami menerapkan script build root-level khusus di `android/build.gradle.kts`.

**Apa yang dilakukannya:**
1.  **Forced Resolution**: Memaksa `androidx.core:core` dan `core-ktx` ke versi `1.13.1` untuk memastikan ketersediaan resource `lStar`.
2.  **Forced Compile SDK**: Menggunakan reflection untuk memaksa semua subprojects (library) melakukan compile dengan `compileSdk = 34`.
3.  **Namespace Injection**: Menyuntikkan namespace ke `isar_flutter_libs` untuk memenuhi persyaratan AGP 8.5.2.
4.  **State Safety**: Mengecek `project.state.executed` untuk menghindari error lifecycle Gradle.

## 📦 Cara Melakukan Build
Jalankan perintah berikut di root proyek:

```bash
flutter build apk --obfuscate --split-debug-info=./debug-symbols --release
```

**Output:**
`build/app/outputs/flutter-apk/app-release.apk`

## 🩺 Pemecahan Masalah (Troubleshooting)
- **Error**: `resource android:attr/lStar not found`
    - **Solusi**: Pastikan `android/local.properties` memiliki `flutter.compileSdkVersion=34` dan script override di `build.gradle.kts` root aktif.
- **Error**: `Namespace not specified`
    - **Solusi**: Script injeksi path root menangani ini secara otomatis untuk `isar_flutter_libs`.
- **Error**: `Project already evaluated`
    - **Solusi**: Pastikan blok `afterEvaluate` dibungkus dalam pengecekan `project.state.executed` (Safe Nuclear Fix).

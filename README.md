# SEAGMA PRESENCE

Project Presensi Mobile (Offline-First) berbasis Flutter dengan arsitektur Clean Architecture + GetX.

## 📋 Prasyarat (Prerequisites)

Sebelum memulai, pastikan developer memiliki:

* **Flutter SDK**: Versi 3.22.x atau terbaru (Stable Channel).
* **Dart SDK**: Versi 3.4.x.
* **Android Studio** / **VS Code** dengan plugin Flutter.
* **Java JDK**: Versi 17 (Disarankan) atau 11.
* **Android SDK**: Command-line tools dan Build-tools terinstall.

## 🚀 Cara Setup Project (How to Setup)

Ikuti langkah ini setelah melakukan *clone* repository:

1. **Install Dependencies**

    ```bash
    flutter pub get
    ```

2. **Generate Code (Isar & Mockito)**
    Project ini menggunakan `build_runner` untuk generate code database Isar.

    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3. **Setup Environment (Android)**
    Pastikan file `android/local.properties` (otomatis dibuat oleh Flutter/Android Studio) menunjuk ke lokasi SDK yang benar.
    *Biasanya, cukup buka project folder `android` di Android Studio, dan biarkan Gradle melakukan sync.*

## 📱 Cara Menjalankan (Run)

Koneksikan device Android (Physical Device atau Emulator API 24+), lalu jalankan:

```bash
flutter run
```

## 🛠️ Arsitektur & Struktur Folder

Lihat dokumen lengkap di folder [docs/](docs/).

* `docs/MASTER_ROADMAP.md`: Blueprint arsitektur dan timeline.

## 🤝 Panduan Partner (Contribution)

**Untuk Partner / Rekan Kerja:**
Silakan baca dokumen **[ONBOARDING_REKAN.md](ONBOARDING_REKAN.md)** untuk panduan lengkap setup dan workflow kerja.

### Hak Akses & Workflow

Partner memiliki akses **Read & Write** (Clone, Pull, Push).
Kita menggunakan metode **Direct Push** ke branch `main`.

**Aturan Emas (Golden Rule):**
> ⚠️ **WAJIB** melakukan `git pull origin main` sebelum mulai coding setiap hari untuk menghindari bentrok code.

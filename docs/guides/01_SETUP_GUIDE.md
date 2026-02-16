# 📦 PANDUAN SETUP DEVELOPMENT ENVIRONMENT

> **Target:** Developer yang baru pertama kali menjalankan project Flutter  
> **OS:** Windows 10/11  
> **Waktu Setup:** ~30-45 menit (tergantung kecepatan internet)

---

## 📋 DAFTAR ISI

1. [Prasyarat (Wajib Install)](#-prasyarat-wajib-install)
2. [Instalasi Flutter SDK](#-instalasi-flutter-sdk)
3. [Instalasi Android Studio & SDK](#-instalasi-android-studio--sdk)
4. [Setup USB Debugging pada HP Android](#-setup-usb-debugging-pada-hp-android)
5. [Clone & Jalankan Proyek](#-clone--jalankan-proyek)
6. [Pemecahan Masalah (Troubleshooting)](#-pemecahan-masalah-troubleshooting)

---

## 🔧 Prasyarat (Wajib Install)

### 1. Git

**Download:** <https://git-scm.com/download/win>

```powershell
# Verifikasi instalasi
git --version
# Output: git version 2.43.0.windows.1 (atau lebih baru)
```

### 2. Visual Studio Code (Rekomendasi IDE)

**Download:** <https://code.visualstudio.com/>

**Ekstensi yang WAJIB dipasang:**

| Ekstensi | Fungsi |
| :--- | :--- |
| **Flutter** | Dukungan bahasa Dart/Flutter |
| **Dart** | Dukungan bahasa Dart (biasanya auto-install dengan Flutter) |
| **Error Lens** | Menampilkan error langsung di baris kode |
| **GitLens** | Riwayat Git & anotasi blame |

### 3. PowerShell 7+ (Opsional tapi Direkomendasikan)

**Download:** <https://github.com/PowerShell/PowerShell/releases>

Windows 10/11 sudah punya PowerShell 5.1, tapi PowerShell 7 lebih modern.

---

## 🦋 Instalasi Flutter SDK

### Langkah 1: Download Flutter SDK

**Download:** <https://docs.flutter.dev/get-started/install/windows>

1. Download file `.zip` Flutter SDK (~1GB)
2. Ekstrak ke folder **TANPA SPASI**, contoh:

   ```
   C:\flutter
   ```

   > ⚠️ **JANGAN** ekstrak ke `C:\Program Files\` atau folder dengan spasi!

### Langkah 2: Tambahkan ke PATH

1. Buka **Start Menu** → Ketik `environment variables`
2. Klik **"Edit the system environment variables"**
3. Klik **"Environment Variables..."**
4. Di bagian **"User variables"**, cari `Path` → Klik **Edit**
5. Klik **New** → Tambahkan:

   ```
   C:\flutter\bin
   ```

6. Klik **OK** semua

### Langkah 3: Verifikasi Instalasi

Buka **PowerShell baru** (penting: harus terminal baru setelah edit PATH):

```powershell
flutter --version
```

Output yang diharapkan:

```
Flutter 3.x.x • channel stable • https://github.com/flutter/flutter.git
Framework • revision xxxxxxx
Engine • revision xxxxxxx
Tools • Dart 3.x.x • DevTools 2.x.x
```

---

## 📱 Instalasi Android Studio & SDK

### Langkah 1: Download Android Studio

**Download:** <https://developer.android.com/studio>

1. Install dengan opsi default
2. Buka Android Studio → **More Actions** → **SDK Manager**

### Langkah 2: Install Komponen Android SDK

Di **SDK Manager** → Tab **SDK Platforms**:

- [x] Android 14.0 (UpsideDownCake) - API 34
- [x] Android 13.0 (Tiramisu) - API 33
- [x] Android 7.0 (Nougat) - API 24 *(untuk kompatibilitas ke belakang)*

Di **SDK Manager** → Tab **SDK Tools**:

- [x] Android SDK Build-Tools 34.0.0
- [x] Android SDK Command-line Tools (terbaru)
- [x] Android SDK Platform-Tools
- [x] Android Emulator *(opsional jika pakai HP fisik)*
- [x] NDK (Side by side) - versi `27.0.12077973` *(PENTING untuk Isar)*

### Langkah 2b: Konfigurasi Media (Kamera)

Proyek ini menggunakan `image_picker` untuk pengambilan foto kegiatan (GANAS) dan bukti lembur.

**Izin di Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**Izin di iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi membutuhkan akses kamera untuk validasi presensi.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses galeri untuk unggah bukti pendukung.</string>
```

*(Sudah dikonfigurasi di proyek, namun wajib dipastikan jika menambahkan modul baru)*

### Langkah 3: Menyetujui Lisensi Android

```powershell
flutter doctor --android-licenses
```

Tekan `y` untuk semua perjanjian lisensi.

### Langkah 4: Verifikasi dengan Flutter Doctor

```powershell
flutter doctor -v
```

**Target Output:**

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Windows Version (Windows 10/11)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Chrome - develop for the web
[✓] Visual Studio Code (version 1.8x.x)
[✓] Connected device (1 available)
[✓] Network resources

• No issues found!
```

> ⚠️ Jika ada `[!]` atau `[✗]`, ikuti instruksi yang diberikan oleh `flutter doctor`.

---

## 🔌 Setup USB Debugging pada HP Android

### Langkah 1: Aktifkan Opsi Pengembang (Developer Options)

1. Buka **Settings** → **About Phone**
2. Ketuk **Build Number** sebanyak **7 kali** berturut-turut
3. Akan muncul toast: *"You are now a developer!"* (Anda sekarang pengembang!)

### Langkah 2: Aktifkan USB Debugging

1. Kembali ke **Settings** → **Developer Options** (biasanya di paling bawah)
2. Aktifkan slider:
   - [x] **USB Debugging**
   - [x] **Install via USB** *(jika ada)*
   - [x] **USB debugging (Security settings)** *(untuk Xiaomi/Redmi)*

### Langkah 3: Hubungkan HP ke Laptop

1. Hubungkan HP dengan kabel USB
2. Pilih mode **"File Transfer / MTP"** (bukan Charging Only)
3. Akan muncul dialog **"Allow USB debugging?"** → Centang **"Always allow"** → **OK**

### Langkah 4: Verifikasi Koneksi

```powershell
# Cek device terdeteksi oleh ADB
adb devices
```

Output yang diharapkan:

```
List of devices attached
XXXXXXXX     device
```

> ⚠️ Jika muncul `unauthorized`, cabut kabel USB, matikan USB Debugging, nyalakan ulang, dan hubungkan lagi.

```powershell
# Cek device terdeteksi oleh Flutter
flutter devices
```

Output:

```
2 connected devices:

CPH2059 (mobile) • 206cd0d0 • android-arm64 • Android 13 (API 33)
Chrome (web)     • chrome   • web-javascript • Google Chrome 120.x
```

---

## 🚀 Clone & Jalankan Proyek

### Langkah 1: Clone Repository

```powershell
cd D:\
git clone <repository-url> seagma_presensi
cd seagma_presensi
```

### Langkah 2: Install Dependensi

```powershell
# Download semua paket dari pubspec.yaml
flutter pub get
```

### Langkah 3: Generate Isar Schema (PENTING!)

Proyek ini menggunakan **Isar Database** yang perlu pembuatan kode otomatis (code generation):

```powershell
# Generate file .g.dart untuk model Isar
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ Jika ada perubahan pada file di `lib/data/models/*.dart`, jalankan ulang perintah ini!

### Langkah 4: Jalankan Aplikasi

```powershell
# List semua device yang tersedia
flutter devices

# Jalankan di HP Android (ganti ID device sesuai output flutter devices)
flutter run -d 206cd0d0

# ATAU jalankan di Chrome untuk tes cepat
flutter run -d chrome
```

### Langkah 5: Hot Reload & Hot Restart

Saat aplikasi berjalan:

- Tekan `r` → **Hot Reload** (Update UI tanpa restart)
- Tekan `R` → **Hot Restart** (Restart penuh dengan reset state)
- Tekan `q` → **Quit** (Hentikan aplikasi)

---

## 🧹 Perintah Penting Lainnya

```powershell
# Bersihkan cache build (jika ada masalah build)
flutter clean

# Rebuild penuh setelah clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d <device-id>

# Build APK untuk testing
flutter build apk --debug

# Build APK untuk produksi
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Analisis kode untuk error/warning
flutter analyze
```

---

## 🔥 Pemecahan Masalah (Troubleshooting)

### Masalah: Perintah `flutter` tidak ditemukan

**Solusi:** Pastikan `C:\flutter\bin` sudah ditambahkan ke PATH dan buka terminal BARU.

---

### Masalah: `adb devices` menampilkan `unauthorized`

**Solusi:**

1. Di HP, buka **Settings** → **Developer Options**
2. Klik **Revoke USB debugging authorizations**
3. Cabut kabel USB
4. Hubungkan kembali dan izinkan debugging lagi

---

### Masalah: `Gradle build failed` atau `NDK not found`

**Solusi:**

```powershell
# Install NDK yang benar
# Buka Android Studio → SDK Manager → SDK Tools → NDK (Side by side)
# Install versi 27.0.12077973
```

Atau tambahkan di `android/app/build.gradle.kts`:

```kotlin
android {
    ndkVersion = "27.0.12077973"
}
```

---

### Masalah: Error `Isar` saat runtime

**Solusi:**

```powershell
# Regenerate Isar schema
dart run build_runner build --delete-conflicting-outputs

# Jika masih error, clean dulu
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

### Masalah: HP tidak terdeteksi di `flutter devices`

**Daftar Periksa:**

1. [ ] USB Debugging sudah ON?
2. [ ] Kabel USB mendukung transfer data (bukan kabel charging only)?
3. [ ] Mode USB = File Transfer / MTP?
4. [ ] Driver ADB sudah terinstall? (biasanya auto-install dari Android Studio)

Jika masih tidak terdeteksi:

```powershell
# Restart ADB server
adb kill-server
adb start-server
adb devices
```

---

## 📚 Referensi Tambahan

| Sumber | Tautan |
| :--- | :--- |
| Dokumentasi Flutter | <https://docs.flutter.dev> |
| Dokumentasi Dart | <https://dart.dev/guides> |
| Dokumentasi GetX | <https://pub.dev/packages/get> |
| Dokumentasi Isar | <https://isar.dev> |
| Dokumentasi PocketBase | <https://pocketbase.io/docs> |

---

> **Pertanyaan atau masalah?** Hubungi Lead Developer atau buka issue di repository.

> **Target:** Developer yang baru pertama kali menjalankan project Flutter  
> **OS:** Windows 10/11  
> **Waktu Setup:** ~30-45 menit (tergantung kecepatan internet)

---

## 📋 DAFTAR ISI

1. [Prerequisites (Wajib Install)](#-prerequisites-wajib-install)
2. [Instalasi Flutter SDK](#-instalasi-flutter-sdk)
3. [Instalasi Android Studio & SDK](#-instalasi-android-studio--sdk)
4. [Setup USB Debugging pada HP Android](#-setup-usb-debugging-pada-hp-android)
5. [Clone & Jalankan Project](#-clone--jalankan-project)
6. [Troubleshooting](#-troubleshooting)

---

## 🔧 Prerequisites (Wajib Install)

### 1. Git

**Download:** <https://git-scm.com/download/win>

```powershell
# Verifikasi instalasi
git --version
# Output: git version 2.43.0.windows.1 (atau lebih baru)
```

### 2. Visual Studio Code (Recommended IDE)

**Download:** <https://code.visualstudio.com/>

**Extensions yang WAJIB dipasang:**

| Extension | Fungsi |
| :--- | :--- |
| **Flutter** | Dart/Flutter language support |
| **Dart** | Dart language support (biasanya auto-install dengan Flutter) |
| **Error Lens** | Menampilkan error langsung di baris kode |
| **GitLens** | Git history & blame annotations |

### 3. PowerShell 7+ (Optional tapi Recommended)

**Download:** <https://github.com/PowerShell/PowerShell/releases>

Windows 10/11 sudah punya PowerShell 5.1, tapi PowerShell 7 lebih modern.

---

## 🦋 Instalasi Flutter SDK

### Step 1: Download Flutter SDK

**Download:** <https://docs.flutter.dev/get-started/install/windows>

1. Download file `.zip` Flutter SDK (~1GB)
2. Extract ke folder **TANPA SPASI**, contoh:

   ```
   C:\flutter
   ```

   > ⚠️ **JANGAN** extract ke `C:\Program Files\` atau folder dengan spasi!

### Step 2: Tambahkan ke PATH

1. Buka **Start Menu** → Ketik `environment variables`
2. Klik **"Edit the system environment variables"**
3. Klik **"Environment Variables..."**
4. Di bagian **"User variables"**, cari `Path` → Klik **Edit**
5. Klik **New** → Tambahkan:

   ```
   C:\flutter\bin
   ```

6. Klik **OK** semua

### Step 3: Verifikasi Instalasi

Buka **PowerShell baru** (penting: harus terminal baru setelah edit PATH):

```powershell
flutter --version
```

Output yang diharapkan:

```
Flutter 3.x.x • channel stable • https://github.com/flutter/flutter.git
Framework • revision xxxxxxx
Engine • revision xxxxxxx
Tools • Dart 3.x.x • DevTools 2.x.x
```

---

## 📱 Instalasi Android Studio & SDK

### Step 1: Download Android Studio

**Download:** <https://developer.android.com/studio>

1. Install dengan opsi default
2. Buka Android Studio → **More Actions** → **SDK Manager**

### Step 2: Install Android SDK Components

Di **SDK Manager** → Tab **SDK Platforms**:

- [x] Android 14.0 (UpsideDownCake) - API 34
- [x] Android 13.0 (Tiramisu) - API 33
- [x] Android 7.0 (Nougat) - API 24 *(untuk backward compatibility)*

Di **SDK Manager** → Tab **SDK Tools**:

- [x] Android SDK Build-Tools 34.0.0
- [x] Android SDK Command-line Tools (latest)
- [x] Android SDK Platform-Tools
- [x] Android Emulator *(optional jika pakai HP fisik)*
- [x] NDK (Side by side) - versi `27.0.12077973` *(PENTING untuk Isar)*

### Step 2b: Konfigurasi Media (Kamera)

Project ini menggunakan `image_picker` untuk pengambilan foto kegiatan (GANAS) dan bukti lembur.

**Izin di Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**Izin di iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi membutuhkan akses kamera untuk validasi presensi.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses galeri untuk unggah bukti pendukung.</string>
```

*(Sudah dikonfigurasi di project, namun wajib dipastikan jika menambahkan modul baru)*

### Step 3: Accept Android Licenses

```powershell
flutter doctor --android-licenses
```

Tekan `y` untuk semua license agreements.

### Step 4: Verifikasi dengan Flutter Doctor

```powershell
flutter doctor -v
```

**Target Output:**

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Windows Version (Windows 10/11)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Chrome - develop for the web
[✓] Visual Studio Code (version 1.8x.x)
[✓] Connected device (1 available)
[✓] Network resources

• No issues found!
```

> ⚠️ Jika ada `[!]` atau `[✗]`, ikuti instruksi yang diberikan oleh `flutter doctor`.

---

## 🔌 Setup USB Debugging pada HP Android

### Step 1: Aktifkan Developer Options

1. Buka **Settings** → **About Phone**
2. Ketuk **Build Number** sebanyak **7 kali** berturut-turut
3. Akan muncul toast: *"You are now a developer!"*

### Step 2: Aktifkan USB Debugging

1. Kembali ke **Settings** → **Developer Options** (biasanya di paling bawah)
2. Aktifkan toggle:
   - [x] **USB Debugging**
   - [x] **Install via USB** *(jika ada)*
   - [x] **USB debugging (Security settings)** *(untuk Xiaomi/Redmi)*

### Step 3: Hubungkan HP ke Laptop

1. Hubungkan HP dengan kabel USB
2. Pilih mode **"File Transfer / MTP"** (bukan Charging Only)
3. Akan muncul dialog **"Allow USB debugging?"** → Centang **"Always allow"** → **OK**

### Step 4: Verifikasi Koneksi

```powershell
# Cek device terdeteksi oleh ADB
adb devices
```

Output yang diharapkan:

```
List of devices attached
XXXXXXXX     device
```

> ⚠️ Jika muncul `unauthorized`, cabut kabel USB, matikan USB Debugging, nyalakan ulang, dan hubungkan lagi.

```powershell
# Cek device terdeteksi oleh Flutter
flutter devices
```

Output:

```
2 connected devices:

CPH2059 (mobile) • 206cd0d0 • android-arm64 • Android 13 (API 33)
Chrome (web)     • chrome   • web-javascript • Google Chrome 120.x
```

---

## 🚀 Clone & Jalankan Project

### Step 1: Clone Repository

```powershell
cd D:\
git clone <repository-url> seagma_presensi
cd seagma_presensi
```

### Step 2: Install Dependencies

```powershell
# Download semua package dari pubspec.yaml
flutter pub get
```

### Step 3: Generate Isar Schema (PENTING!)

Project ini menggunakan **Isar Database** yang perlu code generation:

```powershell
# Generate file .g.dart untuk Isar models
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ Jika ada perubahan pada file di `lib/data/models/*.dart`, jalankan ulang command ini!

### Step 4: Jalankan Aplikasi

```powershell
# List semua device yang tersedia
flutter devices

# Jalankan di HP Android (ganti ID device sesuai output flutter devices)
flutter run -d 206cd0d0

# ATAU jalankan di Chrome untuk quick test
flutter run -d chrome
```

### Step 5: Hot Reload & Hot Restart

Saat aplikasi berjalan:

- Tekan `r` → **Hot Reload** (UI update tanpa restart)
- Tekan `R` → **Hot Restart** (Full restart dengan state reset)
- Tekan `q` → **Quit** (Stop aplikasi)

---

## 🧹 Command Penting Lainnya

```powershell
# Bersihkan build cache (jika ada masalah build)
flutter clean

# Full rebuild setelah clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d <device-id>

# Build APK untuk testing
flutter build apk --debug

# Build APK untuk production
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Analyze code untuk error/warning
flutter analyze
```

---

## 🔥 Troubleshooting

### Problem: `flutter` command not found

**Solusi:** Pastikan `C:\flutter\bin` sudah ditambahkan ke PATH dan buka terminal BARU.

---

### Problem: `adb devices` shows `unauthorized`

**Solusi:**

1. Di HP, buka **Settings** → **Developer Options**
2. Klik **Revoke USB debugging authorizations**
3. Cabut kabel USB
4. Reconnect dan allow debugging lagi

---

### Problem: `Gradle build failed` atau `NDK not found`

**Solusi:**

```powershell
# Install NDK yang benar
# Buka Android Studio → SDK Manager → SDK Tools → NDK (Side by side)
# Install versi 27.0.12077973
```

Atau tambahkan di `android/app/build.gradle.kts`:

```kotlin
android {
    ndkVersion = "27.0.12077973"
}
```

---

### Problem: `Isar` error saat runtime

**Solusi:**

```powershell
# Regenerate Isar schema
dart run build_runner build --delete-conflicting-outputs

# Jika masih error, clean dulu
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

### Problem: HP tidak terdeteksi di `flutter devices`

**Checklist:**

1. [ ] USB Debugging sudah ON?
2. [ ] Kabel USB support data transfer? (bukan charging only cable)
3. [ ] Mode USB = File Transfer / MTP?
4. [ ] Driver ADB sudah terinstall? (biasanya auto-install dari Android Studio)

Jika masih tidak terdeteksi:

```powershell
# Restart ADB server
adb kill-server
adb start-server
adb devices
```

---

## 📚 Referensi Tambahan

| Resource | Link |
| :--- | :--- |
| Flutter Docs | <https://docs.flutter.dev> |
| Dart Docs | <https://dart.dev/guides> |
| GetX Documentation | <https://pub.dev/packages/get> |
| Isar Documentation | <https://isar.dev> |
| PocketBase Docs | <https://pocketbase.io/docs> |

---

> **Pertanyaan atau masalah?** Hubungi Lead Developer atau buka issue di repository.

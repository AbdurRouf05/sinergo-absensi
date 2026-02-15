# Jurnal Teknik: Log Integrasi Absensi Minggu 2
**Tanggal:** 31-01-2026
**Topik:** Menyelesaikan "Neraka Integrasi" - Debugging Modul Absensi
**Penulis:** Antigravity (Assistant) & User (Lead Engineer)

---

## 🛑 Pernyataan Masalah
Selama integrasi Modul Absensi (Alur Check-In), kami menghadapi serangkaian kegagalan mulai dari masalah konektivitas hingga error runtime yang "senyap". Jurnal ini mencatat 6 insiden kritis yang diselesaikan untuk menstabilkan pipeline entri data.

---

## 🛠️ Log Insiden

### 1. Konektivitas (Localhost Loopback) 🐛
*   **Masalah:** Aplikasi gagal terhubung ke PocketBase (`SocketException: Connection refused`). Ini disebabkan `String.fromEnvironment` tidak membaca variabel `.env` tertentu dalam mode debug, menyebabkan fallback kembali ke `http://localhost:8090`.
*   **Dampak:** Emulator tidak dapat menjangkau backend karena `localhost` merujuk ke emulator itu sendiri, bukan mesin host.
*   **Perbaikan:**
    *   Mengganti `String.fromEnvironment` dengan `dotenv.env['POCKETBASE_URL']`.
    *   Mengaktifkan Developer Mode Windows untuk pembuatan symlink aset yang benar.
    *   Mengonfigurasi emulator untuk menggunakan `10.0.2.2` (alamat localhost host dari dalam emulator).

### 2. Skema Database (Lokasi Kantor) 🗄️
*   **Masalah:** Aplikasi menampilkan "Tidak Ada Lokasi Kantor" (No Office Location) meskipun sinkronisasi berjalan.
*   **Penyebab Dasar:** Koleksi `office_locations` di PocketBase kosong atau memiliki nama field yang tidak sesuai (misalnya, `hai`, bukan `name`).
*   **Perbaikan:**
    *   Mendefinisikan skema strict secara manual: `name`, `latitude`, `longitude`, `radius`.
    *   Mengubah nama field yang salah.
    *   **Keamanan:** Mengubah API Rules ke Publik (Unlock) sementara untuk memisahkan masalah izin dari masalah skema.

### 3. Android Manifest (Izin) 🔒
*   **Masalah:** Aplikasi langsung crash saat membuka layar Check-In dengan error `No location permissions are defined in the manifest`.
*   **Perbaikan:** Menambahkan izin berikut ke `android/app/src/main/AndroidManifest.xml`:
    *   `ACCESS_FINE_LOCATION`
    *   `ACCESS_COARSE_LOCATION`
    *   `ACCESS_BACKGROUND_LOCATION` (untuk sinkronisasi latar belakang di masa depan)

### 4. Masalah Dependensi (SDK 35 vs 36) 📦
*   **Masalah:** Build gagal/memberi peringatan karena dependensi (`geolocator`, `image_picker`) update otomatis ke versi yang membutuhkan Android SDK 36 (Android 16 Beta).
*   **Kendala:** Lingkungan kami mewajibkan stabilitas ketat pada Android 15 (SDK 35).
*   **Perbaikan:** Memaksa downgrade di `pubspec.yaml` untuk mengunci versi stabil:
    *   `geolocator: ^11.0.0`
    *   `image_picker: ^1.0.7`
    *   `path_provider: ^2.1.2`

### 5. Logika & Runtime (Keanehan Emulator) 🤖
*   **Masalah:** "Silent Failure" (Gagal tanpa pesan) saat menekan tombol Masuk Presensi. Tidak ada umpan balik, tidak ada navigasi.
*   **Penyebab Dasar 1 (NTP):** `TimeService` gagal sinkronisasi dengan `pool.ntp.org` karena emulator memblokir port NTP. Ini memicu `TimeoutException`.
*   **Penyebab Dasar 2 (Root):** `DeviceService` mendeteksi Emulator sebagai perangkat "Root", memblokir check-in demi keamanan.
*   **Perbaikan:**
    *   **NTP:** Memodifikasi `TimeService` untuk menangkap timeout dan fallback ke Waktu Perangkat (Safe Mode).
    *   **Root:** Menambahkan pengecekan `kDebugMode` untuk melewati deteksi root saat debugging.

### 6. Final "Crash & Typo" 💥
*   **Masalah 1 (Crash):** `Unhandled Exception: No Overlay widget found`.
    *   Terjadi saat `Get.snackbar` mencoba menampilkan pesan sukses. `GetX` kehilangan konteks layar akibat error sebelumnya atau state navigasi.
*   **Masalah 2 (Error 404 - Faktor "S"):** `ClientException: 404 Not Found`.
    *   Repository mengirim data ke `/api/collections/attendance/records` (Tunggal).
    *   Nama koleksi PocketBase yang sebenarnya adalah `attendances` (Jamak).
*   **Perbaikan:**
    *   **Anti-Crash:** Membungkus `_showSnackbar` dalam blok `try-catch` failsafe.
    *   **Safe Navigation:** Memprioritaskan Navigasi (`Get.offAllNamed`) *sebelum* menampilkan umpan balik UI.
    *   **Typo:** Mengoreksi string endpoint API menjadi `attendances`.

---

## ✅ Status Saat Ini
*   **Entri Data:** SUKSES. Data sekarang tervalidasi dengan benar, tersimpan di DB Isar lokal, dan tersinkronisasi ke PocketBase.
*   **Stabilitas:** Aplikasi menangani kondisi offline, sinyal lemah, dan lingkungan emulator tanpa crash.
*   **Langkah Selanjutnya:** Lanjut ke Minggu 3 (Panel Admin & Pelaporan).

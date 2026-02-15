# 🗺️ Peta Pengujian Manual QA - Modul Absensi

Dokumen ini adalah panduan langkah demi langkah untuk melakukan pengujian manual pada emulator atau perangkat riil. Gunakan peta ini untuk memvalidasi integrasi UI dengan logika "The Guardian" di `CheckinController`.

## 🛠️ Prasyarat

- Aplikasi sudah terinstal di Emulator (disarankan menggunakan Google APIs image).
- Akun user sudah login.
- Lokasi kantor sudah tersedia di database lokal (Isar).

---

## 🧪 Skenario 1: "The Magician" (Anti-Fraud GPS)

**Tujuan**: Memastikan pengguna tidak bisa melakukan absensi menggunakan aplikasi Mock GPS.

1. **Persiapan**: Instal aplikasi "Fake GPS" di emulator.
2. **Aktifkan**: Jalankan Fake GPS dan arahkan ke lokasi kantor.
3. **Langkah**:
   - Buka menu **Presensi**.
   - Tunggu hingga indikator GPS menyala.
   - Geser tombol **Slide to Check-In**.
4. **Ekspektasi**:
   - [ ] Muncul alert dialog: **"FRAUD DETECTED"**.
   - [ ] Data tidak tersimpan di database.
   - [ ] Muncul log di console: `FRAUD_ATTEMPT: Mock location detected!`.

---

## 🧪 Skenario 2: "The Runner" (Geofencing)

**Tujuan**: Memastikan pengguna hanya bisa absen di dalam radius kantor.

1. **Langkah (Luar Radius)**:
   - Set lokasi emulator ke jarak > 200m dari kantor.
   - Perhatikan indikator jarak di UI.
2. **Ekspektasi (Luar Radius)**:
   - [ ] Indikator status berwarna Merah/Kuning ("Di luar jangkauan").
   - [ ] Tombol **Slide to Check-In** non-aktif (Disabled).
3. **Langkah (Dalam Radius)**:
   - Set lokasi emulator ke titik koordinat kantor tepat (Radius < 100m).
4. **Ekspektasi (Dalam Radius)**:
   - [ ] Indikator status berubah menjadi Hijau ("Anda berada di area kantor").
   - [ ] Tombol **Slide to Check-In** menjadi aktif.

---

## 🧪 Skenario 3: "The Airplane" (Offline Resilience)

**Tujuan**: Memastikan absensi tetap tercatat meskipun internet mati.

1. **Langkah**:
   - Pastikan sudah berada di dalam radius kantor.
   - Matikan WiFi dan Data Seluler (Mode Pesawat).
   - Geser tombol **Slide to Check-In**.
2. **Ekspektasi**:
   - [ ] Muncul snackbar: **"Berhasil"** (Absensi dicatat lokal).
   - [ ] Status absensi tersimpan dengan `isSynced = false`.
3. **Langkah Lanjutan**:
   - Nyalakan kembali koneksi internet.
   - Cek log console atau Dashboard.
   - [ ] Background sync secara otomatis mengirim data ke server.

---

## 🧪 Skenario 4: "The Time Traveler" (Time Manipulation)

**Tujuan**: Memastikan pengguna tidak bisa mengakali jam perangkat.

1. **Langkah**:
   - Masuk ke Pengaturan Perangkat.
   - Ubah Jam secara manual menjadi lebih awal (misal: kembali ke jam 7 pagi).
   - Lakukan absensi.
2. **Ekspektasi**:
   - [ ] Sistem tetap menggunakan waktu dari NTP (server waktu) atau memblokir absensi.
   - [ ] Muncul alert: **"Waktu sistem terdeteksi dimanipulasi"**.

---

## 📝 Catatan Audit

| Skenario | Status | Catatan |
| :--- | :---: | :--- |
| The Magician | ⚪ | |
| The Runner | ⚪ | |
| The Airplane | ⚪ | |
| The Time Traveler | ⚪ | |

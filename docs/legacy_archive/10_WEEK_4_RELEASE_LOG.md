# MINGGU 4: PENGERASAN & ALAT ADMIN

> **Status:** 🏗️ DEVELOPMENT (Week 4 Focus)
> **Tanggal:** 06 Februari 2026
> **Versi:** 1.0.0+1 (Beta)
> **Maintainer:** SEAGMA Engineering Team

Dokumen ini adalah **SUMBER KEBENARAN TUNGGAL (SSOT)** untuk rilis produksi. Berisi kredensial rahasia, log perbaikan teknis, dan prosedur operasional standar (SOP) untuk admin.

---

## 1. 🔐 KREDENSIAL RAHASIA (SANGAT RAHASIA)

> [!CAUTION]
> **JANGAN PERNAH MENGHILANGKAN FILE KEYSTORE `upload-keystore.jks`.**
> Jika file ini hilang, kita **TIDAK AKAN BISA** mengupdate aplikasi di Google Play Store selamanya. Tidak ada cara recovery. Backup file ini ke Google Drive perusahaan dan Email Founder.

* **Keystore File:** `android/app/upload-keystore.jks`
* **Key Properties:** `android/key.properties` (Excluded from Git)
* **Key Alias:** `upload`
* **Password Brankas:** `S3agmaPresensi2026!`
* **Validity:** 25 Years (Hingga 2051)
* **Status Sertifikat:** Metadata (Nama/Kota) diisi data dummy/generik demi privasi, namun valid secara kriptografi untuk upload Play Store.

---

## 2. ⚔️ LOG PERTEMPURAN TEKNIS (WAR LOG)

Berikut adalah rekapitulasi masalah kritis yang dihadapi saat build produksi dan solusinya. Gunakan ini sebagai referensi jika harus melakukan setup ulang environment di masa depan.

### A. Gradle AGP 8.5 Namespace Error
*   **Masalah:** Library `isar_flutter_libs` v3.1.0 gagal build di AGP 8+ karena tidak mendefinisikan `namespace`. Error: `Namespace not specified`.
*   **Solusi:** "Nuclear Fix" di `android/build.gradle.kts` (Root). Script secara dinamis menginjeksi namespace `dev.isar.isar_flutter_libs` ke library tersebut menggunakan Reflection saat fase konfigurasi Gradle.

### B. Crash Android 12+ (lStar Issue)
*   **Masalah:** Aplikasi crash saat startup di Android 14/15 dengan error `failed to verify byte code... lStar`.
*   **Penyebab:** Konflik dependensi `androidx.core` versi lama (1.6.0) yang dibawa oleh library pihak ketiga, tidak kompatibel dengan SDK 34.
*   **Solusi:**
    1.  **Force Resolution:** Memaksa penggunaan `androidx.core:1.13.1` (Stable) di seluruh project via `resolutionStrategy`.
    2.  **Force CompileSDK:** Menggunakan Reflection di `subprojects {}` untuk memaksa semua modul library dicompile ulang dengan `compileSdk = 34`.

### C. Enkripsi Database Lokal (Technical Debt)
*   **Status:** 🔴 **DINONAKTIFKAN (DEFERRED)**
*   **Masalah:** Parameter `encryptionKey` pada method `Isar.open()` tidak dikenali oleh Analyzer/Compiler Dart, menyebabkan build error: `No named parameter with the name 'encryptionKey'`.
*   **Analisis:** Kemungkinan bug pada `isar_flutter_libs` v3.1.0+1 atau masalah resolusi platform (terdeteksi sebagai Web/Generic).
*   **Tindakan:** Baris kode enkripsi di `IsarService` telah di-comment sementara agar aplikasi bisa rilis tepat waktu.
*   **Rencana:** Isu ini dicatat sebagai **High Priority Technical Debt** (Lihat `docs/08_TECHNICAL_DEBT.md`) untuk diperbaiki pada Rilis v1.1.0 (Menunggu Isar v4 Stable).

---

## 3. 🛡️ AUDIT KEAMANAN SERVER (POCKETBASE)

Konfigurasi API Rules berikut **WAJIB** dipertahankan untuk mencegah manipulasi data absensi (Fraud) dan akses ilegal.

### Collection: `attendances`
| Aksi | API Rule (Aturan) | Efek Keamanan |
| :--- | :--- | :--- |
| **View/List** | `employee = @request.auth.id` | User hanya bisa melihat data absensi mereka sendiri. |
| **Create** | `employee = @request.auth.id && @request.auth.id != ""` | **Anti-Joki.** Mencegah user mengirim absen atas nama orang lain. |
| **Update** | `id = "JANGAN_KOSONG"` (Kosongkan) | **IMMUTABLE.** Data absen yang sudah masuk TIDAK BISA diedit oleh user. |
| **Delete** | `id = "JANGAN_KOSONG"` (Kosongkan) | **PERMANENT.** User tidak bisa menghapus history (misal: menghapus jejak telat). |

### Collection: `users`
*   **Create:** Administrator Only (Kosongkan Rule). Mencegah registrasi akun liar tanpa sepengetahuan HR.
*   **Update:** `id = @request.auth.id` (User hanya bisa edit profil sendiri).

---

## 4. 🚀 FEATURE UPDATE: WEEK 4 - MANAGEMENT CENTER

### C. Smart Location & Distance Locking
*   **Auto-Select:** Aplikasi otomatis mendeteksi kantor terdekat berdasarkan GPS dan mengunci pilihan di dropdown.
*   **Allowed Offices:** Validasi ketat hanya mengizinkan check-in pada daftar kantor yang diberikan akses oleh Admin.
*   **Radius Locking:** Tombol check-in hanya aktif jika user berada di dalam radius kantor yang dipilih.

### D. Admin Broadcast System
*   **Instant Communication:** Admin dapat mengirim pengumuman global ke seluruh karyawan atau spesifik per departemen.
*   **Inbox Integration:** Pengumuman otomatis muncul di bilah notifikasi aplikasi karyawan dan tersimpan di Inbox Lokal.
*   **Offline Resilience:** Pengumuman dikirim via Sync Queue, menjamin pengiriman tetap terjadi meski koneksi Admin terputus saat "Send".

---

## 5. 📋 SOP OPERASIONAL ADMIN (MANUAL)

### PROSEDUR: Ganti HP Karyawan (Reset Device ID)
**Situasi:** Karyawan kehilangan HP, HP rusak, atau membeli HP baru. Saat mencoba login di HP baru, aplikasi menolak dengan pesan error "Device Mismatch" atau "Log Out Dulu".

**Langkah Penanganan (Via Aplikasi - REKOMENDASI):**

1. Login sebagai Admin di aplikasi Seagma.
2. Buka Menu **Admin** → Pilih **"Kelola Karyawan"**.
3. Cari nama karyawan dan tap untuk masuk ke Detail.
4. Klik tombol **"Reset Device"** (Warna Merah).
5. Konfirmasi Dialog. Selesai.

**Langkah Penanganan (Via PocketBase Dashboard - ALTERNATIF):**

1.  Login ke **PocketBase Admin Dashboard** (via Browser).
2.  Buka menu **Collections** (Kiri) > Pilih **users**.
3.  Cari nama karyawan, klik **Edit**.
4.  Cari kolom `registered_device_id` dan **KOSONGKAN**.
5.  Klik **Save Changes**.

---

### PROSEDUR: Update Akses Multi-Office
1. Buka Menu **Admin** → **Kelola Karyawan** → **[Nama Karyawan]**.
2. Pada bagian **"Akses Kantor"**, centang semua lokasi yang diizinkan.
3. Klik **"Simpan Perubahan"**. Perubahan akan sinkron otomatis ke HP karyawan saat mereka online.

---

**End of Release Log.**

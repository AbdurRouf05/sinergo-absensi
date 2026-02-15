# Jurnal Engineering: Sprint Completion Log (User App)

**Tanggal:** 03 Februari 2026
**Penulis:** Senior Project Manager & Lead Tech Writer
**Status:** ✅ USER APP COMPLETED
**Versi:** 1.0.1 (Beta)

---

## 1. 🏁 Rangkuman Eksekutif
Hari ini menandai **selesainya fase pengembangan Aplikasi User (Karyawan)**. Seluruh fitur utama yang direncanakan untuk sisi klien telah terimplementasi, teruji, dan siap untuk tahap UAT (User Acceptance Testing) internal.

Fokus sprint 48 jam terakhir adalah "Penyempurnaan UX dan Penutupan Celah Logika". Kami tidak hanya membangun fitur, tetapi juga memastikan aplikasi terasa responsif dan "memaafkan" kesalahan user.

## 2. 🌟 Fitur Utama yang Telah Selesai
Berikut adalah kapabilitas aplikasi versi 1.0.1:

1.  **Absensi Hybrid (The Guardian):** Validasi berlapis GPS + WiFi + Time + Mock Detection yang berjalan Offline-First.
2.  **Manajemen Shift Cerdas:** Tampilan shift aktif di Home & Profil, dengan deteksi otomatis status "Telat/Lembur".
3.  **Pengajuan Izin (GANAS Module):** Form pengajuan cuti/sakit dengan lampiran foto (Kamera/Galeri) dan feedback visual instan.
4.  **Keamanan Akun:** Fitur Ganti Password dengan validasi server-side dan UX navigasi yang aman.
5.  **Realtime Notifications:** Sistem notifikasi push (via PocketBase subscription) yang memberikan update instan kepada karyawan tanpa perlu pull-to-refresh.

## 3. 🛠️ Perbaikan UX & Kualitas Kode (Major Fixes)

Fokus utama perbaikan UX adalah menghilangkan "Silent Failures" dan "Ghost UI" (UI yang macet).

*   **Masalah UI Macet (Stuck):**
    *   *Sebelumnya:* Setelah submit form (Izin/Password), form tetap terbuka meski sukses, membuat user bingung dan mensubmit ulang (duplikasi).
    *   *Sekarang:* Implementasi pola `Feedback -> Delay (1s) -> Navigate Back -> Reset`. Halaman otomatis tertutup setelah sukses, dan form dibersihkan.

*   **Header & Navigasi:**
    *   Menghapus tombol Logout yang redundan di Header (dipindah ke Profil).
    *   Single source of notification entry (Lonceng di Header).
    *   Penyederhanaan menu "Cepat" di Home menjadi 2 item esensial (Riwayat & Pengajuan) untuk keseimbangan visual.

*   **Manajemen State:**
    *   Menggunakan `permanent: true` pada `NotificationController` untuk menjamin badge counter selalu hidup.
    *   Menghapus logika controller yang diinisialisasi berulang-ulang (LazyPut vs Put).

## 4. 📝 Langkah Selanjutnya (Next Steps)

Dengan selesainya modul User, fokus tim akan bergeser ke:

1.  **Backend & Admin Tools:** Membangun dashboard approval dan manajemen device reset.
2.  **Penetration Testing:** Mencoba menembus pertahanan "Guardian" (Fake GPS, Root, dll).
3.  **Distribusi:** Persiapan file `.apk` rilis dan distribusi internal.

---

## 5. 🛡️ Part 2: Critical Bug Fixes & Admin Module Stabilization (Update Sore)

**Status:** All Critical Bugs Resolved (History, Leave, Admin Approval).

### 1. MODUL HISTORY & ATTENDANCE (Fixed)
*   **Masalah:** Aplikasi crash saat sinkronisasi history (`FormatException`) dan tombol sukses dialog macet.
*   **Solusi:**
    *   **Safe Parsing:** Mengganti `DateTime.parse` mentah dengan `tryParse` pada `HistoryController`.
    *   **Schema Mapping:** Menyesuaikan mapping field database (`created` untuk check-in, `out_time` untuk check-out).
    *   **UI UX:** Menambahkan `Get.back()` pada tombol "OK" di dialog sukses absen agar tidak stuck.

### 2. MODUL PENGAJUAN IZIN / LEAVE (Fixed)
*   **Masalah:** Data masuk ke database dengan `user_id = N/A` (Kosong), menyebabkan error saat Admin mencoba membukanya.
*   **Solusi:**
    *   **Force User ID:** Memodifikasi `LeaveRepository` untuk menyuntikkan `pb.authStore.model.id` secara paksa ke dalam body request, memastikan relasi user selalu terisi.

### 3. INFRASTRUKTUR POCKETBASE (Configured)
*   **Masalah:** Error 400 (Bad Request) saat Admin melakukan fetching dan expanding data user.
*   **Solusi:**
    *   **Unlock API Rules:** Mengubah rule pada collection `leave_requests` dan `users` dari Kosong/SuperuserOnly menjadi `@request.auth.id != ""` (Authenticated Users Only).
    *   **Field Type Check:** Memastikan field `user_id` bertipe Relation.

### 4. MODUL ADMIN DASHBOARD & APPROVAL (Refactored & Fixed)
*   **Masalah:** Fetching error 400, Infinite Loading saat approve/reject, dan tombol "Batal" melempar user keluar dari halaman.
*   **Solusi:**
    *   **Controller Rewrite:** Menulis ulang struktur `AdminController` agar rapi dan bebas syntax error.
    *   **Fetch Logic:** Memperbaiki sintaks filter (`status='pending'`) dan mengaktifkan `expand='user_id'` setelah API Rule dibuka.
    *   **Action Logic:** Menambahkan `Get.back()` setelah proses await (approve/reject) agar loading tertutup otomatis.
    *   **Navigation Fix:** Mengunci tombol "Batal" agar hanya menutup dialog (`Get.back()`) tanpa memindahkan user dari halaman list.

---

> *"Aplikasi presensi bukan hanya tentang mencatat waktu, tapi tentang memberikan rasa percaya dan kemudahan bagi karyawan setiap pagi."* - Engineering Team

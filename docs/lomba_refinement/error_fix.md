# 🛠️ Log Perbaikan Error (Refinement Phase)

Dokumen ini mencatat perbaikan bug dan error yang telah diselesaikan selama fase penyempurnaan aplikasi sebelum lomba.

## 1. Modul Manajemen Karyawan (Add Employee)

- **Status:** ✅ Selesai
- **Masalah:**
  - Tombol simpan tidak memberikan feedback.
  - Error PocketBase saat membuat user baru (`verified: true` ditolak).
  - Form tidak reset setelah simpan, menyulitkan input massal.
- **Solusi:**
  - Mengganti `Snackbar` dengan `Get.dialog` (AlertDialog) agar feedback lebih jelas.
  - Menghapus field `"verified": true` dari payload creation (karena restriksi PocketBase).
  - Menambahkan fungsi `_clearForm()` yang mereset text field tetapi mempertahankan dropdown (Kantor/Shift) untuk kemudahan input berulang.
  - Menambahkan "Golden Code" marker untuk mencegah regresi.

## 2. Modul Broadcast (Pengumuman)

- **Status:** ✅ Selesai
- **Masalah:**
  - Feedback hanya berupa snackbar yang cepat hilang.
  - Tidak ada validasi atau konfirmasi visual yang kuat.
- **Solusi:**
  - Implementasi `Get.dialog` untuk notifikasi Berhasil/Gagal.
  - Logika navigasi diperbaiki: Tutup Dialog -> Tutup Halaman -> Refresh Dashboard.

## 3. Modul Manajemen Posko (Office)

- **Status:** ✅ Selesai
- **Masalah:**
  - Error 404 saat menghapus Posko yang sudah tidak ada (crash/stuck).
  - Dialog konfirmasi macet.
- **Solusi:**
  - _Graceful Error Handling_ pada fungsi delete (404 dianggap sukses delete).
  - Standarisasi penggunaan `AlertDialog` di seluruh aksi CRUD Posko.

## 4. Modul Pengajuan Izin (Leave Request)

- **Status:** ✅ Selesai
- **Masalah:**
  - "Ping-pong" keyboard: Keyboard muncul-tutup berulang kali saat submit, mengganggu dialog.
  - Dialog pop-up tertumpuk.
- **Solusi:**
  - Menambahkan `FocusManager.instance.primaryFocus?.unfocus()` sebelum logic submit.
  - Memberi delay `300ms` agar keyboard tertutup sempurna sebelum dialog muncul.
  - Memastikan `Get.back()` dipanggil untuk menutup loading dialog sebelum sukses dialog muncul.

## 5. Modul Notifikasi

- **Status:** ✅ Selesai
- **Masalah:**
  - Dialog detail notifikasi macet (stuck).
  - Layout tombol "Tutup" miring ke kanan dan sulit dipencet.
- **Solusi:**
  - Mengganti `Get.defaultDialog` (yang sering bermasalah dengan stack) ke `Get.dialog(AlertDialog)`.
  - Mengatur `actionsAlignment: MainAxisAlignment.center` agar tombol Presisi di tengah.
  - Memperbesar ukuran touch target tombol "Tutup" (`width: 120`).

## 6. Dashboard (Status Hari Ini)

- **Status:** ✅ Selesai
- **Masalah:**
  - Jam "Check In" di Dashboard muncul `00:00` (UTC), sedangkan di Riwayat benar `07:00` (WIB).
- **Solusi:**
  - Refactoring `HomeSyncManager`.
  - Menambahkan konversi `.toLocal()` eksplisit saat memparsing data dari PocketBase dan sebelum formatting string tampilan.
  - Sinkronisasi data lokal (`Isar`) dipastikan menyimpan/menampilkan waktu lokal yang benar.

# 👤 Panduan Manajemen User (Admin)

> **Target Pembaca:** Administrator Sistem SEAGMA Presence
> **Akses:** PocketBase Admin Dashboard (`http://<server-url>/_/`)

---

## 📋 Daftar Isi

1. [Membuat Akun User Baru](#-membuat-akun-user-baru)
2. [Field yang Wajib Diisi](#-field-yang-wajib-diisi)
3. [Assign Shift ke User](#-assign-shift-ke-user)
4. [Reset Device ID](#-reset-device-id)
5. [Catatan Keamanan](#-catatan-keamanan)

---

## 🆕 Membuat Akun User Baru

### Langkah-langkah:

1. Buka **PocketBase Admin Dashboard** di browser:
   ```
   http://<server-url>/_/
   ```
2. Login dengan kredensial Admin.
3. Di sidebar kiri, klik collection **`users`**.
4. Klik tombol **"+ New record"** di pojok kanan atas.
5. Isi form sesuai panduan di bawah.
6. Klik **"Create"** untuk menyimpan.

---

## 📝 Field yang Wajib Diisi

| Field             | Tipe     | Keterangan                                      | Contoh                     |
|-------------------|----------|-------------------------------------------------|----------------------------|
| `email`           | Email    | Email unik untuk login. **WAJIB.**              | `budi@perusahaan.com`      |
| `password`        | Password | Minimal 8 karakter. **WAJIB.**                  | `Password123!`             |
| `passwordConfirm` | Password | Harus sama dengan `password`. **WAJIB.**        | `Password123!`             |
| `name`            | Text     | Nama lengkap karyawan. **WAJIB.**               | `Budi Santoso`             |
| `assigned_shift`  | Relation | Pilih shift kerja dari collection `shifts`.     | (Pilih dari dropdown)      |
| `registered_device_id` | Text     | **Kosongkan.** Akan terisi otomatis saat login pertama di HP. | (Biarkan kosong) |

> [!NOTE]
> Field `role` akan terisi otomatis dengan nilai `user` (karyawan biasa).
> Untuk mengubah user menjadi Admin, ubah nilai `role` menjadi `admin` langsung di database.

---

## ⏰ Assign Shift ke User

Sebelum membuat user, pastikan data shift sudah tersedia di collection `shifts`.

### Cara Assign Shift:

1. Saat membuat user baru, klik field **`assigned_shift`**.
2. Akan muncul dropdown berisi daftar shift yang tersedia.
3. Pilih shift yang sesuai (contoh: "Shift Pagi", "Shift Siang").
4. Simpan user.

### Jika Shift Belum Ada:

1. Buka collection **`shifts`**.
2. Klik **"+ New record"**.
3. Isi:
   - `name`: Nama shift (contoh: "Shift Pagi")
   - `start_time`: Jam masuk (contoh: `08:00`)
   - `end_time`: Jam pulang (contoh: `17:00`)
   - `work_days`: Hari kerja (contoh: `senin,selasa,rabu,kamis,jumat`)
4. Simpan, lalu kembali ke pembuatan user.

---

## 🏢 Multi-Office Assignment

Sekarang Admin bisa memberikan akses ke beberapa kantor sekaligus untuk satu karyawan.

### Cara Mengatur Akses:

1. Di Aplikasi, buka menu **Admin** → **Kelola Karyawan**.
2. Klik pada nama karyawan yang ingin diubah.
3. Pada halaman **Detail Karyawan**, cari bagian **Akses Kantor (Multi-Office)**.
4. Centang semua kantor yang boleh dikunjungi karyawan tersebut.
5. Klik **"Simpan Perubahan"**.

> [!IMPORTANT]
> Jika tidak ada kantor yang dipilih, aplikasi akan secara otomatis membatasi user hanya pada kantor utamanya (field `office_id` di database).

---

## 🔄 Reset Device ID

Fitur ini digunakan jika karyawan **ganti HP baru** dan tidak bisa login karena Device ID lama masih terikat.

### Via Aplikasi (Admin Menu):

1. Login sebagai Admin di aplikasi.
2. Buka menu **Admin** → **Kelola Karyawan**.
3. Cari nama karyawan.
4. Tekan tombol **"Reset Device"**.
5. Konfirmasi. Karyawan kini bisa login di HP baru.

### Via PocketBase Dashboard:

1. Buka collection **`users`**.
2. Cari dan klik record user yang ingin di-reset.
3. Kosongkan field **`registered_device_id`** (hapus isinya).
4. Klik **"Save"**.

---

## 📢 Broadcast Pengumuman

Admin dapat mengirimkan pesan massal ke seluruh karyawan atau departemen tertentu.

### Cara Kirim Broadcast:

1. Di Aplikasi, buka menu **Admin**.
2. Klik menu **"Broadcast Pengumuman"** (Icon Megaphone/Orange).
3. Pilih **Target Penerima** (Semua / IT / HR / dll).
4. Isi **Judul** dan **Pesan**.
5. Klik **"Kirim Sekarang"**.

> [!TIP]
> Pesan akan masuk ke menu **Notifikasi (Lonceng)** di aplikasi masing-masing karyawan secara real-time (atau saat mereka online).

---

## 🔐 Catatan Keamanan

| Aspek                  | Kebijakan                                                                 |
|------------------------|---------------------------------------------------------------------------|
| **Role Admin**         | Hanya bisa diubah langsung di database. Tidak ada UI untuk ini.           |
| **Device Binding**     | 1 akun = 1 HP. Jika login di HP lain tanpa reset, akan ditolak.           |
| **Password Policy**    | Minimal 8 karakter. Disarankan kombinasi huruf, angka, dan simbol.        |
| **Audit Trail**        | Setiap perubahan di PocketBase tercatat di log server.                    |

---

> **Pertanyaan?** Hubungi Tim IT atau Lead Developer.

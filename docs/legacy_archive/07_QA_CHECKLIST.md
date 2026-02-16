# 🧪 Checklist QA Manual: Modul Absensi

Sebagai Senior QA Engineer, saya mewajibkan pengujian fisik berikut dilakukan pada perangkat Android untuk memvalidasi sistem "Guardian".

## 📱 Skenario Pengujian Perangkat

| ID | Nama Skenario | Tujuan | Langkah-langkah | Hasil yang Diharapkan | Hasil (L/G) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **QA-01** | **"Sang Penyulap"** | Mendeteksi Mock Location | 1. Install & aktifkan aplikasi "Fake GPS" (misal: Mock Locations).<br>2. Set lokasi ke kantor yang ditentukan.<br>3. Buka aplikasi Seagma Presensi.<br>4. Coba lakukan Check-In. | 🛑 Aplikasi harus menampilkan dialog **"Peringatan Kecurangan"**.<br>Check-In diblokir. | [ ] |
| **QA-02** | **"Mode Pesawat"** | Verifikasi Offline-First | 1. Pastikan Anda berada "Di Dalam Radius".<br>2. Nyalakan **Mode Pesawat** (WiFi & Data MATI).<br>3. Klik "CHECK-IN SEKARANG". | ✅ Pesan muncul: **"Berhasil dicatat secara lokal"**.<br>User kembali ke Home. | [ ] |
| **QA-03** | **"Sang Pelari"** | Persistensi Atomik | 1. Lakukan Check-In.<br>2. SEGERA tutup paksa (force-close) aplikasi dari recent apps.<br>3. Buka ulang aplikasi & cek "Riwayat". | ✅ Catatan ada di data lokal.<br>Tidak ada data hilang saat crash. | [ ] |
| **QA-04** | **"Penjelajah Waktu"** | Mendeteksi Manipulasi Waktu | 1. Ubah pengaturan Waktu Sistem ke **Manual**.<br>2. Ubah waktu mundur/maju 1 jam.<br>3. Coba lakukan Check-In. | 🛑 Aplikasi menampilkan error **"Waktu Dimanipulasi"**.<br>Check-In diblokir. | [ ] |
| **QA-05** | **"Sapaan Cerdas"** | Verifikasi Greeting System | 1. Buka halaman Home.<br>2. Cek teks sapaan (Pagi/Siang/Sore/Malam) sesuai waktu lokal perangkat. | ✅ Sapaan & emoji harus sesuai dengan jam perangkat (misal: 19:00 = Selamat Malam 🌙). | [ ] |
| **QA-06** | **"Anti-Freeze"** | Verifikasi UI Hardening | 1. Klik tombol "CHECK-IN SEKARANG" berkali-kali secara cepat (Double-tap). | ✅ Tombol hanya merespon 1x. State berubah menjadi loading/disabled selama proses validasi. | [ ] |
| **QA-07** | **"Admin Scout"** | Employee Directory Access | 1. Login sebagai Admin.<br>2. Akses menu Daftar Karyawan. | ✅ List karyawan muncul dari database lokal Isar.<br>Tampilan bersih & responsif. | [ ] |
| **QA-08** | **"Multi-Office Scout"** | Access Control Relasi | 1. Admin edit profil User A.<br>2. Centang Kantor Pusat & Cabang A.<br>3. Login sebagai User A.<br>4. Cek dropdown kantor. | ✅ Hanya Kantor Pusat & Cabang A yang muncul & bisa dipilih. | [ ] |
| **QA-09** | **"Smart Selector"** | GPS Auto-Select | 1. Berdiri di radius Kantor Pusat.<br>2. Buka layar Check-in. | ✅ Dropdown otomatis memilih "Kantor Pusat". | [ ] |
| **QA-10** | **"GANAS Warrior"** | Mode Tugas Luar | 1. Pilih "Tugas Luar / GANAS" di dropdown.<br>2. Klik Check-in. | ✅ Form keterangan & upload foto kegiatan muncul.<br>Check-in berhasil meski diluar radius. | [ ] |
| **QA-11** | **"Overtime Trap"** | Claim-Based Overtime | 1. Checkout > 60 menit dari jadwal pulang.<br>2. Klik "CHECK-OUT". | ✅ Popup "Apakah ini Lembur?" muncul.<br>Jika YA: Wajib isi form & bukti foto. | [ ] |
| **QA-12** | **"Tower Signal"** | Dynamic Outpost | 1. Admin buat "Titik Sementara".<br>2. User di radius 50m dari Admin mencoba absen. | ✅ User bisa absen menggunakan koordinat Admin sebagai jangkar. | [ ] |
| **QA-13** | **"Broadcast Echo"** | Broadcast System | 1. Admin kirim pengumuman ke semua user.<br>2. User cek Inbox/Lonceng. | ✅ Ada badge merah & pesan masuk di Inbox. | [ ] |
| **QA-14** | **"The Judge"** | Leave Approval Action | 1. Admin buka Tab Pending.<br>2. Klik "Setujui" atau "Tolak" pada satu izin. | ✅ Status berubah di Isar & antrian Sync bertambah. UI tab lain terupdate. | [ ] |
| **QA-15** | **"Mercy Reason"** | Rejection Sync | 1. Admin "Tolak" izin dengan alasan "Kebutuhan Kantor".<br>2. Cek database PocketBase (setelah sync). | ✅ Kolom `rejection_reason` di PocketBase terisi "Kebutuhan Kantor". | [ ] |

## 🛠️ Data Verifikasi (Isar)
Setelah melakukan tes, verifikasi state lokal menggunakan Isar Inspector (jika tersedia) atau dengan memeriksa layar Riwayat:
- [ ] Record ID ada.
- [ ] `is_synced` bernilai `false` jika dilakukan saat offline.
- [ ] `is_mocked` tercatat (jika berlaku).
- [ ] `allowedOfficeIds` pada `UserLocal` sesuai dengan setting Admin.

---
> [!IMPORTANT]
> Kegagalan pada **QA-01**, **QA-04**, atau **QA-10** (tanpa foto) adalah **PELANGGARAN KEAMANAN**. Jangan deploy ke staging jika tes ini gagal.

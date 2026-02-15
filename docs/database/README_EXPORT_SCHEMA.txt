[PENTING] MANUAL ACTION REQUIRED

Silakan export schema PocketBase Anda sekarang untuk backup keamanan sebelum masuk ke Week 4.

Langkah-langkah:
1. Buka PocketBase Admin Dashboard (http://127.0.0.1:8090/_/).
2. Masuk ke menu **Settings** > **Export collections**.
3. Klik tombol **Download as JSON**.
4. Simpan file tersebut di folder ini dengan nama: `pb_schema.json`.
   (Path: `docs/database/pb_schema.json`)


File ini akan menjadi titik restore (System Restore Point) jika terjadi kesalahan konfigurasi fatal di masa depan.

[UPDATE 03 FEB 2026]
PENTING: Segera lakukan export ulang! Schema telah berubah signifikan dengan penambahan:
1. Koleksi `leave_requests` (Baru).
2. Perbaikan field pada koleksi `notifications`.
Jangan gunakan schema lama untuk restore!

   
# Engineering Journal: Drama Error 400 & Invalid Sort Field

**Tanggal:** 8 Februari 2026
**Penulis:** Antigravity (AI Assistant) & User

---

## 🤯 Problem Statement (Pusing Bgt)

Hari ini kita menghabiskan waktu berjam-jam mencoba memperbaiki satu masalah di fitur Admin Approval Izin:
**Data tidak muncul. List kosong. Error 400 Bad Request.**

Setiap kali kita mencoba fetch data dari PocketBase, server menolak dengan kode 400. Log di terminal Flutter hanya bilang "Something went wrong".

## 🕵️‍♂️ Investigasi & Percobaan

### 1. Tersangka Awal: Filter Param

Awalnya kita menduga query filter yang terlalu kompleks (menggunakan `expand` dan `filter` sekaligus) ditolak server.

**Solusi 1: Trawl Net Strategy**
Kita menghapus semua filter di server (`filter: ''`) dan mencoba mengambil semua data mentah, lalu filter di aplikasi (client-side).
**Hasil:** Masih Error 400. ❌

### 2. Tersangka Kedua: Expand Param

Kemudian kita curiga parameter `expand: 'user_id'` yang bermasalah (mungkin karena API Rules di collection Users).

**Solusi 2: Manual Join Strategy**
Kita menghapus `expand`. Kita fetch 2 kali:

1. Fetch Leave Requests (Murni)
2. Fetch All Users
3. Gabungkan nama user secara manual di Dart (`userMap`).
   **Hasil:** Aplikasi jadi lebih stabil (tidak crash), TAPII... request ke `leave_requests` MASIH Error 400! 😱

### 3. The Final Clue (Log Server)

User akhirnya mengirimkan log JSON lengkap dari dashboard PocketBase. Dan disitulah "pembunuh" sebenarnya bersembunyi.

```json
"details": "invalid sort field \"created\"",
"url": ".../leave_requests/records?...&sort=-created"
```

Ternyata, penyebabnya SANGAT SEPELE: **Sorting**.
Default code menggunakan `sort: '-created'`. Ternyata di schema database ini, field `created` tidak diizinkan untuk disortir.

## ✅ Solusi Final

Kita ubah satu baris kode di `admin_analytics_repository.dart`:

```dart
// DARI:
sort: '-created'

// KE:
sort: '-start_date'
```

**Boom. Fixed.**
Data langsung muncul. Notifikasi langsung jalan.

## 📝 Pelajaran Hari Ini

1. **Log Server > Log Client:** Error 400 di client seringkali tidak jelas. Detail di log server (PocketBase Admin) jauh lebih jujur.
2. **Jangan Asumsi:** Kita berasumsi `created` selalu ada dan bisa disortir. Ternyata tidak.
3. **Manual Join itu Bagus:** Meskipun error utamanya adalah sorting, strategi "Manual Join" yang kita implementasikan di tengah jalan membuat aplikasi jauh lebih robust dan tidak gampang crash. Jadi itu bukan usaha sia-sia.

---

_Catatan: Fitur notifikasi juga sudah diperbaiki dengan metode "Direct Send First" agar instan._

## 🐛 Bonus Bug: Misteri Notifikasi Hilang (Missing ID)

Setelah fitur "Direct Send" diperbaiki, notifikasi berhasil masuk ke database tapi **USER TIDAK MENERIMANYA**.

**Investigasi:**
Screenshot database menunjukkan kolom `user_id` kosong.
Ternyata, `LeaveApprovalController` mengirim `userId` yang kosong/null saat memanggil fungsi kirim notifikasi.

**Solusi:**
Kita melakukan refactoring besar:

1. Pindahkan logika notifikasi DARI Controller KE Repository (`AdminActionRepository`).
2. Di dalam Repository, sebelum update status, kita **FETCH** dulu record cuti tersebut.
3. Ambil `user_id` dari hasil fetch (yang pasti valid).
4. Kirim notifikasi menggunakan ID tersebut.

**Hasil:**
Notifikasi sekarang memiliki `user_id` yang benar dan muncul di HP pengaju. Case closed. 🕵️‍♂️

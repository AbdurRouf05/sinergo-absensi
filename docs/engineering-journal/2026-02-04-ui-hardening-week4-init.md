# Engineering Journal: UI Hardening & Week 4 Initialization

**Tanggal:** 04 Februari 2026  
**Status:** Eksekusi Selesai  
**Fokus:** Anti-Freeze UI, Standardisasi Repository, & Kickoff Week 4.

---

## 1. Global UI/UX Hardening (Anti-Freeze)

**Masalah:** 
User mengeluhkan adanya risiko tombol "macet" atau loading tanpa feedback visual saat melakukan aksi kritis (Check-in/Login). Hal ini sering menyebabkan double-tap yang memicu redundansi request ke database atau API.

**Solusi:**
- Implementasi reactive `isLoading` state pada `AttendanceController` dan `HomeController`.
- Tombol aksi utama (Presensi, Login, Submit) kini secara otomatis menjadi **Disabled** saat proses asinkron sedang berjalan.
- Penambahan logic reset state pada blok `finally` atau `.then()` untuk memastikan UI kembali interaktif setelah proses selesai.

---

## 2. Standardisasi Arsitektur Data Layer

**Perubahan:** 
Relokasi `AdminRepository` dari folder modular internal ke [`lib/data/repositories/admin_repository.dart`](file:///d:/coding/flutter/presensi/seagma-presensi/lib/data/repositories/admin_repository.dart).

**Rasional:**
- Menjaga konsistensi Clean Architecture di mana semua Repository (Data Layer) harus berada di satu tempat yang terpusat.
- Memudahkan discovery oleh `InitialBinding`.
- Mendukung reuse repository oleh modul admin lain yang akan datang.

---

## 3. Kickoff Week 4: Employee Directory

**Pencapaian:**
- Inisialisasi modul `lib/modules/admin/employee_list/`.
- Pembuatan `EmployeeListController` yang memanfaatkan `IAdminRepository.getAllEmployees()`.
- Implementasi `EmployeeListView` dengan standar UI premium (Card-based, CircleAvatar, Clean Typography).
- Registrasi route `adminUsers` untuk akses administratif.

---

## 4. Greeting System (Smart Home)

**Implementasi:**
- Logika dinamis pada `HomeController` menggunakan `ITimeService`.
- Pesan otomatis berubah berdasarkan waktu lokal (Pagi/Siang/Sore/Malam).
- Penggunaan emoji (☀️, 🌤️, 🌥️, 🌙) untuk menambah kesan premium dan user-friendly.

---

**Summary:**
Proyek sekarang berada dalam kondisi "Hardened" secara UI dan siap untuk ekspansi fitur administratif di Minggu 4. Arsitektur tetap stabil dengan 100% Interface-based DI.

# Jurnal Engineering: Debugging & Stabilisasi Modul GANAS

**Tanggal:** 01 Februari 2026  
**Penulis:** Tim Development  
**Status:** ✅ TERATASI  
**Kategori:** Bug Fix / Stabilisasi UX

---

## 1. Pendahuluan
Jurnal ini mendokumentasikan sesi debugging kritis untuk **Modul GANAS (Pengajuan Izin)**. Modul ini mengalami masalah UX yang parah termasuk kegagalan senyap (silent failures), UI macet ("Stuck"), dan kurangnya feedback kepada pengguna.

## 2. Masalah yang Teridentifikasi

### A. Kegagalan Validasi Senyap
- **Gejala:** Field konten dibiarkan kosong -> Tombol ditekan -> Tidak terjadi apa-apa.
- **Penyebab Utama:** `Get.snackbar` gagal muncul atau tertutup overlay lain, sehingga tidak memberikan feedback visual kepada pengguna. Logika validasi ada, tetapi mekanisme feedback rusak.

### B. UI Macet ("The Ghost UI")
- **Gejala:** Konten disubmit -> Data tersimpan ke PocketBase (terverifikasi) -> **Halaman tidak tertutup**. Loading spinner terus berputar atau tombol tetap disabled.
- **Penyebab Utama:**
    1. `Get.back()` ditempatkan di dalam blok `try`. Jika terjadi exception kecil (non-fatal) setelah repository sukses, navigasi dilewati.
    2. Masalah destruction context di mana `Get.snackbar` mencoba muncul setelah `Get.back()` sudah menghancurkan context halaman.

### C. Error Validasi PocketBase
- **Gejala:** Error `Invalid value` untuk field Type dan Status.
- **Penyebab Utama:** Opsi "Select" di PocketBase mengandung spasi (contoh: `sakit, izin`) sedangkan aplikasi mengirim string tanpa spasi, menyebabkan ketidakcocokan data.

### D. Inkompatibilitas File Picker
- **Gejala:** Gagal build dengan `file_picker` pada Android SDK 35/V2 Embedding.
- **Penyebab Utama:** Embedding V1 usang pada library `file_picker`.

---

## 3. Solusi yang Diterapkan

### A. Penggantian Library (Infrastruktur)
- **Tindakan:** Menghapus `file_picker`. Menggantinya dengan `image_picker`.
- **Manfaat:** Mengatasi error build, meningkatkan UX (Opsi Kamera/Galeri), dan menjamin kompatibilitas V2 embedding.

### B. Validasi "Tegas" (Loud Validation)
- **Tindakan:** Mengimplementasikan guard (penjaga) di awal fungsi `submit()`.
- **Mekanisme:** Menggunakan `_nativeSnackbar` (ScaffoldMessenger) untuk menjamin feedback muncul meskipun overlay GetX bermasalah.
- **Hasil:** Field kosong sekarang langsung memicu Snackbar merah.

### C. Jaminan Navigasi (The "Safety Valve")
- **Tindakan:** Memindahkan `Get.back()` **KELUAR** dari blok `try-catch-finally`.
- **Logika:**
  ```dart
  try {
    await repository.submit();
    sukses = true;
  } finally {
    isLoading.value = false;
  }
  
  // SELALU DIEKSEKUSI
  Get.back();
  
  if (sukses) tampilkanPesanSukses();
  ```
- **Hasil:** Halaman *selalu* tertutup, mencegah kondisi "Stuck UI".

### D. Mekanisme Feedback Native
- **Tindakan:** Membuat wrapper `_nativeSnackbar`.
- **Logika:** Mencoba `ScaffoldMessenger.of(context)` terlebih dahulu. Fallback ke `Get.snackbar`. Menangkap error internal untuk mencegah aplikasi crash.

---

## 4. Hasil Verifikasi
- [x] **Submit Kosong:** Snackbar Merah muncul.
- [x] **Submit Sakit (Tanpa File):** Snackbar Merah muncul.
- [x] **Submit Cuti (Tanpa File):** Sukses -> Halaman Tertutup -> Snackbar Hijau.
- [x] **Submit Sakit (Dengan File):** Sukses -> Halaman Tertutup -> Snackbar Hijau.
- [x] **Integritas Data:** Semua record muncul dengan benar di PocketBase.

## 5. Kesimpulan
Modul GANAS sekarang sudah stabil. Perpindahan ke Native Snackbar dan logika navigasi yang robust telah mengatasi inkonsistensi UX.

---
*Disinkronkan dengan codebase: 01 Feb 2026 15:00 WIB*

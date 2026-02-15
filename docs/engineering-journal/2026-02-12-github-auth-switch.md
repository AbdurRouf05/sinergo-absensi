# Jurnal Engineering: Peralihan Akun GitHub (DevOps)

**Tanggal:** 12 Februari 2026  
**Status:** ✅ COMPLETED  
**Topik:** GitHub Authentication & Identity Sync

## 1. Konteks (Context)

Untuk keperluan standarisasi pengiriman kode (Push) pada project `seagma-presensi`, diperlukan sinkronisasi antara identitas pengembang lokal dan akun GitHub yang digunakan di lingkungan produksi/QC.

## 2. Tindakan yang Diambil (Actions Taken)

1. **Local Git Identity**: Mengubah `user.name` ke `AbdurRouf05` dan `user.email` ke `arackermandev05@gmail.com` secara lokal (hanya untuk repositori ini).
2. **GitHub CLI Re-auth**: Melakukan logout dari akun sebelumnya (`AbdurRouf05` lama/keyring) dan melakukan re-authentication menggunakan metode interaktif (`Browser-based Device Activation`).
3. **Identity Verification**: Memastikan `git config` dan `gh auth status` menunjukkan identitas yang konsisten untuk menghindari masalah izin saat push.

## 3. Hasil (Results)

- Proyek sekarang terkonfigurasi untuk menggunakan identitas `AbdurRouf05 <arackermandev05@gmail.com>`.
- Push ke repositori `sagamuda/seagma-presensi` dapat dilakukan dengan izin yang tepat.

---

_Dibuat oleh Antigravity Agent_

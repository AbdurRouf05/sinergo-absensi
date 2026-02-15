# Registri Hutang Teknis (Technical Debt)

> **Tujuan:** Melacak keterbatasan yang diketahui dan perbaikan yang direncanakan.
> **Pemilik:** Tim Pengembangan
> **Terakhir Diupdate:** 06-02-2026

---

## ⏸️ [STATUS] PROJECT FROZEN FOR QA & MIGRATION

Pengembangan fitur baru dihentikan sementara untuk fokus pada stabilitas dan sinkronisasi database server.

---

## 🔴 [KRITIS] Keterbatasan Sinkronisasi Background

### Kondisi Saat Ini

`SyncService` masih menggunakan `Timer.periodic`. Implementasi `Workmanager` ditunda ke Fase Hardening Produksi.

### Risiko

* **TINGGI**: OS mungkin mematikan Timer saat background. Data tertunda sinkron.

---

## 🔴 [KRITIS] Enkripsi Database Lokal (Isar) (DITUNDA)

### Kondisi Saat Ini
Database Isar berjalan dalam mode **Plain Text**. Enkripsi masih terhalang bug library native Android pada Isar v3.

### Risiko

* **TINGGI**: File `.isar` bisa diekstrak jika device di-root.

---

## 🟡 [SEDANG] Fitur yang Ditunda (Deferred to QA Phase)

1. **Dynamic Outpost**: Logika presensi titik sementara belum dibuat.
2. **Analytics & Smart Reporting**: Dashboard rekap jam kerja dan ekspor PDF belum ada.
3. **Real-time Alpha Detection**: Monitoring otomatis siapa yang belum absen via server-side trigger.

---

## 🟡 [SEDANG] Fallback Waktu NTP

### Kondisi Saat Ini
Menggunakan `ntp`. Offset belum di-cache secara permanen untuk periode offline total yang lama.

---

## 🟢 [RENDAH] Cakupan Tes (Test Coverage)

### Kondisi Saat Ini
- Unit tests: 15 lulus (Logic Core, GANAS, Overtime Trap).
- Integration/E2E: Belum ada.

---

## 🏁 [SUMMARY] Evaluasi Sprint Week 1-5

### Status: PAUSED FOR QA

| Area | Status | Tindakan Selanjutnya |
|------|--------|----------------------|
| **Core Logic** | ✅ Stabil | Full Cycle Regression Testing. |
| **Field Ops** | ✅ Stabil | Verifikasi manual skenario GANAS & Overtime. |
| **Admin Gear** | ✅ Stabil | Sinkronisasi field baru ke PocketBase. |
| **Security** | 🟡 Warning | Implementasi software-based mock detection. |

---

> **Konfirmasi Agent:** Semua logika koding untuk fitur Week 5 (Fase 1 & 2) telah selesai. Hutang utama yang tersisa adalah infrastruktur background sync dan enkripsi DB lokal.

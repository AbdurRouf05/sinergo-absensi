# 🏗️ SEAGMA PRESENCE - Panduan Arsitektur

> **Status:** Final (Fase 4 Pengerasan Akhir)  
> **Pola:** Arsitektur Bersih (Clean Architecture) + GetX Micro-Modular  
> **Mandat Ketat:** Interface-First Dependency Injection

---

## 1. Prinsip Arsitektur Inti

### A. Interface-First Dependency Injection
Kelas implementasi **tidak boleh** ditemukan secara langsung menggunakan `Get.find<ConcreteClass>()`. Sebaliknya, mereka harus didaftarkan dan ditemukan melalui antarmuka (interface) abstraknya.

- **Mengapa:** Memastikan logika terlepas dari perangkat keras dan infrastruktur. Memungkinkan mocking yang mulus untuk pengujian.
- **Penegakan:** Audit `grep` di seluruh proyek dilakukan secara berkala untuk mengidentifikasi paparan kelas konkret.

### B. Inisialisasi Berurutan Berbasis Fase
Untuk mencegah *deadlock* saat startup dan error "Service not found", aplikasi mengikuti urutan *boot* yang ketat di `InitialBinding.dart`.

| Fase | Kategori | Service Termasuk |
|------|----------|-------------------|
| **P1** | Infrastruktur | Isar, DeviceService, PermissionService, SecurityService |
| **P2** | Sensor | WifiService, LocationService, TimeService (NTP) |
| **P3** | Logika Inti | AuthService, SyncService |
| **P4** | Domain | UserRepository, AttendanceRepository, LeaveRepository, AdminRepository, NotificationRepository |

### C. Modularisasi Logika (Micro-Managers)
Controller dan Repository yang melebihi 350 baris kode (LOC) harus dipecah menjadi sub-manajer taktis.
- **Controllers:** Fokus pada UI State dan routing.
- **Managers:** Menangani logika domain (contoh: `LocationManager`, `SyncManager`).
- **Validators:** Mengenkapsulasi aturan bisnis (contoh: `CheckInValidator`).

### D. Pengerasan UI/UX (Anti-Freeze)
Semua tombol aksi kritis (Login, Presensi, Submit) harus mengimplementasikan state `isLoading` yang reaktif.
- **Tujuan:** Mencegah ketukan ganda (*double-taps*) dan UI yang macet (*freeze*) selama operasi async.
- **Aturan:** Selama `isLoading` bernilai true, tombol harus dinonaktifkan atau menampilkan indikator loading.

---

## 2. Pola Dependency Injection

### Registrasi Service
```dart
// app/bindings/initial_binding.dart
await Get.putAsync<IAuthService>(() => AuthService().init(), permanent: true);
```

### Penemuan Service (Service Discovery)
```dart
// Controller atau Repository apa pun
final authService = Get.find<IAuthService>();
```

---

## 3. Struktur Proyek (Terstandarisasi)

```text
lib/
├── app/
│   ├── bindings/       # Binding Global (InitialBinding)
│   ├── routes/         # Routing Terpadu
│   └── theme/          # Identitas UI
├── data/
│   ├── models/         # Model Isar & PocketBase
│   ├── repositories/   # Repository Domain (Interface + Impl)
│   └── mappers/        # Pemetaan Data Terpadu
├── services/           # Abstraksi Hardware & Cloud (Interface + Impl)
└── modules/            # Modul Berbasis Fitur
    └── my_feature/
        ├── controllers/# State Fitur
        ├── logic/      # Sub-Managers & Helpers
        ├── views/      # UI Bersih (Tanpa Logika)
        └── widgets/    # Widget Fitur yang Dapat Digunakan Kembali
```

---

## 4. Penanganan Error & Fail-safe
- **AppException:** Hirarki exception kustom untuk pesan UI yang bermakna.
- **SyncQueue:** Semua mutasi cloud harus antre di Isar untuk ketahanan offline.
- **Hardware Fail-safes:** Gunakan `ILocationService` dan `ITimeService` dengan logika cadangan (*fallback*) untuk data sensor yang tidak dapat diandalkan.

---

> **Versi:** 1.0  
> **Terakhir Diperbarui:** 04-02-2026

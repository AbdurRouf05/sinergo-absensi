# 🏆 Action Plan: Penyempurnaan Lomba (Competition Hardening)

**Project:** Sinergo.id (Flutter, Clean Arch, GetX, Isar, PocketBase)
**Deadline Target:** H-3 sebelum kompetisi untuk stabilitas, H-1 untuk polish akhir.

---

## 1. [x] Stability & Critical Hotfixes (Wajib Selesai H-3)

### 1.1 [x] Timezone Consistency

**Problem:** Status harian bisa "beda jam" karena inkonsistensi antara `DateTime.now()` (local) dan data PocketBase (UTC).

**Status:** ✅ **DONE** (Fixed in `HomeSyncManager` by adding `.toLocal()` conversion).

**Action Items:**

| Layer                 | Rule                                                         | Implementasi                                                              |
| :-------------------- | :----------------------------------------------------------- | :------------------------------------------------------------------------ |
| **Data (Repository)** | Semua `DateTime` yang dikirim ke PocketBase WAJIB `.toUtc()` | Audit `AttendanceRepository.checkIn()`, `LeaveRepository.submitRequest()` |
| **Domain (UseCase)**  | Logic perbandingan waktu gunakan UTC                         | `isLate = checkInTimeUtc.isAfter(shiftStartUtc)`                          |
| **Presentation**      | Convert ke local HANYA saat display                          | `DateFormat('HH:mm').format(utcTime.toLocal())`                           |

---

### 1.2 [x] UI/UX Unblocking

#### A. [ ] Edit Profil Loading Freeze

_(Pending Verification)_

#### B. [x] Dialog Hapus Titik Absen Freeze

**Status:** ✅ **DONE** (Fixed in `PoskoController` with proper async handling and 404 checks).

**Diagnosis Steps:**

1. Cek apakah `Get.dialog()` atau `showDialog()` memanggil async operation tanpa loading indicator.
2. Pastikan `Navigator.pop()` dipanggil SETELAH operasi selesai, bukan sebelum.
3. Cek apakah ada `setState()` dipanggil setelah widget di-dispose.

---

## 2. [ ] Realtime & Location Intelligence (The "Wow" Factor)

### 2.1 [ ] Live Location Stream

**Current:** `Geolocator.getCurrentPosition()` → one-shot, user harus refresh manual.
**Target:** `Geolocator.getPositionStream()` → marker bergerak real-time di peta.

---

### 2.2 [ ] Smart Map Link Parsing (Admin Mode)

**Use Case:** Admin paste link Google Maps → sistem otomatis extract Lat/Lng → render di `flutter_map`.

> ⚠️ **RULE:** Render WAJIB menggunakan `flutter_map` (OSM). DILARANG Google Maps SDK.

---

## 3. [ ] Offline-First Visuals (Sinergo.id Signature Feature)

### 3.1 [ ] Local Map Caching

**Strategy:** Cache koordinat penting + status koneksi di Isar. Saat offline, tampilkan info lokasi terakhir + placeholder visual.

---

### 3.2 [ ] Offline Feedback

**UX Rule:** Jangan biarkan user bingung — beri feedback yang jelas dan elegan.

---

## 4. [ ] Integrasi Fitur AI (Competition Booster)

### 4.1 [ ] Opsi A: Smart Recap (REKOMENDASI — Paling Feasible)

**Fitur:** Analisis pola kehadiran user → berikan insight yang actionable.

**UI:** Tampilkan sebagai card di Home Dashboard dengan animasi fade-in.

---

### 4.2 [ ] Opsi B: Liveness Detection (High Impact, Medium Effort)

**Strategy:** Validasi bahwa foto selfie diambil dari kamera langsung (bukan galeri/screenshot).

---

## 5. [ ] UI/UX Polish

### 5.1 [ ] Pagination

**Target Lists:**
| Screen | Current | Target |
|--------|---------|--------|
| Log Absensi (History) | `getFullList()` → load semua | `getList(page, perPage: 20)` |
| Daftar Pegawai (Admin) | `getFullList()` → load semua | `getList(page, perPage: 25)` |
| Notifikasi | Load semua | Lazy load `perPage: 15` |

---

### 5.2 [ ] System Tray Notifications

**Package:** `flutter_local_notifications`

**Setup:**

1. Tambahkan dependency di `pubspec.yaml`
2. Initialize di `main.dart` sebelum `runApp()`
3. Trigger saat ada broadcast dari PocketBase realtime

---

## Timeline Ringkasan

| Fase                      | Target | Priority    | Status     |
| :------------------------ | :----- | :---------- | :--------- |
| **1. Stability**          | H-3    | 🔴 CRITICAL | ✅ DONE    |
| **2. Live Location**      | H-2    | 🟡 HIGH     | ⏳ PENDING |
| **3. Offline Visuals**    | H-2    | 🟡 HIGH     | ⏳ PENDING |
| **4. AI Smart Recap**     | H-1    | 🟢 MEDIUM   | ⏳ PENDING |
| **5. Pagination + Notif** | H-1    | 🟢 MEDIUM   | ⏳ PENDING |

# AUDIT & GAP ANALYSIS REPORT: MODUL 3 (EMPLOYEE ANALYTICS)

**Tanggal:** 04 Februari 2026
**Auditor:** Senior Solutions Architect (Agent)
**Status:** READINESS CHECK

---

## 1. 🔍 Tujuan Audit & Lingkup
Audit ini dilakukan untuk memvalidasi kesiapan teknis proyek `seagma-presensi` (Flutter/GetX/PocketBase) sebelum memulai implementasi **Module 3: Employee Analytics (Reporting Engine)**. Fokus audit meliputi struktur data, logika bisnis yang ada, dan kesenjangan (gaps) terhadap kebutuhan Reporting Engine.

## 2. 🏛️ Status Komponen Saat Ini (Audit Findings)

### A. Data Layer (Models & Repository)
*   **✅ AttendanceModel (`AttendanceLocal`):** Struktur data sudah matang. Memiliki field vital: `checkInTime` (untuk hitung telat), `status` (hadir/telat/izin), dan `lateMinutes`.
*   **✅ ShiftModel (`ShiftLocal`):** Tersedia. Memiliki `startTime` (jam masuk) dan `workDays` (hari kerja: senin, selasa, dst). Ini fondasi perhitungan "Total Hari Kerja".
*   **✅ LeaveModel (`LeaveRequestLocal`):** Tersedia. Memiliki `startDate`, `endDate`, dan `status` ('approved').
*   **⚠️ Repository Layer:**
    *   `AdminRepository` saat ini hanya memiliki logika untuk **Daily Recap** (Harian).
    *   **GAP:** Belum ada fungsi untuk menarik dan meng-agregasi data dalam rentang waktu (Monthly) secara efisien.

### B. Logic Layer (Business Logic)
*   **⚠️ Kalkulasi Keterlambatan:**
    *   Logika *real-time* sudah ada di `AdminRepository` (membandingkan `checkInTime` vs `Shift`), namun logika agregasi bulanan belum ada.
*   **❌ Kalkulasi "Hari Kerja" (Denominator):**
    *   Belum ada fungsi utilitas untuk menghitung "Berapa hari kerja efektif dalam bulan ini?" berdasarkan Shift pattern (Senin-Sabtu) dikurangi Tanggal Merah (jika ada).
*   **❌ Kalkulasi Alpa (Absent):**
    *   Rumus `Alpa = Total Hari Kerja - (Hadir + Izin)` belum diimplementasikan untuk level bulanan.

### C. UI Layer (View & Controller)
*   **✅ Admin Interface Dasar:** Struktur folder `modules/admin` sudah rapi.
*   **❌ Analytics Dashboard:** Belum ada halaman `AnalyticsView` atau `MonthlyRecapView`.
*   **❌ Visualization:** Belum ada komponen Card/Chart untuk persentase kehadiran.

---

## 3. 🧩 Gap Analysis

| Komponen | Status Current | Kebutuhan Module 3 | GAP (Kesenjangan) |
| :--- | :--- | :--- | :--- |
| **Data Fetching** | Fetch per-hari (`Today`) | Fetch per-bulan (`Start - End`) dengan filter Admin | **Implementation Required:** Logic "Trawl Net" untuk fetch bulk data bulan berjalan. |
| **Logic: Total Hari Kerja** | Manual array static | Dinamis berdasarkan `Shift.workDays` & Kalender | **Implementation Required:** Utility function untuk iterasi tanggal dalam satu bulan. |
| **Logic: Alpa Detection** | Logic Harian di Repo | Logic Bulanan (History) | **Implementation Required:** Loop cek kehadiran per user per tanggal. |
| **UI: Report Page** | Tidak ada | Halaman Rekapitulasi + Download | **New Component:** `AnalyticsView`. |
| **UI: Dashboard Stats** | Total Empl, Present Today | % Kehadiran Bulanan (Average) | **Modification:** Tambah Card baru di Analytics. |

---

## 4. ⚠️ Analisis Risiko & Mitigasi (Risk Assessment)

### A. Risiko Teknis
1.  **Performance Bottle-neck ("Trawl Net" Strategy)**
    *   **Risiko:** Fetching data `attendances` satu bulan penuh untuk 50+ karyawan bisa menghasilkan ribuan record JSON. Parsing di Main Thread bisa menyebabkan UI *freeze/jank*.
    *   **Dampak:** UX buruk, aplikasi macet sesaat saat buka report.
    *   **Mitigasi:**
        *   Gunakan `compute()` (Isolate) untuk proses parsing dan kalkulasi matematik berat agar UI tetap responsif.
        *   Pagination jika data > 1000 record (opsional untuk MVP).

2.  **Perubahan Shift (Historical Data Consistency)**
    *   **Risiko:** Jika User A pindah shift di tengah bulan (Pagi -> Malam), perhitungan "Total Hari Kerja" atau "Telat" historis mungkin menjadi tidak akurat jika hanya melihat Shift User *saat ini*.
    *   **Dampak:** Laporan tidak valid.
    *   **Mitigasi:**
        *   *Ideal:* Menyimpan `snapshot_shift_id` di setiap record absensi.
        *   *MVP:* Gunakan asumsi Shift saat ini berlaku surut (simplifikasi), namun beri *disclaimer* pada user.

3.  **Data Sinkronisasi (Offline Data)**
    *   **Risiko:** Data absensi lokal karyawan mungkin belum ter-sync ke server saat Admin menarik laporan.
    *   **Dampak:** Laporan Admin "Under-reported" (Alpa padahal Hadir tapi belum sync).
    *   **Mitigasi:** Tampilkan waktu "Last Sync" user di laporan, atau beri indikator "Data mungkin tidak real-time".

### B. Risiko Non-Teknis (Security)
1.  **Admin Bypass Abuse**
    *   **Risiko:** Filter `pb.collection('attendances').getFullList(filter: 'created >= "$startOfMonth"')` sangat luas. Jika terekspos ke user biasa, ini kebocoran data masif.
    *   **Mitigasi:**
        *   Pastikan Rules PocketBase: Collection `attendances` hanya boleh `List/View` oleh User itu sendiri (`@request.auth.id = user_id`) OR Admin Role.
        *   Hardcode filter di sisi aplikasi Admin agar tidak bisa diinjeksi.

---

## 5. ✅ Rekomendasi & Langkah Selanjutnya

Berdasarkan audit, proyek **SIAP** untuk melanjutkan ke tahap Implementasi Module 3 dengan catatan:
1.  **Prioritaskan Logic Controller:** Fokus utama adalah membuat `AnalyticsController` yang kuat menghitung agregasi sebelum menyentuh UI.
2.  **Gunakan Isolate:** Sangat disarankan untuk kalkulasi laporan.
3.  **Struktur Baru:** Buat modul baru `lib/modules/admin/analytics/` untuk memisahkan kompleksitas dari dashboard utama.

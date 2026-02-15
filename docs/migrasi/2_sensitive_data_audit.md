# TASK B: Hardcoded Secrets & Branding Audit ("Seagma Hunt")

> Audit Date: 2026-02-15
> Auditor: Antigravity (Automated)
> Source: `d:\coding\flutter\presensi\seagma-presensi`

---

## 🚨 SEVERITY LEGEND

| Level       | Meaning                                                          |
| ----------- | ---------------------------------------------------------------- |
| 🔴 CRITICAL | Secret/Password/Key — Harus dihapus atau diganti SEBELUM publish |
| 🟠 HIGH     | Production URL / Branding klien — Wajib diganti                  |
| 🟡 MEDIUM   | Nama brand "Seagma" — Perlu di-rebrand                           |
| 🟢 LOW      | Package import (otomatis berubah saat rename)                    |

---

## 1. 🔴 CRITICAL: Secrets & Credentials

### File: `.env` (ROOT)

| Line | Content                                                   | Risk                   |
| ---- | --------------------------------------------------------- | ---------------------- |
| 2    | `S3_ENDPOINT=https://drive.sagamuda.cloud`                | Production S3 endpoint |
| 3    | `S3_ACCESS_KEY=bOMOyK57UEkYzVQu`                          | **S3 ACCESS KEY**      |
| 4    | `S3_SECRET_KEY=3Kev40QBmLeb4OgspjxNmyv1Kufr7sDn`          | **S3 SECRET KEY**      |
| 5    | `S3_BUCKET_NAME=seagma-presensi`                          | Bucket name (brand)    |
| 10   | `POCKETBASE_URL=https://db-seagmapresence.sagamuda.cloud` | Production DB URL      |
| 13   | `PB_ADMIN_EMAIL=sagamuda.id@gmail.com`                    | **Admin Email**        |
| 14   | `PB_ADMIN_PASSWORD=Sagamuda585858`                        | **ADMIN PASSWORD !!!** |

> [!CAUTION]
> File `.env` berisi **password admin plaintext** dan **S3 secret keys**. File ini **WAJIB diganti seluruh isinya** di project lomba.

### File: `Seagma_Keystore_BACKUP.zip` (ROOT)

- **Ini adalah backup keystore signing** untuk Play Store.
- **WAJIB DIHAPUS PERMANEN** dari project lomba.

---

## 2. 🟠 HIGH: Hardcoded Production URLs in Code

| File                                                              | Line | Content                                                                                    |
| ----------------------------------------------------------------- | ---- | ------------------------------------------------------------------------------------------ |
| `lib/data/models/leave_request_model.dart`                        | 36   | `'https://db-seagmapresence.sagamuda.cloud/api/files/leave_requests/$odId/$attachment'`    |
| `lib/modules/admin/analytics/widgets/analytics_employee_row.dart` | 25   | `"https://db-seagmapresence.sagamuda.cloud/api/files/users/${emp.avatarUrl}"`              |
| `lib/core/constants/app_constants.dart`                           | 16   | `dotenv.env['POCKETBASE_URL'] ?? 'http://localhost:8090'` (fallback OK, tapi reads `.env`) |

> [!WARNING]
> 2 file memiliki **hardcoded production URL** yang mem-bypass `.env`. Ini harus direfactor agar menggunakan `AppConstants.pocketBaseUrl`.

---

## 3. 🟡 MEDIUM: Brand Name "Seagma" in Code

### In Configuration Files

| File                           | Line | Content                                                            |
| ------------------------------ | ---- | ------------------------------------------------------------------ |
| `pubspec.yaml`                 | 1    | `name: seagma_presensi`                                            |
| `pubspec.yaml`                 | 2    | `description: Aplikasi Presensi Seagma`                            |
| `pubspec.yaml`                 | 99   | `image_path: "assets/images/seagma_icon.png"`                      |
| `pubspec.yaml`                 | 102  | `adaptive_icon_foreground: "assets/images/seagma_adaptive_fg.png"` |
| `android/app/build.gradle.kts` | 17   | `namespace = "com.seagma.seagma_presence"`                         |
| `android/app/build.gradle.kts` | 47   | `applicationId = "com.seagma.seagma_presence"`                     |

### In Source Code

| File                                                      | Line | Content                                              |
| --------------------------------------------------------- | ---- | ---------------------------------------------------- |
| `lib/main.dart`                                           | 39   | `runApp(const SeagmaPresenceApp());`                 |
| `lib/main.dart`                                           | 42   | `class SeagmaPresenceApp extends StatelessWidget`    |
| `lib/core/constants/app_constants.dart`                   | 1    | `/// Application-wide constants for SEAGMA PRESENCE` |
| `lib/core/constants/app_constants.dart`                   | 10   | `static const String appName = 'Seagma Presence';`   |
| `lib/modules/attendance/checkin/widgets/checkin_map.dart` | 30   | `userAgentPackageName: 'com.seagma.seagma_presence'` |

### In Asset Files (images/)

| File                                    | Action Needed     |
| --------------------------------------- | ----------------- |
| `assets/images/seagma logo.png`         | Replace or delete |
| `assets/images/seagma logo - hitam.png` | Replace or delete |
| `assets/images/seagma logo - hitam.svg` | Replace or delete |
| `assets/images/seagma logo - putih.png` | Replace or delete |
| `assets/images/seagma logo - putih.svg` | Replace or delete |
| `assets/images/seagma logo.svg`         | Replace or delete |
| `assets/images/seagma_adaptive_fg.png`  | Replace or delete |
| `assets/images/seagma_icon.png`         | Replace or delete |
| `assets/images/seagma_splash.png`       | Replace or delete |

### In Tool Scripts

| File                               | Lines            | Content                               |
| ---------------------------------- | ---------------- | ------------------------------------- |
| `tool/generate_logo_variants.dart` | 7,41,62,83,88-90 | Multiple references to `seagma_*.png` |

---

## 4. 🟢 LOW: Package Imports (Auto-changes with rename)

**498+ occurrences** of `package:seagma_presensi/...` di seluruh file `.dart`.

- File test: `checkout_controller_test.dart`, `checkin_controller_test.dart`, `history_controller_test.dart`, dll.
- Semua file di `lib/` yang saling import.

> [!NOTE]
> Ini akan otomatis berubah saat rename `name:` di `pubspec.yaml` dan melakukan find-replace "seagma_presensi" → nama baru.

---

## 5. Ringkasan Tindakan Sanitasi

| Priority    | Count             | Action                                                     |
| ----------- | ----------------- | ---------------------------------------------------------- |
| 🔴 CRITICAL | 7 values + 1 file | Ganti semua isi `.env`, hapus `Seagma_Keystore_BACKUP.zip` |
| 🟠 HIGH     | 2 files           | Refactor hardcoded URLs ke `AppConstants.pocketBaseUrl`    |
| 🟡 MEDIUM   | ~15 locations     | Find & Replace "Seagma"/"seagma" di config + source code   |
| 🟡 MEDIUM   | 9 image files     | Replace semua logo asset                                   |
| 🟢 LOW      | 498+ imports      | Bulk rename package name                                   |

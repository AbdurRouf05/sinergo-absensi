# TASK D: Asset & Resource Inventory

> Audit Date: 2026-02-15
> Auditor: Antigravity (Automated)
> Source: `d:\coding\flutter\presensi\seagma-presensi`

---

## 1. Registered Assets (pubspec.yaml)

```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
    - assets/images/
    - assets/icons/
```

---

## 2. Assets Directory Inventory

### `assets/images/` — 10 files, ALL branded "Seagma"

| #   | Filename                  | Size   | Action          |
| --- | ------------------------- | ------ | --------------- |
| 1   | `.gitkeep`                | 57 B   | Keep (no brand) |
| 2   | `seagma logo - hitam.png` | 125 KB | 🔴 REPLACE      |
| 3   | `seagma logo - hitam.svg` | 6.4 KB | 🔴 REPLACE      |
| 4   | `seagma logo - putih.png` | 125 KB | 🔴 REPLACE      |
| 5   | `seagma logo - putih.svg` | 6.3 KB | 🔴 REPLACE      |
| 6   | `seagma logo.png`         | 59 KB  | 🔴 REPLACE      |
| 7   | `seagma logo.svg`         | 9.2 KB | 🔴 REPLACE      |
| 8   | `seagma_adaptive_fg.png`  | 36 KB  | 🔴 REPLACE      |
| 9   | `seagma_icon.png`         | 50 KB  | 🔴 REPLACE      |
| 10  | `seagma_splash.png`       | 38 KB  | 🔴 REPLACE      |

> [!CAUTION]
> **SEMUA file gambar mengandung branding "Seagma"**. Tidak ada satu pun yang bisa digunakan langsung untuk versi lomba. Perlu diganti dengan aset "Attendance Fusion".

### `assets/icons/` — 1 file

| #   | Filename   | Size | Action             |
| --- | ---------- | ---- | ------------------ |
| 1   | `.gitkeep` | 57 B | Keep (placeholder) |

---

## 3. Referenced in pubspec.yaml (flutter_launcher_icons)

```yaml
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/seagma_icon.png" # 🔴 REPLACE
  min_sdk_android: 21
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/seagma_adaptive_fg.png" # 🔴 REPLACE
```

### Referenced in pubspec.yaml (flutter_native_splash)

```yaml
flutter_native_splash:
  color: "#2E3D8A" # Warna bisa dipertahankan atau diubah
  android_12:
    color: "#2E3D8A"
    icon_background_color: "#2E3D8A"
```

> [!NOTE]
> Splash screen saat ini hanya menggunakan warna solid `#2E3D8A` (biru tua), tanpa logo image. Ini AMAN — tidak ada branding di splash config.

---

## 4. Other Non-Code Files at Root

| File                         | Size   | Brand Risk       | Action                  |
| ---------------------------- | ------ | ---------------- | ----------------------- |
| `Seagma_Keystore_BACKUP.zip` | 2.9 KB | 🔴 CRITICAL      | **DELETE**              |
| `ONBOARDING_REKAN.md`        | 4.1 KB | 🟡 Check content | Review & sanitize       |
| `README.md`                  | 1.9 KB | 🟡 Check content | Rewrite for lomba       |
| `seagma_presensi.iml`        | 859 B  | 🟡 Brand name    | Auto-generated, replace |
| `.env`                       | 687 B  | 🔴 CRITICAL      | Replace ALL values      |
| `.env.test`                  | 45 B   | 🟡 Check content | Review                  |
| `find_large_files.py`        | 669 B  | 🟢 Neutral       | Can delete or keep      |

---

## 5. Logo Tool Script

File `tool/generate_logo_variants.dart` — Script untuk generate variant logo dari source image.

**References:** `seagma logo.png`, `seagma_splash.png`, `seagma_icon.png`, `seagma_adaptive_fg.png`

**Action:** Update path references saat mengganti logo ke "Attendance Fusion".

---

## 6. Summary: Required Asset Actions

| Category              | Count     | Action                                      |
| --------------------- | --------- | ------------------------------------------- |
| Logo images (PNG)     | 6         | Generate/replace "Attendance Fusion" logos  |
| Logo images (SVG)     | 3         | Generate/replace vector versions            |
| App icon config       | 2 refs    | Update paths in `pubspec.yaml`              |
| Splash config         | 0 changes | Color-only, safe                            |
| Keystore backup       | 1         | **DELETE PERMANENTLY**                      |
| Config files (`.env`) | 1         | Rewrite with demo values                    |
| Documentation         | 2         | Rewrite `README.md` & `ONBOARDING_REKAN.md` |
| Tool scripts          | 1         | Update references                           |

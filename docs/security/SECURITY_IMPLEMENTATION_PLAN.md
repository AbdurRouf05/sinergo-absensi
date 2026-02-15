# Rencana Implementasi Keamanan Week 4

**Tanggal:** 01 Februari 2026  
**Author:** Lead Security Engineer  
**Status:** 📋 IMPLEMENTED / SELESAI (Per 02-02-2026)

---

## 1. Ringkasan Stack Keamanan (Tech Stack)

Berdasarkan riset kompatibilitas dengan **Android 15 (SDK 35)** dan **AGP 8.7.0**:

| Komponen | Rekomendasi | Alasan |
|----------|-------------|--------|
| **Root/Mock Detection** | `freeRASP` v7.0.0+ | Kompatibel SDK 35, deteksi Magisk Hide/Shamiko, gratis s/d 100k download |
| **Token Storage** | `flutter_secure_storage` | Sudah digunakan, menggunakan KeyStore Android |
| **DB Encryption** | ⚠️ Tidak didukung Isar v3 | Mitigasi: Enkripsi data sensitif sebelum simpan |
| **Code Obfuscation** | `--obfuscate` flag | Built-in Flutter, wajib untuk production |

### Alternatif Dipertimbangkan

| Package | Status | Catatan |
|---------|--------|---------|
| `safe_device` | ❌ Kurang komprehensif | Tidak deteksi root hider |
| `flutter_jailbreak_detection` | ❌ Tidak terawat | Terakhir update 2023 |

---

## 2. Arsitektur Keamanan (Layered Defense)

```
┌─────────────────────────────────────────────────────────────┐
│                    LAYER 4: BUILD HARDENING                 │
│            (Code Obfuscation, ProGuard, Signing)            │
├─────────────────────────────────────────────────────────────┤
│                    LAYER 3: API HARDENING                   │
│        (PocketBase Rules, Rate Limiting, HTTPS Only)        │
├─────────────────────────────────────────────────────────────┤
│                    LAYER 2: DATA SECURITY                   │
│    (flutter_secure_storage, Field-level Encryption)         │
├─────────────────────────────────────────────────────────────┤
│                    LAYER 1: DEVICE INTEGRITY                │
│      (freeRASP: Root, Mock Location, Tampering, Hook)       │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Detail Implementasi

### Layer 1: Device Integrity (freeRASP)

**File Target:** `lib/services/security_service.dart` (NEW)

**Fitur yang Diaktifkan:**
- [x] `isRooted` - Deteksi root + Magisk Hide
- [x] `onMockLocation` - Deteksi Fake GPS
- [x] `onHook` - Deteksi Frida/Xposed
- [x] `onTampered` - Deteksi repackaging

**Flow:**
```dart
// Di main.dart atau SplashScreen
await SecurityService.init();
if (SecurityService.isCompromised) {
  // Tampilkan pesan & block app
  showSecurityWarningDialog();
  return;
}
// Lanjutkan ke Login...
```

**Aksi Jika Terdeteksi:**
| Ancaman | Aksi |
|---------|------|
| Rooted | ⛔ Block app completely |
| Mock Location | ⛔ Block attendance only |
| Hook Detected | ⛔ Block app + Log violation |
| Tampering | ⛔ Block app + Force update |

---

### Layer 2: Data Security

**File Target:** `lib/services/auth_service.dart` (MODIFY)

**Strategi:**
1. **Token Storage:** Sudah menggunakan `flutter_secure_storage` ✅
2. **Sensitive Fields:** Enkripsi `deviceId` dan `bssid` sebelum simpan ke Isar
3. **Implementation:**
```dart
// Contoh: Enkripsi BSSID sebelum simpan
final encryptedBssid = await _encryptField(bssid);
attendance.wifiBssid = encryptedBssid;
```

---

### Layer 3: API Hardening

**Target:** PocketBase Dashboard

**Checklist:**
- [x] `users` collection: List Rule = `@request.auth.id != ""`
- [x] `attendances` collection: Create Rule = `@request.auth.id = employee`
- [x] `leave_requests` collection: Create Rule = `@request.auth.id != ""` (Authenticated Users)
- [ ] Rate Limiting: Max 60 requests/minute per user

---

### Layer 4: Build Hardening

**File Target:** `android/app/build.gradle.kts` (MODIFY)

**Build Command (Production):**
```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --target-platform android-arm64
```

**Keystore Setup:**
1. Generate keystore:
```bash
keytool -genkey -v -keystore seagma-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias seagma
```
2. Create `android/key.properties` (JANGAN COMMIT!)
3. Update `build.gradle.kts` dengan signing config

---

## 4. Rencana Verifikasi (Penetration Test)

| Test Case | Tool | Expected Result |
|-----------|------|-----------------|
| Install di HP Rooted | Magisk | App blocked |
| Aktifkan Fake GPS | Fake GPS Go | Attendance rejected |
| Intercept API | Burp Suite/mitmproxy | SSL Pinning block |
| Clone APK | Lucky Patcher | Tampering detected |
| Time Manipulation | System Settings | Time validation reject |

---

## 5. Timeline Estimasi

| Hari | Task |
|------|------|
| Day 1 | Install freeRASP + SecurityService |
| Day 2 | Implement block screens + PB rules |
| Day 3 | Keystore + Signing config |
| Day 4 | Penetration testing |
| Day 5 | Fix issues + Final build |

---

> [!WARNING]
> **SEBELUM MULAI:** Pastikan `pb_schema.json` sudah di-backup ke `docs/database/`!

---
*Dokumen ini akan di-update setelah approval.*

# Engineering Journal: Security Violation UI & Animated Splash Screen

**Date:** 2026-02-15 (Malam 14 Feb → Pagi 15 Feb)  
**Author:** AbdurRouf05 (Assisted by Antigravity)

## 🎯 Objectives

1. **Enhanced Security Red Screen:** Provide detailed explanations and actionable solutions for each security threat.
2. **Device Binding → Red Screen:** Catch session cloning attempts during `restoreSession` and trigger the security screen.
3. **Animated Splash Screen:** Replace static loading with premium staggered animations.
4. **Fix Splash Logo Size:** Logo terlalu besar/terpotong di native splash.

---

## 🛠️ Technical Implementation

### 1. Security Violation UI Enhancement (Phase 8)

**Problem:** Red Screen hanya menampilkan pesan generik "Perangkat tidak aman" tanpa penjelasan spesifik.

**Solution:**

- **`SecurityService`:** Updated `_handleThreat` untuk menerima `title`, `message`, dan `solution`. Setiap threat (Root, Mock GPS, Emulator, Time Manipulation) kini punya pesan & solusi spesifik.
- **`SecurityService.reportThreat()`:** Method public baru agar `AuthService` bisa melaporkan ancaman eksternal.
- **`AuthService.restoreSession()`:** Menangkap `DeviceBindingException` dan memanggil `SecurityService.to.reportThreat()` dengan pesan "Perangkat Tidak Dikenali" + solusi 3 langkah.
- **`SecuritySolutionCard`:** Widget baru di `widgets/` untuk menampilkan langkah perbaikan (lightbulb icon + formatted text).
- **`SecurityViolationView`:** Refactored ke ~190 LOC dengan `SingleChildScrollView` untuk menghindari overflow.

**Files Modified:**

- `lib/services/security_service.dart` (190 LOC)
- `lib/services/auth_service.dart` (199 LOC)
- `lib/modules/security/security_violation_view.dart` (190 LOC)
- `lib/modules/security/widgets/security_solution_card.dart` [NEW] (45 LOC)

### 2. Fix Splash Logo Size

**Problem:** Logo asli (667x638px) tidak ada padding → memenuhi seluruh area splash → terlihat terpotong/kegedean.

**Solution:**

- Buat script `tool/generate_logo_variants.dart` yang generate 3 versi:
  - `seagma_splash.png` — 1200×1200, logo 40% dari canvas
  - `seagma_icon.png` — 1024×1024, logo 60%
  - `seagma_adaptive_fg.png` — 1024×1024, logo 45% (safe zone)
- Update `pubspec.yaml` untuk referensi gambar baru.
- Regenerate splash & launcher icons.

### 3. Animated Splash Screen (Phase 9)

**Problem:** Splash screen statis (icon fingerprint + text langsung muncul) terasa membosankan.

**Solution:**

- **`SplashView`:** Ekstrak `_AnimatedSplashBody` (StatefulWidget + `TickerProviderStateMixin`) dengan 3 `AnimationController`:
  - **Logo:** Fade-in + `easeOutBack` scale (1200ms)
  - **Text "SEAGMA":** Slide-up + fade (900ms, delayed 800ms)
  - **Subtitle "PRESENCE":** Staggered fade (Interval 0.4-1.0)
  - **Status/Spinner:** Delayed fade-in (700ms, delayed 1500ms total)
  - **Status text:** `AnimatedSwitcher` untuk smooth crossfade transitions
- **Native Splash:** Dihapus logo → hanya warna `#2E3D8A` (match `AppColors.primary`) agar transisi ke Flutter splash seamless.
- **`SplashController`:** Ditambahkan `Stopwatch` + `_minDisplayDuration = 4 seconds`. Splash selalu tampil minimal 4 detik meskipun check selesai lebih cepat.

**Files Modified:**

- `lib/modules/splash/splash_view.dart` (overwrite, ~320 LOC total)
- `lib/modules/splash/splash_controller.dart` (overwrite, ~100 LOC)
- `pubspec.yaml` (splash & icon config)

### 4. AuthService Stray Brace Fix

**Problem:** Brace `}` ekstra di `AuthService` menyebabkan compilation error.

**Solution:** Dihapus brace yang salah tempat di akhir `restoreSession` method.

---

## 🧪 Verification Results

| Feature              | Test Case                       | Result                                      |
| :------------------- | :------------------------------ | :------------------------------------------ |
| **Security (Root)**  | Trigger root detection          | ✅ Pesan & solusi spesifik muncul           |
| **Security (Mock)**  | Enable Fake GPS                 | ✅ Langkah perbaikan terlihat jelas         |
| **Device Binding**   | Session restore on wrong device | ✅ Red Screen + solusi 3 langkah            |
| **Solution Card**    | Long solution text              | ✅ Scrollable, tidak overflow               |
| **Splash Animation** | Cold start                      | ✅ Logo → Text → Status muncul bertahap     |
| **Splash Timing**    | Fast security check             | ✅ Tetap tampil minimal 4 detik             |
| **Native → Flutter** | App launch                      | ✅ Seamless (warna sama, tanpa logo statis) |

---

_End of Entry_

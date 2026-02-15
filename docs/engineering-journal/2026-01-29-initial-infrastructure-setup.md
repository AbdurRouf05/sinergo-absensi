# 001 - Initial Infrastructure & Build System Fixes

**Date:** 2026-01-29  
**Author:** AI Assistant (Antigravity) & N455N  
**Context:** Phase 1 Foundation Setup

---

## 1. Project Tech Stack Overview

Platform fondasi yang berhasil dikonfigurasi dan berjalan stabil pada perangkat fisik (Android 11):

- **Framework:** Flutter SDK (Stable)
- **Language:** Dart 3.x
- **Build System:** Gradle 8.5
- **Android Gradle Plugin (AGP):** 8.2.1
- **Kotlin Version:** 1.9.22
- **Database:** Isar v3.1.0+1 (Database Offline-First)

---

## 2. The "Isar vs AGP 8+" Conflict

### Masalah

Saat melakukan build `flutter run`, terjadi error fatal:
`Namespace not specified. Please specify a namespace in the module's build.gradle file like so: android { namespace 'com.example.namespace' }`

**Penyebab:**
Sejak Android Gradle Plugin (AGP) 8.0, atribut `namespace` wajib didefinisikan secara eksplisit di block `android {}` pada `build.gradle`, menggantikan atribut `package` di `AndroidManifest.xml`.
Library **Isar v3.1.0** (versi stabil saat ini) dirilis sebelum kebijakan ini diperketat dan belum mendefinisikan namespace di file gradlenya sendiri. Akibatnya, build system AGP 8+ menolak mengkompilasi modul `isar_flutter_libs` yang menjadi dependensi transitif.

### Solusi yang Gagal

1. **Downgrade Brutal:** Mencoba menurunkan AGP ke versi 7.x dan Gradle ke versi lama. Gagal karena Flutter versi terbaru membutuhkan Java 17 dan Gradle modern.
2. **Edit Manual:** Mengedit file `build.gradle` milik library Isar di dalam cache `.pub-cache`. Ini solusi sangat buruk ("Dirty Fix") karena tidak persisten (akan hilang saat `flutter clean` atau pindah mesin/CI-CD).
3. **Stubbing:** Mencoba mengganti Isar dengan Mock sementara. Ini menunda masalah, bukan menyelesaikannya.

### Solusi yang Berhasil (The Fix)

Kami melakukan **Gradle Script Injection** pada level root project (`android/build.gradle.kts`) untuk memanipulasi konfigurasi project anak (`subprojects`) saat runtime.

**Code Snippet (`android/build.gradle.kts`):**

```kotlin
subprojects {
    val project = this
    val fixIsarNamespace = {
        if (project.name == "isar_flutter_libs") {
            try {
                val android = project.extensions.findByName("android")
                if (android != null) {
                    // Reflection Magic
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "dev.isar.isar_flutter_libs") // Inject Namespace
                    println("✅ [Fix] Force injected namespace for isar_flutter_libs")
                }
            } catch (e: Exception) {
                println("⚠️ [Fix] Failed to inject namespace: ${e.message}")
            }
        }
    }

    // Pastikan dieksekusi baik jika project sudah dievaluasi maupun belum
    if (project.state.executed) {
        fixIsarNamespace()
    } else {
        project.afterEvaluate {
            fixIsarNamespace()
        }
    }
}
```

**Analisa Teknis:**

1. **Intervensi Runtime:** Script ini berjalan saat Gradle sedang mengkonfigurasi graph dependency, sebelum task kompilasi (`assembleDebug`) berjalan.
2. **Reflection:** Kita menggunakan Java Reflection untuk memanggil method `setNamespace` pada objek ekstensi Android milik modul Isar. Ini mem-bypass ketiadaan akses langsung ke source code library tersebut.
3. **State Handling:** Kita menangani kondisi `project.state.executed` untuk memastikan script tetap aman dijalankan meskipun urutan evaluasi Gradle berubah-ubah (mengatasi error `Cannot run afterEvaluate when project is already evaluated`).

---

## 3. The "Method Hallucination" Issue

### Masalah

Compiler Dart error karena `HomeController` memanggil method:

- `_locationService.detectMockLocation()`
- `_timeService.detectTimeManipulation()`

Padahal di file Service asli, method tersebut tidak ada (atau bernama lain seperti `checkFakeGPS` atau hanya private method).

### Analisa Vibe Coding ("Context Disconnect")

Fenomena ini terjadi ketika AI (Asisten) "berhalusinasi" mengenai konteks interface. Saat mengedit Controller, AI berasumsi method tersebut "seharusnya ada" secara logis untuk memenuhi kebutuhan fitur, namun lupa bahwa implementasi di layer Service belum dibuat atau diberi nama yang berbeda.

Ini adalah gap klasik antara **Intent (Niat)** dan **Implementation (Realisasi)**. AI fokus pada flow logika yang benar di satu file, tanpa menverifikasi secara ketat ketersediaan simbol di file dependensinya.

### Solusi

**Synchronized Implementation:**
Kami memaksa Service untuk mengikuti kontrak (interface) yang dibutuhkan Controller.

1. Menambahkan public method `detectMockLocation()` di `LocationService`.
2. Menambahkan public method `detectTimeManipulation()` di `TimeService`.
3. Memperbaiki struktur return type (`TrustedTimeResult`) agar getter `hour` dan `minute` tersedia publik.

---

## 4. Vibe Coding Guidelines (Lessons Learned)

Pedoman untuk kolaborasi Developer & AI di masa depan agar lebih efisien:

### Rule #1 - Infrastructure First 🏗️
>
> **"Jangan percaya AI 100% soal versi."**
Cek kompatibilitas `build.gradle` (Gradle vs AGP vs Kotlin) di awal project sebelum menulis baris kode Dart pertama. Isu infrastruktur seringkali mematikan momentum (vibe) coding.

### Rule #2 - No Lazy Fixes 🚫
>
> **"Jangan matikan library, cari root cause."**
Jika build error karena library (seperti Isar), jangan terima saran untuk menghapusnya/menggantikannya jika library itu core requirement. Paksa AI mencari solusi level sistem (seperti namespace injection), bukan solusi level aplikasi (menghapus fitur).

### Rule #3 - Consistency Check 🔗
>
> **"Perintahkan paket lengkap: Service + Consumer."**
Saat meminta fitur baru, jangan request parsial.
- ❌ *"Buat fungsi cek lokasi palsu di Service"* (Beresiko nama fungsi random).
- ✅ *"Implementasikan deteksi lokasi palsu di Service DAN update Controller untuk memanggilnya. Pastikan nama method sinkron."*

### Rule #4 - Explicit Versioning 🎯
>
> **"Sebutkan target OS di prompt awal."**
Logic permission Android 12+ (API 31) berbeda jauh dengan Android 7. Selalu sebutkan `MinSDK` atau target device di awal instruksi agar AI membangkitkan kode permission yang valid (misal: if SDK >= 31 check `isMocked`).

---

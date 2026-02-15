# 001 - Infrastructure Bootstrapping & Build System Stabilization

**Date:** 2026-01-30  
**Author:** AI Assistant & N455N  
**Context:** Phase 1 Foundation & "Dependency Hell" Resolution

---

## 1. Tech Stack Definition

Infrastructure final yang stabil untuk project Seagma Presence:

- **Framework:** Flutter (Stable Channel)
- **Language:** Kotlin 1.9.22 (Compatible with AGP 8.x)
- **Build System:** Gradle 8.5 (via Wrapper)
- **Android Gradle Plugin (AGP):** 8.2.1
- **MinSDK:** 24 (Android 7.0 Nougat)
- **Database:**
  - **Local:** Isar v3.1.0 (Offline-first NoSQL)
  - **Backend:** PocketBase (Self-hosted)
- **Maps:** OpenStreetMap (via `flutter_map`) - Google API Free

---

## 2. The "Dependency Hell" Logs

### Masalah: AGP 7.4.2 vs Flutter 3.x

Log error: `Android Gradle Plugin version (7.4.2) is lower than Flutter's minimum supported version (8.1.1)`.

**Analisa:**
Flutter versi terbaru (3.19+) memaksa penggunaan Java 17 dan Gradle modern. Template default atau konfigurasi lama yang menggunakan AGP 7.x sudah tidak didukung. Memaksa menggunakan versi lama menyebabkan chain reaction error pada dependency lain yang membutuhkan Fitur Java terbaru (seperti `desugaring`).

**Solusi:**
Upgrade paksa `android/settings.gradle.kts`:

- `com.android.application` -> **8.2.1**
- `org.jetbrains.kotlin.android` -> **1.9.22**

---

## 3. The "Lifecycle Crash" Fix

### Masalah: `Project.afterEvaluate` Crash

Error: `Cannot run Project.afterEvaluate(Action) when the project is already evaluated`.

**Analisa:**
Kami mencoba menyuntikkan namespace ke library Isar menggunakan `afterEvaluate` di `build.gradle` root.
Namun, lifecycle Gradle tidak menjamin kapan block `subprojects` dieksekusi relatif terhadap evaluasi project anak. Jika project anak (Isar) sudah selesai dievaluasi sebelum block root berjalan, memanggil `afterEvaluate` akan melempar fatal exception.

### Solusi Final: Plugin-Aware Configuration

Kami mengganti pendekatan "Timing-based" (`afterEvaluate`) menjadi "Reaction-based" (`withPlugin`).

**Code Snippet (`android/build.gradle.kts`):**

```kotlin
subprojects {
    pluginManager.withPlugin("com.android.library") {
        if (project.name == "isar_flutter_libs") {
             configure<com.android.build.gradle.LibraryExtension> {
                 namespace = "dev.isar.isar_flutter_libs"
             }
        }
    }
}
```

**Kenapa ini Works:**

1. **Reactive:** Block code hanya dijalankan *segera setelah* plugin `com.android.library` diaplikasikan ke subproject. Tidak peduli kapan itu terjadi.
2. **Type-Safe:** Menggunakan `configure<LibraryExtension>` memastikan kita mengakses properti `namespace` pada objek yang benar, bukan menebak-nebak via Reflection.
3. **Lifecycle Safe:** Tidak memanipulasi event loop Gradle (`afterEvaluate`), melainkan hook ke sistem plugin.

---

## 4. Vibe Coding Lessons

### Rule #1 - Validate `settings.gradle` First

Jangan pernah berasumsi template bawaan `flutter create` selalu *up-to-date* dengan kebutuhan library pihak ketiga. Selalu cek versi AGP dan Kotlin di `settings.gradle.kts` atau `build.gradle` root saat inisialisasi project.

### Rule #2 - Beware of Copy-Paste Scripts

Script Gradle "Hack" yang bertebaran di StackOverflow seringkali berbasis Groovy atau Gradle versi lama. Saat menggunakannya di Kotlin DSL (`.kts`) pada environment modern, pastikan untuk:

1. Mengonversi sintaks ke Kotlin DSL yang valid.
2. Menggunakan API modern (`pluginManager`) daripada API legacy (`afterEvaluate` yang rapuh).

---

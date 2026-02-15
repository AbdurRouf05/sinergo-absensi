import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.attendancefusion.app"
    // KITA KUNCI DI 35 (Android 15).
    compileSdk = 35
    buildToolsVersion = "35.0.0"

    ndkVersion = "26.1.10909125"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    defaultConfig {
        applicationId = "com.attendancefusion.app"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            // AKTIFKAN OBFUSCATION (ACAK KODE)
            isMinifyEnabled = true
            isShrinkResources = true
            
            // ATURAN PENGACAKAN
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // GUNAKAN STEMPEL DIGITAL YANG DIBUAT TADI
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

// ==================================================================
// 🛡️ THE GUARDIAN BLOCK (ANTI-ANDROID 16)
// Bagian ini memaksa Gradle membatalkan update otomatis ke versi Beta
// ==================================================================
configurations.all {
    resolutionStrategy {
        eachDependency {
            // Paksa 'androidx.core' kembali ke versi stabil 2024 (Support Android 14/15)
            // Versi 1.17.0+ meminta Android 16, kita tendang balik ke 1.13.1
            if (requested.group == "androidx.core" && requested.name.contains("core")) {
                useVersion("1.13.1")
            }
            
            // Paksa 'androidx.activity' kembali ke versi stabil
            // Versi 1.12.0+ meminta Android 16, kita tendang balik ke 1.9.0
            if (requested.group == "androidx.activity" && requested.name.contains("activity")) {
                useVersion("1.9.0")
            }

            // Paksa 'androidx.lifecycle' aman
            if (requested.group == "androidx.lifecycle" && requested.name.contains("lifecycle")) {
                useVersion("2.7.0")
            }

            // Paksa 'androidx.fragment' aman (needed by image_picker)
            if (requested.group == "androidx.fragment" && requested.name.contains("fragment")) {
                useVersion("1.7.1")
            }

            // Paksa 'androidx.appcompat' aman
            if (requested.group == "androidx.appcompat" && requested.name.contains("appcompat")) {
                useVersion("1.6.1")
            }
        }
    }
}

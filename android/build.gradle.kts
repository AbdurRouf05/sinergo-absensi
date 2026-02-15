// android/build.gradle.kts (THE SAFE NUCLEAR OPTION)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ==================================================================
// ☢️ NUCLEAR FIX: FORCE EVERYTHING ON SUBPROJECTS + SAFE STATE CHECK
// 1. Force Dependency Version (androidx.core)
// 2. Force Namespace (AGP 8)
// 3. Force Compile SDK (lStar Fix)
// ==================================================================
subprojects {
    // 1. STRATEGI RESOLUSI (Hanya core & core-ktx)
    project.configurations.all {
        resolutionStrategy {
            eachDependency {
                if (requested.group == "androidx.core") {
                    val n = requested.name
                    if (n == "core" || n == "core-ktx") {
                        useVersion("1.13.1")
                    }
                }
                if (requested.group == "org.jetbrains.kotlin") {
                     val n = requested.name
                     if (n == "kotlin-stdlib" || n == "kotlin-stdlib-jdk8" || n == "kotlin-stdlib-jdk7") {
                         useVersion("1.9.25")
                     }
                }
            }
        }
    }

    // 2. MODIFIKASI LIBRARY BANDEL (Isar, dll)
    // Gunakan logika SMART check agar tidak crash "Project already evaluated"
    val forceConfiguration = {
        // Cek apakah ini module Android Library?
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.findByName("android")!!
            
            try {
                // A. FORCE COMPILE SDK ke 34 (Agar lStar dikenali)
                val setCompileSdk = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
                setCompileSdk.invoke(android, 34)
                println("☢️ [NUCLEAR] Forced compileSdk=34 for ${project.name}")

                // B. INJECT NAMESPACE (Khusus Isar)
                if (project.name == "isar_flutter_libs") {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                    println("✅ [FIX] Namespace injected for ${project.name}")
                }
            } catch (e: Exception) {
                println("⚠️ [INFO] Could not force settings on ${project.name}: ${e.message}")
            }
        }
    }

    if (project.state.executed) {
         forceConfiguration()
    } else {
        project.afterEvaluate { forceConfiguration() }
    }
}

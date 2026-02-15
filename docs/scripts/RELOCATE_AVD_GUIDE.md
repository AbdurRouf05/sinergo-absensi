# 🛠️ Memindahkan Penyimpanan Emulator Android (AVD)

> [!IMPORTANT]
> **STATUS: COMPLETED**
> Direktori `D:\setup\Android\avd` telah dibuat dan `ANDROID_AVD_HOME` telah diatur.

Secara default, Android Studio menyimpan emulator (AVDs) di `C:\Users\%USERNAME%\.android\avd`. Jika drive C Anda penuh, ikuti langkah ini untuk memindahkannya.

## Langkah 1: Tentukan Direktori Baru

Misal kita akan menggunakan: `D:\setup\Android\avd`

## Langkah 2: Set Environment Variable

Anda perlu menambahkan variable sistem berikut:

- **Nama Variable**: `ANDROID_AVD_HOME`
- **Nilai Variable**: `D:\setup\Android\avd`

### Cara Cepat (PowerShell)

```powershell
[System.Environment]::SetEnvironmentVariable("ANDROID_AVD_HOME", "D:\setup\Android\avd", "User")
```

*Ganti path `"D:\setup\Android\avd"` dengan path yang Anda siapkan.*

## Langkah 3: Restart

Setelah mengatur variable, Anda perlu **merestart Android Studio** atau **Terminal** agar perubahan terbaca.

## Langkah 4: Buat Emulator Baru

Sekarang, setiap kali Anda membuat emulator baru melaui Device Manager, file disk-nya akan otomatis disimpan ke direktori baru tersebut.

# 🚀 SEAGMA PRESENCE - NEW DEVELOPER ONBOARDING

Selamat datang di tim developer **Seagma Presence**!
Dokumen ini berisi panduan cepat agar Anda bisa langsung berkontribusi di project ini.

---

## 📥 LANGKAH 1: DOWNLOAD SOURCE CODE

Project ini menggunakan **Git** sebagai version control.

### 1. Clone Repository (Pilih Salah Satu)

#### Opsi A: Menggunakan Antigravity (Paling Mudah)

1. Buka aplikasi **Antigravity**.
2. Di layar awal, klik tombol **Clone Repository** (Lihat gambar di bawah).
3. Masukkan URL ini:

    ```
    https://github.com/sagamuda/seagma-presensi.git
    ```

4. Pilih folder kosong di laptop Anda untuk menyimpan project ini.
5. Setelah selesai, klik **Open Folder** dan pilih folder `seagma_presensi` yang baru saja di-download.

#### Opsi B: Menggunakan Terminal (Manual)

Buka terminal/command prompt di folder kerja Anda, lalu jalankan:

```bash
git clone https://github.com/sagamuda/seagma-presensi.git
cd seagma_presensi
```

---

## 🛠️ LANGKAH 2: SETUP ENVIRONMENT

Project ini dibangun dengan **Flutter** dan menggunakan database lokal **Isar**.

### 1. Install Dependencies

Download semua library yang dibutuhkan project (internet stabil diperlukan).

```bash
flutter pub get
```

### 2. Generate Code (WAJIB!) ⚠️

Kita menggunakan library `build_runner` untuk generate kode database. Tanpa langkah ini, **aplikasi akan error alias 'merah semua'**.

```bash
dart run build_runner build --delete-conflicting-outputs
```

> *Tunggu sampai proses selesai dan muncul pesan `[INFO] Succeeded`.*

---

## 📱 LANGKAH 3: JALANKAN APLIKASI

Hubungkan HP Android (Mode Developer ON) atau Emulator.

```bash
flutter run
```

---

## 🤝 LANGKAH 4: CARA KERJA (WORKFLOW)

Kita menggunakan strategi **Direct Push** untuk kecepatan.
Agar tidak terjadi bentrok (conflict) code dengan developer lain, **WAJIB** ikuti prosedur ini:

### 🌞 Ritual Pagi (Sebelum Mulai Kerja)

Setiap pagi atau sebelum Anda mulai mengetik code, ambil update terbaru dari server:

```bash
git pull origin main
```

### 📤 Cara Kirim Pekerjaan (Push)

Setelah selesai mengerjakan fitur:

1. **Cek Status** (Pastikan file Anda benar)

    ```bash
    git status
    ```

2. **Simpan Changes (Commit)**

    ```bash
    git add .
    git commit -m "Deskripsi singkat apa yang dikerjakan"
    ```

3. **Pull Lagi (PENTING!)** - *Untuk jaga-jaga kalau ada teman yang push duluan*

    ```bash
    git pull origin main
    ```

    *Jika aman (tidak ada conflict), lanjut ke step 4.*
4. **Push ke Server**

    ```bash
    git push origin main
    ```

---

## ⛔ ATURAN PENTING (DILARANG KERAS)

1. **JANGAN PERNAH** push file `android/local.properties`. (File ini berisi path SDK laptop Anda, bukan laptop orang lain).
2. **JANGAN PERNAH** mengubah file di folder `build/`.
3. **JANGAN PERNAH** memaksa push (`git push -f`) kecuali disuruh Lead Developer.

---

## ❓ FAQ & Troubleshooting

### Q: Kenapa diminta `Password` atau `Token` saat Clone/Push?

**Jawab:**
Karena repository ini bersifat **Private**, GitHub butuh verifikasi bahwa Anda benar-benar anggota tim.
GitHub **tidak lagi mendukung password akun biasa** untuk keamanan. Anda harus menggunakan **Personal Access Token (PAT)**.

### 🛠️ Cara Membuat Token (Sekali Saja)

Jika diminta password, **JANGAN** masukkan password login GitHub Anda. Ikuti langkah ini:

1. Login ke GitHub di browser.
2. Ke **Settings** (pojok kanan atas) -> **Developer settings** (paling bawah kiri).
3. Pilih **Personal access tokens** -> **Tokens (classic)**.
4. Klik **Generate new token (classic)**.
5. Isi **Note**: "Laptop Kerja Seagma".
6. **Expiration**: Pilih "No expiration" (atau sesuai keinginan).
7. **Select scopes** (Centang Wajib):
    * [x] `repo` (Full control of private repositories)
    * [x] `workflow`
8. Klik **Generate token**.
9. **COPY Token** yang muncul (diawali `ghp_...`).
10. Paste token ini saat terminal/Antigravity meminta **Password**.

> 💡 **Tips:** Simpan token ini di tempat aman, karena tidak akan muncul lagi!

---

Selamat bekerja! 🚀

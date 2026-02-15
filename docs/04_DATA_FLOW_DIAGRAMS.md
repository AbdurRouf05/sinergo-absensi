# 📊 SEAGMA PRESENCE - Diagram Alur Data

> Dokumentasi lengkap alur data sistem SEAGMA PRESENCE

---

## 1. Alur Data Sistem Tingkat Tinggi

```mermaid
flowchart TB
    subgraph Mobile["📱 Flutter Mobile App"]
        UI[Antarmuka Pengguna]
        GetX[Controller GetX]
        InterfaceLayer{{"🔌 Interface Layer<br/>(Abstraksi)"}}
        Services[Layanan Inti]
        Isar[(Isar DB<br/>Penyimpanan Offline)]
    end
    
    subgraph Backend["☁️ Server PocketBase"]
        API[REST API]
        Auth[Autentikasi]
        PB_DB[(SQLite DB)]
        Files[Penyimpanan File]
    end
    
    subgraph External["🌐 Layanan Eksternal"]
        NTP[Server NTP]
        GPS[Satelit GPS]
    end
    
    UI --> GetX
    GetX -.->|Discover via Get.find| InterfaceLayer
    InterfaceLayer --> Services
    Services --> Isar
    Services <-->|Sync| API
    API --> Auth
    API --> PB_DB
    API --> Files
    Services --> NTP
    Services --> GPS
```

---

## 2. Alur Autentikasi & Binding Perangkat

```mermaid
sequenceDiagram
    autonumber
    participant U as 👤 User
    participant App as 📱 App
    participant DS as DeviceService
    participant PB as ☁️ PocketBase
    
    U->>App: Buka Aplikasi
    App->>DS: getDeviceId()
    DS-->>App: device_id
    
    U->>App: Login (email, password)
    App->>PB: POST /api/collections/users/auth-with-password
    PB-->>App: auth_token + user_data
    
    alt Login Pertama (Belum ada Device Terikat)
        App->>PB: PATCH /users/{id} {registered_device_id: device_id}
        PB-->>App: ✅ Perangkat Terdaftar
    else Perangkat Sudah Terikat
        alt device_id == registered_device_id
            App-->>U: ✅ Login Sukses
        else device_id != registered_device_id
            App-->>U: 🚫 DIBLOKIR - Perangkat Tidak Cocok
            Note over U,PB: User harus hubungi HR untuk reset perangkat
        end
    end
```

---

## 3. Alur Check-In Absensi

```mermaid
flowchart TB
    Start([👆 User Tap Check-In]) --> ValidateDevice{Device ID<br/>Valid?}
    
    ValidateDevice -->|❌ Tidak Cocok| BlockDevice[🚫 DIBLOKIR<br/>Hubungi HR]
    ValidateDevice -->|✅ Cocok| CheckMock{Mock Location<br/>Terdeteksi?}
    
    CheckMock -->|❌ Terdeteksi| BlockMock[🚫 DIBLOKIR<br/>Fake GPS Terdeteksi]
    CheckMock -->|✅ Bersih| CheckTime{Waktu<br/>Dimanipulasi?}
    
    CheckTime -->|❌ Terdeteksi| BlockTime[🚫 DIBLOKIR<br/>Waktu Curang]
    CheckTime -->|✅ Valid| CheckWifi{Terhubung ke<br/>WiFi Kantor?}
    
    CheckWifi -->|✅ BSSID Cocok| AutoValid[✅ OTOMATIS VALID<br/>WiFi Terverifikasi]
    CheckWifi -->|❌ Tidak Terhubung| CheckGPS{GPS di<br/>Radius Kantor?}
    
    CheckGPS -->|✅ Dalam Jangkauan| GPSValid[✅ VALID<br/>GPS Terverifikasi]
    CheckGPS -->|❌ Luar Jangkauan| BlockGPS[🚫 DIBLOKIR<br/>Di Luar Area]
    
    AutoValid --> SaveAttendance
    GPSValid --> SaveAttendance
    
    SaveAttendance[💾 Simpan Rekam Absensi] --> CheckNetwork{Internet<br/>Tersedia?}
    
    CheckNetwork -->|✅ Online| SyncServer[☁️ Sync ke PocketBase]
    CheckNetwork -->|❌ Offline| SaveLocal[(📱 Simpan ke Isar<br/>Antrean Sync)]
    
    SyncServer --> Success([✅ Check-In Selesai])
    SaveLocal --> Success
```

---

## 4. Alur Check-Out Absensi

```mermaid
flowchart TB
    Start([👆 User Mengetuk Check-Out]) --> HasCheckIn{Ada Check-In<br/>Aktif?}
    
    HasCheckIn -->|❌ Tidak| Error[⚠️ Error<br/>Tidak Ada Check-In Aktif]
    HasCheckIn -->|✅ Ya| ValidateLocation{Lokasi<br/>Valid?}
    
    ValidateLocation -->|❌ Tidak Valid| AllowAnyway{Izinkan Check-Out<br/>Di Luar Kantor?}
    AllowAnyway -->|Config: Ya| FlagAnomaly[⚠️ Tandai Anomali]
    AllowAnyway -->|Config: Tidak| BlockCheckOut[🚫 DIBLOKIR]
    
    ValidateLocation -->|✅ Valid| CalculateHours[📊 Hitung Jam Kerja]
    FlagAnomaly --> CalculateHours
    
    CalculateHours --> CheckShift{Sesuai Jam<br/>Shift?}
    
    CheckShift -->|✅ Normal| SaveCheckOut[💾 Simpan Check-Out]
    CheckShift -->|⏰ Pulang Cepat| EarlyReason[📝 Minta Alasan Pulang Cepat]
    CheckShift -->|⏰ Lembur| OvertimeCalc[📊 Hitung Lembur]
    
    EarlyReason --> SaveCheckOut
    OvertimeCalc --> SaveCheckOut
    
    SaveCheckOut --> SyncData[☁️ Sync ke Server]
    SyncData --> Success([✅ Check-Out Selesai])
```

---

## 5. Alur Data Sync Offline

```mermaid
sequenceDiagram
    autonumber
    participant App as 📱 App
    participant Isar as 💾 Isar DB
    participant Queue as 📋 Antrean Sync
    participant Net as 🌐 Monitor Jaringan
    participant PB as ☁️ PocketBase
    
    Note over App,PB: MODE OFFLINE - User Check-In
    App->>Isar: Simpan absensi (is_offline_entry: true)
    App->>Queue: Tambah ke antrean pending_sync
    
    loop Setiap 30 detik
        Net->>Net: Cek konektivitas
    end
    
    Note over App,PB: JARINGAN PULIH
    Net-->>App: 🌐 Online terdeteksi
    
    App->>Queue: Ambil item pending
    Queue-->>App: List rekaman pending
    
    loop Untuk setiap rekaman pending
        App->>PB: POST /api/collections/attendance
        alt Sukses
            PB-->>App: ✅ Dibuat (server_id)
            App->>Isar: Update rekaman (synced: true, server_id)
            App->>Queue: Hapus dari antrean
        else Konflik
            PB-->>App: ⚠️ Konflik terdeteksi
            App->>App: Terapkan resolusi konflik
            App->>PB: Coba lagi dengan data teresolusi
        else Gagal
            PB-->>App: ❌ Error
            App->>Queue: Tandai retry_count++
            Note over App: Coba lagi di siklus sync berikutnya
        end
    end
```

---

## 6. Alur Data Validasi Lokasi

```mermaid
flowchart LR
    subgraph Input["📍 Sumber Lokasi"]
        GPS[Sensor GPS]
        WiFi[Pemindai WiFi]
    end
    
    subgraph Validation["🔍 Layer Validasi"]
        MockCheck{Deteksi<br/>Mock Location}
        BSSIDCheck{Validasi<br/>BSSID}
        GeoCheck{Cek<br/>Geofence}
    end
    
    subgraph Output["📊 Hasil"]
        Valid[✅ VALID]
        Invalid[❌ INVALID]
        Reason[📝 Kode Alasan]
    end
    
    GPS --> MockCheck
    MockCheck -->|Bersih| GeoCheck
    MockCheck -->|Terdeteksi| Invalid
    
    WiFi --> BSSIDCheck
    BSSIDCheck -->|Cocok| Valid
    BSSIDCheck -->|Tidak Cocok| GeoCheck
    
    GeoCheck -->|Dalam Jangkauan| Valid
    GeoCheck -->|Luar Jangkauan| Invalid
    
    Invalid --> Reason
```

---

## 7. Alur Data Validasi Waktu

```mermaid
flowchart TB
    subgraph Sources["⏰ Sumber Waktu"]
        Device[Waktu Perangkat]
        NTP[Server NTP]
        Boot[Waktu Boot + Berlalu]
    end
    
    subgraph Validation["🔍 Validasi"]
        Compare{Bandingkan Waktu}
        Threshold{Beda > 5 menit?}
    end
    
    subgraph Result["📊 Hasil"]
        Trusted[✅ Waktu Terpercaya]
        Flagged[⚠️ Manipulasi Waktu]
    end
    
    NTP --> Compare
    Device --> Compare
    
    Compare --> Threshold
    Threshold -->|Ya| Flagged
    Threshold -->|Tidak| Trusted
    
    NTP -.->|Fallback jika tidak tersedia| Boot
    Boot --> Compare
```

---

## 8. Alur Data Pembuatan Laporan

```mermaid
flowchart TB
    subgraph Request["📝 Permintaan Laporan"]
        User[User Admin/HR]
        Params[Parameter Filter:<br/>Rentang Tanggal, Departemen, User]
    end
    
    subgraph Processing["⚙️ Pemrosesan"]
        Query[Query Data Absensi]
        Aggregate[Agregasi Statistik]
        Calculate[Hitung Metrik:<br/>- Total Jam<br/>- Jumlah Telat<br/>- Jam Lembur<br/>- Anomali]
    end
    
    subgraph Output["📤 Output"]
        Preview[Preview di App]
        PDF[Export PDF]
        Excel[Export Excel]
    end
    
    User --> Params
    Params --> Query
    Query --> Aggregate
    Aggregate --> Calculate
    
    Calculate --> Preview
    Calculate --> PDF
    Calculate --> Excel
```

---

## 9. Entity Relationship Diagram

```mermaid
erDiagram
    USERS ||--o{ ATTENDANCE : "memiliki"
    USERS ||--o{ GANAS_TICKETS : "membuat"
    USERS ||--o{ OVERTIME_REQUESTS : "mengajukan"
    USERS }o--|| DEPARTMENTS : "anggota dari"
    USERS }o--|| SHIFTS : "ditugaskan"
    
    OFFICE_LOCATIONS ||--o{ ATTENDANCE : "tercatat di"
    ATTENDANCE ||--o| OVERTIME_REQUESTS : "menghasilkan"
    
    USERS {
        string id PK
        string email
        string name
        string registered_device_id
        string office_id FK
        string shift_id FK
        string role
        list allowed_office_ids
    }
    
    ATTENDANCE {
        string id PK
        string user_id FK
        string location_id FK
        datetime check_in_time
        datetime check_out_time
        boolean is_wifi_verified
        string wifi_bssid_used
        float gps_lat
        float gps_long
        boolean is_offline_entry
        string device_id_used
        string status
        text late_reason
        file photo_url
    }
    
    OFFICE_LOCATIONS {
        string id PK
        string name
        float lat
        float long
        float radius
        json allowed_wifi_bssids
    }
    
    SHIFTS {
        string id PK
        string name
        time start_time
        time end_time
        int grace_period_minutes
    }
    
    GANAS_TICKETS {
        string id PK
        string user_id FK
        string ticket_type
        datetime valid_from
        datetime valid_until
        string reason
        string status
    }
    
    OVERTIME_REQUESTS {
        string id PK
        string user_id FK
        string attendance_id FK
        float overtime_hours
        string status
        string approved_by
    }
    
    DEPARTMENTS {
        string id PK
        string name
        string code
    }
```

---

## 10. State Machine - Status Absensi

```mermaid
stateDiagram-v2
    [*] --> NOT_CHECKED_IN
    
    NOT_CHECKED_IN --> CHECKED_IN: Check-In Sukses
    NOT_CHECKED_IN --> ABSENT: Akhir Hari (Tanpa Check-In)
    NOT_CHECKED_IN --> LEAVE: Cuti Disetujui
    
    CHECKED_IN --> CHECKED_OUT: Check-Out Sukses
    CHECKED_IN --> CHECKED_OUT_EARLY: Check-Out Cepat (Bolos)
    CHECKED_IN --> OVERTIME: Check-Out Setelah Shift
    
    CHECKED_OUT --> [*]
    CHECKED_OUT_EARLY --> [*]
    OVERTIME --> OVERTIME_APPROVED: Approval HR
    OVERTIME --> OVERTIME_REJECTED: Penolakan HR
    OVERTIME_APPROVED --> [*]
    OVERTIME_REJECTED --> [*]
    ABSENT --> [*]
    LEAVE --> [*]
    
    note right of CHECKED_IN
        Status: HADIR atau TERLAMBAT
        Tergantung waktu check-in
    end note
```

---

> **Versi Dokumen:** 1.1  
> **Terakhir Diupdate:** 06-02-2026  
> **Penulis:** AI Architect Assistant (Phase 4 Hardening)

# 🫀 MESIN SINKRONISASI "JANTUNG" (HEARTBEAT) — Diagram Status

Dokumen ini merinci mesin status (state machine) yang mengatur siklus hidup setiap catatan lokal (`AttendanceLocal`, `NotificationLocal`, `UserLocal`, `LeaveRequestLocal`), memastikan integritas data dalam lingkungan offline-first.

## Diagram Status

```mermaid
graph TD
    %% Nodes
    Start((Mulai))
    Created[Dibuat]
    Queued[Antrean]
    Uploading[Mengupload]
    Synced[Tersinkronisasi]
    Retry[Coba Lagi]
    Conflict[Konflik]
    ManualResolution[Resolusi Manual]
    Failed[Gagal]
    Discarded[Dibuang]
    End((Selesai))

    %% Transisi
    Start -->|User Check-In/Out| Created
    Created -->|SyncService.processQueue| Queued
    Queued -->|Jaringan Tersedia| Uploading
    Uploading -->|HTTP 200 OK| Synced
    Uploading -->|Error Jaringan / Timeout| Retry
    Uploading -->|HTTP 400/409/422| Conflict
    
    Synced -->|Siklus Hidup Selesai| End
    
    Retry -->|retryCount < maxRetries| Queued
    Retry -->|retryCount >= maxRetries| Failed
    
    Conflict -->|Butuh Intervensi Manusia| ManualResolution
    
    ManualResolution -->|Admin Paksa Retry| Queued
    ManualResolution -->|Admin Abaikan| Discarded
    
    Failed -->|User Manual Retry| Queued
    Failed -->|Admin Bersihkan| Discarded

    %% Styling
    classDef default fill:#ffffff,stroke:#333333,stroke-width:2px;
    classDef success fill:#d4edda,stroke:#155724,color:#155724;
    classDef warning fill:#fff3cd,stroke:#856404,color:#856404;
    classDef error fill:#f8d7da,stroke:#721c24,color:#721c24;
    classDef note fill:#f8f9fa,stroke:#666666,stroke-dasharray: 5 5,font-style:italic,font-size:12px;
    
    class Synced success;
    class Retry,ManualResolution warning;
    class Conflict,Failed,Discarded error;

    %% Catatan
    Note_Created[/"Disimpan di Isar DB<br/>isSynced = false"/] -.-> Created
    Note_Queued[/"Status: PENDING<br/>Pemicu: konektivitas/bg_fetch"/] -.-> Queued
    Note_Uploading[/"Status: IN_PROGRESS<br/>POST /api/... "/] -.-> Uploading
    Note_Synced[/"Status: COMPLETED<br/>isSynced = true"/] -.-> Synced
    Note_Retry[/"Strategi Backoff Eksponensial<br/>Max 5 menit"/] -.-> Retry
    Note_Conflict[/"Status: FAILED<br/>Alasan: Penolakan Server"/] -.-> Conflict
    Note_ManualResolution[/"Admin: Retry/Hapus"/] -.-> ManualResolution
    Note_Failed[/"Status: FAILED<br/>Setelah 3x Percobaan"/] -.-> Failed
    Note_Discarded[/"Soft Delete"/] -.-> Discarded

    class Note_Created,Note_Queued,Note_Uploading,Note_Synced,Note_Retry,Note_Conflict,Note_ManualResolution,Note_Failed,Note_Discarded note;
```

## Konfigurasi Mesin Sinkronisasi

| Parameter | Nilai | Rasional |
|-----------|-------|----------|
| **Max Retries** | 3 | Keseimbangan antara kegigihan dan baterai |
| **Base Backoff** | 1 detik | Percobaan ulang pertama cepat untuk kegagalan sesaat |
| **Max Backoff** | 5 menit | Mencegah membanjiri server saat gangguan |
| **Interval Background** | 15 menit | Batasan iOS + Mode Doze Android |
| **Ukuran Batch Antrean** | 10 rekaman | Mencegah timeout pada sinkronisasi massal |
| **Timeout Upload Foto** | 60 detik | File besar pada jaringan 3G lambat |

## Logika Backoff Eksponensial

Mekanisme percobaan ulang menggunakan strategi backoff eksponensial untuk mencegah kelebihan beban server dan menghemat baterai.

```dart
int getBackoffDuration(int retryCount) {
  // delay = min(2^retryCount * 1000, 300000) milidetik
  final delay = (1 << retryCount) * 1000; // 2^n * 1 detik
  return delay.clamp(1000, 300000); // Min 1s, Max 5 menit
}
```

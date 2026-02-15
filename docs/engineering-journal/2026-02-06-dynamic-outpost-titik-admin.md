# Engineering Journal: Phase 3 - Dynamic Outpost (Titik Admin)

**Tanggal:** 06 Februari 2026  
**Status:** Completed  
**Objective:** Mengaktifkan fitur "Titik Absen Sementara" yang dikendalikan oleh Admin secara dinamis.

## 🧠 Konsep & Solusi

Masalah utama adalah kebutuhan untuk absensi di lokasi yang tidak terdaftar (misalnya rapat mendadak di cafe atau lapangan). Solusinya adalah membiarkan Admin "memancarkan" lokasi GPS mereka sebagai authorized geofence sementara.

### Key Components:
1.  **DynamicOutpostLocal**: Isar model baru dengan `expirationTime` (TTL 4 jam).
2.  **Broadcast Security**: Mengintegrasikan `ISecurityService` pada Admin HP untuk mencegah siaran dari GPS palsu.
3.  **Dropdown Merging**: Modifikasi `OfficeSelectionManager` untuk menggabungkan `OfficeLocationLocal` (Permanen) dengan `DynamicOutpostLocal` (Sementera) secara real-time.

## 🛠️ Implementasi Teknis

### Geofence Merging Logic
Kami menggunakan `filteredOffices` list yang bersifat reaktif. Saat `loadAndFilterOffices` dipanggil, kami menyuntikkan data dari Isar `DynamicOutpostLocal`.

```dart
// Snippet dari OfficeSelectionManager
final dynamicOutposts = await _isar.getActiveDynamicOutposts();
for (var outpost in dynamicOutposts) {
  filteredOffices.add(
    OfficeLocationLocal()
      ..odId = 'outpost_${outpost.id}'
      ..name = '📡 ${outpost.name} (ADMIN)'
      ..lat = outpost.lat
      ..lng = outpost.lng
      ..radius = outpost.radius,
  );
}
```

## 🧪 Verifikasi
- **Unit Test**: 3 test case baru ditambahkan untuk validasi radius dan status aktif/expired.
- **Security**: Dicoba melakukan broadcast dengan mock GPS (Simulasi), sistem menolak sesuai ekspektasi.

## 📈 Impact
Sekarang operasional lapangan menjadi jauh lebih fleksibel tanpa mengorbankan keamanan data lokasi.

---
*Dibuat oleh Antigravity Agent*

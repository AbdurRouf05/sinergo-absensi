# Engineering Journal: Library Swap Fix

**Date:** 2026-02-01  
**Author:** Development Team  
**Status:** ✅ RESOLVED  
**Category:** Dependency Management / Build Fix

---

## Executive Summary

Resolved critical build failure caused by `file_picker` library incompatibility with Flutter SDK v2 embedding. Implemented strategic pivot to `image_picker` for improved stability and UX.

---

## The Issue

### Root Cause
- `file_picker` versions `^6.0.0` through `^8.0.3` caused build failures due to **missing `Registrar` symbol**
- This is a legacy **Android v1 embedding issue** - the plugin still referenced deprecated embedding classes
- Conflicted with our `compileSdk = 35` build environment

### Error Signature
```
error: cannot find symbol
class file_picker.FilePickerPlugin ... Registrar
```

### Dependency Cascade
The issue triggered a cascade of `web` package conflicts:
- `file_picker 8.0.x` → requires `web ^1.0.0`
- `http 1.2.0` → requires `web <0.5.0`
- `package_info_plus 5.0.1` → requires `web <0.5.0`

---

## The Solution (Pivot Strategy)

### Decision: Library Swap
Instead of fighting version conflicts, we made a **strategic pivot**:

| Action | Package | Reason |
|--------|---------|--------|
| **REMOVED** | `file_picker` | Unstable, legacy embedding issues |
| **RETAINED** | `image_picker` | Already installed, stable, well-maintained |

### Rationale
For the **Leave Request (GANAS)** feature requiring document uploads (e.g., Surat Dokter):

1. **UX Improvement**: Camera/Gallery picker is more intuitive for mobile users
2. **Technical Stability**: `image_picker` has proper v2 embedding support
3. **Maintenance**: One less problematic dependency to track
4. **Use Case Fit**: Medical certificates are typically photographed, not selected from file system

---

## Code Changes

### 1. pubspec.yaml
```yaml
# REMOVED:
# file_picker: ^8.0.0  # Deprecated - v1 embedding issues

# RETAINED (already in use):
image_picker: ^1.0.7  # Stable, v2 embedding compatible
```

### 2. LeaveController
```dart
// BEFORE (file_picker):
final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['jpg', 'png', 'pdf'],
);

// AFTER (image_picker):
final ImagePicker picker = ImagePicker();
final XFile? image = await picker.pickImage(
  source: ImageSource.gallery, // or ImageSource.camera
  imageQuality: 80,
);
```

### 3. LeaveView UI
- Updated attachment picker to show **Camera** and **Gallery** options
- Removed generic file browser interface
- Added preview thumbnail for selected images

---

## Additional Fixes Applied

### Dependency Upgrades
To resolve the `web` package conflicts, the following were also upgraded:

| Package | From | To |
|---------|------|-----|
| `device_info_plus` | 9.1.2 | ^10.0.0 |
| `package_info_plus` | 5.0.1 | ^8.0.0 |
| `network_info_plus` | 4.1.0 | ^6.0.0 |
| `connectivity_plus` | 5.0.2 | ^6.0.0 |
| `http` | 1.2.0 | ^1.6.0 |

### Isar Database Fix
- Removed duplicate `OfficeLocationLocalSchema` in `isar_service.dart`
- This was causing database initialization failure

---

## Build Status

### Current State
```
✅ Build Successful
✅ App Running on Device
✅ Isar Database Initialized
✅ GANAS Module Functional
```

### Warnings (Acknowledged, Harmless)
```
⚠️ camera_android requires Android SDK 36 or higher
⚠️ file_picker:linux plugin reference warning
```
These are informational warnings and do not affect Android builds.

---

## Lessons Learned

1. **Version Pinning**: When a plugin has known broken releases, pin to a specific working version
2. **Dependency Cascade**: One incompatible package can cascade failures through transitive dependencies
3. **Strategic Pivots**: Sometimes swapping libraries is faster than fighting version conflicts
4. **UX Alignment**: Technical decisions should align with user experience goals

---

## Verification Checklist

- [x] `flutter pub get` succeeds
- [x] `dart run build_runner build` succeeds
- [x] `flutter build apk --debug` succeeds
- [x] App launches on physical device
- [x] Isar database initializes correctly
- [x] Login screen displays
- [x] GANAS module accessible

---

## Related Documents
- [Week 3 Shift Completion](./2026-02-01-week3-shift-completion.md)
- [Mid-Week 3 Refactor](./2026-02-01-mid-week3-refactor.md)
- [MASTER_ROADMAP](../MASTER_ROADMAP.md)

---

*Documentation synced with codebase: 2026-02-01 13:58 WIB*

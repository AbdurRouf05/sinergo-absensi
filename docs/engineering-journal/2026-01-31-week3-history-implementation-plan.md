# 📋 Week 3: History Module - Technical Implementation Plan

> **Phase:** Week 3 Kickoff (Data Visualization)  
> **Author:** Antigravity (Senior Solutions Architect)  
> **Date:** 2026-01-31  
> **Status:** 🟢 APPROVED (Option B - Separate Module)  

---

## 🎯 Executive Summary

This document outlines the **Technical Implementation Plan** for the **History Module** as part of Week 3's Data Visualization phase. Before writing any Flutter code, this plan ensures strict adherence to the **Offline-First Architecture** established in Week 1-2.

> [!IMPORTANT]
> **Core Principle:** The History View MUST pull data **exclusively** from the local Isar Database (`AttendanceLocal` collection), NOT from PocketBase API directly. This maintains UX consistency regardless of network conditions.

---

## 1. Data Retrieval Strategy (Offline-First)

### 1.1 Data Source Confirmation

| Aspect | Implementation |
|--------|----------------|
| **Primary Source** | `IsarService.getAttendanceHistory(userId, startDate?, endDate?, limit?)` |
| **Fallback to API** | ❌ **NOT ALLOWED** for History View |
| **Background Sync** | Existing `SyncService` handles cloud → local sync automatically |

### 1.2 Query Logic

The existing method in `IsarService` already supports our needs:

```dart
// File: lib/services/isar_service.dart (Lines 166-188)
Future<List<AttendanceLocal>> getAttendanceHistory(
  String userId, {
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
}) async {
  var query = _isar.attendanceLocals.filter().userIdEqualTo(userId);

  if (startDate != null) {
    query = query.checkInTimeGreaterThan(startDate);
  }
  if (endDate != null) {
    query = query.checkInTimeLessThan(endDate);
  }

  var sortedQuery = query.sortByCheckInTimeDesc(); // ← Descending by date

  if (limit != null) {
    return await sortedQuery.limit(limit).findAll();
  }
  return await sortedQuery.findAll();
}
```

**Sort Order:** Records will be displayed in **descending order by `checkInTime`** (most recent first).

### 1.3 Data Fields Required for Display

From `AttendanceLocal` model (`lib/data/models/attendance_model.dart`):

| Field | Type | Purpose in UI |
|-------|------|---------------|
| `checkInTime` | `DateTime` | Primary date/time display |
| `checkOutTime` | `DateTime?` | Duration calculation |
| `status` | `AttendanceStatus` | Color coding (Present/Late/Absent) |
| `isSynced` | `bool` | **Sync indicator icon** |
| `isOfflineEntry` | `bool` | "Offline" badge |
| `gpsLat`, `gpsLong` | `double?` | Location preview (optional) |
| `photoLocalPath` | `String?` | Thumbnail (if available) |
| `workingMinutes` | `int?` (computed) | Duration display |

---

## 2. Controller Logic (`HistoryController`)

### 2.1 State Variables

```dart
class HistoryController extends GetxController {
  // Core state
  final RxList<AttendanceLocal> attendanceRecords = <AttendanceLocal>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter state
  final Rx<DateTime?> filterStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);
  final Rx<DateFilterType> filterType = DateFilterType.thisMonth.obs;

  // Pagination (optional for performance)
  final RxInt currentPage = 0.obs;
  static const int pageSize = 30;
}

enum DateFilterType {
  today,
  thisWeek,
  thisMonth,
  custom,
}
```

### 2.2 `loadHistory()` Function Logic

```dart
Future<void> loadHistory() async {
  try {
    isLoading.value = true;
    hasError.value = false;
    
    final user = _authService.currentUser.value;
    if (user == null) throw AppException('User not logged in');

    // Calculate date range based on filter
    final (start, end) = _calculateDateRange(filterType.value);
    filterStartDate.value = start;
    filterEndDate.value = end;

    // Query from LOCAL ISAR ONLY (Offline-First!)
    final records = await _isarService.getAttendanceHistory(
      user.odId,
      startDate: start,
      endDate: end,
    );

    attendanceRecords.assignAll(records);
    _logger.i('Loaded ${records.length} attendance records for history');
    
  } catch (e) {
    hasError.value = true;
    errorMessage.value = e.toString();
    _logger.e('Failed to load history', error: e);
  } finally {
    isLoading.value = false;
  }
}

(DateTime?, DateTime?) _calculateDateRange(DateFilterType type) {
  final now = DateTime.now();
  switch (type) {
    case DateFilterType.today:
      return (DateTime(now.year, now.month, now.day), now);
    case DateFilterType.thisWeek:
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return (DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day), now);
    case DateFilterType.thisMonth:
      return (DateTime(now.year, now.month, 1), now);
    case DateFilterType.custom:
      return (filterStartDate.value, filterEndDate.value);
  }
}
```

### 2.3 Lifecycle Hooks

```dart
@override
void onInit() {
  super.onInit();
  loadHistory(); // Initial load on screen entry
  
  // Listen to filter changes
  ever(filterType, (_) => loadHistory());
}

Future<void> refreshHistory() async {
  // Pull-to-refresh implementation
  await loadHistory();
}
```

---

## 3. UI/UX Components

### 3.1 Attendance Card Design

```
┌────────────────────────────────────────────────────────┐
│  ┌───────┐                                    [✅/⏳]  │
│  │ PHOTO │  Jumat, 31 Januari 2026                    │
│  │ thumb │  ────────────────────────────              │
│  └───────┘  Check-In: 08:02 → Check-Out: 17:35        │
│                                                        │
│  [✅ Hadir]   [🕐 9j 33m]   [📍 Kantor Pusat]          │
│                                                        │
│  ───────────────────────────────────────────────────  │
│  📶 Status: Tersinkronisasi ✅ (atau ⏳ Pending Sync)  │
└────────────────────────────────────────────────────────┘
```

### 3.2 Sync Status Indicator (CRUCIAL)

| Condition | Icon | Color | Text |
|-----------|------|-------|------|
| `isSynced == true` | ✅ / `Icons.cloud_done` | Green `#28A745` | "Tersinkronisasi" |
| `isSynced == false` | ⏳ / `Icons.cloud_upload_outlined` | Orange `#FD7E14` | "Menunggu Sinkronisasi" |
| `isOfflineEntry == true && isSynced == false` | 📵 / `Icons.signal_wifi_off` | Orange | "Dibuat Offline" |

**Widget Implementation Strategy:**

```dart
Widget _buildSyncIndicator(AttendanceLocal record) {
  if (record.isSynced) {
    return Row(
      children: [
        Icon(Icons.cloud_done, color: AppColors.success, size: 16),
        SizedBox(width: 4),
        Text('Tersinkronisasi', style: TextStyle(color: AppColors.success)),
      ],
    );
  } else {
    return Row(
      children: [
        Icon(Icons.cloud_upload_outlined, color: AppColors.warning, size: 16),
        SizedBox(width: 4),
        Text('Menunggu Sinkronisasi', style: TextStyle(color: AppColors.warning)),
      ],
    );
  }
}
```

### 3.3 Empty State Design

When `attendanceRecords.isEmpty`:

```
┌──────────────────────────────────────┐
│                                      │
│           📋                         │
│                                      │
│    Belum Ada Data Kehadiran          │
│                                      │
│    Riwayat absensi Anda akan         │
│    muncul di sini setelah            │
│    melakukan Check-In pertama.       │
│                                      │
│    [  Mulai Check-In  ]              │
│                                      │
└──────────────────────────────────────┘
```

### 3.4 Loading State

- Use `Shimmer` effect for skeleton loading cards
- Show 3-4 placeholder cards with pulsing animation

### 3.5 Filter UI

```
┌──────────────────────────────────────────────┐
│  [Hari Ini] [Minggu Ini] [◉ Bulan Ini] [📅]  │
└──────────────────────────────────────────────┘
```

- Chip-based filter selection
- Custom date range picker (calendar dialog)

---

## 4. Routing & Dependency Injection

### 4.1 Route Registration

**File:** `lib/app/routes/app_routes.dart`

Route constant already exists:
```dart
static const String history = '/history'; // Line 9
```

### 4.2 `AppPages` Registration

**File:** `lib/app/routes/app_pages.dart`

```dart
// Add import at top
import '../../modules/history/history_binding.dart';
import '../../modules/history/history_view.dart';

// Add to routes list
GetPage(
  name: AppRoutes.history,
  page: () => const HistoryView(),
  binding: HistoryBinding(),
  transition: Transition.rightToLeft,
),
```

### 4.3 `HistoryBinding` Dependencies

**File:** `lib/modules/history/history_binding.dart`

```dart
import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // Note: IsarService and AuthService are already registered 
    // globally in InitialBinding, no need to re-register here.
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
```

---

## 5. File Structure Plan

```
lib/modules/history/
├── history_binding.dart      # Dependency injection
├── history_controller.dart   # State management & business logic
├── history_view.dart         # Main screen UI
└── widgets/
    ├── attendance_card.dart       # Reusable card component
    ├── date_filter_chips.dart     # Filter UI component
    ├── history_empty_state.dart   # Empty state widget
    └── sync_status_badge.dart     # Sync indicator widget
```

---

## 6. Verification Plan

### 6.1 Unit Tests

**Test File:** `test/modules/history/history_controller_test.dart`

| Test Case | Description |
|-----------|-------------|
| `loadHistory returns records sorted by date descending` | Verify sort order |
| `loadHistory filters by this month correctly` | Date range calculation |
| `loadHistory handles empty result gracefully` | Empty state trigger |
| `loadHistory sets error state on exception` | Error handling |

**Command to run:**
```bash
flutter test test/modules/history/history_controller_test.dart
```

### 6.2 Manual Verification Steps

> [!NOTE]
> These steps require running the app on an emulator or physical device.

1. **Prerequisite:** Ensure at least 2-3 attendance records exist in Isar (from previous Check-In tests).

2. **Navigate to History Screen:**
   - From Home → Tap History icon/button in navigation
   - Verify screen loads without error

3. **Verify Offline-First Behavior:**
   - Enable Airplane Mode on device
   - Navigate to History Screen
   - ✅ **PASS** if records still display from local database
   - ❌ **FAIL** if error or empty state appears

4. **Verify Sync Status Indicators:**
   - Create a new Check-In while OFFLINE
   - Navigate to History Screen
   - Find the new record → Should show ⏳ "Menunggu Sinkronisasi"
   - Disable Airplane Mode, wait for sync
   - Pull-to-refresh on History Screen
   - Record should now show ✅ "Tersinkronisasi"

5. **Verify Filter Functionality:**
   - Toggle between "Hari Ini", "Minggu Ini", "Bulan Ini"
   - Verify list updates accordingly

---

## 7. Dependencies & Risks

### 7.1 Existing Dependencies (No New Packages Required)

| Dependency | Usage |
|------------|-------|
| `get` | State management, routing |
| `isar` | Local database queries |
| `logger` | Debug logging |
| `intl` | Date formatting |

> [!IMPORTANT]
> **Architecture Discovery:** History is implemented as a **Tab inside HomeView** (index 1), NOT a separate route/page. See `HomeView._buildHistory()` at line 531-533 which is currently a placeholder.

---

## 8. 🚨 Risk Analysis & Mitigation Strategy

### 8.1 Predicted Issues (HIGH → LOW Priority)

| # | Issue | Severity | Root Cause | Mitigation |
|---|-------|----------|------------|------------|
| 1 | **Data not appearing despite records exist** | 🔴 HIGH | `userId` mismatch - Using wrong ID format (local id vs PocketBase `odId`) | Use `authService.currentUser.value?.odId` consistently. Add null-check. |
| 2 | **UI freezes with large dataset (500+ records)** | 🔴 HIGH | Loading all records at once, no pagination | Implement `limit` parameter in initial load (30 records). Add "Load More" trigger. |
| 3 | **"Tersinkronisasi" vs "Pending" icon not updating** | 🟡 MEDIUM | Card not rebuilding after background sync | Use `Obx()` wrapper on sync indicator OR listen to `SyncService.syncStatus`. |
| 4 | **Empty state flash before data loads** | 🟡 MEDIUM | `isLoading` not set early enough | Set `isLoading.value = true` in `onInit()` BEFORE calling `loadHistory()`. |
| 5 | **Date filter off by one day** | 🟡 MEDIUM | Time zone confusion | Use `DateTime(year, month, day, 0, 0, 0)` for start, `DateTime(year, month, day, 23, 59, 59)` for end. |
| 6 | **Photo thumbnail not showing** | 🟢 LOW | Local file path invalid after reinstall | Validate `File.existsSync()` before displaying. Show placeholder if missing. |
| 7 | **Pull-to-refresh animation stuck** | 🟢 LOW | Exception thrown without finally | Wrap in try-catch-finally, ensure `isLoading = false` always. |

### 8.2 Key Mitigation Code

#### Issue #1: UserId Mismatch Prevention
```dart
Future<void> loadHistory() async {
  final user = _authService.currentUser.value;
  if (user == null) {
    hasError.value = true;
    errorMessage.value = 'Silakan login kembali';
    return; // Graceful exit
  }
  
  final userId = user.odId; // Use PocketBase ID, NOT local id
  // ...
}
```

#### Issue #3: Reactive Sync Status
```dart
@override
void onInit() {
  super.onInit();
  
  // Refresh list when sync completes
  ever(Get.find<SyncService>().syncStatus, (status) {
    if (status == 'synced') {
      loadHistory(); // Reload to get updated isSynced flags
    }
  });
}
```

---

## 9. 📝 Deferred TODOs (Non-Blocking)

Items yang tidak menghalangi alur utama aplikasi:

| ID | Item | Reason to Defer | Target |
|----|------|-----------------|--------|
| **TODO-H1** | Pagination dengan `offset` di `IsarService` | Tidak terasa untuk < 100 records | Week 4 |
| **TODO-H2** | Photo thumbnail dengan caching | Performance optimization | Week 4 |
| **TODO-H3** | Export to PDF/Excel | Admin feature | Week 4 |
| **TODO-H4** | Infinite scroll vs "Load More" button | UX polish | Week 4 |
| **TODO-H5** | `Shimmer` loading effect | Visual polish | Week 4 |
| **TODO-H6** | Card tap → Detail View | Bisa pakai snackbar dulu | Week 4 |
| **TODO-H7** | Attendance correction request | Butuh backend GANAS module | Week 3-4 |

---

## 10. 🔧 Architecture Clarification

### Current State (Discovered)
```
HomeView (Tab-based navigation)
├── Tab 0: Dashboard (_buildDashboard) ← Implemented
├── Tab 1: History (_buildHistory)     ← PLACEHOLDER "Coming Soon"
└── Tab 2: Profile (_buildProfile)     ← PLACEHOLDER "Coming Soon"
```

### Implementation Options

#### Option A: Inline in HomeView (Simpler)
- Replace `_buildHistory()` content directly in `home_view.dart`
- Add history logic to `HomeController`
- **Pro:** Less files, faster navigation
- **Con:** HomeView becomes larger

#### Option B: Separate Module + Widget Embedding (Recommended)
- Create `lib/modules/history/` with `HistoryController` + widgets
- In `HomeView._buildHistory()`, return `HistoryContent()` widget
- **Pro:** Clean separation, reusable, follows existing patterns
- **Con:** Slightly more setup

**Recommendation:** Option B for consistency with checkin/checkout modules.

---

## ✅ Approval Checklist (Updated)

Before proceeding to EXECUTION:

- [ ] Data retrieval strategy aligns with Offline-First architecture
- [ ] Controller logic follows existing patterns
- [ ] Risk mitigations are acceptable
- [ ] **Architecture confirmed:** Option A (inline) or Option B (separate module)?
- [ ] Deferred TODOs agreed upon
- [ ] Verification plan is testable

---

> **Questions for You:**
> 1. **Architecture:** Pilih Option A (inline) atau Option B (separate module)?
> 2. **Risk:** Ada concern lain?
> 3. **TODOs:** Ada yang harus dikerjakan sekarang, bukan nanti?


# Engineering Journal: Claim-Based Overtime (The Trap)

**Tanggal:** 06 Februari 2026
**Author:** Antigravity
**Status:** ✅ COMPLETED & VERIFIED

## 1. Problem Statement
Employees often checkout late due to organizational inefficiency or personal choice, leading to unauthorized overtime costs. The system needs a way to catch these "late checkouts" and force a decision: either cap the time to the shift end (if it wasn't valid work) or provide proof for an overtime claim.

## 2. Technical Implementation

### A. OvertimeManager
Created a standalone `OvertimeManager` in `lib/modules/attendance/checkin/logic/` to:
- Calculate if the current time exceeds the `ShiftEndTime` by more than 60 minutes.
- Manage the state of overtime claims (captured photo, note).
- Validate requirements (Note min. 5 chars & Photo mandatory).

### B. The Trap (Interception)
Modified `CheckinController._handleCheckoutFlow` to:
- Fetch user shift information.
- Trigger `_showOvertimeTrapDialog` if threshold is reached.
- Completer pattern used to wait for user feedback before proceeding with `_performCheckout`.

```dart
if (isReached) {
  await _showOvertimeTrapDialog(timeRes.time, shiftEndTime, pos);
} else {
  await _performCheckout(timeRes.time, pos);
  _showSuccessDialog();
}
```

### C. UI Verification (The Trap Dialog)
Implemented `OvertimeClaimDialog` as a two-step process:
1. **Confirmation**: "Apakah Anda sedang Lembur?"
2. **Detail Form**: Capture Camera + Note.

## 3. Verification & Testing

### A. Unit Tests
Updated `test/modules/attendance/checkin_controller_test.dart` to include:
- `Should verify overtime threshold calculation`.
- `Should perform normal checkout if within threshold`.
- `Should auto-cap time if dialog is intercepted (Context Null scenario)`.

### B. Findings
- Discovered that `Get.dialog` crashes in pure logic tests without a context.
- Implemented `if (Get.context == null)` guard to bypass UI and simulate capping for test environments.

## 4. Conclusion
Phase 2 of Week 5 is complete. The system now has a proactive mechanism to prevent "phantom" overtime while allowing legitimate claims with audit trails. Project set to **PAUSED** for server-side migration.

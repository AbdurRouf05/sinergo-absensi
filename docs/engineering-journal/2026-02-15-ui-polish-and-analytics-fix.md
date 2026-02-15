# Engineering Journal: UI Polish & Analytics Timezone Fixes

**Date:** 2026-02-15
**Author:** AbdurRouf05 (Assisted by Antigravity)

## 🎯 Objectives

1.  **Fix Analytics Accuracy:** Users reported "Today's" leave not appearing in Admin Recap during early morning hours.
2.  **Polish UI:** User reported "messy" dropdowns and "too big" text on Home screen.
3.  **Security/UX:** User requested confirmation before logout.
4.  **Dynamic Data:** Profile and Home screens were showing static/default data for Shift and Office.

---

## 🛠️ Technical Implementation

### 1. Analytics Timezone Fix (The "UTC Morning" Bug)

**Issue:**

- PocketBase stores dates in UTC.
- "Today" starts at 00:00 UTC (07:00 WIB).
- Checking analytics at 06:30 WIB meant comparing against a "future" time (00:00 UTC), so today's leaves were excluded.
- Logic uses `DateTime.now()` which was problematic for start-of-day comparisons.

**Solution:**

- Modified `AnalyticsController` to use **Full Day Range** (`00:00:00` local to `23:59:59` local).
- Converted local start/end times to UTC _after_ defining the full day window.
- This ensures any event happening "today" (even if 00:00 UTC is technically 07:00 WIB) is captured because the query covers the entire 24h block.

### 2. UI Polish: Employee Detail Dropdown

**Issue:**

- The "Shift Kerja" dropdown had a double border (Container + InputDecoration) and redundant "Shift Kerja" label inside the box.
- User described it as "messy".

**Solution:**

- **Refactoring:** Removed the outer `Container`.
- **Styling:** Used standard `OutlineInputBorder` with `contentPadding` for a cleaner, native look.
- **Typography:** Removed the floating label when a value is selected to reduce visual noise.

### 3. UI Polish: Home Shift Display

**Issue:**

- The Shift text on Home screen (e.g., "Regular Shift (08:00 - 17:00)") was one long line, causing overflow or looking "too big and messy".
- Also displayed `-` because it was checking the wrong ID (`shiftId` instead of `shiftOdId`).

**Solution:**

- **Logic Fix:** Changed null check to use `shiftOdId` (PocketBase ID).
- **Typography:** Implemented **Auto-Split Logic**.
  - Checks for parentheses `()`.
  - Splits Name (Line 1) and Time (Line 2).
  - Reduced font size: Name (14pt Bold), Time (12pt Medium).
  - Center alignment for better balance.

### 4. Logout Confirmation

**Issue:**

- Clicking "Keluar Aplikasi" immediately logged the user out. Accidental clicks were annoying.

**Solution:**

- **Interceptor:** Added `Get.defaultDialog` in `ProfileActionSection`.
- **UX:** "Apakah Anda yakin?" with **Red** "Ya, Keluar" button (Destructive Action pattern).

### 5. Dynamic Profile & Home Data

**Issue:**

- Profile and Home screens showed "Non-Shift" or "Belum Diatur" despite user having data.
- **Root Cause:** The `expand` parameter used old legacy keys (`assigned_shift`, `assigned_office_location`) instead of the correct schema keys (`shift`, `office_id`).

**Solution:**

- Updated `ProfileDataManager` and `HomeDataManager`.
- **Correct Key:** `expand: 'shift,office_id'`.
- **Fallback:** Added logic to try legacy keys if primary keys return null (backward compatibility).

---

## 🧪 Verification Results

| Feature        | Test Case               | Result                                         |
| :------------- | :---------------------- | :--------------------------------------------- |
| **Analytics**  | Check Recap at 06:00 AM | ✅ Shows "Today's" leave correctly             |
| **Dropdown**   | Employee Detail View    | ✅ Clean single border, no overlap             |
| **Home Shift** | Long Shift Name         | ✅ Split into 2 lines, centered, readable      |
| **Logout**     | Click Logout            | ✅ Dialog appears, Cancel works, Confirm works |
| **Profile**    | View Profile            | ✅ Shows real Shift & Office name              |

## 📝 Next Steps

- Monitor for any other "timezone" related issues in reports (e.g., weekly/monthly recaps).
- Continual UI hardening based on user feedback.

---

_End of Entry_

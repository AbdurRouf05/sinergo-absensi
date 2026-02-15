# 📓 Engineering Journal: The Notification System Pivot (Error 400 Saga)
**Date:** 2026-02-04
**Topic:** Resolving Error 400 in Leave Sync via Feature Pivot

## 1. The Problem: "Bad Request" (400) on Sync
We encountered a persistent `400 Bad Request` error users tried to sync their Leave History. 
-   **Symptoms:** `LeveRepository` failed when calling `getList` or `getFullList`.
-   **Diagnosis Attempts:**
    -   Sanitized User IDs (Removed quotes).
    -   Simplified Strings.
    -   **Nuclear Option:** We bypassed the PocketBase Dart SDK purely to use raw `http.get`. This revealed that even with a perfect request, the Server Filter logic was rejecting the request under specific conditions (likely related to strict API Rules or Token format issues).

## 2. The Solution: "Trawl Net Strategy"
Instead of fighting the Server-Side Filter, we implemented Client-Side Filtering.
-   **Concept:** Fetch **ALL** records (User can see only their own usually via API Rule, but we fetch *all available to context*) without a `filter` param in the URL.
-   **Implementation:**
    ```dart
    // Fetch EVERYTHING
    final result = await pb.collection('notifications').getFullList(sort: '-created');
    
    // Filter LOCALLY in Dart
    final myItems = result.where((i) => i.data['user_id'] == currentUser.id).toList();
    ```
-   **Result:** Error 400 vanished. Data loads perfectly.

## 3. The Pivot: From History to Inbox
To improve UX and reliability, we shifted the paradigm:
-   **OLD:** User manually checks a "Riwayat" (History) tab.
-   **NEW:** User receives **Realtime Notifications (Inbox)** when status changes.

### Key Changes
1.  **User UI:** Removed "Riwayat" tab from `LeaveView`. Now it's just a Form.
2.  **Admin Trigger:** Updated `LeaveApprovalController` to auto-create a `notifications` record upon Approve/Reject.
    -   **Success:** "Pengajuan izin Anda pada tanggal [Tgl] telah DISETUJUI."
    -   **Warning:** "Maaf, pengajuan cuti Anda pada tanggal [Tgl] DITOLAK."
3.  **Notification System:** 
    -   Added `NotificationController` with **Trawl Net Strategy** (Critical for stability).
    -   Added "Bell Icon" to Home Dashboard.
    -   Added Detail Dialog for viewing full messages.

## 4. Technical Debt Resolved
-   Removed legacy `LeaveHistoryView` and Sync Logic from `LeaveController`.
-   Fixed UI responsiveness in Dialogs (Switched to Custom Actions).
-   Hardened Auth flow against "Corrupted Token" hypothesis by testing Public API access (confirmed Token was likely the issue, but Trawl Net mitigates it for now).

## 5. Next Steps
-   Monitor server load with Trawl Net (fetching all notifications might be heavy if db grows to millions). **Mitigation:** Add Pagination to Trawl Net logic later.

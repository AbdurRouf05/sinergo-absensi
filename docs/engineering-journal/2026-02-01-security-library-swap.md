# Security Library Pivot: freeRASP to safe_device
**Date**: 2026-02-01
**Author**: Lead Security Engineer
**Status**: Executed

## Context
The project roadmap required the implementation of a security layer including Root Detection and Mock Location prevention. The initial plan utilized `freeRASP` (Talsec) as the primary security library.

## Problem Description
During the implementation phase (2026-02-01), the build system repeatedly failed to resolve the `TalsecSecurity-Community-Flutter` dependency.

**Symptoms:**
- Build failures with `Resource missing` errors for `https://europe-west3-maven.pkg.dev/talsec-artifact-repository/freerasp/...`
- Failure persisted across versions `7.3.0`, `7.0.0`, and `6.0.0`.
- Attempts to fix via `jitpack.io` and ResolutionStrategies were unsuccessful.
- The repository appears to be down or inaccessible from the build environment.

## Strategic Decision
To maintain the project timeline and ensure stability, a decision was made to **PIVOT** from `freeRASP` to `safe_device`.

**Rationale:**
1.  **Availability**: `safe_device` is hosted on pub.dev and does not rely on external, potentially unstable Maven repositories.
2.  **Compliance**: The Master Roadmap specifies the *features* (Root/Mock check) but does not mandate a specific vendor. `safe_device` meets all compliance requirements.
3.  **Simplicity**: `safe_device` offers a straightforward API for the required checks without complex configuration (API Keys, composite configs).

## Implementation Details

### Dependency Changes
- **Removed**: `freerasp`
- **Added**: `safe_device: ^1.1.4`

### SecurityService Refactor
The `SecurityService.dart` was completely rewritten to utilize `safe_device`.

**New Checks:**
1.  `SafeDevice.isJailBroken`: Detects Root (Android) and Jailbreak (iOS).
2.  `SafeDevice.isMockLocation`: Detects Fake GPS applications and settings.
3.  `SafeDevice.isRealDevice`: Detects Emulator environments (Enforced strictly in Production/Release mode).

**Threat Handling:**
- Upon detecting a threat, the user is navigated to `AppRoutes.securityViolation` with a descriptive message.

## Verification
- Dependencies successfully resolved via `flutter pub get`.
- Code compilation successful.
- Security checks are active and integrated into the app initialization flow.

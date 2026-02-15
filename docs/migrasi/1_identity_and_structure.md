# TASK A: Identity & Structure Scan

> Audit Date: 2026-02-15
> Auditor: Antigravity (Automated)
> Source: `d:\coding\flutter\presensi\seagma-presensi`

---

## 1. Project Identity (pubspec.yaml)

| Field           | Value                    |
| --------------- | ------------------------ |
| **name**        | `seagma_presensi`        |
| **description** | Aplikasi Presensi Seagma |
| **version**     | `0.1.0+1`                |
| **Dart SDK**    | `>=3.2.0 <4.0.0`         |
| **publish_to**  | `none`                   |

---

## 2. Android Build Config (android/app/build.gradle.kts)

| Field                 | Value                              |
| --------------------- | ---------------------------------- |
| **applicationId**     | `com.seagma.seagma_presence`       |
| **namespace**         | `com.seagma.seagma_presence`       |
| **compileSdk**        | `35`                               |
| **minSdk**            | `24`                               |
| **targetSdk**         | `35`                               |
| **buildToolsVersion** | `35.0.0`                           |
| **ndkVersion**        | `26.1.10909125`                    |
| **Java Compat**       | `17`                               |
| **Release Signing**   | `key.properties` (external file)   |
| **ProGuard**          | Enabled (minify + shrinkResources) |

> [!CAUTION]
> File `Seagma_Keystore_BACKUP.zip` ditemukan di root project. **WAJIB DIHAPUS** sebelum dipublikasikan untuk lomba.

---

## 3. Dependencies

### Production Dependencies

| Package                | Version  | Category     |
| ---------------------- | -------- | ------------ |
| get                    | 4.6.6    | Core & State |
| intl                   | 0.19.0   | Core         |
| cupertino_icons        | 1.0.8    | Core         |
| isar                   | ^3.1.0   | Database     |
| isar_flutter_libs      | ^3.1.0   | Database     |
| path_provider          | ^2.1.5   | Database     |
| geolocator             | 11.0.0   | Hardware     |
| permission_handler     | 11.3.0   | Hardware     |
| image_picker           | 1.0.7    | Hardware     |
| device_info_plus       | ^10.0.0  | Plus Plugins |
| package_info_plus      | ^8.0.0   | Plus Plugins |
| network_info_plus      | ^6.0.0   | Plus Plugins |
| connectivity_plus      | ^6.0.0   | Plus Plugins |
| flutter_secure_storage | ^10.0.0  | Services     |
| safe_device            | ^1.1.4   | Services     |
| workmanager            | ^0.9.0+3 | Services     |
| flutter_map            | 6.1.0    | Maps         |
| latlong2               | 0.9.1    | Maps         |
| ntp                    | 2.0.0    | Utils        |
| uuid                   | 4.3.3    | Utils        |
| image                  | ^4.1.7   | Utils        |
| flutter_image_compress | ^2.1.0   | Utils        |
| cached_network_image   | ^3.3.1   | Utils        |
| pocketbase             | 0.19.0   | Backend      |
| http                   | ^1.6.0   | Backend      |
| flutter_dotenv         | ^6.0.0   | Backend      |
| month_picker_dialog    | ^6.7.1   | Backend      |
| logger                 | any      | Logging      |
| crypto                 | any      | Security     |
| pdf                    | ^3.11.3  | Export       |
| printing               | ^5.14.2  | Export       |
| csv                    | ^7.1.0   | Export       |
| share_plus             | ^12.0.1  | Sharing      |
| open_filex             | ^4.7.0   | File Opener  |

### Dev Dependencies

| Package                | Version |
| ---------------------- | ------- |
| flutter_test           | SDK     |
| flutter_lints          | 3.0.1   |
| mockito                | 5.4.4   |
| isar_generator         | 3.1.0+1 |
| flutter_native_splash  | ^2.3.10 |
| build_runner           | ^2.4.13 |
| flutter_launcher_icons | ^0.13.1 |

### Dependency Overrides

| Package                          | Forced Version | Reason                 |
| -------------------------------- | -------------- | ---------------------- |
| sqflite_android                  | 2.4.0          | API 36 build error fix |
| flutter_plugin_android_lifecycle | 2.0.33         | V2 Embedding fix       |

---

## 4. Folder Structure (lib/)

```
lib/
├── main.dart
├── app/
│   ├── bindings/
│   │   └── initial_binding.dart
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── dark_theme.dart
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── app_exceptions.dart
│   ├── utils/
│   │   └── geo_utils.dart
│   └── widgets/
│       └── base_network_image.dart
├── data/
│   ├── managers/
│   │   └── session_manager.dart
│   ├── mappers/
│   │   └── user_mapper.dart
│   ├── models/
│   │   ├── attendance_model.dart (+.g.dart)
│   │   ├── daily_recap_model.dart (+.g.dart)
│   │   ├── dynamic_outpost_model.dart (+.g.dart)
│   │   ├── leave_request_model.dart (+.g.dart)
│   │   ├── notification_model.dart (+.g.dart)
│   │   ├── office_location_model.dart (+.g.dart)
│   │   ├── shift_model.dart (+.g.dart)
│   │   ├── sync_queue_model.dart (+.g.dart)
│   │   ├── time_result_model.dart
│   │   ├── user_model.dart (+.g.dart)
│   │   └── dto/
│   │       ├── admin_recap_dto.dart
│   │       ├── monthly_stats_dto.dart
│   │       └── recap_row_model.dart
│   ├── providers/
│   │   └── auth_provider.dart
│   └── repositories/
│       ├── admin_action_repository.dart
│       ├── admin_analytics_repository.dart
│       ├── admin_repository.dart
│       ├── attendance_repository.dart
│       ├── dynamic_outpost_repository.dart
│       ├── leave_repository.dart
│       ├── interfaces/
│       │   └── i_admin_repository.dart
│       └── local/
│           ├── attendance_local_repository.dart
│           ├── dynamic_outpost_local_repository.dart
│           ├── hr_local_repository.dart
│           ├── notification_local_repository.dart
│           ├── office_local_repository.dart
│           ├── sync_queue_repository.dart
│           └── user_local_repository.dart
├── modules/
│   ├── admin/
│   │   ├── analytics/
│   │   ├── controllers/
│   │   ├── employee_list/
│   │   ├── logic/
│   │   └── views/
│   ├── analytics/
│   │   └── widgets/
│   ├── attendance/
│   │   ├── checkin/
│   │   └── checkout/
│   ├── auth/
│   │   └── login/
│   ├── history/
│   │   ├── logic/
│   │   └── widgets/
│   ├── home/
│   │   ├── logic/
│   │   └── widgets/
│   ├── leave/
│   │   ├── logic/
│   │   ├── views/
│   │   └── widgets/
│   ├── notifications/
│   │   └── widgets/
│   ├── profile/
│   │   ├── logic/
│   │   └── widgets/
│   ├── security/
│   │   └── widgets/
│   └── splash/
├── services/  (implied from imports)
└── (98 total .dart files)
```

**Total Dart files in `lib/`**: 98 files (termasuk `.g.dart` generated files)

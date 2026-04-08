# PELMS Mobile App

Physical Education Learning Management System — Flutter Mobile Application

## Overview

This Flutter app is the mobile equivalent of the PELMS ASP.NET MVC web application. It allows students to view fitness test instructions, record their scores, and view their dashboard. Teachers can view and export student scores.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.0.0)
- Dart SDK (included with Flutter)
- Android Studio / Xcode for emulators/simulators
- A running instance of the PELMS Web API (`/Web.API/`)

## Getting Started

### 1. Clone and install dependencies

```bash
cd Mobile.Flutter
flutter pub get
```

### 2. Configure the API URL

Open `lib/config/api_config.dart` and update the base URL:

```dart
// Android emulator (default)
static const String baseUrl = 'http://10.0.2.2:5000/api';

// iOS simulator
// static const String baseUrl = 'http://localhost:5000/api';

// Physical device / production
// static const String baseUrl = 'https://your-server.com/api';
```

### 3. Run the app

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/
│   ├── api_config.dart       # API base URL and endpoints
│   └── theme.dart            # Material Design 3 theme (green/teal)
├── models/                   # Data models (JSON serializable)
├── providers/                # Riverpod state providers
├── services/                 # API, Auth, and Storage services
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── consent_screen.dart
│   ├── profile_setup_screen.dart
│   ├── student/
│   │   ├── student_dashboard.dart
│   │   ├── test_list_screen.dart
│   │   └── test_detail_screen.dart
│   ├── teacher/
│   │   ├── teacher_dashboard.dart
│   │   └── student_detail_screen.dart
│   └── profile_screen.dart
├── widgets/                  # Reusable UI components
└── utils/                    # Constants and validators
```

## Features

- **Authentication**: JWT login/register with secure token storage
- **Student Flow**: Test list → Test detail (instructions + video) → Score input → Dashboard
- **Teacher Flow**: Student list → Individual student scorecard → Excel export
- **Responsive Design**: Adapts to phone and tablet screen sizes
- **Material Design 3**: Green/teal fitness theme

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile framework |
| Riverpod | State management |
| Dio | HTTP client with JWT interceptor |
| flutter_secure_storage | Secure JWT token storage |
| video_player | Test instruction video playback |
| go_router | Declarative navigation |

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | /auth/login | Login with username/password |
| POST | /auth/register | Register new user |
| GET | /dashboard/student | Current student's scorecard |
| GET | /dashboard/students | All students (teacher) |
| GET | /dashboard/student/{id} | Individual student (teacher) |
| GET | /tests/{key} | Test instructions |
| POST | /scores | Submit a test score |
| GET | /student-profile | Get student profile |
| POST | /student-profile | Create student profile |
| PUT | /student-profile | Update student profile |
| GET | /teacher-profile | Get teacher profile |
| POST | /teacher-profile | Create teacher profile |
| PUT | /teacher-profile | Update teacher profile |
| GET | /export/student | Export current student Excel |
| GET | /export/student/{id} | Export specific student Excel |
| GET | /export/all | Export all students Excel |

## Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

# mobile/ — KnowChina Flutter App

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run
# or:
make dev-mobile
```

## Build

```bash
flutter build ios --release --no-codesign
flutter build apk --release
```

## Environment

Create `lib/config/env.dart` (not committed to git):

```dart
class Env {
  static const supabaseUrl = 'https://xxx.supabase.co';
  static const supabaseAnonKey = 'your-anon-key';
  static const revenueCatIOSKey = 'your-ios-key';
  static const revenueCatAndroidKey = 'your-android-key';
  static const serverBaseUrl = 'https://knowchina-server.your-subdomain.workers.dev';
}
```

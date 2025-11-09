# FinFit Setup Guide

## Quick Start

### 1. Install Flutter
Make sure you have Flutter installed. Check with:
```bash
flutter doctor
```

### 2. Initialize Flutter Project
If the project doesn't have Android/iOS folders, create them:
```bash
flutter create .
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Firebase Setup (Required for Full Functionality)

#### Option A: Use Firebase (Recommended)
1. Create a Firebase project at https://console.firebase.google.com
2. Add Android and/or iOS apps to your Firebase project
3. Download configuration files:
   - Android: `google-services.json` → place in `android/app/`
   - iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
4. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
5. Configure Firebase:
   ```bash
   flutterfire configure
   ```
6. Enable Firebase services:
   - Cloud Firestore (Database)
   - Firebase Authentication (enable Anonymous authentication)

#### Option B: Run Without Firebase (Demo Mode)
The app will work in demo mode without Firebase, but features like:
- User persistence
- Leaderboards
- Quiz results
- Transaction history

will not be saved. You can test the UI and functionality locally.

### 5. Initialize Quiz Questions (Optional)
After setting up Firebase, you can initialize quiz questions:
```bash
# Make sure Firebase is configured first
dart scripts/init_quiz_questions.dart
```

### 6. Run the App
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For web (limited functionality)
flutter run -d chrome
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── services/                 # Business logic & Firebase
├── screens/                  # UI screens
└── widgets/                  # Reusable widgets
```

## Firebase Collections

The app uses the following Firestore collections:
- `users` - User profiles and settings
- `transactions` - User transactions
- `quiz_questions` - Financial literacy quiz questions
- `quiz_results` - Quiz completion records

## Mock Data

The app includes mock transaction generation for testing. When a user completes setup, the app will automatically generate sample transactions for the current month.

## Troubleshooting

### Firebase Not Working
- Make sure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location
- Verify Firebase project settings
- Check that Firestore and Authentication are enabled

### Build Errors
- Run `flutter clean` then `flutter pub get`
- Make sure you have the latest Flutter SDK
- Check that all dependencies are compatible

### Notification Errors
- Notifications require proper platform setup
- Android: Check notification permissions
- iOS: Check notification permissions in Settings

## Development Notes

- The app uses Provider for state management
- Firebase services are abstracted for easy testing
- Mock data is generated automatically for demo purposes
- FinScore calculation happens in real-time based on transactions

## Next Steps

1. Set up Firebase (see Option A above)
2. Customize the FinScore algorithm if needed
3. Add more quiz questions to Firestore
4. Configure push notifications
5. Test on physical devices

## Support

For issues or questions, check the main README.md file or create an issue in the repository.


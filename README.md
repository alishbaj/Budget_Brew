# FinFit - Financial Health Tracking App

FinFit is a Flutter mobile application designed to help users track, maintain, and improve their financial health through personalized budgeting, social competition, and financial literacy education.

## Features

### 🎯 Core Features
- **Personalized Budgeting**: Set monthly budget limits and track spending
- **Savings Goals**: Set and monitor savings targets
- **Investment Tracking**: Optional investment goal tracking
- **FinScore Algorithm**: Calculate financial health score based on FICO-like factors
- **Real-time Notifications**: Alerts for budget deviations and savings goals
- **Social Competition**: Leaderboards with friends and teams
- **Financial Literacy Quiz**: Educational games to improve financial knowledge
- **Streak Tracking**: Maintain consistency with streak counters

### 📊 FinScore Calculation
The FinScore algorithm calculates financial health using:
- **Payment History (35%)**: Budget adherence
- **Amounts Owed (30%)**: Budget utilization
- **Length of Credit History (15%)**: Account age
- **New Credit (10%)**: Recent activity stability
- **Credit Mix (10%)**: Diversity of financial activities

## Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase account
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd hackutd25
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Firebase:
   - Create a Firebase project
   - Add Android/iOS apps to Firebase
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. Enable Firebase services:
   - Cloud Firestore
   - Firebase Authentication (Anonymous auth enabled)

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── transaction_model.dart
│   ├── finscore_model.dart
│   └── quiz_model.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── finscore_service.dart
│   └── notification_service.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── setup_screen.dart
│   ├── dashboard_screen.dart
│   ├── leaderboard_screen.dart
│   ├── quiz_screen.dart
│   └── profile_screen.dart
└── widgets/                  # Reusable widgets
    ├── progress_card.dart
    ├── finscore_card.dart
    └── transaction_list.dart
```

## Usage

### Initial Setup
1. Launch the app
2. Enter your name
3. Set monthly budget limit
4. Set savings goal
5. (Optional) Set investment goal
6. (Optional) Join a team for competition

### Dashboard
- View your FinScore
- Monitor budget and savings progress
- See recent transactions
- Check your current streak

### Leaderboard
- View global rankings
- Filter by team
- Compete with friends

### Financial Literacy Quiz
- Answer questions about personal finance
- Earn points for correct answers
- Improve your financial knowledge

## Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Firebase**: Backend services (Firestore, Auth)
- **Provider**: State management
- **Local Notifications**: Push notifications for alerts

## Future Enhancements

- Plaid API integration for real transaction data
- More detailed analytics and charts
- Social features (add friends, share achievements)
- More quiz questions and categories
- Investment portfolio tracking
- Budget categories and subcategories
- Export financial reports

## License

This project is created for Capital One's "The Best Financial Hack" track at HackUTD 2025.

## Contributors

- Developed for HackUTD 2025
- Capital One Financial Hack Challenge


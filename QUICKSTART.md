# FinFit Quick Start Guide

## For Hackathon Demo (Fastest Setup)

### Step 1: Clone and Setup
```bash
# Clone the repository
cd hackutd25

# Initialize Flutter project (if needed)
flutter create .

# Install dependencies
flutter pub get
```

### Step 2: Run Without Firebase (Demo Mode)
The app will work in demo mode without Firebase setup:
```bash
flutter run
```

**Note**: In demo mode:
- ✅ UI works perfectly
- ✅ You can see all screens
- ✅ Mock data is generated
- ❌ Data won't persist between sessions
- ❌ Leaderboards won't work across devices

### Step 3: Full Setup with Firebase (Recommended)

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com
   - Create a new project
   - Enable Firestore Database
   - Enable Authentication (Anonymous auth)

2. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

3. **Initialize Quiz Questions**
   ```bash
   dart scripts/init_quiz_questions.dart
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## Features to Demo

### 1. User Setup
- Enter name, budget, savings goals
- Optional: Investment tracking
- Optional: Join a team

### 2. Dashboard
- View FinScore (financial health score)
- Monitor budget and savings progress
- See recent transactions
- Check streak counter

### 3. Leaderboard
- View global rankings
- Filter by team
- See FinScore rankings

### 4. Financial Literacy Quiz
- Answer 10 questions
- Earn points
- Learn about personal finance

### 5. Notifications
- Budget alerts
- Savings alerts
- Streak notifications

## FinScore Algorithm

The FinScore is calculated using:
- **Payment History (35%)**: Budget adherence
- **Amounts Owed (30%)**: Budget utilization  
- **Length of Credit History (15%)**: Account age
- **New Credit (10%)**: Recent activity
- **Credit Mix (10%)**: Financial diversity

Score range: 300-850 (similar to FICO)

## Mock Data

The app automatically generates:
- 30 transactions for the current month
- Various categories (food, transportation, etc.)
- Income and expense transactions
- Savings transactions

## Troubleshooting

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase errors?
- Make sure you've run `flutterfire configure`
- Check that Firestore and Auth are enabled
- Verify `google-services.json` is in `android/app/`

### No quiz questions?
- Run `dart scripts/init_quiz_questions.dart`
- Or the app will use default questions from code

## Demo Script

1. **Setup**: Create a new user profile
2. **Dashboard**: Show FinScore and progress
3. **Transactions**: View mock transaction history
4. **Quiz**: Complete a financial literacy quiz
5. **Leaderboard**: Show rankings
6. **Notifications**: Demonstrate alerts

## Tips for Hackathon

- Use demo mode if Firebase setup is taking too long
- Focus on UI/UX and FinScore algorithm
- Highlight the social competition aspect
- Show how notifications help users stay on track
- Emphasize financial literacy through quizzes

## Next Steps

- Add Plaid API integration for real transactions
- Implement more detailed analytics
- Add more quiz questions
- Create team creation/joining flow
- Add friend system
- Implement push notifications

Good luck with your hackathon! 🚀


# FinFit - Project Overview

## 🎯 Project Description

FinFit is a mobile application designed to help users track, maintain, and improve their financial health through personalized budgeting, social competition, and financial literacy education. Built for Capital One's "The Best Financial Hack" track at HackUTD 2025.

## ✨ Key Features

### 1. Personalized Financial Tracking
- **Monthly Budget Tracking**: Set and monitor spending limits
- **Savings Goals**: Track progress toward savings targets
- **Investment Goals**: Optional investment tracking (ready for future integration)
- **Real-time Updates**: Dashboard updates as transactions are added

### 2. FinScore Algorithm
A proprietary financial health score (300-850 scale, similar to FICO) calculated using:
- **Payment History (35%)**: How well users stick to their budgets
- **Amounts Owed (30%)**: Budget utilization percentage
- **Length of Credit History (15%)**: Account age and activity
- **New Credit (10%)**: Recent financial activity stability
- **Credit Mix (10%)**: Diversity of financial activities

### 3. Social Competition
- **Leaderboards**: Global and team-based rankings
- **Teams**: Join teams to compete with friends
- **Points System**: Earn points for good financial habits
- **Streaks**: Maintain consistency with daily streak tracking

### 4. Financial Literacy
- **Interactive Quiz**: 10+ financial literacy questions
- **Educational Content**: Explanations for each quiz answer
- **Points Rewards**: Earn points for correct answers
- **Progress Tracking**: Track quiz completion and scores

### 5. Smart Notifications
- **Budget Alerts**: Notify when spending approaches or exceeds budget
- **Savings Alerts**: Remind users about savings goals
- **Investment Updates**: Track investment changes (future feature)
- **Streak Notifications**: Celebrate consistency milestones

## 🏗️ Technical Architecture

### Frontend
- **Framework**: Flutter (cross-platform)
- **State Management**: Provider
- **UI**: Material Design 3
- **Charts**: fl_chart (for future analytics)

### Backend
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth (Anonymous + Email/Password)
- **Notifications**: Local notifications (Flutter Local Notifications)

### Data Models
- `UserModel`: User profile, goals, scores, streaks
- `TransactionModel`: Income, expenses, savings, investments
- `FinScoreModel`: Financial health score and breakdown
- `QuizQuestion`: Financial literacy quiz questions
- `QuizResult`: Quiz completion records

### Services
- `AuthService`: User authentication and session management
- `FirebaseService`: Database operations and mock data generation
- `FinScoreService`: Financial health score calculation
- `NotificationService`: Local notification management

## 📱 User Flow

1. **Splash Screen**: App initialization and auth check
2. **Setup Screen**: User onboarding (name, budget, goals, team)
3. **Dashboard**: Main screen with FinScore, progress, transactions
4. **Leaderboard**: Rankings and competition
5. **Quiz**: Financial literacy games
6. **Profile**: User settings and statistics

## 🚀 Implementation Status

### ✅ Completed
- [x] Flutter project structure
- [x] User authentication (Anonymous + Email/Password)
- [x] User setup and onboarding
- [x] Dashboard with FinScore display
- [x] Budget and savings tracking
- [x] Transaction management
- [x] FinScore algorithm implementation
- [x] Leaderboard (global and team-based)
- [x] Financial literacy quiz
- [x] Notification system
- [x] Streak tracking
- [x] Mock data generation
- [x] Firebase integration
- [x] UI/UX design

### 🔄 Future Enhancements
- [ ] Plaid API integration for real transaction data
- [ ] Push notifications (Firebase Cloud Messaging)
- [ ] Advanced analytics and charts
- [ ] Friend system and social features
- [ ] Investment portfolio tracking
- [ ] Budget categories and subcategories
- [ ] Export financial reports
- [ ] More quiz questions and categories
- [ ] Team creation and management UI
- [ ] Achievement system and badges

## 📊 Data Flow

1. **User Setup**: User enters goals → Saved to Firestore
2. **Transaction Tracking**: Mock transactions generated → Stored in Firestore
3. **FinScore Calculation**: Transactions analyzed → Score calculated → Updated in user profile
4. **Notifications**: Score/budget changes detected → Local notifications sent
5. **Leaderboard**: User scores fetched → Sorted and displayed
6. **Quiz**: Questions loaded → Answers submitted → Points awarded → Results saved

## 🎨 Design Philosophy

- **Clean and Modern**: Material Design 3 with intuitive UI
- **User-Friendly**: Simple setup process and clear visual feedback
- **Gamified**: Points, streaks, and leaderboards to encourage engagement
- **Educational**: Financial literacy through interactive quizzes
- **Social**: Competition with friends and teams

## 🔒 Security & Privacy

- Firebase Authentication for secure user management
- Firestore security rules (to be configured)
- Local data encryption (Flutter secure storage - future)
- Anonymous authentication option for privacy

## 📈 Scalability

- Cloud Firestore for scalable database
- Provider for efficient state management
- Modular architecture for easy feature additions
- Mock data system for testing and demos

## 🧪 Testing

- Mock transaction generation for testing
- Default quiz questions if Firestore unavailable
- Error handling for offline scenarios
- Graceful degradation when Firebase not configured

## 📝 Documentation

- README.md: Main project documentation
- SETUP.md: Detailed setup instructions
- QUICKSTART.md: Quick start guide for hackathon
- PROJECT_OVERVIEW.md: This file

## 🎯 Hackathon Goals

1. **Demonstrate Innovation**: Unique FinScore algorithm
2. **Show Technical Skills**: Flutter, Firebase, state management
3. **Address Challenge**: Financial health and literacy
4. **User Experience**: Intuitive and engaging interface
5. **Social Impact**: Help users improve financial well-being

## 💡 Key Differentiators

1. **FinScore Algorithm**: Proprietary financial health scoring
2. **Social Competition**: Gamified budgeting with friends
3. **Educational Focus**: Financial literacy through quizzes
4. **Comprehensive Tracking**: Budget, savings, and investments
5. **Smart Notifications**: Proactive alerts for financial health

## 🏆 Competition Alignment

- ✅ Innovative payment/financial solution
- ✅ Helps consumers shop smarter (budget tracking)
- ✅ Makes financing more accessible (financial literacy)
- ✅ Improves financial literacy (quiz system)
- ✅ Creative and bold ideas (FinScore, social competition)

---

**Built with ❤️ for HackUTD 2025 - Capital One Challenge**


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:finfit/services/auth_service.dart';
import 'package:finfit/services/firebase_service.dart';
import 'package:finfit/services/finscore_service.dart';
import 'package:finfit/services/notification_service.dart';
import 'package:finfit/screens/splash_screen.dart';
import 'package:finfit/screens/setup_screen.dart';
import 'package:finfit/screens/dashboard_screen.dart';
import 'package:finfit/screens/leaderboard_screen.dart';
import 'package:finfit/screens/quiz_screen.dart';
import 'package:finfit/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (will need Firebase configuration)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase not configured yet - app will work in demo mode
    debugPrint('Firebase not initialized: $e');
  }
  
  // Initialize notifications
  try {
    await NotificationService().init();
  } catch (e) {
    debugPrint('Notifications not initialized: $e');
  }
  
  runApp(const FinFitApp());
}

class FinFitApp extends StatelessWidget {
  const FinFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirebaseService()),
        ChangeNotifierProvider(create: (_) => FinScoreService()),
      ],
      child: MaterialApp(
        title: 'FinFit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF1976D2),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2),
            primary: const Color(0xFF1976D2),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/setup': (context) => const SetupScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


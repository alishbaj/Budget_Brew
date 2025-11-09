import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finfit/models/user_model.dart';
import 'package:finfit/services/firebase_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  User? get firebaseUser => _auth.currentUser;

  AuthService() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final firebaseService = FirebaseService();
      _currentUser = await firebaseService.getUser(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInAnonymously();
      return true;
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        final user = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          monthlyBudget: 0,
          savingsGoal: 0,
          createdAt: DateTime.now(),
        );
        final firebaseService = FirebaseService();
        await firebaseService.createUser(user);
        _currentUser = user;
      }
      return true;
    } catch (e) {
      debugPrint('Error signing up: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final firebaseService = FirebaseService();
      await firebaseService.updateUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user: $e');
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:finfit/models/user_model.dart';
import 'package:finfit/models/transaction_model.dart';
import 'package:finfit/models/quiz_model.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  Stream<List<UserModel>> getUsersByTeam(String teamId) {
    return _firestore
        .collection('users')
        .where('teamId', isEqualTo: teamId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<UserModel>> getTopUsers({int limit = 10}) {
    return _firestore
        .collection('users')
        .orderBy('currentFinScore', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }

  // Transaction operations
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toMap());
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId);

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.orderBy('date', descending: true).get();
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting transactions: $e');
      return [];
    }
  }

  Stream<List<TransactionModel>> getTransactionsStream(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  // Quiz operations
  Future<List<QuizQuestion>> getQuizQuestions({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('quiz_questions')
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => QuizQuestion.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting quiz questions: $e');
      // Return default questions if Firestore fails
      return _getDefaultQuizQuestions();
    }
  }

  Future<void> saveQuizResult(QuizResult result) async {
    try {
      await _firestore
          .collection('quiz_results')
          .doc('${result.userId}_${result.completedAt.millisecondsSinceEpoch}')
          .set(result.toMap());
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  // Generate mock transactions for demo
  Future<void> generateMockTransactions(String userId) async {
    final now = DateTime.now();
    final transactions = <TransactionModel>[];

    // Generate transactions for the current month
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      const categories = Category.values;
      final category = categories[i % categories.length];

      transactions.add(TransactionModel(
        id: '${userId}_${date.millisecondsSinceEpoch}',
        userId: userId,
        type: i % 5 == 0 ? TransactionType.income : TransactionType.expense,
        category: category,
        amount: i % 5 == 0
            ? 100.0 + (i * 10)
            : 10.0 + (i * 2) + (i % 3 * 5),
        description: _getDescriptionForCategory(category),
        date: date,
      ));
    }

    // Add some savings transactions
    for (int i = 0; i < 5; i++) {
      final date = now.subtract(Duration(days: i * 7));
      transactions.add(TransactionModel(
        id: '${userId}_savings_${date.millisecondsSinceEpoch}',
        userId: userId,
        type: TransactionType.savings,
        category: Category.other,
        amount: 50.0 + (i * 10),
        description: 'Weekly savings',
        date: date,
      ));
    }

    for (final transaction in transactions) {
      await addTransaction(transaction);
    }
  }

  String _getDescriptionForCategory(Category category) {
    switch (category) {
      case Category.food:
        return 'Restaurant/ groceries';
      case Category.transportation:
        return 'Gas/ Uber/ Parking';
      case Category.entertainment:
        return 'Movie/ Concert/ Games';
      case Category.utilities:
        return 'Electric/ Water/ Internet';
      case Category.shopping:
        return 'Clothing/ Electronics';
      case Category.healthcare:
        return 'Doctor/ Pharmacy';
      case Category.education:
        return 'Books/ Courses';
      case Category.other:
        return 'Miscellaneous';
    }
  }

  List<QuizQuestion> _getDefaultQuizQuestions() {
    return [
      QuizQuestion(
        id: '1',
        question: 'What is the recommended percentage of income to save?',
        options: ['5-10%', '10-20%', '20-30%', '30-40%'],
        correctAnswerIndex: 1,
        explanation: 'Financial experts recommend saving at least 10-20% of your income for long-term financial security.',
        points: 10,
      ),
      QuizQuestion(
        id: '2',
        question: 'What is compound interest?',
        options: [
          'Interest on the principal only',
          'Interest on principal plus previously earned interest',
          'Interest charged on loans',
          'Interest paid monthly'
        ],
        correctAnswerIndex: 1,
        explanation: 'Compound interest is interest calculated on the initial principal and also on accumulated interest from previous periods.',
        points: 10,
      ),
      QuizQuestion(
        id: '3',
        question: 'What is an emergency fund?',
        options: [
          'Money for vacations',
          'Money saved for unexpected expenses',
          'Money for investments',
          'Money for monthly bills'
        ],
        correctAnswerIndex: 1,
        explanation: 'An emergency fund is money set aside to cover unexpected expenses or financial emergencies, typically 3-6 months of living expenses.',
        points: 10,
      ),
      QuizQuestion(
        id: '4',
        question: 'What does APR stand for?',
        options: [
          'Annual Percentage Rate',
          'Average Payment Rate',
          'Annual Payment Return',
          'Average Percentage Return'
        ],
        correctAnswerIndex: 0,
        explanation: 'APR stands for Annual Percentage Rate, which represents the annual cost of borrowing money, including interest and fees.',
        points: 10,
      ),
      QuizQuestion(
        id: '5',
        question: 'What is the 50/30/20 budget rule?',
        options: [
          '50% needs, 30% wants, 20% savings',
          '50% savings, 30% needs, 20% wants',
          '50% wants, 30% needs, 20% savings',
          '50% needs, 30% savings, 20% wants'
        ],
        correctAnswerIndex: 0,
        explanation: 'The 50/30/20 rule suggests allocating 50% of income to needs, 30% to wants, and 20% to savings and debt repayment.',
        points: 10,
      ),
      QuizQuestion(
        id: '6',
        question: 'What is a credit score used for?',
        options: [
          'To determine loan eligibility and interest rates',
          'To calculate taxes',
          'To track expenses',
          'To measure income'
        ],
        correctAnswerIndex: 0,
        explanation: 'A credit score is used by lenders to assess creditworthiness and determine loan eligibility and interest rates.',
        points: 10,
      ),
      QuizQuestion(
        id: '7',
        question: 'What is diversification in investing?',
        options: [
          'Putting all money in one stock',
          'Spreading investments across different assets',
          'Investing only in bonds',
          'Avoiding investments'
        ],
        correctAnswerIndex: 1,
        explanation: 'Diversification is the strategy of spreading investments across different assets to reduce risk.',
        points: 10,
      ),
      QuizQuestion(
        id: '8',
        question: 'What is the difference between a debit card and a credit card?',
        options: [
          'Debit cards use your money, credit cards borrow money',
          'They are the same thing',
          'Credit cards use your money, debit cards borrow money',
          'Debit cards have higher limits'
        ],
        correctAnswerIndex: 0,
        explanation: 'Debit cards withdraw money directly from your bank account, while credit cards allow you to borrow money that you must repay.',
        points: 10,
      ),
      QuizQuestion(
        id: '9',
        question: 'What is inflation?',
        options: [
          'Decrease in prices over time',
          'Increase in prices over time',
          'Stable prices',
          'Increase in income'
        ],
        correctAnswerIndex: 1,
        explanation: 'Inflation is the rate at which the general level of prices for goods and services rises, eroding purchasing power.',
        points: 10,
      ),
      QuizQuestion(
        id: '10',
        question: 'What is a budget?',
        options: [
          'A plan for spending and saving money',
          'A list of expenses',
          'A savings account',
          'A credit card statement'
        ],
        correctAnswerIndex: 0,
        explanation: 'A budget is a financial plan that helps you track income and expenses to achieve financial goals.',
        points: 10,
      ),
    ];
  }
}


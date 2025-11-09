import 'package:flutter/foundation.dart';
import 'package:finfit/models/finscore_model.dart';
import 'package:finfit/models/transaction_model.dart';
import 'package:finfit/models/user_model.dart';
import 'package:finfit/services/firebase_service.dart';

class FinScoreService extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // FinScore calculation based on FICO-like factors
  // Payment History (35%) - Based on staying within budget
  // Amounts Owed (30%) - Based on budget utilization
  // Length of Credit History (15%) - Based on account age
  // New Credit (10%) - Based on recent changes
  // Credit Mix (10%) - Based on diversity of financial activities

  Future<FinScoreModel> calculateFinScore(
    UserModel user,
    List<TransactionModel> transactions,
  ) async {
    try {
      final now = DateTime.now();
      final accountAgeDays = now.difference(user.createdAt).inDays;
      final accountAgeMonths = accountAgeDays / 30.0;

      // Filter transactions for current month
      final currentMonthStart = DateTime(now.year, now.month, 1);
      final currentMonthTransactions = transactions.where((t) =>
          t.date.isAfter(currentMonthStart) || t.date.isAtSameMomentAs(currentMonthStart)).toList();

      // Calculate spending
      final totalSpending = currentMonthTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      final totalIncome = currentMonthTransactions
          .where((t) => t.type == TransactionType.income)
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      final totalSavings = currentMonthTransactions
          .where((t) => t.type == TransactionType.savings)
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      // Payment History (35%) - Budget adherence
      final budgetUtilization = user.monthlyBudget > 0
          ? (totalSpending / user.monthlyBudget).clamp(0.0, 2.0)
          : 1.0;
      final paymentHistoryScore = budgetUtilization <= 1.0
          ? 850.0 * 0.35 * (1.0 - budgetUtilization * 0.5)
          : 850.0 * 0.35 * (1.0 - (budgetUtilization - 1.0) * 0.5);

      // Amounts Owed (30%) - Budget utilization
      final amountsOwedScore = budgetUtilization <= 0.9
          ? 850.0 * 0.30
          : budgetUtilization <= 1.0
              ? 850.0 * 0.30 * (1.0 - (budgetUtilization - 0.9) * 5)
              : 850.0 * 0.30 * 0.5 * (2.0 - budgetUtilization);

      // Length of Credit History (15%) - Account age
      final accountAgeScore = 850.0 *
          0.15 *
          (accountAgeMonths.clamp(0.0, 24.0) / 24.0);

      // New Credit (10%) - Recent activity stability
      final recentTransactions = transactions
          .where((t) => now.difference(t.date).inDays <= 7)
          .length;
      final newCreditScore = recentTransactions <= 10
          ? 850.0 * 0.10
          : 850.0 * 0.10 * (1.0 - (recentTransactions - 10) * 0.05).clamp(0.0, 1.0);

      // Credit Mix (10%) - Diversity of financial activities
      final hasIncome = totalIncome > 0;
      final hasSavings = totalSavings > 0;
      final hasInvestments = currentMonthTransactions
          .any((t) => t.type == TransactionType.investment);
      final categoryDiversity = currentMonthTransactions
          .map((t) => t.category)
          .toSet()
          .length;
      final creditMixScore = 850.0 *
          0.10 *
          ((hasIncome ? 0.3 : 0.0) +
              (hasSavings ? 0.3 : 0.0) +
              (hasInvestments ? 0.2 : 0.0) +
              (categoryDiversity / 8.0 * 0.2));

      // Calculate total score
      final totalScore = (paymentHistoryScore +
              amountsOwedScore +
              accountAgeScore +
              newCreditScore +
              creditMixScore)
          .clamp(300.0, 850.0);

      // Determine trend
      final previousScore = user.currentFinScore;
      String trend = 'stable';
      if (totalScore > previousScore + 10) {
        trend = 'up';
      } else if (totalScore < previousScore - 10) {
        trend = 'down';
      }

      final breakdown = {
        'paymentHistory': paymentHistoryScore,
        'amountsOwed': amountsOwedScore,
        'accountAge': accountAgeScore,
        'newCredit': newCreditScore,
        'creditMix': creditMixScore,
      };

      return FinScoreModel(
        userId: user.id,
        score: totalScore,
        calculatedAt: now,
        breakdown: breakdown,
        trend: trend,
      );
    } catch (e) {
      debugPrint('Error calculating FinScore: $e');
      return FinScoreModel(
        userId: user.id,
        score: 600.0,
        calculatedAt: DateTime.now(),
        breakdown: {},
        trend: 'stable',
      );
    }
  }

  Future<void> updateUserFinScore(String userId, double newScore) async {
    try {
      final user = await _firebaseService.getUser(userId);
      if (user != null) {
        final updatedUser = user.copyWith(currentFinScore: newScore);
        await _firebaseService.updateUser(updatedUser);
      }
    } catch (e) {
      debugPrint('Error updating user FinScore: $e');
    }
  }
}


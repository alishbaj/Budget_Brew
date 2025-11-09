import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finfit/services/auth_service.dart';
import 'package:finfit/services/firebase_service.dart';
import 'package:finfit/services/finscore_service.dart';
import 'package:finfit/services/notification_service.dart';
import 'package:finfit/models/transaction_model.dart';
import 'package:finfit/widgets/progress_card.dart';
import 'package:finfit/widgets/finscore_card.dart';
import 'package:finfit/widgets/transaction_list.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNotifications();
      _updateFinScore();
    });
  }

  Future<void> _checkNotifications() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final user = authService.currentUser;
    
    if (user == null) return;

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final transactions = await firebaseService.getTransactions(
      user.id,
      startDate: monthStart,
    );

    final totalSpending = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    final totalSavings = transactions
        .where((t) => t.type == TransactionType.savings)
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    // Check budget alerts
    if (totalSpending > user.monthlyBudget * 0.9) {
      final overspend = totalSpending - user.monthlyBudget;
      await NotificationService().showBudgetAlert(
        title: 'Budget Alert',
        body: 'You\'re ${((totalSpending / user.monthlyBudget) * 100 - 100).toStringAsFixed(0)}% over your monthly budget!',
        overspendAmount: overspend,
      );
    }

    // Check savings alerts
    if (totalSavings < user.savingsGoal * 0.8) {
      final deficit = user.savingsGoal - totalSavings;
      await NotificationService().showSavingsAlert(
        title: 'Savings Alert',
        body: 'You\'ve fallen behind your savings goal by \$${deficit.toStringAsFixed(2)}.',
        deficit: deficit,
      );
    }
  }

  Future<void> _updateFinScore() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final finscoreService = Provider.of<FinScoreService>(context, listen: false);
    final user = authService.currentUser;
    
    if (user == null) return;

    final transactions = await firebaseService.getTransactions(user.id);
    final finscore = await finscoreService.calculateFinScore(user, transactions);
    await finscoreService.updateUserFinScore(user.id, finscore.score);
    
    final updatedUser = user.copyWith(currentFinScore: finscore.score);
    await authService.updateUser(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.of(context).pushNamed('/leaderboard');
            },
          ),
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () {
              Navigator.of(context).pushNamed('/quiz');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: Provider.of<FirebaseService>(context).getTransactionsStream(user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;
          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);
          final monthTransactions = transactions
              .where((t) => t.date.isAfter(monthStart) || t.date.isAtSameMomentAs(monthStart))
              .toList();

          final totalSpending = monthTransactions
              .where((t) => t.type == TransactionType.expense)
              .fold<double>(0.0, (sum, t) => sum + t.amount);

          final totalSavings = monthTransactions
              .where((t) => t.type == TransactionType.savings)
              .fold<double>(0.0, (sum, t) => sum + t.amount);

          final budgetProgress = user.monthlyBudget > 0
              ? (totalSpending / user.monthlyBudget).clamp(0.0, 1.0)
              : 0.0;

          final savingsProgress = user.savingsGoal > 0
              ? (totalSavings / user.savingsGoal).clamp(0.0, 1.0)
              : 0.0;

          return RefreshIndicator(
            onRefresh: () async {
              await _updateFinScore();
              await _checkNotifications();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${user.name}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('MMMM yyyy').format(now),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FinScoreCard(finScore: user.currentFinScore),
                  const SizedBox(height: 20),
                  ProgressCard(
                    title: 'Monthly Budget',
                    current: totalSpending,
                    goal: user.monthlyBudget,
                    progress: budgetProgress,
                    color: Colors.blue,
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 16),
                  ProgressCard(
                    title: 'Savings Goal',
                    current: totalSavings,
                    goal: user.savingsGoal,
                    progress: savingsProgress,
                    color: Colors.green,
                    icon: Icons.savings,
                  ),
                  if (user.investmentGoal != null) ...[
                    const SizedBox(height: 16),
                    ProgressCard(
                      title: 'Investment Goal',
                      current: 0, // Would need investment tracking
                      goal: user.investmentGoal!,
                      progress: 0,
                      color: Colors.orange,
                      icon: Icons.trending_up,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Show all transactions
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TransactionList(transactions: transactions.take(5).toList()),
                  const SizedBox(height: 20),
                  if (user.streak > 0)
                    Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 10),
                            Text(
                              '${user.streak} day streak! 🔥',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


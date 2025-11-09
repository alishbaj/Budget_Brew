import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finfit/services/auth_service.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              context,
              'FinScore',
              user.currentFinScore.toStringAsFixed(0),
              Icons.score,
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Total Points',
              user.totalPoints.toString(),
              Icons.stars,
              Colors.amber,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Current Streak',
              '${user.streak} days',
              Icons.local_fire_department,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Monthly Budget',
              '\$${user.monthlyBudget.toStringAsFixed(2)}',
              Icons.account_balance_wallet,
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Savings Goal',
              '\$${user.savingsGoal.toStringAsFixed(2)}',
              Icons.savings,
              Colors.teal,
            ),
            if (user.teamName != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Team',
                user.teamName!,
                Icons.group,
                Colors.purple,
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/setup',
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


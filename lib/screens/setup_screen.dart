import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finfit/services/auth_service.dart';
import 'package:finfit/services/firebase_service.dart';


class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _savingsController = TextEditingController();
  final _investmentController = TextEditingController();
  final _teamNameController = TextEditingController();
  
  bool _joinTeam = false;
  bool _hasInvestment = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _savingsController.dispose();
    _investmentController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  Future<void> _saveSetup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      
      final user = authService.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in first')),
        );
        return;
      }

      final updatedUser = user.copyWith(
        name: _nameController.text,
        monthlyBudget: double.parse(_budgetController.text),
        savingsGoal: double.parse(_savingsController.text),
        investmentGoal: _hasInvestment && _investmentController.text.isNotEmpty
            ? double.parse(_investmentController.text)
            : null,
        teamId: _joinTeam && _teamNameController.text.isNotEmpty
            ? _teamNameController.text.toLowerCase().replaceAll(' ', '_')
            : null,
        teamName: _joinTeam && _teamNameController.text.isNotEmpty
            ? _teamNameController.text
            : null,
      );

      await firebaseService.updateUser(updatedUser);
      await authService.updateUser(updatedUser);

      // Generate mock transactions
      await firebaseService.generateMockTransactions(user.id);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to FinFit!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Let\'s set up your financial goals',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Budget Limit (\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly budget';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _savingsController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Savings Goal (\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.savings),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your savings goal';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Track Investments'),
                subtitle: const Text('Optional: Set an investment tracking goal'),
                value: _hasInvestment,
                onChanged: (value) {
                  setState(() {
                    _hasInvestment = value;
                  });
                },
              ),
              if (_hasInvestment) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _investmentController,
                  decoration: const InputDecoration(
                    labelText: 'Investment Goal (\$)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.trending_up),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_hasInvestment && (value == null || value.isEmpty)) {
                      return 'Please enter investment goal';
                    }
                    if (value != null &&
                        value.isNotEmpty &&
                        (double.tryParse(value) == null || double.parse(value) <= 0)) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Join a Team'),
                subtitle: const Text('Compete with friends on the leaderboard'),
                value: _joinTeam,
                onChanged: (value) {
                  setState(() {
                    _joinTeam = value;
                  });
                },
              ),
              if (_joinTeam) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _teamNameController,
                  decoration: const InputDecoration(
                    labelText: 'Team Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                  ),
                  validator: (value) {
                    if (_joinTeam && (value == null || value.isEmpty)) {
                      return 'Please enter a team name';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveSetup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Complete Setup',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


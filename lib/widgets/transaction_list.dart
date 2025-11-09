import 'package:flutter/material.dart';
import 'package:finfit/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionList({super.key, required this.transactions});

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.food:
        return Icons.restaurant;
      case Category.transportation:
        return Icons.directions_car;
      case Category.entertainment:
        return Icons.movie;
      case Category.utilities:
        return Icons.home;
      case Category.shopping:
        return Icons.shopping_bag;
      case Category.healthcare:
        return Icons.local_hospital;
      case Category.education:
        return Icons.school;
      case Category.other:
        return Icons.category;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.income:
        return Colors.green;
      case TransactionType.savings:
        return Colors.blue;
      case TransactionType.investment:
        return Colors.orange;
    }
  }

  String _getCategoryName(Category category) {
    return category.name[0].toUpperCase() + category.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('No transactions yet'),
          ),
        ),
      );
    }

    return Column(
      children: transactions.map((transaction) {
        final color = _getTransactionColor(transaction.type);
        final icon = _getCategoryIcon(transaction.category);
        final isExpense = transaction.type == TransactionType.expense;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color),
            ),
            title: Text(transaction.description),
            subtitle: Text(
              '${_getCategoryName(transaction.category)} • ${DateFormat('MMM d').format(transaction.date)}',
            ),
            trailing: Text(
              '${isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


enum TransactionType {
  expense,
  income,
  savings,
  investment,
}

enum Category {
  food,
  transportation,
  entertainment,
  utilities,
  shopping,
  healthcare,
  education,
  other,
}

class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final Category category;
  final double amount;
  final String description;
  final DateTime date;
  final bool isRecurring;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    this.isRecurring = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'category': category.name,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'isRecurring': isRecurring,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: Category.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => Category.other,
      ),
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      isRecurring: map['isRecurring'] ?? false,
    );
  }
}


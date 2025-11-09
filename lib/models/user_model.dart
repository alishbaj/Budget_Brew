class UserModel {
  final String id;
  final String email;
  final String name;
  final double monthlyBudget;
  final double savingsGoal;
  final double? investmentGoal;
  final String? teamId;
  final String? teamName;
  final DateTime createdAt;
  final int streak;
  final int totalPoints;
  final double currentFinScore;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.monthlyBudget,
    required this.savingsGoal,
    this.investmentGoal,
    this.teamId,
    this.teamName,
    required this.createdAt,
    this.streak = 0,
    this.totalPoints = 0,
    this.currentFinScore = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'monthlyBudget': monthlyBudget,
      'savingsGoal': savingsGoal,
      'investmentGoal': investmentGoal,
      'teamId': teamId,
      'teamName': teamName,
      'createdAt': createdAt.toIso8601String(),
      'streak': streak,
      'totalPoints': totalPoints,
      'currentFinScore': currentFinScore,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      monthlyBudget: (map['monthlyBudget'] ?? 0.0).toDouble(),
      savingsGoal: (map['savingsGoal'] ?? 0.0).toDouble(),
      investmentGoal: map['investmentGoal']?.toDouble(),
      teamId: map['teamId'],
      teamName: map['teamName'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      streak: map['streak'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      currentFinScore: (map['currentFinScore'] ?? 0.0).toDouble(),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    double? monthlyBudget,
    double? savingsGoal,
    double? investmentGoal,
    String? teamId,
    String? teamName,
    DateTime? createdAt,
    int? streak,
    int? totalPoints,
    double? currentFinScore,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      investmentGoal: investmentGoal ?? this.investmentGoal,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      createdAt: createdAt ?? this.createdAt,
      streak: streak ?? this.streak,
      totalPoints: totalPoints ?? this.totalPoints,
      currentFinScore: currentFinScore ?? this.currentFinScore,
    );
  }
}


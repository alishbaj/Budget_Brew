class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final int points;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.points = 10,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'points': points,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
      points: map['points'] ?? 10,
    );
  }
}

class QuizResult {
  final String userId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final int pointsEarned;

  QuizResult({
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.pointsEarned,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': completedAt.toIso8601String(),
      'pointsEarned': pointsEarned,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      userId: map['userId'] ?? '',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      completedAt: DateTime.parse(
        map['completedAt'] ?? DateTime.now().toIso8601String(),
      ),
      pointsEarned: map['pointsEarned'] ?? 0,
    );
  }
}


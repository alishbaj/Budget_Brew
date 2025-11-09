class FinScoreModel {
  final String userId;
  final double score; // 0-850 scale (similar to FICO)
  final DateTime calculatedAt;
  final Map<String, double> breakdown; // Component scores
  final String trend; // 'up', 'down', 'stable'

  FinScoreModel({
    required this.userId,
    required this.score,
    required this.calculatedAt,
    required this.breakdown,
    required this.trend,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'score': score,
      'calculatedAt': calculatedAt.toIso8601String(),
      'breakdown': breakdown,
      'trend': trend,
    };
  }

  factory FinScoreModel.fromMap(Map<String, dynamic> map) {
    return FinScoreModel(
      userId: map['userId'] ?? '',
      score: (map['score'] ?? 0.0).toDouble(),
      calculatedAt: DateTime.parse(
        map['calculatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      breakdown: Map<String, double>.from(map['breakdown'] ?? {}),
      trend: map['trend'] ?? 'stable',
    );
  }
}


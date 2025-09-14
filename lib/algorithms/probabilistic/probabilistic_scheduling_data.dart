import '../abstract_scheduling_data.dart';

class ProbabilisticSchedulingData implements SchedulingData {
  @override
  String get type => 'probabilistic';

  DateTime lastReview;
  double performanceScore; // e.g. 0.0 means forgotten, 1.0 means perfect

  ProbabilisticSchedulingData({
    DateTime? lastReview,
    double? performanceScore,
  })  : lastReview = lastReview ?? DateTime.now(),
        performanceScore = performanceScore ?? 0.0;

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'lastReview': lastReview.toIso8601String(),
        'performanceScore': performanceScore,
      };

  factory ProbabilisticSchedulingData.fromJson(Map<String, dynamic> json) {
    return ProbabilisticSchedulingData(
      lastReview:
          DateTime.tryParse(json['lastReview'] as String) ?? DateTime.now(),
      performanceScore: (json['performanceScore'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'ProbabilisticSchedulingData(lastReview: ${lastReview.toIso8601String()}, performanceScore: $performanceScore)';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

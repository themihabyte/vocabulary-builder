import '../algorithms/abstract_scheduling_data.dart';
import '../algorithms/probabilistic/probabilistic_scheduling_data.dart';

class CardModel {
  final String word;
  final String translation;
  final String exampleContext;
  final SchedulingData schedulingData;
  final bool isActive;

  CardModel({
    required this.word,
    required this.translation,
    required this.exampleContext,
    required this.schedulingData,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'translation': translation,
        'example_context': exampleContext,
        'scheduling_data': schedulingData.toJson(),
        'is_active': isActive,
      };

  factory CardModel.fromJson(Map<String, dynamic> json) {
// Try to get scheduling_data. If not present, fallback to default scheduling data.
    Map<String, dynamic>? schedulingJson;
    if (json.containsKey('scheduling_data')) {
      schedulingJson = json['scheduling_data'] as Map<String, dynamic>;
    }

    SchedulingData schedulingData;
    if (schedulingJson != null && schedulingJson.containsKey('type')) {
      final String type = schedulingJson['type'] as String;
      if (type == 'probabilistic') {
        schedulingData = ProbabilisticSchedulingData.fromJson(schedulingJson);
      } else {
        throw Exception('Unknown scheduling data type: $type');
      }
    } else {
      // If scheduling data is missing, create a default instance.
      schedulingData = ProbabilisticSchedulingData();
    }
    return CardModel(
      word: json['word'] as String,
      translation: json['translation'] as String,
      exampleContext: json['example_context'] as String,
      schedulingData: schedulingData,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
  @override
  String toString() {
    return 'CardModel(word: $word, translation: $translation, exampleContext: $exampleContext, schedulingData: $schedulingData, isActive: $isActive)';
  }
}

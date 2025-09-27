import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../algorithms/abstract_scheduling_data.dart';
import '../algorithms/probabilistic/probabilistic_scheduling_data.dart';

const _uuid = Uuid();

typedef Json = Map<String, Object?>;

mixin CardFields {
  String get id;
  String get word;
  String get translation;
  String get exampleContext;
  SchedulingData get schedulingData;
  bool get isActive;
}

@immutable
class CardModel with CardFields {
  @override
  final String id;
  @override
  final String word;
  @override
  final String translation;
  @override
  final String exampleContext;
  @override
  final SchedulingData schedulingData;
  @override
  final bool isActive;

  CardModel({
    String? id,
    required this.word,
    required this.translation,
    required this.exampleContext,
    required this.schedulingData,
    this.isActive = true,
  }) : id = id ?? _uuid.v4();

  factory CardModel.from(CardFields other) => CardModel(
        id: other.id,
        word: other.word,
        translation: other.translation,
        exampleContext: other.exampleContext,
        schedulingData: other.schedulingData,
        isActive: other.isActive,
      );

  Json toJson() => <String, Object?>{
        'id': id,
        'word': word,
        'translation': translation,
        'example_context': exampleContext,
        'scheduling_data': schedulingData.toJson(), // should include "type"
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
      id: json['id'] as String? ?? _uuid.v4(),
      word: json['word'] as String,
      translation: json['translation'] as String,
      exampleContext: json['example_context'] as String,
      schedulingData: schedulingData,
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }
  @override
  String toString() {
    return 'CardModel(word: $word, translation: $translation, exampleContext: $exampleContext, schedulingData: $schedulingData, isActive: $isActive)';
  }
}

/// --- Mutable (for forms/editors) -------------------------------------------
class MutableCardModel with CardFields {
  @override
  String id;
  @override
  String word;
  @override
  String translation;
  @override
  String exampleContext;
  @override
  SchedulingData schedulingData;
  @override
  bool isActive;

  MutableCardModel({
    String? id,
    required this.word,
    required this.translation,
    required this.exampleContext,
    required this.schedulingData,
    this.isActive = true,
  }) : id = id ?? _uuid.v4();

  factory MutableCardModel.from(CardFields other) => MutableCardModel(
        id: other.id,
        word: other.word,
        translation: other.translation,
        exampleContext: other.exampleContext,
        schedulingData: other.schedulingData,
        isActive: other.isActive,
      );
}

/// --- Tiny conversion helpers -----------------------------------------------
extension CardModelX on CardModel {
  MutableCardModel toMutable() => MutableCardModel.from(this);
}

extension MutableCardModelX on MutableCardModel {
  CardModel toImmutable() => CardModel.from(this);
}

extension CardModelListX on List<CardModel> {
  List<MutableCardModel> toMutableList() =>
      map((c) => c.toMutable()).toList(growable: true);
}

extension MutableCardModelListX on List<MutableCardModel> {
  List<CardModel> toImmutableList() =>
      map((c) => c.toImmutable()).toList(growable: false);
}

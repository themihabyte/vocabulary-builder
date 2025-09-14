import 'dart:math';

import '../../models/card_model.dart';
import '../abstract_card_selection_algorithm.dart';
import 'probabilistic_scheduling_data.dart';

class ProbabilisticCardSelectionAlgorithm implements CardSelectionAlgorithm {
  // final double timeFactor; // e.g., 0.1

  ProbabilisticCardSelectionAlgorithm(
      // {this.timeFactor = 0.1}
      );

  @override
  CardModel selectCard(List<CardModel> cards) {
    final now = DateTime.now();
    List<double> scores = [];
    double totalScore = 0;

    // Calculate risk scores for each card using its probabilistic scheduling data.
    for (var card in cards) {
      final probabilisticData =
          card.schedulingData as ProbabilisticSchedulingData;
      final daysSinceReview =
          now.difference(probabilisticData.lastReview).inDays.toDouble();
      double timeFactor = 0.0;
      if (daysSinceReview > 7) {
        timeFactor = 1.0;
      } else {
        timeFactor = daysSinceReview / 7.0; // Scale from 0 to 1 over a week
      }
      final risk = (1 - probabilisticData.performanceScore) + timeFactor;
      scores.add(risk);
      totalScore += risk;
    }

    // Choose a card at random, weighted by its risk score.
    final randomValue = Random().nextDouble() * totalScore;
    double cumulative = 0;
    for (int i = 0; i < cards.length; i++) {
      cumulative += scores[i];
      if (randomValue < cumulative) {
        return cards[i];
      }
    }
    // Fallback in case of rounding errors:
    return cards.last;
  }
}

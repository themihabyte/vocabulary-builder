import 'dart:async';

import 'package:flutter/foundation.dart';
import '../algorithms/abstract_card_selection_algorithm.dart';
import '../algorithms/probabilistic/probabilistic_algorithm.dart';
import '../algorithms/probabilistic/probabilistic_scheduling_data.dart';
import '../models/card_model.dart';
import '../services/abstract_deck_repository.dart';

class DeckProvider extends ChangeNotifier {
  final AbstractDeckRepository repository;
  final List<CardModel> _allCards = [];
  CardSelectionAlgorithm algorithm = ProbabilisticCardSelectionAlgorithm();

  late StreamSubscription<List<CardModel>> _deckSub;

  DeckProvider({required this.repository}) {
    _deckSub = repository.watchDeck().listen(_onDeckChanged);
  }

  List<CardModel> get activeCards => _allCards
      .where((card) => card.isActive)
      .toList(growable: false); // Unmodifiable?
  List<CardModel> get allCards => List.unmodifiable(_allCards);

  void _onDeckChanged(List<CardModel> cards) {
    _allCards
      ..clear()
      ..addAll(cards);
    notifyListeners();
  }

  @override
  void dispose() {
    _deckSub.cancel();
    super.dispose();
  }

  void addCard(CardModel card) => repository.insertCard(card);

  Future<void> updateCard(int index, CardModel card) =>
      repository.updateCard(card);

  Future<void> removeCard(int index) {
    final id = _allCards[index].id;
    if (id == null) {
      throw StateError('Can\'t remove a card withour ID assigned');
    }
    return repository.removeCard(id);
  }

  /// Select the next card using the chosen algorithm.
  CardModel get nextCard => algorithm.selectCard(activeCards);

  /// Record a review:
  /// If [remembered] is true, increase the performance score; otherwise, reset it.
  void reviewCard(CardModel card, int index, bool remembered) {
    // Cast the scheduling data to our probabilistic implementation.
    final scheduling = card.schedulingData as ProbabilisticSchedulingData;
    scheduling.lastReview = DateTime.now();
    if (remembered) {
      scheduling.performanceScore =
          (scheduling.performanceScore + 0.1).clamp(0.0, 1.0);
    } else {
      scheduling.performanceScore = 0.0;
    }
    final reviewedCard = CardModel(
        id: card.id,
        word: card.word,
        translation: card.translation,
        exampleContext: card.exampleContext,
        schedulingData: scheduling);
    updateCard(index, reviewedCard);
    notifyListeners();
  }
}

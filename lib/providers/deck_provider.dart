import 'package:flutter/foundation.dart';
import '../algorithms/abstract_card_selection_algorithm.dart';
import '../algorithms/probabilistic/probabilistic_algorithm.dart';
import '../algorithms/probabilistic/probabilistic_scheduling_data.dart';
import '../models/card_model.dart';
import '../services/abstract_deck_repository.dart';

class DeckProvider extends ChangeNotifier {
  final AbstractDeckRepository repository;
  final List<CardModel> _cards = [];
  CardSelectionAlgorithm algorithm = ProbabilisticCardSelectionAlgorithm();

  List<CardModel> get activeCards =>
      _cards.where((card) => card.isActive).toList();
  List<CardModel> get cards => List.unmodifiable(_cards);

  // Inject the repository through the constructor.
  DeckProvider({required this.repository}) {
    _loadDeck();
  }

  Future<void> _loadDeck() async {
    final loadedCards = await repository.loadDeck();
    _cards.clear();
    _cards.addAll(loadedCards);
    notifyListeners();
  }

  void addCard(CardModel card) {
    _cards.add(card);
    repository.saveDeck(_cards);
    notifyListeners();
  }

  void updateDeck(List<CardModel> cards) {
    _cards
      ..clear()
      ..addAll(cards);
    repository.saveDeck(_cards);
    notifyListeners();
  }

  void removeCard(int index) {
    _cards.removeAt(index);
    repository.saveDeck(_cards);
    notifyListeners();
  }

  void updateCard(int index, CardModel newCard) {
    _cards[index] = newCard;
    repository.saveDeck(_cards);
    notifyListeners();
  }

  /// Select the next card using the chosen algorithm.
  CardModel get nextCard => algorithm.selectCard(activeCards);

  /// Record a review:
  /// If [remembered] is true, increase the performance score; otherwise, reset it.
  void reviewCard(CardModel card, bool remembered) {
    // Cast the scheduling data to our probabilistic implementation.
    final scheduling = card.schedulingData as ProbabilisticSchedulingData;
    scheduling.lastReview = DateTime.now();
    if (remembered) {
      scheduling.performanceScore =
          (scheduling.performanceScore + 0.1).clamp(0.0, 1.0);
    } else {
      scheduling.performanceScore = 0.0;
    }
    notifyListeners();
  }
}

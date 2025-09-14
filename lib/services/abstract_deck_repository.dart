import '../models/card_model.dart';

abstract class AbstractDeckRepository {
  Future<List<CardModel>> loadDeck();
  Future<void> saveDeck(List<CardModel> cards);
}

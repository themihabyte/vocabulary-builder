import '../models/card_model.dart';

abstract class AbstractDeckRepository {
  Future<List<CardModel>> loadDeck();
  Future<void> saveDeck(List<CardModel> cards);
  Stream<List<CardModel>> watchDeck();
  Future<void> upsertCard(CardModel card);
  Future<void> removeCard(String id);
}

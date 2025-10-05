import '../models/card_model.dart';

abstract class AbstractDeckRepository {
  Stream<List<CardModel>> watchDeck();

  /// Persists `card` and returns once the write is enqueued.
  ///
  /// The returned `Future` completes before the generated Firebase key is
  /// known. Consumers must wait for `watchDeck()` to emit the updated deck
  /// (or read the card again) before relying on a non-null `id`.
  Future<void> insertCard(CardModel card);

  Future<void> updateCard(CardModel card);
  Future<void> removeCard(String id);
}

import 'package:firebase_database/firebase_database.dart';
import 'package:vocabulary_builder/models/card_model.dart';
import 'package:vocabulary_builder/services/abstract_deck_repository.dart';

// TODO: check offline capabilities

class FirebaseDeckRepository implements AbstractDeckRepository {
  FirebaseDeckRepository({
    required String userId,
    FirebaseDatabase? database,
  })  : _database = database ?? FirebaseDatabase.instance,
        _deckRef =
            (database ?? FirebaseDatabase.instance).ref('users/$userId/deck');

  final FirebaseDatabase _database;
  final DatabaseReference _deckRef;

  List<CardModel> _deserializeSnapshot(DataSnapshot snapshot) {
    final cards = <CardModel>[];
    for (final child in snapshot.children) {
      final value = child.value;
      if (value is! Map) continue; // TODO: what is 'is!'?
      final json = _convertMap(value);
      json['id'] = child.key;
      cards.add(CardModel.fromJson(json));
    }
    return List.unmodifiable(cards);
  }

  Map<String, dynamic> _convertMap(Map raw) {
    return raw.map<String, dynamic>(
      (key, dynamic value) => MapEntry(key.toString(), _convertValue(value)),
    );
  }

  dynamic _convertValue(Object? value) {
    if (value is Map) return _convertMap(value);
    if (value is List) return value.map(_convertValue).toList(growable: false);
    return value;
  }

  @override
  Future<void> removeCard(String id) {
    return _deckRef.child(id).remove();
  }

  @override
  Stream<List<CardModel>> watchDeck() {
    return _deckRef.onValue
        .map((event) => _deserializeSnapshot(event.snapshot));
  }

  /// See [AbstractDeckRepository.insertCard] for lifecycle expectations.
  @override
  Future<void> insertCard(CardModel card) {
    final newCardRef = _deckRef.push();
    return newCardRef.set(card.toJson());
  }

  @override
  Future<void> updateCard(CardModel card) {
    final String? cardRef = card.id;
    if (cardRef == null) {
      throw StateError(
          'Cannot update a card that has not been written to Firebase');
    }

    return _deckRef.child(cardRef).update(card.toJson());
  }
}

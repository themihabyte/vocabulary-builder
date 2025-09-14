import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/card_model.dart';
import 'abstract_deck_repository.dart';

class LocalDeckRepository implements AbstractDeckRepository {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/deck_data.json');
  }

  @override
  Future<List<CardModel>> loadDeck() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((item) => CardModel.fromJson(item)).toList();
    } catch (e) {
      print('Error loading deck: $e');
      return [];
    }
  }

  @override
  Future<void> saveDeck(List<CardModel> cards) async {
    final file = await _localFile;
    final jsonData = cards.map((card) => card.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }
}

import '../models/card_model.dart';

abstract class CardSelectionAlgorithm {
  CardModel selectCard(List<CardModel> cards);
}

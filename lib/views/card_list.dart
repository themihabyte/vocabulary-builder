import 'package:flutter/material.dart';
import 'package:vocabulary_builder/models/card_model.dart';

class CardList extends StatelessWidget {
  final List<CardModel> cards;
  final Function(CardModel) onEdit;
  const CardList({
    super.key,
    required this.cards,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Center(child: Text("No cards in your deck."));
    }
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return CardListItem(
          card: cards[index],
          onEdit: onEdit,
        );
      },
    );
  }
}

class CardListItem extends StatelessWidget {
  final CardModel card;
  final Function(CardModel) onEdit;
  const CardListItem({
    super.key,
    required this.card,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(card.word),
      subtitle: Text(card.translation),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            card.isActive ? Icons.visibility : Icons.visibility_off,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(card),
          ),
        ],
      ),
    );
  }
}

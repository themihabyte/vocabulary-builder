import 'package:flutter/material.dart';
import 'package:vocabulary_builder/models/card_model.dart';

class CardList extends StatelessWidget {
  final List<MutableCardModel> cards;
  final Function(MutableCardModel) onToggleActivity;
  final Function(MutableCardModel) onEdit;
  const CardList({
    super.key,
    required this.cards,
    required this.onToggleActivity,
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
          onToggleActivity: onToggleActivity,
          onEdit: onEdit,
        );
      },
    );
  }
}

class CardListItem extends StatelessWidget {
  final MutableCardModel card;
  final Function(MutableCardModel) onToggleActivity;
  final Function(MutableCardModel) onEdit;

  const CardListItem({
    super.key,
    required this.card,
    required this.onToggleActivity,
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
          IconButton(
            icon: card.isActive
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () => onToggleActivity(card),
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

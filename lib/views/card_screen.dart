import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_builder/models/card_model.dart';
import 'package:vocabulary_builder/views/manage_deck_screen.dart';
import '../widgets/card_widget.dart';
import '../providers/deck_provider.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckProvider>(
      builder: (context, deckProvider, child) {
        final cards = deckProvider.activeCards;
        final hasCards = cards.isNotEmpty;

        final CardModel? currentCard = hasCards ? deckProvider.nextCard : null;
        final int currentIndex = hasCards ? cards.indexOf(currentCard!) : -1;
        final int totalCards = hasCards ? cards.length : -1;

        return Scaffold(
            appBar: _buildAppBar(context),
            body: hasCards
                ? _buildCardBody(
                    context, currentCard!, currentIndex, totalCards)
                : _buildEmptyState(),
            bottomNavigationBar: hasCards
                ? _buildBottomBar(deckProvider, currentCard!, currentIndex)
                : null);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Vocabulary builder'),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageDeckScreen()));
            },
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No cards in your deck. Please add some.'),
    );
  }

  Widget _buildCardBody(BuildContext context, CardModel currentCard,
      int currentIndex, int totalCards) {
    return Stack(
      children: [
        // Position the index text at the top center.
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              "${currentIndex + 1}/$totalCards",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        // Display the card widget in the center.
        Center(child: CardWidget(card: currentCard)),
      ],
    );
  }

  Widget _buildBottomBar(
    DeckProvider deckProvider,
    CardModel currentCard,
    int currentIndex,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    deckProvider.reviewCard(currentCard, currentIndex, false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text("Don't remember"))),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    deckProvider.reviewCard(currentCard, currentIndex, true);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  child: const Text("Remember"))),
        ],
      ),
    );
  }
}

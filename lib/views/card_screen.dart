import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabricks/views/manage_deck_screen.dart';
import '../widgets/card_widget.dart';
import '../providers/deck_provider.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckProvider>(
      builder: (context, deckProvider, child) {
        final cards = deckProvider.activeCards;
        if (cards.isEmpty) {
          return const EmptyCardWidget();
        }

        // Use the scheduling algorithm to choose the next card.
        final currentCard = deckProvider.nextCard;
        final currentIndex = cards.indexOf(currentCard);

        return Scaffold(
            appBar: AppBar(
              title: const Text('VocaBricks'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Manage Deck',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageDeckScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                // Position the index text at the top center.
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "${currentIndex + 1}/${cards.length}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                // Display the card widget in the center.
                Center(child: CardWidget(card: currentCard)),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            deckProvider.reviewCard(currentCard, false);
                            deckProvider.notifyListeners();
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
                            deckProvider.reviewCard(currentCard, true);
                            deckProvider.notifyListeners();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text("Remember")))
                ],
              ),
            ));
      },
    );
  }
}

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Manage Deck',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageDeckScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("No cards in your deck. Please add some."),
      ),
    );
  }
}

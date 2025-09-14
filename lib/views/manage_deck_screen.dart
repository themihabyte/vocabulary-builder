import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabricks/algorithms/probabilistic/probabilistic_scheduling_data.dart';
import '../algorithms/abstract_scheduling_data.dart';
import '../providers/deck_provider.dart';
import '../models/card_model.dart';

// TODO : Place iconbutton to delete card, and toggle active state

class ManageDeckScreen extends StatelessWidget {
  const ManageDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deck Management")),
      body: Consumer<DeckProvider>(
        builder: (context, deckProvider, child) {
          final cards = deckProvider.cards;
          if (cards.isEmpty) {
            return const Center(child: Text("No cards in your deck."));
          }
          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return ListTile(
                title: Text(card.word),
                subtitle: Text(card.translation),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        card.isActive ? Icons.visibility : Icons.visibility_off,
                        color: card.isActive ? Colors.green : Colors.grey,
                      ),
                      tooltip: card.isActive ? 'Set inactive' : 'Set active',
                      onPressed: () {
                        final updatedCard = CardModel(
                          word: card.word,
                          translation: card.translation,
                          exampleContext: card.exampleContext,
                          schedulingData: card.schedulingData,
                          isActive: !card.isActive,
                        );
                        deckProvider.updateCard(index, updatedCard);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => CardDialog(
                          card: card,
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Open a dialog to add a new card.
          showDialog(
            context: context,
            builder: (context) {
              return const CardDialog();
            },
          );
        },
      ),
    );
  }
}

class CardDialog extends StatefulWidget {
  final CardModel? card; // If null, we're adding a new card.
  final int? index; // If provided, we're editing an existing card.

  const CardDialog({super.key, this.card, this.index});

  @override
  _CardDialogState createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  final _formKey = GlobalKey<FormState>();
  late String word;
  late String translation;
  late String exampleContext;
  late SchedulingData schedulingData;
  late bool isActive;
  late DeckProvider deckProvider;
  late int index;

  @override
  void initState() {
    super.initState();
    // Use existing values if editing, otherwise default to empty strings.
    word = widget.card?.word ?? "";
    translation = widget.card?.translation ?? "";
    exampleContext = widget.card?.exampleContext ?? "";
    schedulingData = widget.card?.schedulingData ??
        ProbabilisticSchedulingData(
            lastReview: DateTime.now(), performanceScore: 0.0);
    // TODO: Change to more generic type of SchedulingData
    isActive = widget.card?.isActive ?? true;
    deckProvider = Provider.of<DeckProvider>(context, listen: false);
    index = widget.index ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether we are in edit mode.
    bool isEditing = widget.card != null && widget.index != null;

    return AlertDialog(
      title: Text(isEditing ? "Edit Card" : "Add New Card"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: word,
              decoration: const InputDecoration(labelText: "Word"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a word.";
                }
                return null;
              },
              onSaved: (value) => word = value!,
            ),
            TextFormField(
              initialValue: translation,
              decoration: const InputDecoration(labelText: "Translation"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a translation.";
                }
                return null;
              },
              onSaved: (value) => translation = value!,
            ),
            TextFormField(
              initialValue: exampleContext,
              decoration:
                  const InputDecoration(labelText: "Example in context"),
              onSaved: (value) {
                // Use empty string if value is null.
                exampleContext = value ?? "";
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (isEditing)
          TextButton(
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              deckProvider.removeCard(index);
              Navigator.of(context).pop();
            },
          ),
        TextButton(
          child: Text(isEditing ? "Save" : "Add"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final card = CardModel(
                  word: word,
                  translation: translation,
                  exampleContext: exampleContext,
                  schedulingData: schedulingData,
                  isActive: isActive);
              if (isEditing) {
                deckProvider.updateCard(widget.index!, card);
              } else {
                deckProvider.addCard(card);
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

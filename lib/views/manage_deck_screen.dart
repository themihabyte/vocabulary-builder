import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_builder/algorithms/probabilistic/probabilistic_scheduling_data.dart';
import 'package:vocabulary_builder/views/card_list.dart';
import '../algorithms/abstract_scheduling_data.dart';
import '../providers/deck_provider.dart';
import '../models/card_model.dart';

class ManageDeckScreen extends StatefulWidget {
  const ManageDeckScreen({super.key});

  @override
  State<ManageDeckScreen> createState() => _ManageDeckScreenState();
}

class _ManageDeckScreenState extends State<ManageDeckScreen> {
  void _toggleCardActivity(CardModel card) {
    setState(() {
      // TODO: Implement activity toggle functionality
    });
  }

  Future<void> _onEditCard(CardModel card, int index) async {
    final deckProvider = context.read<DeckProvider>();
    final updatedCard = await showDialog<CardModel>(
      context: context,
      builder: (context) => _CardDialog(card: card),
    );

    if (updatedCard != null) {
      deckProvider.updateCard(index, updatedCard);
    }
    // TODO: enforce Navigator return a result (define enum?). Throw exception if card was expected to return but didnt
  }

  Future<void> _onAddCard() async {
    final deckProvider = context.read<
        DeckProvider>(); // TODO: understand context.read vs Consumer<DeckProvider>
    final newCard = await showDialog<CardModel>(
      context: context,
      builder: (context) => const _CardDialog(),
    );

    if (newCard != null) {
      deckProvider.addCard(newCard);
    }
    // TODO: enforce Navigator return a result. Throw exception if card was expected to return but didnt
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deck Management")),
      body: CardList(
        cards: context.watch<DeckProvider>().allCards,
        onToggleActivity: _toggleCardActivity,
        onEdit: _onEditCard,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddCard,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CardDialog extends StatefulWidget {
  final CardModel? card; // If null, we're adding a new card.

  const _CardDialog({
    this.card,
  });

  @override
  _CardDialogState createState() => _CardDialogState();
}

class _CardDialogState extends State<_CardDialog> {
  final _formKey = GlobalKey<FormState>();
  late String? id;
  late String word;
  late String translation;
  late String exampleContext;
  late SchedulingData schedulingData;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    // Use existing values if editing, otherwise default to empty strings.
    id = widget.card?.id;
    word = widget.card?.word ?? "";
    translation = widget.card?.translation ?? "";
    exampleContext = widget.card?.exampleContext ?? "";
    schedulingData = widget.card?.schedulingData ??
        ProbabilisticSchedulingData(
            lastReview: DateTime.now(), performanceScore: 0.0);
    // TODO: Change to more generic type of SchedulingData
    isActive = widget.card?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether we are in edit mode.
    bool isEditing = widget.card != null;

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
        TextButton(
          child: Text(isEditing ? "Save" : "Add"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              CardModel result;
              result = CardModel(
                id: id,
                word: word,
                translation: translation,
                exampleContext: exampleContext,
                schedulingData: schedulingData,
                isActive: isActive,
              );
              Navigator.of(context).pop(result);
            }
          },
        ),
      ],
    );
  }
}

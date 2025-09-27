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
  late DeckProvider _deckProvider;
  late List<MutableCardModel> _localCards;

  @override
  void initState() {
    super.initState();
    _deckProvider = Provider.of<DeckProvider>(context, listen: false);
    _localCards = _deckProvider.cards.toMutableList();
  }

  void _persistDeck() {
    _deckProvider.updateDeck(_localCards.toImmutableList());
  }

  void _toggleCardActivity(MutableCardModel card) {
    setState(() {
      card.isActive = !card.isActive;
    });
  }

  Future<bool?> _showBackDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Save deck?'),
            content: const Text('Would you like to save changes you made?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _onEditCard(MutableCardModel card) async {
    final updatedCard = await showDialog<MutableCardModel>(
      context: context,
      builder: (context) => _CardDialog(card: card),
    );

    setState(() {
      if (updatedCard != null) {
        final index = _localCards.indexOf(card);
        if (index != -1) {
          _localCards[index] = updatedCard;
        }
      }
    });
  }

  Future<void> _onAddCard() async {
    final newCard = await showDialog<MutableCardModel>(
      context: context,
      builder: (context) => const _CardDialog(),
    );

    if (newCard != null) {
      setState(() {
        _localCards.add(newCard);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldSaveDeck = await _showBackDialog() ?? false;
        if (shouldSaveDeck) {
          _persistDeck();
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Deck Management")),
        body: CardList(
          cards: _localCards,
          onToggleActivity: _toggleCardActivity,
          onEdit: _onEditCard,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddCard,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _CardDialog extends StatefulWidget {
  final MutableCardModel? card; // If null, we're adding a new card.

  const _CardDialog({
    this.card,
  });

  @override
  _CardDialogState createState() => _CardDialogState();
}

class _CardDialogState extends State<_CardDialog> {
  final _formKey = GlobalKey<FormState>();
  late String word;
  late String translation;
  late String exampleContext;
  late SchedulingData schedulingData;
  late bool isActive;

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
              MutableCardModel result;
              if (isEditing) {
                result = widget.card!;
                result
                  ..word = word
                  ..translation = translation
                  ..exampleContext = exampleContext
                  ..schedulingData = schedulingData
                  ..isActive = isActive;
              } else {
                result = MutableCardModel(
                  word: word,
                  translation: translation,
                  exampleContext: exampleContext,
                  schedulingData: schedulingData,
                  isActive: isActive,
                );
              }
              Navigator.of(context).pop(result);
            }
          },
        ),
      ],
    );
  }
}

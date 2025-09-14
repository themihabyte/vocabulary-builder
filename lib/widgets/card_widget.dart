import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardWidget extends StatefulWidget {
  final CardModel card;

  const CardWidget({super.key, required this.card});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool showWord = false; // False by default

  void _toggleContent() {
    setState(() {
      showWord = !showWord;
    });
  }

  @override
  void didUpdateWidget(covariant CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card != widget.card) {
      setState(() {
        showWord = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: GestureDetector(
        onTap: _toggleContent,
        child: SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.75,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    showWord ? widget.card.word : widget.card.translation,
                    style: showWord
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    showWord ? widget.card.exampleContext : "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

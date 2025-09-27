import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_builder/services/local_deck_repository.dart';
import 'package:vocabulary_builder/views/card_screen.dart';
import 'providers/deck_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DeckProvider(repository: LocalDeckRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Cards App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CardScreen(),
    );
  }
}

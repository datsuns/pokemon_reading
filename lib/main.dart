import 'package:flutter/material.dart';
import 'package:pokemon_reading/pokemon_card.dart';
import 'package:pokemon_reading/pokemon_names.dart';

void main() {
  runApp(
    MyApp(
      items: List<int>.generate(1010, (i) => i),
      names: PokemonNames(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<int> items;
  final PokemonNames names;

  const MyApp({super.key, required this.items, required this.names});

  @override
  Widget build(BuildContext context) {
    const title = 'pokemon reading!';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              int n = index + 1;
              return PokemonCard(
                  n, names.loadj(n), names.loadyomij(n), names.loadk(n));
            }),
      ),
    );
  }
}

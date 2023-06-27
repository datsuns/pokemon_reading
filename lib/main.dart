import 'package:flutter/material.dart';
import 'package:pokemon_reading/pokemon_card.dart';
import 'package:pokemon_reading/pokemon_names.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(
    MyApp(
      items: List<int>.generate(1010, (i) => i),
      names: PokemonNames(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final List<int> items;
  final PokemonNames names;

  const MyApp({super.key, required this.items, required this.names});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  void _incrementCounter() {
    setState(() {
      _currentIndex += 100;
      itemScrollController.scrollTo(
          index: _currentIndex, duration: Duration(microseconds: 10));
    });
  }

  void _itemPositionsCallback() {
    final visibleIndexes = itemPositionsListener.itemPositions.value
        .toList()
        .map((itemPosition) => itemPosition.index);
    _currentIndex = visibleIndexes.first;
  }

  @override
  Widget build(BuildContext context) {
    const title = 'pokemon reading!';

    itemPositionsListener.itemPositions.addListener(_itemPositionsCallback);

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ScrollablePositionedList.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            int n = index + 1;
            return PokemonCard(n, widget.names.loadj(n),
                widget.names.loadyomij(n), widget.names.loadk(n));
          },
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

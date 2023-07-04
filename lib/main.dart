import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_reading/pokemon_card.dart';
import 'package:pokemon_reading/pokemon_names.dart';
import 'package:pokemon_reading/sound_player.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:gap/gap.dart';

void main() {
  const int numOfItems = 1010;
  const int scrollUnit = 50;
  runApp(
    MyApp(
      numOfItems: numOfItems,
      names: PokemonNames(),
      allIndexes: List<int>.generate(numOfItems, (i) => i + 1),
      scrollUnit: scrollUnit,
    ),
  );
}

class MyApp extends StatefulWidget {
  final int numOfItems;
  final PokemonNames names;
  final List<int> allIndexes;
  final int scrollUnit;

  const MyApp({
    super.key,
    required this.numOfItems,
    required this.names,
    required this.allIndexes,
    required this.scrollUnit,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  SoundPlayer _player = SoundPlayer(playing: false, player: AudioPlayer());
  var indexes = <int>[];

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  void initState() {
    indexes = widget.allIndexes;
    super.initState();
  }

  int toNamesIndex(int require) {
    return min(indexes.length - 1, require) + 1;
  }

  void _scroll(int i) {
    itemScrollController.scrollTo(
      index: i,
      duration: Duration(microseconds: 100),
    );
    //var tmp = widget.names.filter("フシギ");
    //setState(() {
    //  indexes = tmp;
    //});
  }

  void _resetFilter() {
    setState(() {
      indexes = widget.allIndexes;
    });
  }

  void _scrollUp() {
    setState(() {
      _currentIndex = max(_currentIndex - widget.scrollUnit, 0);
    });
    _scroll(_currentIndex);
  }

  void _scrollDown() {
    setState(() {
      _currentIndex = min(indexes.length, _currentIndex + widget.scrollUnit);
    });
    _scroll(_currentIndex);
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
          itemCount: indexes.length,
          itemBuilder: generatePokemonCard,
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _resetFilter,
              tooltip: 'ResetFilter',
              child: const Icon(Icons.disabled_by_default),
            ),
            Gap(16),
            FloatingActionButton(
              onPressed: _scrollUp,
              tooltip: 'ScrollUp',
              child: const Icon(Icons.keyboard_double_arrow_up),
            ),
            Gap(16),
            FloatingActionButton(
              onPressed: _scrollDown,
              tooltip: 'ScrollDown',
              child: const Icon(Icons.keyboard_double_arrow_down),
            ),
          ],
        ),
      ),
    );
  }

  Widget generatePokemonCard(context, index) {
    int n = toNamesIndex(index);
    return PokemonCard(n, _player, widget.names.loadj(n),
        widget.names.loadyomij(n), widget.names.loadk(n));
  }
}

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_reading/pokemon_card.dart';
import 'package:pokemon_reading/pokemon_names.dart';
import 'package:pokemon_reading/sound_player.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:gap/gap.dart';

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
  SoundPlayer _player = SoundPlayer(playing: false, player: AudioPlayer());
  final int _scrollUnit = 50;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  void _scroll(int i) {
    itemScrollController.scrollTo(
      index: i,
      duration: Duration(microseconds: 100),
    );
  }

  void _scrollUp() {
    setState(() {
      _currentIndex = max(_currentIndex - _scrollUnit, 0);
    });
    _scroll(_currentIndex);
  }

  void _scrollDown() {
    setState(() {
      _currentIndex = min(widget.items.length, _currentIndex + _scrollUnit);
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
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            int n = index + 1;
            return PokemonCard(n, _player, widget.names.loadj(n),
                widget.names.loadyomij(n), widget.names.loadk(n));
          },
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
}

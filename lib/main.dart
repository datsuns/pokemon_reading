import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_reading/pokemon_card.dart';
import 'package:pokemon_reading/pokemon_names.dart';
import 'package:pokemon_reading/sound_player.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:gap/gap.dart';

void main() {
  const int numOfItems = 1202;
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
  var _indexes = <int>[];
  TextEditingController _editingController = TextEditingController();

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ScrollOffsetController _scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener _scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  void initState() {
    _indexes = widget.allIndexes;
    super.initState();
  }

  int _toNamesIndex(int require) {
    if (require > _indexes.length) {
      return _indexes.last;
    }
    return _indexes[require];
  }

  void _scroll(int i) {
    _itemScrollController.scrollTo(
      index: i,
      duration: Duration(microseconds: 100),
    );
  }

  void _setFilter(String text) {
    setState(() {
      _indexes = widget.names.filter(text);
    });
  }

  void _resetFilter() {
    setState(() {
      _indexes = widget.allIndexes;
      _editingController.text = "";
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
      _currentIndex = min(_indexes.length, _currentIndex + widget.scrollUnit);
    });
    _scroll(_currentIndex);
  }

  void _itemPositionsCallback() {
    final visibleIndexes = _itemPositionsListener.itemPositions.value
        .toList()
        .map((itemPosition) => itemPosition.index);
    _currentIndex = visibleIndexes.isEmpty ? 0 : visibleIndexes.first;
  }

  Widget _generatePokemonCard(context, index) {
    int n = _toNamesIndex(index);
    return PokemonCard(widget.names.loadn(n), widget.names.loadn2(n), _player, widget.names.loadj(n),
        widget.names.loadyomij(n), widget.names.loadk(n));
  }

  @override
  Widget build(BuildContext context) {
    const title = 'pokemon reading!';

    _itemPositionsListener.itemPositions.addListener(_itemPositionsCallback);

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _setFilter,
                controller: _editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _resetFilter,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: _indexes.length,
                itemBuilder: _generatePokemonCard,
                itemScrollController: _itemScrollController,
                scrollOffsetController: _scrollOffsetController,
                itemPositionsListener: _itemPositionsListener,
                scrollOffsetListener: _scrollOffsetListener,
              ),
            )
          ],
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

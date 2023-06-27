import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:audioplayers/audioplayers.dart';

class PokemonCard extends StatelessWidget {
  final int n;
  final String nameJ;
  final String yomiJ;
  final String nameK;

  PokemonCard(this.n, this.nameJ, this.yomiJ, this.nameK);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        ListTile(title: Text(sprintf("No.%04d", [n]))),
        ListTile(title: Text(sprintf("%s (%s)", [nameJ, yomiJ]))),
        Image.asset(sprintf("assets/images/%04d.jpg", [n])),
        ElevatedButton(
          onPressed: () {
            String path = sprintf("sounds/%04d.mp3", [n]);
            AudioPlayer().play(AssetSource(path));
          },
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 30)),
          child: Text(nameK),
        ),
      ],
    ));
  }
}

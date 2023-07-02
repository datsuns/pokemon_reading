import 'package:flutter/material.dart';
import 'package:pokemon_reading/sound_player.dart';
import 'package:sprintf/sprintf.dart';

// ignore: must_be_immutable
class PokemonCard extends StatelessWidget {
  final int n;
  final String nameJ;
  final String yomiJ;
  final String nameK;
  SoundPlayer player;

  PokemonCard(this.n, this.player, this.nameJ, this.yomiJ, this.nameK);

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
            player.play(path);
          },
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 30)),
          child: Text(nameK),
        ),
      ],
    ));
  }
}

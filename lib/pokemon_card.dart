import 'package:flutter/material.dart';
import 'package:pokemon_reading/sound_player.dart';
import 'package:sprintf/sprintf.dart';

// ignore: must_be_immutable
class PokemonCard extends StatelessWidget {
  final int n;
  final int n2;
  final String nameJ;
  final String nameJ2;
  final String yomiJ;
  final String yomiJ2;
  final String nameK;
  final String nameK2;
  final String img;
  SoundPlayer player;

  PokemonCard(this.n, this.n2, this.player, this.nameJ, this.nameJ2, this.yomiJ,
      this.yomiJ2, this.nameK, this.nameK2)
      : img = buildImagePath(n, n2);

  static String buildImagePath(int n, int n2) {
    if (n2 == 0) {
      return sprintf("assets/images/%04d.jpg", [n]);
    } else {
      return sprintf("assets/images/%04d-%d.jpg", [n, n2]);
    }
  }

  Widget buildCardTitle() {
    if (nameJ2 == "") {
      return ListTile(
        title: Text(sprintf("%s (%s)", [nameJ, yomiJ])),
      );
    } else {
      return ListTile(
        title: Text(sprintf("%s (%s)", [nameJ, yomiJ])),
        subtitle: Text(sprintf("%s(%s)", [nameJ2, yomiJ2])),
      );
    }
  }

  Widget buildButtonTitle() {
    if (nameK2 == "") {
      return Text(nameK);
    } else {
      return Column(
        children: [
          Text(sprintf("%s", [nameK])),
          Text(
            sprintf("(%s)", [nameK2]),
            style: TextStyle(fontSize: 15),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        ListTile(title: Text(sprintf("No.%04d", [n]))),
        buildCardTitle(),
        Image.asset(img),
        ElevatedButton(
          onPressed: () {
            String path = sprintf("sounds/%04d.mp3", [n]);
            player.play(path);
          },
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 30)),
          child: buildButtonTitle(),
        ),
      ],
    ));
  }
}

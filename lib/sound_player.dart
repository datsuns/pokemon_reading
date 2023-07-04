import 'package:synchronized/synchronized.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  bool playing;
  AudioPlayer player;
  SoundPlayer({required this.playing, required this.player});

  void play(String path) {
    if (start()) {
      player.play(AssetSource(path));
    }
  }

  bool start() {
    var lock = Lock();
    bool started = false;
    lock.synchronized(() {
      if (playing == false) {
        player.onPlayerStateChanged.listen(onPlayerStateChanged);
        playing = true;
        started = true;
      }
    });
    return started;
  }

  void onPlayerStateChanged(event) {
    switch (event) {
      case PlayerState.completed:
        playing = false;
        break;
      default:
        playing = false;
        break;
    }
  }

  void stop() {
    playing = false;
  }
}

import 'package:audioplayers/audioplayers.dart';

abstract class AudioPlayingService {
  startPlayer(String url);

  pauseOrResume();

  seek(Duration duration);

  PlayerState fetchPlayerState();

  Stream<Duration> durationStream();
}

class AudioPlayingServiceI implements AudioPlayingService {
  final player = AudioPlayer();
  @override
  pauseOrResume() {
    if (player.state == PlayerState.paused) {
      player.resume();
    } else {
      player.pause();
    }
  }

  @override
  startPlayer(String url) {
    player.play(UrlSource(url));
  }

  @override
  Stream<Duration> durationStream() {
    return player.onPositionChanged;
  }

  @override
  seek(Duration duration) {
    player.seek(duration);
  }

  @override
  PlayerState fetchPlayerState() {
    return player.state;
  }
}

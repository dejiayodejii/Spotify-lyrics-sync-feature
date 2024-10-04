import 'package:audioplayers/audioplayers.dart';

abstract class AudioPlayingService {
  startPlayer(String url);

  pause();

  resume();

  seek(Duration duration);

  PlayerState fetchPlayerState();

  Stream<Duration> durationStream();
}

class AudioPlayingServiceI implements AudioPlayingService {
  final player = AudioPlayer();
  @override
  pause() {
    player.pause();
  }

  @override
  resume() {
    player.resume();
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

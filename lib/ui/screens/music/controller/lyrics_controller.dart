import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_lyric_sync/data/model/lyrics_model.dart';
import 'package:spotify_lyric_sync/data/model/music_model.dart';
import 'package:spotify_lyric_sync/ui/screens/music/controller/music_lyric_controller.dart';

import '../../../../data/repository/lyric_repo.dart';

class LyricsNotifier extends StateNotifier<LyricsState> {
  final LyricsRepository _repository;
  final Ref _ref;

  LyricsNotifier(this._repository, this._ref) : super(const LyricsState());

  Future<void> fetchLyrics(String songName, String artistName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lyricsString = await _repository.fetchLyrics(songName, artistName);
      final lyrics = lyricsString.split('\n').map(Lyric.fromString).toList();
      state = state.copyWith(lyrics: lyrics, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Stream<Duration> get positionStream => _ref.read(musicProvider.notifier).getPositonStream();

  int getCurrentLyricIndex(Duration duration) {
    if (state.lyrics == null) return -1;
    final currentTime = DateTime(1970, 1, 1).add(duration);
    return state.lyrics!.indexWhere((lyric) => lyric.timeStamp.isAfter(currentTime));
  }
}



final lyricsNotifierProvider = StateNotifierProvider.family<LyricsNotifier, LyricsState, MusicModel>(
  (ref, music) => LyricsNotifier(
    ref.read(lyricsRepositoryProvider),
    ref,
  )..fetchLyrics(music.songName!, music.artistName!),
);

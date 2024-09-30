import 'package:spotify_lyric_sync/data/model/music_model.dart';

class MusicState {
  final bool isLoading;
  final bool isPlaying;
  final String error;
  final MusicModel? musicModel;

  const MusicState({
    this.isLoading = false,
    this.isPlaying = false,
    this.musicModel,
    this.error = "",
  });

  MusicState copyWith({
    bool? isLoading,
    bool? isPlaying,
    String? error,
    MusicModel? musicModel,
  }) {
    return MusicState(
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      error: error ?? this.error,
      musicModel: musicModel ?? this.musicModel,
    );
  }
}
import 'package:intl/intl.dart';

class Lyric {
  final String words;
  final DateTime timeStamp;

  Lyric(this.words, this.timeStamp);

  factory Lyric.fromString(String line) {
    final parts = line.split(' ');
    final timestamp = DateFormat("[mm:ss.SS]").parse(parts[0]);
    final words = parts.sublist(1).join(' ');
    return Lyric(words, timestamp);
  }
}

// lyrics_state.dart
class LyricsState {
  final List<Lyric>? lyrics;
  final bool isLoading;
  final String? error;

  const LyricsState({
    this.lyrics,
    this.isLoading = false,
    this.error,
  });

  LyricsState copyWith({
    List<Lyric>? lyrics,
    bool? isLoading,
    String? error,
  }) {
    return LyricsState(
      lyrics: lyrics ?? this.lyrics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
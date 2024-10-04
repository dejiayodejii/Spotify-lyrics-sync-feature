// lyrics_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_lyric_sync/data/model/lyrics_model.dart';
import 'package:spotify_lyric_sync/ui/screens/music/controller/lyrics_controller.dart';

import '../../../data/model/music_model.dart';

class LyricsPage extends ConsumerWidget {
  final MusicModel music;

  const LyricsPage({super.key, required this.music});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyricsState = ref.watch(lyricsNotifierProvider(music));
    final lyricsNotifier = ref.read(lyricsNotifierProvider(music).notifier);

    return Scaffold(
      backgroundColor: music.songColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 20),
          child: _buildContent(lyricsState, lyricsNotifier),
        ),
      ),
    );
  }

  Widget _buildContent(LyricsState state, LyricsNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white,));
    } else if (state.error != null) {
      return Center(child: Text(state.error!));
    } else if (state.lyrics != null) {
      return _buildLyricsList(state.lyrics!, notifier);
    } else {
      return const Center(child: Text('No lyrics available'));
    }
  }

  Widget _buildLyricsList(List<Lyric> lyrics, LyricsNotifier notifier) {
    return StreamBuilder<Duration>(
      stream: notifier.positionStream,
      builder: (context, snapshot) {
        final currentIndex =
            notifier.getCurrentLyricIndex(snapshot.data ?? Duration.zero);
        return ListView.builder(
          itemCount: lyrics.length,
          itemBuilder: (context, index) =>
              _buildLyricItem(lyrics[index], index == currentIndex),
        );
      },
    );
  }

  Widget _buildLyricItem(Lyric lyric, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        lyric.words,
        style: TextStyle(
          color: isCurrent ? Colors.white : Colors.white38,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

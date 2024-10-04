import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_lyric_sync/core/constant/colors.dart';
import 'package:spotify_lyric_sync/data/model/music_model.dart';
import 'package:spotify_lyric_sync/data/model/music_state_model.dart';
import 'package:spotify_lyric_sync/ui/screens/music/lyric_page.dart';
import 'package:spotify_lyric_sync/ui/components/art_work_image.dart';
import 'package:spotify_lyric_sync/ui/screens/music/controller/music_lyric_controller.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({super.key});

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(musicProvider.notifier).fetchSongDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(musicProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: state.isLoading
              ? _buildLoadingIndicator()
              : state.error.isNotEmpty
                  ? _buildErrorMessage(state.error)
                  : _buildMusicPlayer(state),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildMusicPlayer(MusicState state) {
    final music = state.musicModel!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildHeader(music, textTheme),
        Expanded(
          flex: 2,
          child: Center(child: ArtWorkImage(image: music.songImage)),
        ),
        Expanded(
          child: _buildPlayerControls(music, textTheme, state),
        ),
      ],
    );
  }

  Widget _buildHeader(MusicModel music, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close, color: Colors.transparent),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Singing Now',
              style: textTheme.bodyMedium?.copyWith(color: CustomColors.primaryColor),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: music.artistImage != null
                      ? CachedNetworkImageProvider(music.artistImage!)
                      : null,
                  radius: 10,
                ),
                const SizedBox(width: 4),
                Text(
                  music.artistName ?? '-',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                )
              ],
            )
          ],
        ),
        const Icon(Icons.close, color: Colors.white),
      ],
    );
  }

  Widget _buildPlayerControls(MusicModel music, TextTheme textTheme, MusicState state) {
    final notifier = ref.watch(musicProvider.notifier);

    return Column(
      children: [
        _buildSongInfo(music, textTheme),
        const SizedBox(height: 16),
        _buildProgressBar(notifier, music),
        const SizedBox(height: 16),
        _buildControlButtons(state, notifier, music),
      ],
    );
  }

  Widget _buildSongInfo(MusicModel music, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              music.songName ?? '',
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            Text(
              music.artistName ?? '-',
              style: textTheme.titleMedium?.copyWith(color: Colors.white60),
            ),
          ],
        ),
        const Icon(Icons.favorite, color: CustomColors.primaryColor),
      ],
    );
  }

  Widget _buildProgressBar(MusicLyricsController notifier, MusicModel music) {
    return StreamBuilder<Duration>(
      stream: notifier.getPositonStream(),
      builder: (context, snapshot) {
        return ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          total: music.duration ?? const Duration(minutes: 4),
          bufferedBarColor: Colors.white38,
          baseBarColor: Colors.white10,
          thumbColor: Colors.white,
          timeLabelTextStyle: const TextStyle(color: Colors.white),
          progressBarColor: Colors.white,
          onSeek: notifier.seek,
        );
      },
    );
  }

  Widget _buildControlButtons(MusicState state, MusicLyricsController notifier, MusicModel music) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.lyrics_outlined, color: Colors.white),
          onPressed: () => _navigateToLyricsPage(music),
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            state.isPlaying ? Icons.pause : Icons.play_circle,
            color: Colors.white,
            size: 60,
          ),
          onPressed: notifier.pauseResume,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.loop, color: CustomColors.primaryColor),
          onPressed: () {},
        ),
      ],
    );
  }

  void _navigateToLyricsPage(MusicModel music) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LyricsPage(music: music),
      ),
    );
  }
}
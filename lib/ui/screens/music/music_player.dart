import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_lyric_sync/core/constant/colors.dart';
import 'package:spotify_lyric_sync/ui/screens/music/lyric_page.dart';

import '../../components/art_work_image.dart';
import 'controller/music_lyric_controller.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
         ref.read(musicProvider.notifier).fetchSongDetails();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(musicProvider);
    final music = state.musicModel;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )),
        ),
      );
    } else if (state.error.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: musicWidget()),
        ),
      );
    }
  }

  Widget loadData() {
    final state = ref.watch(musicProvider);
    if (state.isLoading) {
      return const CircularProgressIndicator();
    } else if (state.error.isNotEmpty) {
      return Text(state.error);
    } else {
      return musicWidget();
    }
  }

  Column musicWidget() {
    final textTheme = Theme.of(context).textTheme;
    final notifier = ref.watch(musicProvider.notifier);
    final state = ref.watch(musicProvider);
    final music = state.musicModel!;
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.close, color: Colors.transparent),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Singing Now',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: CustomColors.primaryColor),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: music.artistImage != null
                          ? NetworkImage(music.artistImage!)
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
            const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ],
        ),
        Expanded(
            flex: 2,
            child: Center(
              child: ArtWorkImage(image: music.songImage),
            )),
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.songName ?? '',
                      style:
                          textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      music.artistName ?? '-',
                      style: textTheme.titleMedium
                          ?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
                const Icon(
                  Icons.favorite,
                  color: CustomColors.primaryColor,
                )
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder(
                stream: notifier.getPositonStream(),
                builder: (context, data) {
                  return ProgressBar(
                    progress: data.data ?? const Duration(seconds: 0),
                    total: music.duration ?? const Duration(minutes: 4),
                    bufferedBarColor: Colors.white38,
                    baseBarColor: Colors.white10,
                    thumbColor: Colors.white,
                    timeLabelTextStyle: const TextStyle(color: Colors.white),
                    progressBarColor: Colors.white,
                    onSeek: (duration) {
                      notifier.seek(duration);
                    },
                  );
                }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LyricsPage(
                                    music: music,
                                   
                                  )));
                    },
                    icon:
                        const Icon(Icons.lyrics_outlined, color: Colors.white)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36)),
                IconButton(
                    onPressed: () async {
                      notifier.pauseResume();
                    },
                    icon: Icon(
                      state.isPlaying ? Icons.pause : Icons.play_circle,
                      color: Colors.white,
                      size: 60,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.loop,
                        color: CustomColors.primaryColor)),
              ],
            )
          ],
        ))
      ],
    );
  }
}

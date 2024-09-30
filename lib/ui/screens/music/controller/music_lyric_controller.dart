// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';

import 'package:spotify_lyric_sync/data/model/music_model.dart';
import 'package:spotify_lyric_sync/data/services/spotify_service.dart';
import 'package:spotify_lyric_sync/data/services/youtube_service.dart';

import '../../../../core/utility/pallete_generator.dart';
import '../../../../data/model/music_state_model.dart';
import '../../../../data/services/audio_service.dart';

// Provider definition
final musicProvider =
    StateNotifierProvider<MusicLyricsController, MusicState>((ref) {
  return MusicLyricsController(
    youtubeService: YoutubeServiceI(),
    spotifyService: SpotifyServiceI(),
    audioPlayingService: AudioPlayingServiceI(),
  );
});

class MusicLyricsController extends StateNotifier<MusicState> {
  final YoutubeService _youtubeService;
  final SpotifyService _spotifyService;
  final AudioPlayingService _audioPlayingService;

  MusicLyricsController({
    required YoutubeService youtubeService,
    required SpotifyService spotifyService,
    required AudioPlayingService audioPlayingService,
  })  : _youtubeService = youtubeService,
        _spotifyService = spotifyService,
        _audioPlayingService = audioPlayingService,
        super(const MusicState());

  Future<void> fetchSongDetails() async {
    try {
      startLoading();
      final trackDetails =
          await _spotifyService.getSongDetails("7MXVkk9YMctZqd1Srtv4MB");
      final musicModel = await _createMusicModel(trackDetails);
      state = state.copyWith(isLoading: false, musicModel: musicModel);
      startPlayer(musicModel.audioUrl!);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<MusicModel> _createMusicModel(Track trackDetails) async {
    final artistName = trackDetails.artists?.first.name ?? '';
    final songName = trackDetails.name ?? '';
    final songImage = trackDetails.album?.images?.first.url ?? '';
    final artistImage = trackDetails.artists?.first.images?.first.url ?? '';
    final songColor = await getImagePalette(songImage);
    final moreDetails =
        await _getMoreDetails(songName: songName, artistName: artistName);

    return MusicModel(
      audioUrl: moreDetails.audioUrl,
      duration: moreDetails.duration,
      artistName: artistName,
      songName: songName,
      songImage: songImage,
      artistImage: artistImage,
      songColor: songColor,
    );
  }

  startLoading() {
    state = state.copyWith(isLoading: true, error: '');
  }

  Future<MoreDetails> _getMoreDetails(
      {required String songName, required String artistName}) async {
    return await _youtubeService.getMoreDetails(
        songName: songName, artistName: artistName);
  }

  void startPlayer(String url) => _audioPlayingService.startPlayer(url);
  void pauseResume() => _audioPlayingService.pauseOrResume();

  seek(Duration duration) {
    _audioPlayingService.seek(duration);
  }

  Stream<Duration> getPositonStream() => _audioPlayingService.durationStream();
}

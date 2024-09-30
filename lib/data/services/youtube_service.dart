// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class YoutubeService {
  getAudioUrl(String videoId);

  Future<MoreDetails> getMoreDetails(
      {required String songName, required String artistName});
}

class YoutubeServiceI implements YoutubeService {
  final yt = YoutubeExplode();
  @override
  getAudioUrl(String videoId) {}

  @override
  Future<MoreDetails> getMoreDetails(
      {required String songName, required String artistName}) async {
    final video = (await yt.search.search("$songName $artistName")).first;
    var manifest = await yt.videos.streamsClient.getManifest(video.id.value);
    final details = MoreDetails(
      videoId: video.id.value,
      duration: video.duration!,
      audioUrl: manifest.audioOnly.last.url.toString()
    );
    return details;
  }
}

class MoreDetails {
  final String videoId;
  final Duration duration;
  final String audioUrl;
  MoreDetails({
    required this.videoId,
    required this.duration,
    required this.audioUrl
  });
}

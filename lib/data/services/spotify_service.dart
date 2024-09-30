import 'package:spotify/spotify.dart';

import '../../core/constant/strings.dart';

abstract class SpotifyService {
Future<Track> getSongDetails(String trackId);
}

class SpotifyServiceI implements SpotifyService {
  final SpotifyApi spotifyApi = SpotifyApi(SpotifyApiCredentials(
      CustomStrings.clientId, CustomStrings.clientSecret));

  @override
  Future<Track> getSongDetails(String trackId) async {
    try {
      final trackDetails = await spotifyApi.tracks.get(trackId);
      return trackDetails;
    } catch (e) {
      rethrow;
    }
  }
}

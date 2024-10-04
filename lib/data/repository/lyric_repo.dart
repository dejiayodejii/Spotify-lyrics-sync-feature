import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LyricsRepository {
  Future<String> fetchLyrics(String songName, String artistName) async {
    final url = Uri.parse(
      'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=$songName $artistName&type=default'
    );
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load lyrics: ${response.statusCode}');
    }
  }
}


final lyricsRepositoryProvider = Provider((ref) => LyricsRepository());
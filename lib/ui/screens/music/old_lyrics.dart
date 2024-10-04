// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// import '../../../data/model/lyrics_model.dart';
// import '../../../data/model/music_model.dart';
// import 'controller/music_lyric_controller.dart';

// class LyricsPage extends ConsumerStatefulWidget {
//   final MusicModel music;

//   const LyricsPage({
//     super.key,
//     required this.music,
//   });

//   @override
//   ConsumerState<LyricsPage> createState() => _LyricsPageState();
// }

// class _LyricsPageState extends ConsumerState<LyricsPage> {
//   List<Lyric>? _lyrics;
//   final ItemScrollController _itemScrollController = ItemScrollController();
//   final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
//   StreamSubscription? _streamSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _setupPositionStream();
//     _fetchLyrics();
//   }

//   @override
//   void dispose() {
//     _streamSubscription?.cancel();
//     super.dispose();
//   }

//   void _setupPositionStream() {
//     _streamSubscription = ref.read(musicProvider.notifier).getPositonStream().listen(_scrollToCurrentLyric);
//   }

//   void _scrollToCurrentLyric(Duration duration) {
//     if (_lyrics == null) return;
    
//     final currentTime = _durationToDateTime(duration);
//     final currentIndex = _lyrics!.indexWhere((lyric) => lyric.timeStamp.isAfter(currentTime));
    
//     if (currentIndex > 4) {
//       _itemScrollController.scrollTo(
//         index: currentIndex - 3,
//         duration: const Duration(milliseconds: 600),
//       );
//     }
//   }

//   Future<void> _fetchLyrics() async {
//     final url = Uri.parse(
//       'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${widget.music.songName} ${widget.music.artistName}&type=default'
//     );
    
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         setState(() {
//           _lyrics = _parseLyrics(response.body);
//         });
//       } else {
//         // Handle error
//         print('Failed to load lyrics: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle exception
//       print('Exception while fetching lyrics: $e');
//     }
//   }

//   List<Lyric> _parseLyrics(String data) {
//     return data.split('\n').map((line) {
//       final parts = line.split(' ');
//       final timestamp = DateFormat("[mm:ss.SS]").parse(parts[0]);
//       final words = parts.sublist(1).join(' ');
//       return Lyric(words, timestamp);
//     }).toList();
//   }

//   DateTime _durationToDateTime(Duration duration) {
//     return DateTime(1970, 1, 1).add(duration);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.music.songColor,
//       body: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 20),
//           child: _lyrics != null
//               ? _buildLyricsList()
//               : const Center(child: CircularProgressIndicator()),
//         ),
//       ),
//     );
//   }

//   Widget _buildLyricsList() {
//     return StreamBuilder<Duration>(
//       stream: ref.read(musicProvider.notifier).getPositonStream(),
//       builder: (context, snapshot) {
//         final currentTime = _durationToDateTime(snapshot.data ?? Duration.zero);
//         return ScrollablePositionedList.builder(
//           itemCount: _lyrics!.length,
//           itemBuilder: (context, index) => _buildLyricItem(_lyrics![index], currentTime),
//           itemScrollController: _itemScrollController,
//           itemPositionsListener: _itemPositionsListener,
//         );
//       },
//     );
//   }

//   Widget _buildLyricItem(Lyric lyric, DateTime currentTime) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Text(
//         lyric.words,
//         style: TextStyle(
//           color: lyric.timeStamp.isAfter(currentTime) ? Colors.white38 : Colors.white,
//           fontSize: 26,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
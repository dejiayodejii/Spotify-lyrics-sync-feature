import 'package:flutter/material.dart';

class MusicModel {
  Duration? duration;
  String? trackId;
  String? artistName;
  String? songName;
  String? songImage;
  String? artistImage;
  String? audioUrl;
  Color? songColor;

  MusicModel(
      {this.duration,
      this.trackId,
      this.audioUrl,
      this.artistName,
      this.songName,
      this.songImage,
      this.artistImage,
      this.songColor});
}

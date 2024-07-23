import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/modelsData.dart';

class PlaylistState with ChangeNotifier {
  List<Track> _trackList = [];

  List<Track> get getTrackList => _trackList;

  void updateTrackList(List<Track>? trackList) {
    _trackList = trackList!;

    notifyListeners();
  }
}

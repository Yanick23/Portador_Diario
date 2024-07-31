import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class PlaylistState with ChangeNotifier {
  List<Track> _trackList = [];

  List<Track> get getTrackList => _trackList;

  void updateTrackList(List<Track>? trackList) {
    _trackList = trackList!;

    notifyListeners();
  }
}

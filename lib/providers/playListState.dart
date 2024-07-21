import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/modelsData.dart';

class PlaylistState with ChangeNotifier {
  Playlist? _playlist = Playlist();

  Playlist? get getPlaylist => _playlist;

  void updatePlaylist(Playlist playlist) {
    _playlist = playlist;

    notifyListeners();
  }
}

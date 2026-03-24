import 'dart:convert';

import 'package:melody_player/features/home/data/data_sources/dados.dart';
import 'package:spotify/spotify.dart';

class PlaylistService {
  Playlist getPlayList() {
    try {
      Playlist playlist = Playlist.fromJson(jsonDecode(playListdata));

      print(playlist.name);
      return playlist;
    } catch (e) {
      print(e);
    }
    return Playlist();
  }
}

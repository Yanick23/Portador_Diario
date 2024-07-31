import 'dart:convert';

import 'package:spoti_stream_music/widgets/dados.dart';
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

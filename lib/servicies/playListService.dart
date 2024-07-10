import 'dart:convert';

import 'package:spoti_stream_music/models/modelsData.dart';
import 'package:spoti_stream_music/widgets/dados.dart';

class PlaylistService {
  Playlista? getPlayList() {
    try {
      Playlista playlist = Playlista.fromJson(jsonDecode(playListdata));

      print(playlist.name);
      return playlist;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

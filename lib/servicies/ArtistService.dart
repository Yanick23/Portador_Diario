import 'dart:convert';

import 'package:spoti_stream_music/widgets/dados.dart';
import 'package:spotify/spotify.dart';

class ArtistService {
  List<Artist>? mostPopularArtist() {
    var response = jsonDecode(ArtistData);
    response = response['items'];

    try {
      if (response is List) {
        final List<Artist> artistas = (response as List)
            .map((e) => Artist.fromJson(e as Map<String, dynamic>))
            .toList();

        return artistas;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

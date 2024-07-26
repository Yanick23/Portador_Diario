import 'dart:convert';

import 'package:spoti_stream_music/models/modelsData.dart';
import 'package:spoti_stream_music/widgets/dados.dart';

class ArtistService {
  List<Artists>? mostPopularArtist() {
    var response = jsonDecode(ArtistData);
    response = response['items'];

    try {
      if (response is List) {
        final List<Artists> artistas = (response as List)
            .map((e) => Artists.fromJson(e as Map<String, dynamic>))
            .toList();

        return artistas;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

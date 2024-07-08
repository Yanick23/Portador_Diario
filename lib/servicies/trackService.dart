import 'dart:convert';

//import 'package:audioplayers/audioplayers.dart';
import 'package:spoti_stream_music/models/modelsData.dart';
import 'package:spoti_stream_music/widgets/jj.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class TrackService {
  //final player = AudioPlayer();
  List<Track>? listTrack() {
    try {
      final dynamic jsonResponse = jsonDecode(response);
      if (jsonResponse['items'] is List) {
        final List<Track> tracks = (jsonResponse['items'] as List)
            .map((e) => Track.fromJson(e as Map<String, dynamic>))
            .toList();
        print("Sucesso");
        return tracks;
      }
    } catch (e) {
      print("Erro ao decodificar JSON: $e");
    }
    return null;
  }

  Future<String?> PlayMusic(String text) async {
    final yt = YoutubeExplode();
    final video = (await yt.search.search("$text")).first;
    final videoId = video.id.value;

    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.last.url;
    print(audioUrl.toString());
    //player.play(UrlSource(audioUrl.toString()));
  }
}

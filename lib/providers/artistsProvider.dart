import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/modelsData.dart';

class ArtistProvider with ChangeNotifier {
  late Artists _artista;

  Artists get artista => _artista;

  void setAtistt(Artists artists) {
    _artista = artists;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class ArtistProvider with ChangeNotifier {
  late Artist _artista;

  Artist get artista => _artista;

  void setAtistt(Artist artists) {
    _artista = artists;
    notifyListeners();
  }
}

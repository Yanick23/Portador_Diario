import 'package:flutter/material.dart';

class CurrentIndexMusicState with ChangeNotifier {
  int _currentIndexMusic = 0;

  int get currentIndexMusic => _currentIndexMusic;

  void updateCurrentIndexMusic(int currentIndexMusic) {
    _currentIndexMusic = currentIndexMusic;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class PlayMusicBarState with ChangeNotifier {
  bool _playMusicBarState = false;

  bool get playMusicBarState => _playMusicBarState;

  void updatePlayMusicBarState(bool state) {
    _playMusicBarState = state;
    notifyListeners();
  }
}

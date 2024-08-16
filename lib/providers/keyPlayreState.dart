import 'package:flutter/material.dart';

class Keyplayrestate with ChangeNotifier {
  bool _playMusicKeyStae = false;

  bool get playMusicKeyStae => _playMusicKeyStae;

  void updatePlayMusicBarState(bool state) {
    _playMusicKeyStae = state;
    notifyListeners();
  }
}

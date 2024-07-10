import 'package:flutter/foundation.dart';
import 'package:spoti_stream_music/models/modelsData.dart';
import 'package:spotify/spotify.dart';

class PageState with ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  get showNavigationBar => null;

  void updateSelectedPage(int index) {
    _selectedPage = index;
    notifyListeners();
  }
}

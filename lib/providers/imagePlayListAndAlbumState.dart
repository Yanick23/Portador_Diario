import 'package:flutter/material.dart';

class ImagePlayListAndAlbumstate extends ChangeNotifier {
  String _imageUrl = '';

  String get imageUrl => _imageUrl;

  void updateImageUrl(String imageUrl) {
    _imageUrl = imageUrl;

    notifyListeners();
  }
}

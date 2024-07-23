import 'package:flutter/material.dart';

class TypereproducerState extends ChangeNotifier {
  late Object _ObjecTypereproducer;

  Object get ObjecTypereproducer => _ObjecTypereproducer;

  void updatePlayMusicBarState(Object object) {
    _ObjecTypereproducer = object;
    notifyListeners();
  }
}

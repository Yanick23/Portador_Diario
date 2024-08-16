// ignore_for_file: file_names

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:just_audio/just_audio.dart';

class AudioPLayerProvider with ChangeNotifier {
  List<Track> _trackList = [];

  List<Track> _trackListEmOrdem = [];

  List<Track> get getTrackList => _trackList;
  List<Track> get getTrackListEmOrdem => _trackListEmOrdem;
  final AudioPlayer _audioPLayer = AudioPlayer();
  final List<AudioSource> _playlist = [];

  AudioPlayer get audioPlayer => _audioPLayer;
  List<AudioSource> get playlist => _playlist;

  void updateTrackList(List<Track>? trackList) {
    _trackList = trackList!;

    notifyListeners();
  }

  void updateTrackListEmOrdem(List<Track>? trackList) {
    _trackListEmOrdem = trackList!;

    notifyListeners();
  }

  Future<void> setTackOnPlayList(Track e) async {
    final audioSource = AudioSource.uri(Uri.parse(e.href!),
        tag: MediaItem(
            id: e.id!,
            title: e.name!,
            album: e.album!.name,
            artist: e.artists!.first.name,
            duration: Duration(milliseconds: e.durationMs!),
            artUri: Uri.parse(e.album!.images!.first.url!)));
    _playlist.add(audioSource);
    if (_playlist.length == 1) {
      await _audioPLayer
          .setAudioSource(ConcatenatingAudioSource(children: _playlist));
    } else {
      await (_audioPLayer.audioSource as ConcatenatingAudioSource)
          .add(audioSource);
    }
    notifyListeners();
  }

  Future<void> play() async {
    _audioPLayer.play();
  }

  Future<void> pause() async {
    _audioPLayer.pause();
  }

  Future<void> skipToNext() async {
    _audioPLayer.seekToNext();
  }

  Future<void> skipPrevious() async {
    _audioPLayer.seekToPrevious();
  }

  // ignore: unused_element
  Future<void> _init() async {
    await _audioPLayer.setLoopMode(LoopMode.all);
  }

  // ignore: annotate_overrides
  void dispose() {
    _audioPLayer.dispose();
    super.dispose();
  }
}

import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/spotify.dart';

class AudioPlayerState extends Equatable {
  final List<Track> trackList;
  final List<Track> trackListEmOrdem;
  final List<AudioSource> playlist;
  final AudioPlayer audioPlayer;

  const AudioPlayerState({
    this.trackList = const [],
    this.trackListEmOrdem = const [],
    this.playlist = const [],
    required this.audioPlayer,
  });

  AudioPlayerState copyWith({
    List<Track>? trackList,
    List<Track>? trackListEmOrdem,
    List<AudioSource>? playlist,
    AudioPlayer? audioPlayer,
  }) {
    return AudioPlayerState(
      trackList: trackList ?? this.trackList,
      trackListEmOrdem: trackListEmOrdem ?? this.trackListEmOrdem,
      playlist: playlist ?? this.playlist,
      audioPlayer: audioPlayer ?? this.audioPlayer,
    );
  }

  @override
  List<Object?> get props => [trackList, trackListEmOrdem, playlist, audioPlayer];
}


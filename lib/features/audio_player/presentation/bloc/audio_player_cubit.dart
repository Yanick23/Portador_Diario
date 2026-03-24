import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:spotify/spotify.dart';

import 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(AudioPlayerState(audioPlayer: AudioPlayer()));

  AudioPlayer get audioPlayer => state.audioPlayer;

  void updateTrackList(List<Track>? trackList) {
    emit(state.copyWith(trackList: trackList ?? []));
  }

  void updateTrackListEmOrdem(List<Track>? trackList) {
    emit(state.copyWith(trackListEmOrdem: trackList ?? []));
  }

  void updateTrackListToSources(List<Track>? trackList) {
    if (trackList == null) return;

    var tracs = trackList.map((e) {
      return AudioSource.uri(
        Uri.parse(e.href ?? ''),
        tag: MediaItem(
          id: e.id ?? '',
          title: e.name ?? '',
          album: e.album?.name ?? '',
          artist: e.artists?.first.name ?? '',
          duration: Duration(milliseconds: e.durationMs ?? 0),
          artUri: Uri.parse(e.album?.images?.first.url ?? ''),
        ),
      );
    }).toList();

    emit(state.copyWith(playlist: tracs));
  }

  void updateTrackUri(String trackId, String newUri) {
    var newPlaylist = List<AudioSource>.from(state.playlist);
    int trackIndex = newPlaylist.indexWhere((audioSource) {
      if (audioSource is UriAudioSource) {
        return (audioSource.tag as MediaItem).id == trackId;
      }
      return false;
    });

    if (trackIndex != -1) {
      var oldTrack = newPlaylist[trackIndex] as UriAudioSource;
      var updatedTrack = AudioSource.uri(
        Uri.parse(newUri),
        tag: oldTrack.tag,
      );
      newPlaylist[trackIndex] = updatedTrack;
      emit(state.copyWith(playlist: newPlaylist));
    }
  }

  Future<void> setTackOnPlayList(Track e) async {
    var newPlaylist = List<AudioSource>.from(state.playlist);
    final audioSource = AudioSource.uri(
      Uri.parse(e.href ?? ''),
      tag: MediaItem(
        id: e.id ?? '',
        title: e.name ?? '',
        album: e.album?.name ?? '',
        artist: e.artists?.first.name ?? '',
        duration: Duration(milliseconds: e.durationMs ?? 0),
        artUri: Uri.parse(e.album?.images?.first.url ?? ''),
      ),
    );
    newPlaylist.add(audioSource);

    if (newPlaylist.length == 1) {
      await state.audioPlayer.setAudioSource(ConcatenatingAudioSource(children: newPlaylist));
    } else {
      if (state.audioPlayer.audioSource is ConcatenatingAudioSource) {
        await (state.audioPlayer.audioSource as ConcatenatingAudioSource).add(audioSource);
      }
    }
    emit(state.copyWith(playlist: newPlaylist));
  }

  Future<void> play() async {
    state.audioPlayer.play();
  }

  Future<void> pause() async {
    state.audioPlayer.pause();
  }

  Future<void> skipToNext() async {
    state.audioPlayer.seekToNext();
  }

  Future<void> skipPrevious() async {
    state.audioPlayer.seekToPrevious();
  }

  @override
  Future<void> close() {
    state.audioPlayer.dispose();
    return super.close();
  }
}

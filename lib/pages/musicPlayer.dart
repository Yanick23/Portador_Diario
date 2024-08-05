import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/downloadService.dart';

import 'package:spotify/spotify.dart' as listMusix;

import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/AudioPLayerProvider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayer extends StatefulWidget {
  final bool showBarPlay;

  const MusicPlayer({super.key, required this.showBarPlay});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  int? track;
  Duration? duration;
  bool isPlaying = false;
  bool isLoading = true;
  late AudioPlayer player;
  late List<listMusix.Track> a;
  late String imageUrl = '';

  late Object trackInfo = Object();

  Widget _buildPlayingBar(listMusix.Track? currentTrack, TextTheme textTheme) {
    return SizedBox(
      height: 70,
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            if (isPlaying) {
              await player.pause();
            } else {
              await player.play();
            }
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          child: Icon(
            shadows: const [
              BoxShadow(
                  color: Colors.black, blurRadius: 10, offset: Offset(0, 1)),
              BoxShadow(
                  color: Colors.black, blurRadius: 5, offset: Offset(0, 1))
            ],
            isPlaying ? Icons.pause_sharp : Icons.play_arrow,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          currentTrack?.name ?? '',
          style: const TextStyle(fontSize: 12),
        ),
        subtitle: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            '${currentTrack?.artists!.first.name}'),
        trailing: const Icon(shadows: [
          BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 1)),
          BoxShadow(color: Colors.black, blurRadius: 5, offset: Offset(0, 1))
        ], Icons.favorite),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    track = Provider.of<CurrentIndexMusicState>(context, listen: false)
        .currentIndexMusic;
    late List<listMusix.Track> tracks =
        Provider.of<AudioPLayerProvider>(context, listen: false).getTrackList;
    imageUrl = Provider.of<ImagePlayListAndAlbumstate>(context).imageUrl;
    trackInfo = Provider.of<TypereproducerState>(context).ObjecTypereproducer;

    setState(() {
      a = [];
      for (var element in tracks) {
        a.add(element);
      }
    });

    if (track != null) {
      _setupTrack(track!);
    }
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _nextTrack();
      }
    });

    if (track != null) {
      _setupTrack(track!);
    }
  }

  Future<void> _playMusic(String text) async {
    final yt = YoutubeExplode();
    final video = (await yt.search.search(text)).first;
    final videoId = video.id.value;
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.last.url;

    player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl.toString()),
        tag: MediaItem(
            id: '${a[track!].id}',
            title: '${a[track!].name}',
            artUri: Uri.parse('${a[track!].album!.images!.first.url}'),
            album: '${a[track!].album!.name}')));

    await player.play();
    setState(() {
      isPlaying = true;
    });
  }

  late Color? color = Colors.black;

  Future<void> _setupTrack(int index) async {
    setState(() {
      isLoading = true;
    });

    try {
      var currentTrack = a[index];
      Provider.of<CurrentIndexMusicState>(context, listen: false)
          .updateCurrentIndexMusic(index);
      Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
          .updateImageUrl(imageUrl);
      await _playMusic(
          '${currentTrack.artists!.first.name} - ${currentTrack.name} (audio)');

      String? image = currentTrack.album?.images?.first.url ?? imageUrl;
      final tempSongColor = await getImagePalette(NetworkImage(image));

      setState(() {
        color = tempSongColor;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _nextTrack() {
    if (track! + 1 < a.length) {
      _setupTrack(track! + 1);
    } else {
      player.stop();
    }
  }

  void _previousTrack() {
    if (track! - 1 >= 0) {
      _setupTrack(track! - 1);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    track = Provider.of<CurrentIndexMusicState>(context).currentIndexMusic;

    var currentTrack = a[track!];

    return StreamBuilder<Duration>(
        stream: player.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          return Scaffold(
            backgroundColor: color!,
            body: SafeArea(
              child: widget.showBarPlay
                  ? _buildPlayingBar(currentTrack, textTheme)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.close,
                                  color: Colors.transparent,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(width: 4),
                                        Text(
                                          currentTrack.artists?.first.name ??
                                              "",
                                          maxLines: 1,
                                          style: textTheme.bodyLarge
                                              ?.copyWith(color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Icon(Icons.close, color: Colors.white),
                              ],
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ))
                                    : trackInfo is listMusix.AlbumSimple
                                        ? ArtWorkImage(
                                            image: imageUrl,
                                          )
                                        : ArtWorkImage(
                                            image: currentTrack
                                                .album!.images!.first.url,
                                          ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 310,
                                      child: Text(
                                        currentTrack.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.titleLarge
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      currentTrack.artists!.first.name ?? '-',
                                      maxLines: 1,
                                      style: textTheme.titleMedium
                                          ?.copyWith(color: Colors.white60),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(0, 1)),
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(0, 1))
                                  ],
                                  Icons.favorite,
                                  color: CustomColors.primaryColor,
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            ProgressBar(
                              barCapShape: BarCapShape.square,
                              progress: position,
                              total:
                                  player.duration ?? const Duration(minutes: 4),
                              bufferedBarColor: Colors.white38,
                              buffered: player.bufferedPosition,
                              baseBarColor: Colors.white10,
                              thumbColor: Colors.white,
                              timeLabelTextStyle: const TextStyle(
                                color: Colors.white,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 10,
                                      offset: Offset(0, 1)),
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 10,
                                      offset: Offset(0, 1))
                                ],
                              ),
                              progressBarColor: Colors.white,
                              onSeek: (duration) {
                                player.seek(duration);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _previousTrack,
                                  icon: const Icon(
                                      shadows: [
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10,
                                            offset: Offset(0, 3)),
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 20,
                                            offset: Offset(0, 3))
                                      ],
                                      Icons.skip_previous,
                                      color: Colors.white,
                                      size: 36),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (isPlaying) {
                                      await player.pause();
                                    } else {
                                      await player.play();
                                    }
                                    setState(() {
                                      isPlaying = !isPlaying;
                                    });
                                  },
                                  icon: Icon(
                                    shadows: const [
                                      BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 10,
                                          offset: Offset(0, 3)),
                                      BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 20,
                                          offset: Offset(0, 3))
                                    ],
                                    isPlaying
                                        ? Icons.pause_sharp
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _nextTrack,
                                  icon: const Icon(
                                      shadows: [
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10,
                                            offset: Offset(0, 3)),
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 20,
                                            offset: Offset(0, 3))
                                      ],
                                      Icons.skip_next,
                                      color: Colors.white,
                                      size: 36),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }
}

class ArtWorkImage extends StatelessWidget {
  final String? image;
  const ArtWorkImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Image.network(
            image!,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          width: 2,
                          color: Colors.grey,
                          style: BorderStyle.solid)),
                  child: const Icon(
                    Icons.music_note_outlined,
                    size: 120,
                  ));
            },
          )
        : const Icon(
            Icons.music_note,
            size: 100,
          );
  }
}

Future<Color?> getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor?.color;
}

class CustomColors {
  static const Color primaryColor = Colors.red;
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/ListenNowPage.dart';
import 'package:spoti_stream_music/providers/keyPlayreState.dart';
import 'package:spoti_stream_music/widgets/controller.dart';
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
  late DraggableScrollableController _controller;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  bool loading = false;

  bool _randomList = false;

  bool _options = false;

  bool key = false;

  late AudioPlayer player;
  late List<listMusix.Track> a = [];
  late List<listMusix.Track> randomList = [];
  double _overlayOpacity = 0.5;
  late List<listMusix.Track> shuffledTracks = [];
  List<listMusix.Track> musicasJaTocadas = [];
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

    setState(() {
      key = Provider.of<Keyplayrestate>(context).playMusicKeyStae;

      track = Provider.of<CurrentIndexMusicState>(context, listen: false)
          .currentIndexMusic;

      late List<listMusix.Track> tracks =
          Provider.of<AudioPLayerProvider>(context, listen: false).getTrackList;
      a = List.from(tracks);
      shuffledTracks = List.from(a);
    });

    if (track != null) {
      _setupTrack(track!);
    }
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _controller = DraggableScrollableController()
      ..addListener(
        () {
          double maxExtent = 0.6;
          double currentExtent = _controller.size;
          setState(() {
            _overlayOpacity = 0.5 * (currentExtent / maxExtent);
          });

          if (_controller.size == 0) {
            setState(() {
              _options = false;
            });
          }
        },
      );
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
    try {
      final video = (await yt.search.search(text)).first;
      final videoId = video.id.value;
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.last.url;

      List<AudioSource> child =
          Provider.of<AudioPLayerProvider>(context, listen: false).playlist;
      Provider.of<AudioPLayerProvider>(context, listen: false)
          .updateTrackUri(a[track!].id!, audioUrl.toString());

      // Descomentar e configurar corretamente a fonte de áudio
      await player.setAudioSource(
        ConcatenatingAudioSource(children: child),
        initialIndex: track!,
      );

      await player.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Erro ao tentar reproduzir a música: $e');
      // Tratamento de erro: exibir mensagem ao usuário ou tentar novamente
    }
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

      String artistNames =
          currentTrack.artists!.map((artist) => artist.name).join(', ');

      await _playMusic('${artistNames} - ${currentTrack.name} (Lyrics)');

      String? image = currentTrack.album?.images?.first.url;
      final tempSongColor = await getImagePalette(NetworkImage(image!), 0.2);

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
                    : Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              currentTrack
                                                      .artists?.first.name ??
                                                  "",
                                              maxLines: 1,
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const Icon(Icons.close,
                                        color: Colors.white),
                                  ],
                                ),
                                Expanded(
                                  child: Center(
                                    child: isLoading
                                        ? Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: LoadingAnimationWidget
                                                  .halfTriangleDot(
                                                color: Colors.blue,
                                                size: 50,
                                              ),
                                            ),
                                          )
                                        : ArtWorkImage(
                                            image: currentTrack
                                                .album!.images!.first.url,
                                          ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 180,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.share_outlined,
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
                                                )),
                                            Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  iconSize: 25,
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                  onPressed: () {
                                                    if (_options == false) {
                                                      setState(() {
                                                        _options = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _options = false;
                                                      });
                                                    }
                                                  },
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ListemNowPage(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(shadows: [
                                                  BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 1)),
                                                  BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 1))
                                                ], Icons.format_list_bulleted_rounded))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 250,
                                              child: Text(
                                                currentTrack.name ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.titleLarge
                                                    ?.copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              currentTrack
                                                      .artists!.first.name ??
                                                  '-',
                                              maxLines: 1,
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.white60),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            size: 30,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ProgressBar(
                                      barCapShape: BarCapShape.square,
                                      progress: position,
                                      total: player.duration ??
                                          const Duration(minutes: 4),
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
                                    ControllersRow(
                                      player: player,
                                      isLoading: isLoading,
                                      randomList: _randomList,
                                      musicasJaTocadas: musicasJaTocadas,
                                      a: a,
                                      onPreviousTrack: _previousTrack,
                                      onNextTrack: _nextTrack,
                                      onShufflePressed: () {
                                        baralhar(context);
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                          if (_options)
                            GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _options = false;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  _options = false;
                                });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color:
                                    Colors.black.withOpacity(_overlayOpacity),
                              ),
                            ),
                          if (_options)
                            DraggableScrollableSheet(
                              controller: _controller,
                              initialChildSize: 0.6,
                              minChildSize: 0.0,
                              maxChildSize: 0.6,
                              snapSizes: const [0.6],
                              shouldCloseOnMinExtent: true,
                              expand: true,
                              snap: true,
                              snapAnimationDuration:
                                  Duration(milliseconds: 300),
                              builder:
                                  (context, ScrollController scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    color: Colors.transparent,
                                    child: Container(
                                      height: 700,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Container(
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.white54,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.share,
                                                color: Colors.white),
                                            title: const Text(
                                              'Share',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              // Ação para compartilhar
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.favorite,
                                                color: Colors.white),
                                            title: const Text(
                                              'Add to Favorites',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.playlist_add,
                                                color: Colors.white),
                                            title: const Text(
                                              'Add to Playlist',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                        ],
                      )),
          );
        });
  }

  void baralhar(BuildContext context) {
    if (_randomList == true) {
      a.shuffle();
      Provider.of<AudioPLayerProvider>(context, listen: false)
          .updateTrackList(a);
      Provider.of<CurrentIndexMusicState>(context, listen: false)
          .updateCurrentIndexMusic(0);
    } else {
      Provider.of<AudioPLayerProvider>(context, listen: false).updateTrackList(
          Provider.of<AudioPLayerProvider>(context, listen: false)
              .getTrackListEmOrdem);
      Provider.of<CurrentIndexMusicState>(context, listen: false)
          .updateCurrentIndexMusic(0);
    }
    _randomList = !_randomList;
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

Future<Color?> getImagePalette(ImageProvider imageProvider, amount) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);

  var color = paletteGenerator.dominantColor?.color ?? Colors.black;
  return darken(color, amount);
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
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

import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_infinite_marquee/flutter_infinite_marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import 'package:spoti_stream_music/models/modelsData.dart' as listMusix;
import 'package:spoti_stream_music/providers/audioPlayerProvider.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/playListState.dart';
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

  Widget _buildPlayingBar(listMusix.Track? currentTrack, TextTheme textTheme) {
    return Container(
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
            isPlaying ? Icons.pause_sharp : Icons.play_arrow,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          currentTrack?.name ?? '',
          style: TextStyle(fontSize: 12),
        ),
        subtitle:
            currentTrack?.artists != null && currentTrack!.artists!.isNotEmpty
                ? Container(
                    height: 20,
                    child: currentTrack.artists!.length > 1
                        ? InfiniteMarquee(
                            frequency: Duration(milliseconds: 30),
                            initialScrollOffset: 0,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return Text(', ');
                            },
                            itemBuilder: (context, index) {
                              return Text(
                                  '${currentTrack.artists![index % currentTrack.artists!.length].name}');
                            },
                          )
                        : currentTrack.artists!.length == 1
                            ? Text('${currentTrack.artists![0].name}')
                            : null)
                : Text(
                    '${currentTrack!.artists![0].name}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
        trailing: Icon(Icons.favorite),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    track = Provider.of<CurrentIndexMusicState>(context, listen: false)
        .currentIndexMusic;
    late List<listMusix.Track> tracks =
        Provider.of<PlaylistState>(context, listen: false).getTrackList!;

    setState(() {
      a = [];
      tracks!.forEach((element) {
        a.add(element!);
      });
    });

    if (track != null) {
      _initializeTrack();
    }
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    if (track != null) {
      _initializeTrack();
    }
  }

  Future<void> PlayMusic(String text) async {
    final yt = YoutubeExplode();
    final video = (await yt.search.search(text)).first;
    final videoId = video.id.value;

    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.last.url;

    await player.setUrl(audioUrl.toString());
    await player.play();
    setState(() {
      isPlaying = player.playerState.playing;
      ;
      duration = video.duration!;
    });
  }

  late Color? color = Colors.black;

  void _initializeTrack() async {
    setState(() {
      isLoading = true;
    });
    try {
      var currentTrack = a[track!];
      await PlayMusic(
          '${currentTrack.artists!.first.name} - ${currentTrack.name}');
      String? tempSongName = currentTrack.name;
      if (tempSongName != null) {
        currentTrack.name = tempSongName;

        String? image = currentTrack.album?.images?.first.url;
        if (image != null) {
          final tempSongColor = await getImagePalette(NetworkImage(image));
          if (tempSongColor != null) {
            setState(() {
              color = tempSongColor;
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _changeMusic(int index) async {
    setState(() {
      isLoading = true;
      isPlaying = false;
    });

    var nextTrack = a[index];
    await PlayMusic('${nextTrack.artists!.first!.name} - ${nextTrack.name}');
    String? tempSongName = nextTrack.name;
    if (tempSongName != null) {
      nextTrack.name = tempSongName;

      String? image = nextTrack.album?.images?.first.url;
      if (image != null) {
        final tempSongColor = await getImagePalette(NetworkImage(image));
        if (tempSongColor != null) {
          setState(() {
            color = tempSongColor;
            isLoading = false;
            track = index;
          });
        }
      }
    }
  }

  void _nextTrack() {
    _changeMusic(track! + 1);
  }

  void _previousTrack() {
    if (track! - 1 >= 0) {
      _changeMusic(track! - 1);
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
    print('quantidade - ${a.length}');

    print(currentTrack.name);
    return Scaffold(
      backgroundColor: color!,
      body: widget.showBarPlay
          ? _buildPlayingBar(currentTrack, textTheme)
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
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
                                  currentTrack.artists?.first.name ?? "",
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
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.blue,
                              ))
                            : ArtWorkImage(
                                image: currentTrack.album!.images!.first!.url,
                              ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentTrack.name ?? '',
                                    style: textTheme.titleLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    currentTrack.artists!.first.name ?? '-',
                                    style: textTheme.titleMedium
                                        ?.copyWith(color: Colors.white60),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.favorite,
                                color: CustomColors.primaryColor,
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          StreamBuilder<Duration>(
                              stream: player.positionStream,
                              builder: (context, snapshot) {
                                final position = snapshot.data ?? Duration.zero;
                                return Column(
                                  children: [
                                    ProgressBar(
                                      progress: position,
                                      total: player.duration ??
                                          const Duration(minutes: 4),
                                      bufferedBarColor: Colors.white38,
                                      buffered: player.bufferedPosition ??
                                          Duration.zero,
                                      baseBarColor: Colors.white10,
                                      thumbColor: Colors.white,
                                      timeLabelTextStyle:
                                          const TextStyle(color: Colors.white),
                                      progressBarColor: Colors.white,
                                      onSeek: (duration) {
                                        player.seek(duration);
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _previousTrack();
                                          },
                                          icon: const Icon(Icons.skip_previous,
                                              color: Colors.white, size: 36),
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
                                            isPlaying
                                                ? Icons.pause_sharp
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _nextTrack();
                                          },
                                          icon: const Icon(Icons.skip_next,
                                              color: Colors.white, size: 36),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
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
        : Container(
            child: Icon(
              Icons.music_note,
              size: 100,
            ),
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

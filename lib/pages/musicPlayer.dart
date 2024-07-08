import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'package:spoti_stream_music/models/modelsData.dart' as trackm;

class MusicPlayer extends StatefulWidget {
  final trackm.Track? track;
  const MusicPlayer({super.key, this.track});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  trackm.Track? track;
  YourAudioPlayer player = YourAudioPlayer();

  @override
  void initState() {
    super.initState();
    track = widget.track;

    if (track != null) {
      _initializeTrack();
    }
  }

  late Color? color = Colors.black;

  void _initializeTrack() async {
    String? tempSongName = track?.name;
    if (tempSongName != null) {
      track?.name = tempSongName;

      String? image = track?.album?.images?.first.url;
      if (image != null) {
        final tempSongColor = await getImagePalette(const AssetImage(
            "assets/tlp_hero_album-covers-d12ef0296af80b58363dc0deef077ecc.jpg"));
        if (tempSongColor != null) {
          setState(() {
            color = tempSongColor;
          });
        }
      }
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

    return Scaffold(
      backgroundColor: color!,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 16),
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
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: track?.artists!.first != null
                                ? NetworkImage("")
                                : null,
                            radius: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            track?.artists?.first.name ?? "",
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
                  child: ArtWorkImage(
                    image: track!.album!.images!.first!.url,
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
                              track?.name ?? '',
                              style: textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              track?.artists!.first.name ?? '-',
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
                    StreamBuilder(
                        stream: player.onPositionChanged,
                        builder: (context, data) {
                          return ProgressBar(
                            progress: data.data ?? const Duration(seconds: 0),
                            total: const Duration(minutes: 4),
                            bufferedBarColor: Colors.white38,
                            baseBarColor: Colors.white10,
                            thumbColor: Colors.white,
                            timeLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            progressBarColor: Colors.white,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          );
                        }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LyricsPage(
                                    track: track,
                                    player:
                                        player), // Placeholder for your lyrics page
                              ),
                            );
                          },
                          icon: const Icon(Icons.lyrics_outlined,
                              color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white, size: 36),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (player.state == PlayerState.playing) {
                              player.pause();
                            } else {
                              player.resume();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            player.state == PlayerState.playing
                                ? Icons.pause
                                : Icons.play_circle,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.skip_next,
                              color: Colors.white, size: 36),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.loop,
                              color: CustomColors.primaryColor),
                        ),
                      ],
                    )
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
        ? Image.asset(
            "assets/tlp_hero_album-covers-d12ef0296af80b58363dc0deef077ecc.jpg")
        : Container(
            child: Icon(
              Icons.music_note,
              size: 100,
            ),
          );
  }
}

class YourAudioPlayer {
  void dispose() {}
  void seek(Duration duration) {}
  void pause() async {}
  void resume() async {}
  Stream<Duration> get onPositionChanged => Stream.value(Duration.zero);
  PlayerState get state => PlayerState.paused;
}

enum PlayerState { playing, paused }

Future<Color?> getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor?.color;
}

class LyricsPage extends StatelessWidget {
  final trackm.Track? track;
  final YourAudioPlayer player;
  const LyricsPage({super.key, this.track, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class CustomColors {
  static const Color primaryColor = Colors.red;
}

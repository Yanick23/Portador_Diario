import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/models/modelsData.dart';
import 'package:spoti_stream_music/pages/musicPlayer.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/playListState.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';
import 'package:spoti_stream_music/widgets/trackCard.dart';

class PlayListMusic extends StatefulWidget {
  const PlayListMusic({super.key});

  @override
  State<PlayListMusic> createState() => _PlayListMusicState();
}

class _PlayListMusicState extends State<PlayListMusic> {
  late ScrollController scrollController;
  double imageSize = 0;
  double initialSize = 200;
  double containerHeight = 500;
  double containerinitalHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;
  late Color? color = Colors.black;
  late bool _isLoading = true;
  late List<Track> list = [];

  @override
  void initState() {
    super.initState();
    imageSize = initialSize;
    scrollController = ScrollController()
      ..addListener(() {
        if (!showTopBar) {
          imageSize = initialSize - scrollController.offset;
          if (imageSize < 0) {
            imageSize = 0;
          }
        }
        containerHeight = containerinitalHeight - scrollController.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialSize;
        if (scrollController.offset > 224) {
          showTopBar = true;
        } else {
          showTopBar = false;
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTrack();
  }

  Future<void> _initializeTrack() async {
    var playlist = Provider.of<PlaylistState>(context).getPlaylist!;
    try {
      setState(() {
        list = [];
        playlist!.tracks!.items!.forEach(
          (element) {
            list.add(element!.track!);
          },
        );
      });

      final tempSongColor =
          await getImagePalette(NetworkImage('${playlist.images!.first.url}'));
      if (tempSongColor != null) {
        setState(() {
          color = tempSongColor;
        });
      }
    } catch (e) {
      setState(() {
        color = Color.fromARGB(255, 0, 0, 0);
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var playlist = Provider.of<PlaylistState>(context).getPlaylist!;

    return Scaffold(
      backgroundColor: color,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            color: color,
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 385,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.black.withOpacity(0),
                          Color.fromARGB(255, 0, 0, 0).withOpacity(0),
                          Color.fromARGB(255, 0, 0, 0).withOpacity(0),
                          color!.withOpacity(0.1),
                          Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                          color!.withOpacity(0.1)
                        ])),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                  blurRadius: 30,
                                  color: Color.fromARGB(255, 66, 65, 65))
                            ]),
                            child: Image.network(
                                width: imageSize, height: imageSize,
                                errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                width: 200,
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note,
                                    size: 100,
                                  ),
                                ),
                              );
                            },
                                fit: BoxFit.cover,
                                '${playlist!.images!.first.url}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${playlist!.owner!.displayName}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                            '${playlist.owner!.displayName![0]}'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${playlist!.owner!.displayName}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                                Icons
                                                    .download_for_offline_outlined,
                                                size: 30),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            GestureDetector(
                                                onTap: () {},
                                                child: const Icon(
                                                    Icons
                                                        .person_add_alt_1_outlined,
                                                    size: 30)),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            GestureDetector(
                                                onTap: () {},
                                                child: const Icon(
                                                    Icons.share_outlined,
                                                    size: 30)),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.play_circle_sharp,
                                          size: 40,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: 700,
                    child: ListView.builder(
                      itemCount: playlist?.tracks!.items!.length ?? 0,
                      itemBuilder: (context, index) {
                        final Track track =
                            playlist!.tracks!.items![index]!.track!;
                        return GestureDetector(
                          onTap: () {
                            Provider.of<CurrentIndexMusicState>(context,
                                    listen: false)
                                .updateCurrentIndexMusic(index);
                            Provider.of<PlayMusicBarState>(context,
                                    listen: false)
                                .updatePlayMusicBarState(true);
                          },
                          child: TrackCard(
                            image: track!.album!.images!.first.url!,
                            artista: track!.artists!.first.name!,
                            titulo: track!.name!,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              child: Container(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              color: showTopBar
                  ? Colors.transparent
                  : Color(0xFFC61855).withOpacity(0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: SafeArea(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 38,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 250),
                        opacity: showTopBar ? 1 : 0,
                        child: Text(
                          '${playlist.name}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}

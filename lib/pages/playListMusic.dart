import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/modelsData.dart';
import 'package:spoti_stream_music/pages/musicPlayer.dart';
import 'package:spoti_stream_music/servicies/playListService.dart';
import 'package:spoti_stream_music/servicies/trackService.dart';
import 'package:spoti_stream_music/widgets/trackCard.dart';

class PlayListMusic extends StatefulWidget {
  const PlayListMusic({super.key});

  @override
  State<PlayListMusic> createState() => _PlayListMusicState();
}

class _PlayListMusicState extends State<PlayListMusic> {
  late ScrollController scrollController;
  @override
  double imageSize = 0;
  double initialSize = 200;
  double containerHeight = 500;
  double containerinitalHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;
  late Color? color = Colors.black;
  late bool _isLoading = true;
  List<Track>? lista;

  @override
  void initState() {
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
        setState(() {});
      });
    PlaylistService().getPlayList();
    lista = TrackService().listTrack();
    super.initState();
    _initializeTrack();
  }

  Future<void> _initializeTrack() async {
    try {
      final tempSongColor = await getImagePalette(AssetImage(
          "assets/Free-Music-Album-Cover-Art-Banner-Photoshop-Template-1024x1024.jpg"));
      if (tempSongColor != null) {
        setState(() {
          color = tempSongColor;
          _isLoading = false;
        });
      }
    } catch (e) {
      color = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : Stack(
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
                          height: 350,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.black.withOpacity(0),
                                Color.fromARGB(255, 209, 209, 209)
                                    .withOpacity(0),
                                Color.fromARGB(255, 180, 180, 180)
                                    .withOpacity(0),
                                color!.withOpacity(0.1)
                              ])),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        blurRadius: 100,
                                        color: Color.fromARGB(255, 66, 65, 65))
                                  ]),
                                  child: Image.asset(
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                      "assets/Free-Music-Album-Cover-Art-Banner-Photoshop-Template-1024x1024.jpg"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 16,
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Yanick",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.blue,
                                              child: Text("Y"),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Yanick Ribeiro",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
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
                            itemCount: lista?.length ?? 0,
                            itemBuilder: (context, index) {
                              final Track track = lista![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MusicPlayer(
                                          track: index,
                                          lista: lista!,
                                        ),
                                      ));
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
                    padding: EdgeInsets.symmetric(
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
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  size: 38,
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 250),
                              opacity: showTopBar ? 1 : 0,
                              child: Text(
                                "Ophelia",
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

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoti_stream_music/pages/musicPlayer.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/AudioPLayerProvider.dart';
import 'package:spoti_stream_music/providers/keyPlayreState.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';
import 'package:spoti_stream_music/widgets/trackCard.dart';
import 'package:spotify/spotify.dart' as spoti;

class PlayListMusic extends StatefulWidget {
  const PlayListMusic({super.key});

  @override
  State<PlayListMusic> createState() => _PlayListMusicState();
}

class _PlayListMusicState extends State<PlayListMusic> {
  late ScrollController scrollController;
  late ScrollController scrollController2 = ScrollController();
  double imageSize = 0;
  double initialSize = 210;
  double containerHeight = 500;
  double containerinitalHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;
  bool loading = true;
  late Color? color = Colors.black;
  late List<spoti.Track> list = [];
  late String imageUrl = '';
  final SearchService _searchService = SearchService(
      'cac81364fb3c4160815b48280446612e', 'd12dd157d54342759fe55340b8354e80');
  late SharedPreferences prefs;

  late Object trackInfo = Object();

  @override
  void initState() {
    super.initState();
    imageSize = initialSize;
    scrollController2 = ScrollController();

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          imageSize = initialSize - scrollController.offset;
          imageSize = imageSize < 0 ? 0 : imageSize;
          containerHeight = containerinitalHeight - scrollController.offset;
          containerHeight = containerHeight < 0 ? 0 : containerHeight;
          imageOpacity = imageSize / initialSize;
          showTopBar = scrollController.offset > 224;
        });
      });
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTrack();
  }

  Future<void> _setInfoObject(Object trackinfo) async {
    if (trackInfo is spoti.PlaylistSimple) {
      var playlist = trackInfo as spoti.PlaylistSimple;
      await prefs.setStringList('ObjectType', [playlist.type.toString()]);
    } else if (TrackInfo is spoti.AlbumSimple) {
      var album = trackInfo as spoti.AlbumSimple;
    } else if (TrackInfo is spoti.Track) {
      var track = trackInfo as spoti.Track;
    }
    ;
  }

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _initializeTrack() async {
    try {
      trackInfo = Provider.of<TypereproducerState>(context, listen: false)
          .ObjecTypereproducer;
      List<spoti.Track> tracks = [];

      if (trackInfo is spoti.PlaylistSimple) {
        var playlist = trackInfo as spoti.PlaylistSimple;
        var fetchedTracks = await _searchService.playListTrack(playlist.id!);
        imageUrl = playlist.images!.first.url!;
        tracks = fetchedTracks ?? [];
      } else if (trackInfo is spoti.Album) {
        var album = trackInfo as spoti.Album;
        var fetchedTracks = await _searchService.albumsTracks(album.id!, album);
        imageUrl = album.images!.first.url!;
        tracks = fetchedTracks ?? [];
      } else if (TrackInfo is spoti.Track) {
        var track = trackInfo as spoti.Track;
        var fetchedTracks = await _searchService.getTrack(track.id!);
        imageUrl = track.album!.images!.first.url!;
        tracks = fetchedTracks ?? [];
      }

      setState(() {
        list = tracks;
      });

      final tempSongColor =
          await getImagePalettePlaylist(NetworkImage(imageUrl));
      setState(() {
        color = tempSongColor ?? const Color.fromARGB(255, 0, 0, 0);
      });

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        color = const Color.fromARGB(255, 0, 0, 0);
      });

      setState(() {
        loading = false;
      });
      print('Erro ao inicializar a track: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: loading
          ? Center(
              child: Container(
                height: 60,
                width: 60,
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.blue,
                  size: 50,
                ),
              ),
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
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(imageOpacity),
                                const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0),
                                const Color.fromARGB(255, 179, 166, 166)
                                    .withOpacity(0),
                                color!.withOpacity(0.1),
                                const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.9),
                              ],
                            ),
                          ),
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
                                  imageUrl,
                                  width: imageSize,
                                  height: imageSize,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Center(
                                        child: Icon(
                                          Icons.music_note,
                                          size: 100,
                                        ),
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                ),
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
                                    SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2,
                                          ),
                                          child: Text(
                                            '${_getName(trackInfo)}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
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
                                              '${_getOwnerInicial(trackInfo)}'),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${_getOwner(trackInfo)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons
                                                    .download_for_offline_outlined,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: const Icon(
                                                  Icons.share_outlined,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.play_circle_sharp,
                                              size: 40,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          height: 700,
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final spoti.Track track = list[index];

                              return SingleChildScrollView(
                                controller: scrollController2,
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<AudioPLayerProvider>(context,
                                            listen: false)
                                        .updateTrackList(list);
                                    Provider.of<AudioPLayerProvider>(context,
                                            listen: false)
                                        .updateTrackListEmOrdem(list);
                                    Provider.of<CurrentIndexMusicState>(context,
                                            listen: false)
                                        .updateCurrentIndexMusic(index);
                                    Provider.of<PlayMusicBarState>(context,
                                            listen: false)
                                        .updatePlayMusicBarState(true);
                                  },
                                  child: TrackCard(
                                    image: track!.album!.images!.first!.url!,
                                    titulo: track.name!,
                                    artista: track.artists!.first.name!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  color: showTopBar ? Colors.black : Colors.transparent,
                  child: SafeArea(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Visibility(
                                  visible: showTopBar,
                                  child: Text(
                                    _getName(trackInfo),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _getName(Object trackInfo) {
    if (trackInfo is spoti.PlaylistSimple) {
      return trackInfo.name!;
    } else if (trackInfo is spoti.Album) {
      return trackInfo.name!;
    } else if (trackInfo is spoti.Track) {
      return trackInfo.name!;
    } else {
      return 'N/A';
    }
  }

  String _getOwner(Object trackInfo) {
    if (trackInfo is spoti.PlaylistSimple) {
      return trackInfo.owner!.displayName!;
    } else if (trackInfo is spoti.Album) {
      return trackInfo.artists!.first.name!;
    } else if (trackInfo is spoti.Track) {
      return trackInfo.artists!.first.name!;
    } else {
      return 'N/A';
    }
  }

  String _getOwnerInicial(Object trackInfo) {
    if (trackInfo is spoti.PlaylistSimple) {
      return trackInfo.owner!.displayName![0];
    } else if (trackInfo is spoti.Album) {
      return trackInfo.artists!.first.name![0];
    } else if (trackInfo is spoti.Track) {
      return trackInfo.artists!.first.name![0];
    } else {
      return 'N/A';
    }
  }
}

Future<Color?> getImagePalettePlaylist(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);

  var color = paletteGenerator.dominantColor?.color ?? Colors.black;
  return color;
}

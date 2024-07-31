import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/playListState.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';
import 'package:spotify/spotify.dart' as spoti;

class ArtistPage extends StatefulWidget {
  const ArtistPage();

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late ScrollController scrollController;
  late double? imageSize;
  bool showTopBar = false;
  List<spoti.Album> discografia = [];
  List<spoti.Track> top10Tracks = [];
  spoti.Artist? artist;
  List<spoti.Track> _trackList = [];

  final SearchService _searchService = SearchService(
      'cac81364fb3c4160815b48280446612e', 'd12dd157d54342759fe55340b8354e80');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    artist = Provider.of<ArtistProvider>(context).artista;
    _fetchTopTracks();
  }

  void _fetchTopTracks() async {
    if (artist != null) {
      List<spoti.Track>? tracks =
          await _searchService.top10TrackArtist(artist!.id!);

      List<spoti.Album>? albums = await _searchService.Discografia(
          artist!.id!, ['album', 'single', 'appears_on', 'compilation']);

      setState(() {
        if (tracks != null) {
          top10Tracks = tracks;
          discografia = albums!;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    imageSize = 200;

    scrollController.addListener(() {
      if (scrollController.offset > imageSize!) {
        setState(() {
          showTopBar = true;
        });
      } else {
        setState(() {
          showTopBar = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (artist == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height - 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(artist!.images!.first!.url!),
                fit: BoxFit.fill,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 30,
                  color: Color.fromARGB(255, 66, 65, 65),
                ),
              ],
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 290,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0),
                          const Color.fromARGB(255, 45, 44, 44)
                              .withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 180),
                        Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 2,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  artist!.name!,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    color: Colors.black,
                    height: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top 10 mais ouvidos',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 250,
                          child: ListView.builder(
                            itemCount: top10Tracks.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<PlaylistState>(context,
                                          listen: false)
                                      .updateTrackList(top10Tracks);
                                  Provider.of<CurrentIndexMusicState>(context,
                                          listen: false)
                                      .updateCurrentIndexMusic(index);
                                  Provider.of<PlayMusicBarState>(context,
                                          listen: false)
                                      .updatePlayMusicBarState(true);
                                  Provider.of<TypereproducerState>(context,
                                          listen: false)
                                      .updatePlayMusicBarState(spoti.Track);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 2, color: Colors.grey))),
                                  child: ListTile(
                                    leading: Image.network(
                                        '${top10Tracks[index].album!.images!.first!.url}'),
                                    title: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      '${index + 1}. ${top10Tracks[index].name!}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      '${top10Tracks[index].album!.name}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.sizeOf(context).width,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Center(
                                child: Text(
                                  'Mostrar tudo',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Discografia',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: const Color.fromARGB(255, 149, 148, 148),
                                blurRadius: 20,
                                blurStyle: BlurStyle.outer,
                                offset: Offset.infinite),
                          ]),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: discografia.length,
                            itemBuilder: (context, index) {
                              var item = discografia[index];
                              return GestureDetector(
                                onTap: () async {
                                  final List<spoti.Track>? tracks =
                                      await _searchService
                                          .albumsTracks(item.id!);
                                  Provider.of<PageState>(context, listen: false)
                                      .updateSelectedPage(6);
                                  Provider.of<ImagePlayListAndAlbumstate>(
                                          context,
                                          listen: false)
                                      .updateImageUrl(item.images!.first!.url!);
                                  Provider.of<PlaylistState>(context,
                                          listen: false)
                                      .updateTrackList(tracks);
                                  Provider.of<TypereproducerState>(context,
                                          listen: false)
                                      .updatePlayMusicBarState(item);
                                },
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                            ),
                                            BoxShadow(
                                              color: Colors.white,
                                            )
                                          ],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                item.images!.first!.url!),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        item.name!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        item.releaseDate!,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: showTopBar
                  ? Colors.transparent
                  : const Color(0xFFC61855).withOpacity(0),
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
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleTrackTap(BuildContext context, spoti.Track track) {
    final List<spoti.Track>? tracks = [track];

    Provider.of<PageState>(context, listen: false).updateSelectedPage(6);
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(track!.album!.images!.first!.url!);
    Provider.of<PlaylistState>(context, listen: false).updateTrackList(tracks);
    Provider.of<TypereproducerState>(context, listen: false)
        .updatePlayMusicBarState(track);
  }

  void _handleArtistTap(BuildContext context, spoti.Artist artist) {
    Provider.of<ArtistProvider>(context, listen: false).setAtistt(artist);
    Provider.of<PageState>(context, listen: false).updateSelectedPage(7);
  }

  void _handleAlbumTap(BuildContext context, spoti.AlbumSimple item) async {
    final List<spoti.Track>? tracks =
        await _searchService.albumsTracks(item.id!);
    Provider.of<PageState>(context, listen: false).updateSelectedPage(6);
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(item.images!.first!.url!);
    Provider.of<PlaylistState>(context, listen: false).updateTrackList(tracks);
    Provider.of<TypereproducerState>(context, listen: false)
        .updatePlayMusicBarState(item);
  }

  void _handlePlayListTap(
      BuildContext context, spoti.PlaylistSimple playlist) async {
    final List<spoti.Track>? tracks =
        await _searchService.playListTrack(playlist.id!);

    Provider.of<PageState>(context, listen: false).updateSelectedPage(6);
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(playlist.images!.first!.url!);
    Provider.of<PlaylistState>(context, listen: false).updateTrackList(tracks);
    Provider.of<TypereproducerState>(context, listen: false)
        .updatePlayMusicBarState(playlist);
  }
}

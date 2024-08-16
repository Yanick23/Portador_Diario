// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/keyPlayreState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/AudioPLayerProvider.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';
import 'package:spoti_stream_music/widgets/CircularArtistCard.dart';
import 'package:spoti_stream_music/widgets/dommyCard.dart';
import 'package:spoti_stream_music/widgets/dummyListViewCell.dart';
import 'package:spotify/spotify.dart' as spoti;

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late ScrollController scrollController;
  late double? imageSize;
  bool showTopBar = false;
  List<spoti.Album> discografia = [];
  List<spoti.Track> top10Tracks = [];
  List<spoti.Artist> artists = [];
  List<spoti.PlaylistSimple> playlists = [];
  int count = 0;
  spoti.Artist? artist;
  late spoti.Album? UltimoLancamento = spoti.Album();
  bool _loadingTop10 = true;
  bool _ultimoLancamento = true;
  bool _loadingTopDisc = true;
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
      try {
        final playlists = await _searchService.PlayListArtist(artist!.name!);
        final tracks = await _searchService.top10TrackArtist(artist!.id!);
        final albums =
            await _searchService.Discografia(artist!.id!, ['album', 'single']);
        final artistas = await _searchService.getArtistRelated(artist!.id!);
        setState(() {
          this.playlists = playlists ?? [];
          this.top10Tracks = tracks ?? [];
          this.discografia = albums ?? [];
          this.artists = artistas ?? [];
          this.UltimoLancamento = discografia[0];
          count = discografia.length;
        });
        setState(() {
          _loadingTop10 = false;
          _loadingTopDisc = false;
          _ultimoLancamento = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _loadingTop10 = false;
          _loadingTopDisc = false;
          _ultimoLancamento = false;
        });
      }
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
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _ultimoLancamento
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
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height - 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(artist!.images!.first.url!),
                      fit: BoxFit.cover,
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
                    child: Container(
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
                                  const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0),
                                  const Color.fromARGB(255, 45, 44, 44)
                                      .withOpacity(0.9),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 180),
                                SizedBox(
                                  width: double.infinity,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                2,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20),
                            color: Colors.black,
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Top 10 mais ouvidos',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 250,
                                    child: _loadingTop10
                                        ? Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 126, 123, 123),
                                              highlightColor: Color.fromARGB(
                                                  255, 236, 231, 231),
                                              child: ListView.builder(
                                                itemCount: 5,
                                                itemBuilder: (context, index) {
                                                  return const DummyListViewCell();
                                                },
                                              ),
                                            ),
                                          )
                                        : Flexible(
                                            child: ListView.builder(
                                              itemCount: top10Tracks.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Provider.of<AudioPLayerProvider>(
                                                            context,
                                                            listen: false)
                                                        .updateTrackList(
                                                            top10Tracks);

                                                    Provider.of<AudioPLayerProvider>(
                                                            context,
                                                            listen: false)
                                                        .updateTrackListEmOrdem(
                                                            top10Tracks);
                                                    Provider.of<CurrentIndexMusicState>(
                                                            context,
                                                            listen: false)
                                                        .updateCurrentIndexMusic(
                                                            index);
                                                    Provider.of<PlayMusicBarState>(
                                                            context,
                                                            listen: false)
                                                        .updatePlayMusicBarState(
                                                            true);
                                                    Provider.of<TypereproducerState>(
                                                            context,
                                                            listen: false)
                                                        .UpdateTypereproducerState(
                                                            spoti.Track);
                                                  },
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 2,
                                                                color: Colors
                                                                    .grey))),
                                                    child: ListTile(
                                                      leading: Image.network(
                                                          '${top10Tracks[index].album!.images!.first.url}'),
                                                      title: Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        '${index + 1}. ${top10Tracks[index].name!}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      subtitle: Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        '${top10Tracks[index].album!.name}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Center(
                                          child: Text(
                                            'Mostrar tudo',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Ultimo Lancamento',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 150,
                                    width: 500,
                                    child: count != 0
                                        ? GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context)
                                                  .pushNamed('/playlistMusic');
                                              Provider.of<ImagePlayListAndAlbumstate>(
                                                      context,
                                                      listen: false)
                                                  .updateImageUrl(artist!
                                                      .images!.first!.url!);

                                              Provider.of<TypereproducerState>(
                                                      context,
                                                      listen: false)
                                                  .UpdateTypereproducerState(
                                                      UltimoLancamento!);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 150,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.white,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          '${UltimoLancamento!.images!.first.url ?? ''}'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                          '${UltimoLancamento!.albumType!.name.substring(0, 1).toUpperCase() ?? ''}${discografia.first.albumType!.name.substring(
                                                                1,
                                                              ) ?? ''}'),
                                                      Text(
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.grey),
                                                          'De ${UltimoLancamento!.artists!.first.name ?? ''}'),
                                                      Text(
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.grey),
                                                          'Lancado em ${UltimoLancamento!.releaseDate ?? ''}')
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                  const SizedBox(
                                    height: 10,
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
                                  Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 149, 148, 148),
                                          blurRadius: 20,
                                          blurStyle: BlurStyle.outer,
                                          offset: Offset.infinite),
                                    ]),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: _loadingTopDisc
                                        ? Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 126, 123, 123),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 236, 231, 231),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 4,
                                                itemBuilder: (context, index) {
                                                  return const DummyCard();
                                                },
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: discografia.length,
                                            itemBuilder: (context, index) {
                                              var item = discografia[index];
                                              return GestureDetector(
                                                onTap: () async {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/playlistMusic');
                                                  Provider.of<ImagePlayListAndAlbumstate>(
                                                          context,
                                                          listen: false)
                                                      .updateImageUrl(item
                                                          .images!.first!.url!);

                                                  Provider.of<TypereproducerState>(
                                                          context,
                                                          listen: false)
                                                      .UpdateTypereproducerState(
                                                          item);
                                                },
                                                child: Container(
                                                  width: 150,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                item
                                                                    .images!
                                                                    .first
                                                                    .url!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        item.name!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        item.releaseDate!,
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Artistas semelhantes',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 149, 148, 148),
                                          blurRadius: 20,
                                          blurStyle: BlurStyle.outer,
                                          offset: Offset.infinite),
                                    ]),
                                    height: 190,
                                    width: MediaQuery.of(context).size.width,
                                    child: _loadingTopDisc
                                        ? Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 126, 123, 123),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 236, 231, 231),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 4,
                                                itemBuilder: (context, index) {
                                                  return const DummyCard();
                                                },
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: artists.length,
                                            itemBuilder: (context, index) {
                                              var item = artists[index];

                                              return GestureDetector(
                                                  onTap: () async {
                                                    Provider.of<ArtistProvider>(
                                                            context,
                                                            listen: false)
                                                        .setAtistt(item);
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            '/artistPage');
                                                  },
                                                  child: Row(
                                                    children: [
                                                      CircularArtistCard(
                                                        artistName: item.name!,
                                                        imageUrl: item.images!
                                                            .first!.url!,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ));
                                            },
                                          ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Playlists',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 149, 148, 148),
                                          blurRadius: 20,
                                          blurStyle: BlurStyle.outer,
                                          offset: Offset.infinite),
                                    ]),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: _loadingTopDisc
                                        ? Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 126, 123, 123),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 236, 231, 231),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 4,
                                                itemBuilder: (context, index) {
                                                  return const DummyCard();
                                                },
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: playlists.length,
                                            itemBuilder: (context, index) {
                                              var item = playlists[index];
                                              return GestureDetector(
                                                onTap: () async {
                                                  Provider.of<ImagePlayListAndAlbumstate>(
                                                          context,
                                                          listen: false)
                                                      .updateImageUrl(item
                                                          .images!.first!.url!);

                                                  Provider.of<TypereproducerState>(
                                                          context,
                                                          listen: false)
                                                      .UpdateTypereproducerState(
                                                          item);
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/playlistMusic');
                                                },
                                                child: Container(
                                                  width: 150,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                item
                                                                    .images!
                                                                    .first
                                                                    .url!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        item.name!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 3),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
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
                                    artist!.name!,
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
}

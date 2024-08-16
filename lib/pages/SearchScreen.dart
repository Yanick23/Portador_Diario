import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/AudioPLayerProvider.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';
import 'package:spotify/spotify.dart' as spoti;
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Object> _searchResults = [];
  bool _isLoading = false;
  bool _filterBar = false;
  int controlerChip = 0;

  late List<Object> _filterObjects = [];

  final SearchService _searchService = SearchService(
      'cac81364fb3c4160815b48280446612e', 'd12dd157d54342759fe55340b8354e80');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filterBar = false;
        _searchResults = [];
      });
      return;
    } else {
      setState(() {
        _filterBar = true;
      });
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await _searchService.search(query);
      setState(() {
        _searchResults = results;
        _filterObjects = results;
      });
    } catch (e) {
      print('Error searching: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filtrarItems(Object object) {
    if (object is spoti.Track) {
      setState(() {
        _filterObjects = _searchResults
            .where(
              (element) => element is spoti.Track,
            )
            .toList();
      });
    } else if (object is spoti.PlaylistSimple) {
      setState(() {
        _filterObjects = _searchResults
            .where(
              (element) => element is spoti.PlaylistSimple,
            )
            .toList();
      });
    } else if (object is spoti.AlbumSimple) {
      setState(() {
        _filterObjects = _searchResults
            .where(
              (element) => element is spoti.AlbumSimple,
            )
            .toList();
      });
    } else if (object is spoti.Artist) {
      setState(() {
        _filterObjects = _searchResults
            .where(
              (element) => element is spoti.Artist,
            )
            .toList();
      });
    } else {
      setState(() {
        _filterObjects = _searchResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Pesquisa',
                        hintStyle:
                            TextStyle(fontSize: 18, color: Colors.white54),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  _filterBar
                      ? Container(
                          height: 50,
                          child: ListView(
                            padding: EdgeInsets.all(13),
                            physics: PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildFilterChip(
                                  color: controlerChip == 1
                                      ? Colors.blue
                                      : Colors.white,
                                  label: 'ARTISTAS',
                                  object: spoti.Artist(),
                                  selected: 1),
                              SizedBox(width: 9),
                              _buildFilterChip(
                                  color: controlerChip == 2
                                      ? Colors.blue
                                      : Colors.white,
                                  label: 'PLAYLIST',
                                  object: spoti.PlaylistSimple(),
                                  selected: 2),
                              SizedBox(width: 9),
                              _buildFilterChip(
                                  color: controlerChip == 3
                                      ? Colors.blue
                                      : Colors.white,
                                  label: 'ÁLBUM',
                                  object: spoti.AlbumSimple(),
                                  selected: 3),
                              SizedBox(width: 9),
                              _buildFilterChip(
                                  color: controlerChip == 4
                                      ? Colors.blue
                                      : Colors.white,
                                  label: 'FAIXAS',
                                  object: spoti.Track(),
                                  selected: 4),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 126, 123, 123),
                        highlightColor: Color.fromARGB(255, 236, 231, 231),
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return dummyListViewCell();
                          },
                        ),
                      ),
                    )
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget dummyListViewCell() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              color: Colors.white,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Container(
                  width: 40,
                  height: 8,
                  color: Colors.white,
                ),
              ],
            ))
          ],
        ));
  }

  Widget _buildFilterChip(
      {required String label,
      required Object object,
      required Color color,
      required int selected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          controlerChip = selected;
        });
        _filtrarItems(object);
      },
      child: Container(
        height: 20,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white24,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filterObjects.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filterObjects.length,
      itemBuilder: (context, index) {
        final result = _filterObjects[index];

        return ListTile(
          leading: Image.network(
            _getResultImageUrl(result)!,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.disc_full, color: Colors.white);
            },
          ),
          title: Text(
            _getResultName(result)!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            _getResultType(result)!,
            style: const TextStyle(color: Colors.white54),
          ),
          onTap: () {
            if (result is spoti.Track) {
              _handleTrackTap(context, result);
            }
            if (result is spoti.Album) {
              _handleAlbumTap(context, result);
            } else if (result is spoti.PlaylistSimple) {
              _handlePlayListTap(context, result);
            } else if (result is spoti.Artist) {
              _handleArtistTap(context, spoti.Artist.fromJson(result.toJson()));
            }
          },
        );
      },
    );
  }

  String? _getResultImageUrl(Object result) {
    if (result is spoti.Track) {
      return result.album!.images!.first.url ?? '';
    } else if (result is spoti.AlbumSimple) {
      return result.images!.first.url;
    } else if (result is spoti.Artist) {
      return result.images!.first.url ?? '';
    } else if (result is spoti.PlaylistSimple) {
      return result.images!.first.url;
    } else {
      return '';
    }
  }

  String? _getResultType(Object result) {
    if (result is spoti.Track) {
      return "Track" ?? '';
    } else if (result is spoti.AlbumSimple) {
      return "Album";
    } else if (result is spoti.Artist) {
      return "Artist" ?? '';
    } else if (result is spoti.PlaylistSimple) {
      return "Playlist";
    } else {
      return '';
    }
  }

  String? _getResultName(Object result) {
    if (result is spoti.Track) {
      return result.name;
    } else if (result is spoti.AlbumSimple) {
      return result.name;
    } else if (result is spoti.Artist) {
      return result.name;
    } else if (result is spoti.PlaylistSimple) {
      return result.name;
    } else {
      return '';
    }
  }

  void _handleTrackTap(BuildContext context, spoti.Track track) {
    final List<spoti.Track>? tracks = [spoti.Track.fromJson(track.toJson())];

    Navigator.of(context).pushNamed('/playlistMusic');
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(track!.album!.images!.first!.url!);
    Provider.of<AudioPLayerProvider>(context, listen: false)
        .updateTrackList(tracks);
    Provider.of<TypereproducerState>(context, listen: false)
        .UpdateTypereproducerState(track);
  }

  void _handleArtistTap(BuildContext context, spoti.Artist artist) {
    Provider.of<ArtistProvider>(context, listen: false).setAtistt(artist);
    Navigator.of(context).pushNamed('/artistPage');
  }

  void _handleAlbumTap(BuildContext context, spoti.Album albumSimple) async {
    final List<spoti.Track>? tracks =
        await _searchService.albumsTracks(albumSimple.id!, albumSimple);
    Navigator.of(context).pushNamed('/playlistMusic');
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(albumSimple.images!.first!.url!);

    Provider.of<TypereproducerState>(context, listen: false)
        .UpdateTypereproducerState(albumSimple);
  }

  void _handlePlayListTap(
      BuildContext context, spoti.PlaylistSimple playlist) async {
    final List<spoti.Track>? tracks =
        await _searchService.playListTrack(playlist.id!);
    final bf = tracks?.map((e) => print(e.name)).toList() ?? [];
    Navigator.of(context).pushNamed('/playlistMusic');
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(playlist.images!.first!.url!);

    Provider.of<TypereproducerState>(context, listen: false)
        .UpdateTypereproducerState(playlist);
  }
}

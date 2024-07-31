import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/playListState.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';
import 'package:spotify/spotify.dart' as spoti;

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
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
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
      return Center(
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
              return Icon(Icons.disc_full, color: Colors.white);
            },
          ),
          title: Text(
            _getResultName(result)!,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            _getResultType(result)!,
            style: TextStyle(color: Colors.white54),
          ),
          onTap: () {
            if (result is spoti.Track) {
              _handleTrackTap(context, result);
            }
            if (result is spoti.AlbumSimple) {
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

  void _handleAlbumTap(
      BuildContext context, spoti.AlbumSimple albumSimple) async {
    final List<spoti.Track>? tracks =
        await _searchService.albumsTracks(albumSimple.id!);
    Provider.of<PageState>(context, listen: false).updateSelectedPage(6);
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(albumSimple.images!.first!.url!);
    Provider.of<PlaylistState>(context, listen: false).updateTrackList(tracks);
    Provider.of<TypereproducerState>(context, listen: false)
        .updatePlayMusicBarState(albumSimple);
  }

  void _handlePlayListTap(
      BuildContext context, spoti.PlaylistSimple playlist) async {
    final List<spoti.Track>? tracks =
        await _searchService.playListTrack(playlist.id!);
    final bf = tracks?.map((e) => print(e.name)).toList() ?? [];
    Provider.of<PageState>(context, listen: false).updateSelectedPage(6);
    Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
        .updateImageUrl(playlist.images!.first!.url!);
    Provider.of<PlaylistState>(context, listen: false).updateTrackList(tracks);
    Provider.of<TypereproducerState>(context, listen: false)
        .updatePlayMusicBarState(playlist);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/artist_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/audio_player_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/type_reproducer_cubit.dart';
import 'package:melody_player/features/search/data/data_sources/searchService.dart';
import 'package:spotify/spotify.dart' as spoti;
import 'package:shimmer/shimmer.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/image_playlist_and_album_cubit.dart';
import 'package:melody_player/core/services/service_locator.dart';
import 'package:melody_player/core/presentation/responsive/responsive_layout.dart';
import 'package:melody_player/features/home/presentation/widgets/music_card.dart';

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

  final SearchService _searchService = sl<SearchService>();

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
        _filterObjects = _searchResults.where((e) => e is spoti.Track).toList();
      });
    } else if (object is spoti.PlaylistSimple) {
      setState(() {
        _filterObjects = _searchResults.where((e) => e is spoti.PlaylistSimple).toList();
      });
    } else if (object is spoti.AlbumSimple) {
      setState(() {
        _filterObjects = _searchResults.where((e) => e is spoti.AlbumSimple).toList();
      });
    } else if (object is spoti.Artist) {
      setState(() {
        _filterObjects = _searchResults.where((e) => e is spoti.Artist).toList();
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
      body: Column(
        children: [
          _buildSearchHeader(context),
          if (_filterBar) _buildFilterBar(),
          Expanded(
            child: _isLoading ? _buildShimmer() : _buildSearchResults(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    bool isDesktop = ResponsiveLayout.isDesktop(context);
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Pesquisa',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 16),
            const CircleAvatar(
              backgroundColor: Colors.white10,
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 50,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(label: 'ARTISTAS', object: spoti.Artist(), selected: 1),
          const SizedBox(width: 8),
          _buildFilterChip(label: 'PLAYLIST', object: spoti.PlaylistSimple(), selected: 2),
          const SizedBox(width: 8),
          _buildFilterChip(label: 'ÁLBUM', object: spoti.AlbumSimple(), selected: 3),
          const SizedBox(width: 8),
          _buildFilterChip(label: 'FAIXAS', object: spoti.Track(), selected: 4),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white10,
      highlightColor: Colors.white24,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, __) => _buildShimmerItem(),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(width: 64, height: 64, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: double.infinity, height: 12, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: 150, height: 10, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (_filterObjects.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    bool isDesktop = ResponsiveLayout.isDesktop(context);
    bool isTablet = ResponsiveLayout.isTablet(context);

    if (isDesktop || isTablet) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _filterObjects.length,
        itemBuilder: (context, index) {
          final result = _filterObjects[index];
          return MusicCard(
            title: _getResultName(result) ?? 'Unknown',
            artist: _getResultType(result) ?? '',
            imageUrl: _getResultImageUrl(result) ?? '',
            isLarge: isDesktop,
            onTap: () => _handleResultTap(context, result),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: _filterObjects.length,
      itemBuilder: (context, index) {
        final result = _filterObjects[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              _getResultImageUrl(result) ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: Colors.white),
            ),
          ),
          title: Text(
            _getResultName(result) ?? 'Unknown',
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _getResultType(result) ?? '',
            style: const TextStyle(color: Colors.white54),
          ),
          onTap: () => _handleResultTap(context, result),
        );
      },
    );
  }

  void _handleResultTap(BuildContext context, Object result) {
    if (result is spoti.Track) {
      _handleTrackTap(context, result);
    } else if (result is spoti.Album) {
      _handleAlbumTap(context, result);
    } else if (result is spoti.PlaylistSimple) {
      _handlePlayListTap(context, result);
    } else if (result is spoti.Artist) {
      _handleArtistTap(context, spoti.Artist.fromJson(result.toJson()));
    }
  }

  Widget _buildFilterChip({
    required String label,
    required Object object,
    required int selected,
  }) {
    bool isSelected = controlerChip == selected;
    return GestureDetector(
      onTap: () {
        setState(() {
          controlerChip = selected;
        });
        _filtrarItems(object);
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String? _getResultImageUrl(Object result) {
    if (result is spoti.Track) return result.album?.images?.first.url;
    if (result is spoti.AlbumSimple) return result.images?.first.url;
    if (result is spoti.Artist) return result.images?.first.url;
    if (result is spoti.PlaylistSimple) return result.images?.first.url;
    return null;
  }

  String? _getResultType(Object result) {
    if (result is spoti.Track) return "Track";
    if (result is spoti.AlbumSimple) return "Album";
    if (result is spoti.Artist) return "Artist";
    if (result is spoti.PlaylistSimple) return "Playlist";
    return null;
  }

  String? _getResultName(Object result) {
    if (result is spoti.Track) return result.name;
    if (result is spoti.AlbumSimple) return result.name;
    if (result is spoti.Artist) return result.name;
    if (result is spoti.PlaylistSimple) return result.name;
    return null;
  }

  void _handleTrackTap(BuildContext context, spoti.Track track) {
    final List<spoti.Track> tracks = [spoti.Track.fromJson(track.toJson())];
    Navigator.of(context).pushNamed('/playlistMusic');
    context.read<ImagePlayListAndAlbumCubit>().updateImageUrl(track.album?.images?.first.url ?? '');
    context.read<AudioPlayerCubit>().updateTrackList(tracks);
    context.read<TypeReproducerCubit>().updateTypeReproducerState(track);
  }

  void _handleArtistTap(BuildContext context, spoti.Artist artist) {
    context.read<ArtistCubit>().setArtist(artist);
    Navigator.of(context).pushNamed('/artistPage');
  }

  void _handleAlbumTap(BuildContext context, spoti.Album album) async {
    final List<spoti.Track>? tracks = await _searchService.albumsTracks(album.id!, album);
    Navigator.of(context).pushNamed('/playlistMusic');
    context.read<ImagePlayListAndAlbumCubit>().updateImageUrl(album.images?.first.url ?? '');
    context.read<TypeReproducerCubit>().updateTypeReproducerState(album);
  }

  void _handlePlayListTap(BuildContext context, spoti.PlaylistSimple playlist) async {
    final List<spoti.Track>? tracks = await _searchService.playListTrack(playlist.id!);
    Navigator.of(context).pushNamed('/playlistMusic');
    context.read<ImagePlayListAndAlbumCubit>().updateImageUrl(playlist.images?.first.url ?? '');
    context.read<TypeReproducerCubit>().updateTypeReproducerState(playlist);
  }
}

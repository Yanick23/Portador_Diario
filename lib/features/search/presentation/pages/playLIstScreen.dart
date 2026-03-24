// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:melody_player/features/audio_player/presentation/bloc/type_reproducer_cubit.dart';
import 'package:melody_player/features/home/data/data_sources/playListService.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/image_playlist_and_album_cubit.dart';

import 'package:spotify/spotify.dart' as spoti;

import 'package:melody_player/core/presentation/responsive/responsive_layout.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});
  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  late spoti.Playlist? playlist1 = PlaylistService().getPlayList();
  final List<spoti.Playlist> _playlists = [];

  @override
  void initState() {
    if (playlist1 != null) {
      _playlists.add(playlist1!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveLayout.isDesktop(context);
    bool isTablet = ResponsiveLayout.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Suas Playlists",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: _buildPlaylistContent(context, isDesktop, isTablet),
    );
  }

  Widget _buildPlaylistContent(
      BuildContext context, bool isDesktop, bool isTablet) {
    if (_playlists.isEmpty) {
      return const Center(
        child: Text("Nenhuma playlist encontrada",
            style: TextStyle(color: Colors.white54)),
      );
    }

    if (isDesktop || isTablet) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          final playlist = _playlists[index];
          return _buildPlaylistCard(context, playlist, isDesktop);
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return _buildPlaylistTile(context, playlist);
      },
    );
  }

  Widget _buildPlaylistCard(
      BuildContext context, spoti.Playlist playlist, bool isDesktop) {
    return GestureDetector(
      onTap: () => _handlePlaylistTap(context, playlist),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                playlist.images?.first.url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    color: Colors.white10,
                    child: const Icon(Icons.playlist_play,
                        color: Colors.white, size: 48)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playlist.name ?? 'Untitled',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${playlist.tracks?.total ?? 0} músicas',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(BuildContext context, spoti.Playlist playlist) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          playlist.images?.first.url ?? '',
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.playlist_play, color: Colors.white),
        ),
      ),
      title: Text(playlist.name ?? 'Untitled',
          style: const TextStyle(color: Colors.white)),
      subtitle: Text('${playlist.tracks?.total ?? 0} músicas',
          style: const TextStyle(color: Colors.white54)),
      onTap: () => _handlePlaylistTap(context, playlist),
    );
  }

  void _handlePlaylistTap(BuildContext context, spoti.Playlist playlist) {
    Navigator.of(context).pushNamed('/playlistMusic');
    if (playlist.images?.isNotEmpty ?? false) {
      context
          .read<ImagePlayListAndAlbumCubit>()
          .updateImageUrl(playlist.images!.first.url!);
    }
    context.read<TypeReproducerCubit>().updateTypeReproducerState(playlist);
  }
}

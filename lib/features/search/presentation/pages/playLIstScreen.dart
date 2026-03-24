// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:melody_player/features/audio_player/presentation/bloc/type_reproducer_cubit.dart';
import 'package:melody_player/features/home/data/data_sources/playListService.dart';
import 'package:melody_player/features/home/presentation/widgets/cardplayListInfo.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/image_playlist_and_album_cubit.dart';

import 'package:spotify/spotify.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});
  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  late Playlist? playlist1 = PlaylistService().getPlayList();
  final List<Playlist> _playlists = [];

  @override
  void initState() {
    setState(() {
      _playlists.add(playlist1!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.search,
              size: 30,
            ),
          )
        ],
        title: const Text(
          "Playlists",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5),
        child: ListView.builder(
          itemCount: _playlists.length,
          itemBuilder: (context, index) {
            final playlist = _playlists[index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/playlistMusic');
                context.read<ImagePlayListAndAlbumCubit>()
                    .updateImageUrl(_playlists[index].images!.first.url!);
                context.read<TypeReproducerCubit>()
                    .updateTypeReproducerState(playlist);
              },
              child: CardplayListInfo(
                playlistinfo: playlist,
              ),
            );
          },
        ),
      ),
    );
  }
}



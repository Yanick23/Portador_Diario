// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';

import 'package:spoti_stream_music/providers/typeReproducer.dart';
import 'package:spoti_stream_music/servicies/playListService.dart';
import 'package:spoti_stream_music/widgets/CardPlayList.dart';
import 'package:spoti_stream_music/widgets/cardplayListInfo.dart';

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
                Provider.of<ImagePlayListAndAlbumstate>(context, listen: false)
                    .updateImageUrl(_playlists[index].images!.first.url!);
                Provider.of<TypereproducerState>(context, listen: false)
                    .UpdateTypereproducerState(playlist);
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

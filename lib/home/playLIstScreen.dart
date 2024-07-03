import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/playlistInfo.dart';
import 'package:spoti_stream_music/widget/CardPlayList.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  final List<Playlistinfo> _playlists = [
    Playlistinfo("Playlist 1", "Description 1", "ImageURL 1"),
    Playlistinfo("Playlist 2", "Description 2", "ImageURL 2"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Playlists",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          final playlist = _playlists[index];
          return CardPlayList(
            titulo: playlist.title,
            descricao: playlist.nome,
          );
        },
      ),
    );
  }
}

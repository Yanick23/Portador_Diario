import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/models/playlistInfo.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/widget/CardPlayList.dart';
import 'package:spoti_stream_music/widget/cardplayListInfo.dart';

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
        leading: IconButton(
            onPressed: () {
              Provider.of<PageState>(context, listen: false)
                  .updateSelectedPage(4);
            },
            icon: Icon(Icons.arrow_back)),
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
            return CardplayListInfo(
              playlistinfo:
                  Playlistinfo(playlist.nome, playlist.criador, playlist.image),
            );
          },
        ),
      ),
    );
  }
}

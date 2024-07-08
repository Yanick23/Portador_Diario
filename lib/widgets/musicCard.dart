import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/modelsData.dart' as playlist;

class MusicCard extends StatelessWidget {
  // final playlist.Playlistinfo playlistinfo;
  const MusicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
        child: ListTile(
          leading: Image.network(
            "kk",
            errorBuilder: (context, error, stackTrace) => Container(
              child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Icon(Icons.music_note)),
            ),
          ),
          title: Text("hh"),
          subtitle: Text(' gg'),
          trailing: Container(
            child: Icon(Icons.play_arrow),
          ),
        ));
  }
}

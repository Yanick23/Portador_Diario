import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/playlistInfo.dart';

class CardplayListInfo extends StatelessWidget {
  final Playlistinfo playlistinfo;
  const CardplayListInfo({super.key, required this.playlistinfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
      child: ListTile(
          leading: Image.network(
            playlistinfo.image,
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
          title: Text(playlistinfo.nome),
          subtitle: Text(' ${playlistinfo.nome}'),
          trailing: Container(
            child: Icon(Icons.play_arrow),
          )),
    );
  }
}

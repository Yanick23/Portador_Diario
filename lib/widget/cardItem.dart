import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/playlistInfo.dart';

class Cardplaylistinfo extends StatelessWidget {
  final Playlistinfo playlistinfo;
  const Cardplaylistinfo({super.key, required this.playlistinfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
      child: ListTile(
          leading: Image.network(playlistinfo.image),
          title: Text(playlistinfo.nome),
          subtitle: Text(' ${playlistinfo.nome}'),
          trailing: Container(
            child: Icon(Icons.play_arrow),
          )),
    );
  }
}

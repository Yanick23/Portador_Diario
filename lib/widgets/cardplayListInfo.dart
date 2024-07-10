import 'package:flutter/material.dart';
import 'package:spoti_stream_music/models/modelsData.dart' as playlist;

class CardplayListInfo extends StatelessWidget {
  final playlist.Playlista playlistinfo;
  const CardplayListInfo({super.key, required this.playlistinfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
      child: ListTile(
          leading: Image.network(
            playlistinfo.images!.first!.url!,
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
          title: Text(playlistinfo!.name!),
          subtitle: Text(
            '${playlistinfo.owner!.displayName!}',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: const Icon(Icons.play_arrow)),
    );
  }
}

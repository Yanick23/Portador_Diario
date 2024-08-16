import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/providers/AudioPLayerProvider.dart';
import 'package:spoti_stream_music/widgets/trackCard.dart';
import 'package:spotify/spotify.dart' as spoti;

class ListemNowPage extends StatefulWidget {
  const ListemNowPage({super.key});

  @override
  State<ListemNowPage> createState() => _ListemNowPageState();
}

class _ListemNowPageState extends State<ListemNowPage> {
  late List<spoti.Track> list = [];

  @override
  void initState() {
    super.initState();
    _initializeTrack();
  }

  Future<void> _initializeTrack() async {
    final tracks =
        Provider.of<AudioPLayerProvider>(context, listen: false).getTrackList;

    setState(() {
      list = List.from(tracks); // Ensure list is a new instance
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              '  A Ouvir ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '${list.length} temas',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final track = list[index];
            return TrackCard(
              image: track!.album!.images!.first!.url!,
              titulo: track.name!,
              artista: track.artists!.first.name!,
            );
          },
        ),
      ),
    );
  }
}

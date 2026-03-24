import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/audio_player_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/audio_player_state.dart';
import 'package:melody_player/features/home/presentation/widgets/trackCard.dart';
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
    final tracks = context.read<AudioPlayerCubit>().state.trackList;

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
        child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
          builder: (context, state) {
            final tracks = state.trackList;
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return TrackCard(
                  image: track.album!.images!.first!.url!,
                  titulo: track.name!,
                  artista: track.artists!.first.name!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

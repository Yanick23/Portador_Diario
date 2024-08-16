import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Certifique-se de importar a biblioteca necessária
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import para animação de carregamento
import 'package:provider/provider.dart'; // Import para gerenciamento de estado

class ControllersRow extends StatelessWidget {
  final AudioPlayer player;
  final bool isLoading;
  final bool randomList;
  final List<dynamic> musicasJaTocadas;
  final List<dynamic> a;
  final VoidCallback onPreviousTrack;
  final VoidCallback onNextTrack;
  final VoidCallback onShufflePressed;

  ControllersRow({
    required this.player,
    required this.isLoading,
    required this.randomList,
    required this.musicasJaTocadas,
    required this.a,
    required this.onPreviousTrack,
    required this.onNextTrack,
    required this.onShufflePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            color: randomList ? Colors.white : Colors.blue,
            onPressed: onShufflePressed,
            icon: const Icon(
              Icons.shuffle,
              shadows: [
                BoxShadow(
                    color: Colors.black, blurRadius: 10, offset: Offset(0, 3)),
                BoxShadow(
                    color: Colors.black, blurRadius: 20, offset: Offset(0, 3))
              ],
            )),
        IconButton(
          onPressed: onPreviousTrack,
          icon: const Icon(shadows: [
            BoxShadow(
                color: Colors.black, blurRadius: 10, offset: Offset(0, 3)),
            BoxShadow(color: Colors.black, blurRadius: 20, offset: Offset(0, 3))
          ], Icons.skip_previous, color: Colors.white, size: 50),
        ),
        StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (!(playing ?? false)) {
                return IconButton(
                  onPressed: () async {
                    await player.play();
                  },
                  icon: const Icon(
                    shadows: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0, 3)),
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 20,
                          offset: Offset(0, 3))
                    ],
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 70,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: () async {
                    await player.pause();
                  },
                  icon: const Icon(
                    shadows: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0, 3)),
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 20,
                          offset: Offset(0, 3))
                    ],
                    Icons.pause,
                    color: Colors.white,
                    size: 70,
                  ),
                );
              } else {
                return const Icon(
                  shadows: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 3)),
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                        offset: Offset(0, 3))
                  ],
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 70,
                );
              }
            }),
        IconButton(
          onPressed: onNextTrack,
          icon: const Icon(shadows: [
            BoxShadow(
                color: Colors.black, blurRadius: 10, offset: Offset(0, 3)),
            BoxShadow(color: Colors.black, blurRadius: 20, offset: Offset(0, 3))
          ], Icons.skip_next, color: Colors.white, size: 50),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.repeat,
              shadows: [
                BoxShadow(
                    color: Colors.black, blurRadius: 10, offset: Offset(0, 3)),
                BoxShadow(
                    color: Colors.black, blurRadius: 20, offset: Offset(0, 3))
              ],
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class CardArtistaFavorito extends StatelessWidget {
  const CardArtistaFavorito({
    super.key,
    required this.artista,
  });

  final Artist artista;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: NetworkImage(artista.images!.first.url!),
          fit: BoxFit.cover,
        ),
      ),
      width: 150,
      height: 300,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 28, 27, 27).withOpacity(0.8),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artista.name ?? '—',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

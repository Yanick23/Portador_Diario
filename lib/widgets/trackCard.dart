import 'package:flutter/material.dart';

class TrackCard extends StatelessWidget {
  final String image;
  final String artista;
  final String titulo;
  const TrackCard({
    super.key,
    required this.image,
    required this.artista,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
        child: ListTile(
          leading: Image.network(
            "${image}",
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
          title:
              Text(maxLines: 1, overflow: TextOverflow.ellipsis, "${titulo}"),
          subtitle: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            '${artista}',
            style: TextStyle(color: const Color.fromARGB(255, 188, 181, 181)),
          ),
          trailing: Container(
            width: 75,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_sharp),
                  onPressed: () {},
                ),
                Icon(Icons.more_vert_sharp)
              ],
            ),
          ),
        ));
  }
}

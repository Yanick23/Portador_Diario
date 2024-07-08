import 'package:flutter/material.dart';

class CardPlayList extends StatelessWidget {
  final String? titulo;
  final String? descricao;
  const CardPlayList({super.key, this.descricao, this.titulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 87, 87, 87),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Icon(
            Icons.queue_music_sharp,
            size: 40,
          ),
        ),
        titulo != null
            ? Text(
                titulo!,
                style: const TextStyle(fontSize: 16),
              )
            : const Text(
                "",
                style: TextStyle(fontSize: 10),
              ),
        descricao != null
            ? Text(descricao!,
                style: const TextStyle(fontSize: 14, color: Colors.grey))
            : const Text("")
      ],
    );
  }
}

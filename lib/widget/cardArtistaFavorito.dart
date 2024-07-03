import 'package:flutter/material.dart';

class CardArtistaFavorito extends StatelessWidget {
  const CardArtistaFavorito({
    super.key,
    required this.nome,
  });

  final String nome;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 100,
        child: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 87, 87, 87),
          child: Text(
            nome,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spoti_stream_music/widgets/CardPlayList.dart';
import 'package:spoti_stream_music/widgets/cardArtistaFavorito.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 37, 36, 36),
              padding: const EdgeInsets.all(8.0),
              height: 100,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Musica",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.notifications_none_sharp,
                        size: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8),
              child: const Text("Os seus artistas preferidos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Container(
                height: 140,
                padding: EdgeInsets.only(left: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CardArtistaFavorito(
                      nome: "Azagaia",
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    CardArtistaFavorito(
                      nome: "Hernani ",
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    CardArtistaFavorito(
                      nome: "J. Cole",
                    ),
                  ],
                )),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8),
              child: const Text("A pensar em si",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 8),
              height: 280,
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return const Row(
                    children: [
                      CardPlayList(
                        descricao: "50 temas",
                        titulo: "100% azagaia",
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/artistPage.dart';
import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/servicies/ArtistService.dart';
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
      backgroundColor: const Color.fromARGB(255, 24, 24, 23),
      body: SingleChildScrollView(
        child: Container(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: const Text("Os seus artistas favoritos",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Container(
                  height: 250,
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      var artists = ArtistService().mostPopularArtist()![index];
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<ArtistProvider>(context,
                                      listen: false)
                                  .setAtistt(artists);
                              Provider.of<PageState>(context, listen: false)
                                  .updateSelectedPage(7);
                            },
                            child: CardArtistaFavorito(artista: artists),
                          ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  )),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: const Text("A pensar em si",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 8),
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
      ),
    );
  }
}

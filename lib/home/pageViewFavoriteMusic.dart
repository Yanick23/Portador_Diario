import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/home/homeScreen.dart';
import 'package:spoti_stream_music/home/playLIstScreen.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/widget/optionFavoritePage.dart';

class PageViewFavoriteMusic extends StatefulWidget {
  final int? onNavigateToPlaylist;
  const PageViewFavoriteMusic({super.key, this.onNavigateToPlaylist});

  @override
  State<PageViewFavoriteMusic> createState() => _PageViewFavoriteMusicState();
}

class _PageViewFavoriteMusicState extends State<PageViewFavoriteMusic> {
  @override
  Widget build(BuildContext context) {
    int selectedPage = Provider.of<PageState>(context).selectedPage;

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          const OptionFavoritePage(
            text: "A minha musica aleatoria",
            iconsRow_1: Icon(
              Icons.bar_chart_sharp,
              size: 28,
              color: Color(0xFF00EEFF),
            ),
            iconOrText: Icon(
              Icons.play_arrow,
              size: 28,
              color: Color(0xFF00EEFF),
            ),
            colorText: Color(0xFF00EEFF),
          ),
          const SizedBox(
            height: 20,
          ),
          const OptionFavoritePage(
            text: "Musica transferida",
            iconsRow_1: Icon(
              Icons.done,
              size: 28,
              color: Color.fromARGB(255, 0, 255, 34),
            ),
            iconOrText: Icon(
              Icons.download_outlined,
              color: Color.fromARGB(255, 170, 187, 189),
              size: 28,
            ),
            colorText: Color.fromARGB(255, 255, 255, 255),
          ),
          SizedBox(
            height: 20,
          ),
          const OptionFavoritePage(
            text: "Temas favoritos",
            iconOrText: Text("300",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 170, 187, 189),
                )),
            colorText: Color.fromARGB(255, 255, 255, 255),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Provider.of<PageState>(context, listen: false)
                  .updateSelectedPage(2);
            },
            child: const OptionFavoritePage(
              text: "Playlists",
              iconOrText: Text("130",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 170, 187, 189),
                  )),
              colorText: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          const OptionFavoritePage(
            text: "Albuns",
            iconOrText: Text("128",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 170, 187, 189),
                )),
            colorText: Color.fromARGB(255, 255, 255, 255),
          ),
          SizedBox(
            height: 20,
          ),
          const OptionFavoritePage(
            text: "Artistas",
            iconOrText: Text("128",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 170, 187, 189),
                )),
            colorText: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
    );
  }
}

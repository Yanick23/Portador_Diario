import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/home/favoritoScreen.dart';
import 'package:spoti_stream_music/home/homeScreen.dart';
import 'package:spoti_stream_music/home/playLIstScreen.dart';

import 'package:spoti_stream_music/providers/pageState.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  final List<Widget> _widgets = [
    const HomeScreen(),
    const Favoritoscreen(),
    const Favoritoscreen(),
    const HomeScreen(),
    const Favoritoscreen(),
    const Playlistscreen()
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int selectedPage = Provider.of<PageState>(context).selectedPage;

    return Scaffold(
      body: Container(
        child: _widgets[selectedPage],
      ),
      bottomNavigationBar: Consumer<PageState>(
        builder: (context, pageState, child) {
          return NavigationBar(
            destinations: [
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: 60,
                    height: 40,
                    child: IconButton(
                      icon: Icon(Icons.music_note_outlined),
                      onPressed: () {
                        pageState.updateSelectedPage(0);
                      },
                    ),
                  ),
                  const Text("Musica",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  width: 60,
                  height: 40,
                  child: IconButton(
                      onPressed: () {
                        pageState.updateSelectedPage(1);
                      },
                      icon: const Icon(Icons.podcasts_rounded)),
                ),
                const Text("Podcast",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: 60,
                    height: 40,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        pageState.updateSelectedPage(2);
                      },
                    ),
                  ),
                  const Text("Favoritos",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: 60,
                    height: 40,
                    child: IconButton(
                        onPressed: () {
                          pageState.updateSelectedPage(3);
                        },
                        icon: const Icon(Icons.search_sharp)),
                  ),
                  const Text("Pesquisa",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

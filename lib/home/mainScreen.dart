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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int value) {
          Provider.of<PageState>(context, listen: false)
              .updateSelectedPage(value);
        },
        children: [
          HomeScreen(),
          Favoritoscreen(),
          HomeScreen(),
          HomeScreen(),
          Favoritoscreen(),
          Playlistscreen()
        ],
      ),
      bottomNavigationBar: Consumer<PageState>(
        builder: (context, pageState, child) {
          return NavigationBar(
            selectedIndex: pageState.selectedPage,
            onDestinationSelected: (int index) {
              pageState.updateSelectedPage(index);
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                  icon: Icon(Icons.music_note_outlined), label: "Musica"),
              NavigationDestination(
                  icon: Icon(Icons.podcasts_rounded), label: "Podcasts"),
              NavigationDestination(
                  icon: Icon(Icons.favorite_border), label: "Favoritos"),
              NavigationDestination(
                  icon: Icon(Icons.search_sharp), label: "Pesquisa")
            ],
          );
        },
      ),
    );
  }
}

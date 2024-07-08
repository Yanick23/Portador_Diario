import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/favoritoScreen.dart';
import 'package:spoti_stream_music/pages/homeScreen.dart';
import 'package:spoti_stream_music/pages/playLIstScreen.dart';
import 'package:spoti_stream_music/pages/playListMusic.dart';

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
    const Playlistscreen(),
    const PlayListMusic(),
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
            height: 65,
            destinations: [
              _buildNavItem(
                icon: Icons.music_note_outlined,
                label: 'Musica',
                selectedPage: selectedPage,
                targetPage: 0,
                color: selectedPage == 0 ? Colors.blue : null,
              ),
              _buildNavItem(
                icon: Icons.podcasts_rounded,
                label: 'Podcast',
                selectedPage: selectedPage,
                targetPage: 1,
              ),
              _buildNavItem(
                icon: Icons.favorite_border,
                label: 'Favoritos',
                selectedPage: selectedPage,
                targetPage: 2,
                color: selectedPage == 2 ||
                        selectedPage == 4 ||
                        selectedPage == 5 ||
                        selectedPage == 6
                    ? Colors.blue
                    : null,
              ),
              _buildNavItem(
                icon: Icons.search_sharp,
                label: 'Pesquisa',
                selectedPage: selectedPage,
                targetPage: 3,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int selectedPage,
    required int targetPage,
    Color? color,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            width: 50,
            height: 40,
            child: IconButton(
              icon: Icon(
                size: 25,
                icon,
              ),
              onPressed: () => Provider.of<PageState>(context, listen: false)
                  .updateSelectedPage(targetPage),
            ),
          ),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

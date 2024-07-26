import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/SearchScreen.dart';
import 'package:spoti_stream_music/pages/artistPage.dart';
import 'package:spoti_stream_music/pages/favoritoScreen.dart';
import 'package:spoti_stream_music/pages/homeScreen.dart';
import 'package:spoti_stream_music/pages/musicPlayer.dart';
import 'package:spoti_stream_music/pages/playLIstScreen.dart';
import 'package:spoti_stream_music/pages/playListMusic.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DraggableScrollableController _controller;
  bool showBarPlay = true;
  double _navBarOpacity = 1.0;

  final List<Widget> _widgets = [
    const HomeScreen(),
    const Favoritoscreen(),
    const Favoritoscreen(),
    const SearchScreen(),
    const Favoritoscreen(),
    const Playlistscreen(),
    const PlayListMusic(),
    const ArtistPage()
  ];

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController()
      ..addListener(() {
        setState(() {
          if (_controller.size >= 0.2) {
            showBarPlay = false;
            _navBarOpacity = 0.0;
          } else {
            showBarPlay = true;
            _navBarOpacity = 1.0;
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    int selectedPage = Provider.of<PageState>(context).selectedPage;
    bool playBarState =
        Provider.of<PlayMusicBarState>(context).playMusicBarState;

    return Scaffold(
      body: Stack(
        children: [
          _widgets[selectedPage],
          if (playBarState)
            DraggableScrollableSheet(
              controller: _controller,
              initialChildSize: 0.12,
              minChildSize: 0.12,
              maxChildSize: 1,
              builder: (context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              alignment: Alignment.center,
                              child: MusicPlayer(
                                showBarPlay: showBarPlay,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: showBarPlay == true
          ? AnimatedOpacity(
              opacity: _navBarOpacity,
              duration: const Duration(milliseconds: 300),
              child: Consumer<PageState>(
                builder: (context, pageState, child) {
                  return NavigationBar(
                    height: 55,
                    destinations: [
                      _buildNavItem(
                        icon: Icons.music_note_outlined,
                        label: 'Música',
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
                        color: selectedPage == 3 ? Colors.blue : null,
                      ),
                    ],
                  );
                },
              ),
            )
          : null,
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
            ),
            width: 50,
            height: 30,
            child: IconButton(
              highlightColor: Colors.transparent,
              icon: Icon(
                icon,
                size: 25,
                color: color,
              ),
              onPressed: () => {
                Provider.of<PageState>(context, listen: false)
                    .updateSelectedPage(targetPage),
              },
            ),
          ),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

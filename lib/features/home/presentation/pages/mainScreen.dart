import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:melody_player/features/home/presentation/pages/homeScreen.dart';
import 'package:melody_player/features/audio_player/presentation/pages/musicPlayer.dart';

import 'package:melody_player/features/home/presentation/bloc/page_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/play_music_bar_cubit.dart';
import 'package:melody_player/features/search/presentation/pages/SearchScreen.dart';
import 'package:melody_player/features/search/presentation/pages/artistPage.dart';
import 'package:melody_player/features/search/presentation/pages/favoritoScreen.dart';
import 'package:melody_player/features/search/presentation/pages/playLIstScreen.dart';
import 'package:melody_player/features/search/presentation/pages/playListMusic.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DraggableScrollableController _controller;
  bool showBarPlay = true;
  double _navBarOpacity = 1.0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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
    int selectedPage = context.watch<PageCubit>().state;
    bool playBarState = context.watch<PlayMusicBarCubit>().state;

    return Scaffold(
      body: Stack(
        children: [
          Navigator(
            key: _navigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              Widget page;
              switch (settings.name) {
                case '/artistPage':
                  page = const ArtistPage();
                  break;
                case '/playlistMusic':
                  page = const PlayListMusic();
                  break;
                case '/playlist':
                  page = const Playlistscreen();
                  break;
                case '/search':
                  page = const SearchScreen();
                  break;
                case '/favorites':
                  page = const Favoritoscreen();
                  break;
                default:
                  page = _widgets[selectedPage];
                  break;
              }
              return MaterialPageRoute(builder: (_) => page);
            },
          ),
          if (playBarState)
            DraggableScrollableSheet(
              controller: _controller,
              initialChildSize: 0.12,
              minChildSize: 0.12,
              maxChildSize: 1,
              snapSizes: const [1],
              shouldCloseOnMinExtent: true,
              expand: true,
              snap: true,
              snapAnimationDuration: Duration(milliseconds: 300),
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
              child: BlocBuilder<PageCubit, int>(
                builder: (context, pageState) {
                  return NavigationBar(
                    height: 55,
                    destinations: [
                      _buildNavItem(
                        icon: Icons.music_note_outlined,
                        label: 'Música',
                        selectedPage: pageState,
                        targetPage: 0,
                        route: '/',
                        color: pageState == 0 ? Colors.blue : null,
                      ),
                      _buildNavItem(
                        icon: Icons.favorite_border,
                        label: 'Favoritos',
                        selectedPage: pageState,
                        targetPage: 2,
                        route: '/favorites',
                        color: pageState == 2 ||
                                pageState == 4 ||
                                pageState == 5 ||
                                pageState == 6
                            ? Colors.blue
                            : null,
                      ),
                      _buildNavItem(
                        icon: Icons.search_sharp,
                        label: 'Pesquisa',
                        selectedPage: pageState,
                        targetPage: 3,
                        route: '/search',
                        color: pageState == 3 ? Colors.blue : null,
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
    required String route,
    Color? color,
  }) {
    return Column(
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
            onPressed: () {
              context.read<PageCubit>().updateSelectedPage(targetPage);
              _navigatorKey.currentState?.pushNamed(route);
            },
          ),
        ),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w300, color: color),
        ),
      ],
    );
  }
}

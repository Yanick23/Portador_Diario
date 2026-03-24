import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody_player/core/presentation/responsive/responsive_layout.dart';
import 'package:melody_player/features/home/presentation/bloc/page_cubit.dart';
import 'package:melody_player/features/home/presentation/widgets/sidebar.dart';
import 'package:melody_player/features/audio_player/presentation/widgets/player_bar.dart';
import 'package:melody_player/features/audio_player/presentation/widgets/mini_player.dart';
import 'package:melody_player/features/home/presentation/pages/homeScreen.dart';
import 'package:melody_player/features/search/presentation/pages/SearchScreen.dart';
import 'package:melody_player/features/search/presentation/pages/favoritoScreen.dart';
import 'package:melody_player/features/search/presentation/pages/playLIstScreen.dart';
import 'package:melody_player/features/audio_player/presentation/pages/now_playing_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const Favoritoscreen(),
    const Playlistscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, int>(
      builder: (context, selectedIndex) {
        // Ensure index is within bounds for our new _pages list
        // Note: Existing app has more pages, I might need to map them.
        int safeIndex = selectedIndex < _pages.length ? selectedIndex : 0;

        return ResponsiveLayout(
          mobile: _MobileLayout(
            selectedIndex: safeIndex,
            body: _pages[safeIndex],
            onIndexChanged: (i) => context.read<PageCubit>().updateSelectedPage(i),
          ),
          tablet: _TabletLayout(
            selectedIndex: safeIndex,
            body: _pages[safeIndex],
            onIndexChanged: (i) => context.read<PageCubit>().updateSelectedPage(i),
          ),
          desktop: _DesktopLayout(
            selectedIndex: safeIndex,
            body: _pages[safeIndex],
            onIndexChanged: (i) => context.read<PageCubit>().updateSelectedPage(i),
          ),
        );
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget body;
  final Function(int) onIndexChanged;

  const _MobileLayout({
    required this.selectedIndex,
    required this.body,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Melody'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => onIndexChanged(1)),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          body,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NowPlayingPage()),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onIndexChanged,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_play), label: 'Playlists'),
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget body;
  final Function(int) onIndexChanged;

  const _TabletLayout({
    required this.selectedIndex,
    required this.body,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            isCollapsed: true,
            selectedIndex: selectedIndex,
            onIndexChanged: onIndexChanged,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: body),
                const PlayerBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget body;
  final Function(int) onIndexChanged;

  const _DesktopLayout({
    required this.selectedIndex,
    required this.body,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Sidebar(
                  selectedIndex: selectedIndex,
                  onIndexChanged: onIndexChanged,
                ),
                Expanded(
                  flex: 5,
                  child: body,
                ),
                // Third column for queue/player info
                Container(
                  width: 300,
                  color: const Color.fromARGB(255, 12, 12, 12),
                  child: const Center(child: Text('Now Playing / Queue')),
                ),
              ],
            ),
          ),
          const PlayerBar(),
        ],
      ),
    );
  }
}

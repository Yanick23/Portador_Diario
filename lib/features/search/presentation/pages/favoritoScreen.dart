import 'package:flutter/material.dart';
import 'package:melody_player/core/presentation/responsive/responsive_layout.dart';
import 'package:melody_player/features/home/presentation/widgets/music_card.dart';

class Favoritoscreen extends StatefulWidget {
  const Favoritoscreen({super.key});

  @override
  State<Favoritoscreen> createState() => _FavoritoscreenState();
}

class _FavoritoscreenState extends State<Favoritoscreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isDesktop ? 200.0 : 150.0,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Favoritos',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blueGrey, Colors.black],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildTabButton("Músicas", 0),
                  const SizedBox(width: 16),
                  _buildTabButton("Podcasts", 1),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24.0 : 16.0),
            sliver: _selectedIndex == 0
                ? _buildFavoriteMusics(context)
                : _buildPodcasts(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }

  Widget _buildFavoriteMusics(BuildContext context) {
    // For now, we reuse PageViewFavoriteMusic or implement a responsive grid
    bool isDesktop = ResponsiveLayout.isDesktop(context);
    bool isTablet = ResponsiveLayout.isTablet(context);

    if (isDesktop || isTablet) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => MusicCard(
            onTap: () {},
            title: 'Liked Song',
            artist: 'Various Artists',
            imageUrl: '',
          ),
          childCount: 8,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          leading: const Icon(Icons.music_note, color: Colors.white),
          title:
              const Text('Liked Song', style: TextStyle(color: Colors.white)),
          subtitle: const Text('Various Artists',
              style: TextStyle(color: Colors.white54)),
          onTap: () {},
        ),
        childCount: 20,
      ),
    );
  }

  Widget _buildPodcasts() {
    return const SliverFillRemaining(
      child: Center(
        child:
            Text("Podcasts em breve", style: TextStyle(color: Colors.white54)),
      ),
    );
  }
}

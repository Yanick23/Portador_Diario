import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/artist_cubit.dart';
import 'package:melody_player/features/home/data/data_sources/ArtistService.dart';
import 'package:melody_player/core/services/service_locator.dart';
import 'package:melody_player/core/presentation/responsive/responsive_layout.dart';
import 'package:melody_player/features/home/presentation/widgets/music_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final artists = sl<ArtistService>().mostPopularArtist() ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Os seus artistas favoritos",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: ResponsiveLayout.isMobile(context)
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildMobileListItem(artists[index]),
                      childCount: artists.length > 10 ? 10 : artists.length,
                    ),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveLayout.isDesktop(context) ? 4 : 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => MusicCard(
                        title: artists[index].name ?? 'Unknown',
                        artist: 'Artist',
                        imageUrl: artists[index].images?.first.url ?? '',
                        isLarge: ResponsiveLayout.isDesktop(context),
                        onTap: () {
                          context.read<ArtistCubit>().setArtist(artists[index]);
                          Navigator.of(context).pushNamed('/artistPage');
                        },
                      ),
                      childCount: artists.length > 12 ? 12 : artists.length,
                    ),
                  ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Text(
                "A pensar em si",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveLayout.isMobile(context) ? 2 : (ResponsiveLayout.isTablet(context) ? 3 : 5),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => MusicCard(
                  title: 'Playlist Topic',
                  artist: 'Recommended',
                  imageUrl: 'https://via.placeholder.com/150', 
                  onTap: () {},
                ),
                childCount: 6,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (ResponsiveLayout.isMobile(context)) return const SizedBox(height: 10);
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bem-vindo",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileListItem(dynamic artist) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(artist.images?.first.url ?? ''),
      ),
      title: Text(artist.name ?? 'Unknown', style: const TextStyle(color: Colors.white)),
      subtitle: const Text('Artist', style: TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.more_vert, color: Colors.white70),
      onTap: () {
        context.read<ArtistCubit>().setArtist(artist);
        Navigator.of(context).pushNamed('/artistPage');
      },
    );
  }
}

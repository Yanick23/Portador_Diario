import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const Sidebar({
    super.key,
    this.isCollapsed = false,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 80 : 240,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.white10, width: 0.5)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: isCollapsed
                ? const Icon(Icons.music_note, color: Colors.blue, size: 32)
                : Row(
                    children: [
                      const Icon(Icons.music_note, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Melody',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(context, Icons.home_filled, 'Home', 0),
          _buildMenuItem(context, Icons.search, 'Search', 1),
          _buildMenuItem(context, Icons.library_music, 'Library', 2),
          _buildMenuItem(context, Icons.playlist_play, 'Playlists', 3),
          const Spacer(),
          if (!isCollapsed) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'YOUR PLAYLISTS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildPlaylistItem('Top 50 - Global'),
                  _buildPlaylistItem('Focus Mix'),
                  _buildPlaylistItem('Discover Weekly'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;
    if (isCollapsed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: IconButton(
            icon: Icon(icon, color: isSelected ? Colors.blue : Colors.white70),
            onPressed: () => onIndexChanged(index),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: isSelected ? Colors.white12 : Colors.transparent,
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.white70),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () => onIndexChanged(index),
      ),
    );
  }

  Widget _buildPlaylistItem(String name) {
    return ListTile(
      dense: true,
      title: Text(
        name,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {},
    );
  }
}

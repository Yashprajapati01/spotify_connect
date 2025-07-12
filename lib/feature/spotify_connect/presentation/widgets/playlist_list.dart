import 'package:connectspotify/feature/spotify_connect/presentation/widgets/playlist_card.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/playlist_entity.dart';

class PlaylistsList extends StatelessWidget {
  final List<Playlist> playlists;

  const PlaylistsList({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No playlists found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return PlaylistCard(playlist: playlist);
      },
    );
  }
}
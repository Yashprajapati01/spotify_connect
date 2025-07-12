import 'package:injectable/injectable.dart';
import '../entities/generated_playlist.dart';
import '../repositories/spotify.dart';

@injectable
class CreateSpotifyPlaylist {
  final SpotifyRepository spotifyRepository;

  CreateSpotifyPlaylist(this.spotifyRepository);

  Future<GeneratedPlaylist> call(GeneratedPlaylist generatedPlaylist) async {
    try {
      // 1. Create playlist on Spotify
      final spotifyPlaylistId = await spotifyRepository.createPlaylist(
        generatedPlaylist.name,
        generatedPlaylist.description,
        true, // public
      );

      // 2. Add tracks to the playlist
      final trackUris = generatedPlaylist.tracks.map((track) => track.uri).toList();
      await spotifyRepository.addTracksToPlaylist(spotifyPlaylistId, trackUris);

      // 3. Return updated playlist
      return GeneratedPlaylist(
        id: generatedPlaylist.id,
        name: generatedPlaylist.name,
        description: generatedPlaylist.description,
        mood: generatedPlaylist.mood,
        tracks: generatedPlaylist.tracks,
        sourcePlaylistIds: generatedPlaylist.sourcePlaylistIds,
        createdAt: generatedPlaylist.createdAt,
        isAddedToSpotify: true,
      );
    } catch (e) {
      print('❌ Error creating Spotify playlist: $e');
      rethrow;
    }
  }
}
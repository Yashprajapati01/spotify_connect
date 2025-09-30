import 'package:injectable/injectable.dart';
import '../entities/user_taste_profile.dart';
import '../entities/playlist_entity.dart';
import '../repositories/spotify.dart';

@injectable
class AnalyzeUserTaste {
  final SpotifyRepository _repository;

  AnalyzeUserTaste(this._repository);

  Future<UserTasteProfile> call(List<Playlist> userPlaylists) async {
    try {
      // Analyze user's playlists to build taste profile
      final Map<String, double> genrePreferences = {};
      final List<String> topArtists = [];

      // Track counts for proper averaging
      double totalEnergy = 0.0;
      double totalDanceability = 0.0;
      double totalValence = 0.0;
      int trackCount = 0;

      // Process each playlist to extract patterns
      for (final playlist in userPlaylists) {
        // Get detailed track information for analysis
        final tracks = await _repository.getPlaylistTracks(playlist.id);

        // Analyze genres, artists, and audio features
        for (final track in tracks) {
          // Extract artist information
          if (track.artists.isNotEmpty &&
              !topArtists.contains(track.artists.first)) {
            topArtists.add(track.artists.first);
          }

          // Simulate audio feature analysis with realistic values
          final features = _generateRealisticAudioFeatures(track);
          totalEnergy += features['energy']!;
          totalDanceability += features['danceability']!;
          totalValence += features['valence']!;
          trackCount++;
        }
      }

      // Calculate proper averages (ensure values are between 0.0 and 1.0)
      final averageEnergy = trackCount > 0
          ? (totalEnergy / trackCount).clamp(0.0, 1.0)
          : 0.5;
      final averageDanceability = trackCount > 0
          ? (totalDanceability / trackCount).clamp(0.0, 1.0)
          : 0.5;
      final averageValence = trackCount > 0
          ? (totalValence / trackCount).clamp(0.0, 1.0)
          : 0.5;

      return UserTasteProfile(
        genrePreferences: genrePreferences,
        audioFeatures: {
          'energy': averageEnergy,
          'danceability': averageDanceability,
          'valence': averageValence,
        },
        topArtists: topArtists.take(20).toList(),
        averageEnergy: averageEnergy,
        averageDanceability: averageDanceability,
        averageValence: averageValence,
        discoveredGenres: _extractGenres(userPlaylists),
      );
    } catch (e) {
      throw Exception('Failed to analyze user taste: $e');
    }
  }

  Map<String, double> _generateRealisticAudioFeatures(dynamic track) {
    // Generate realistic audio features based on track characteristics
    // In real implementation, call Spotify Audio Features API

    // Use track name and artist to generate somewhat consistent values
    final trackHash = (track.name + track.artistName).hashCode.abs();
    final random = trackHash / 2147483647; // Normalize to 0-1

    // Generate realistic values with some variation
    return {
      'energy': (0.3 + (random * 0.7)).clamp(0.0, 1.0), // 0.3 to 1.0
      'danceability': (0.2 + (random * 0.8)).clamp(0.0, 1.0), // 0.2 to 1.0
      'valence': (0.1 + (random * 0.9)).clamp(0.0, 1.0), // 0.1 to 1.0
    };
  }

  List<String> _extractGenres(List<Playlist> playlists) {
    // Extract genres from playlist names and descriptions
    final genres = <String>[];
    final commonGenres = [
      'pop',
      'rock',
      'hip-hop',
      'electronic',
      'indie',
      'jazz',
      'classical',
      'country',
      'r&b',
      'reggae',
      'folk',
      'blues',
      'metal',
      'punk',
      'funk',
    ];

    for (final playlist in playlists) {
      final name = playlist.name.toLowerCase();
      for (final genre in commonGenres) {
        if (name.contains(genre) && !genres.contains(genre)) {
          genres.add(genre);
        }
      }
    }

    return genres;
  }
}

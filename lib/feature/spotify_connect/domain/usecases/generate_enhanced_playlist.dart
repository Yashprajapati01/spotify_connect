import 'package:injectable/injectable.dart';
import '../entities/enhanced_playlist.dart';
import '../entities/explore_mode_request.dart';
import '../entities/user_taste_profile.dart';
import '../entities/track.dart';
import '../repositories/spotify.dart';

@injectable
class GenerateEnhancedPlaylist {
  final SpotifyRepository _repository;

  GenerateEnhancedPlaylist(this._repository);

  Future<EnhancedPlaylist> call(
    ExploreModeRequest request,
    UserTasteProfile tasteProfile,
  ) async {
    try {
      // Get tracks from selected playlists
      final List<Track> originalTracks = [];
      for (final playlistId in request.selectedPlaylistIds) {
        final tracks = await _repository.getPlaylistTracks(playlistId);
        originalTracks.addAll(tracks);
      }

      // Generate enhanced playlist description based on mood and analysis
      final playlistName = _generatePlaylistName(
        request.mood,
        request.currentActivity,
      );
      final description = _generateDescription(request, tasteProfile);

      // Discover new tracks based on taste profile and mood
      final discoveredTracks = await _discoverNewTracks(
        request,
        tasteProfile,
        originalTracks,
      );

      // Combine and shuffle tracks intelligently
      final allTracks = _combineAndArrangeTracks(
        originalTracks,
        discoveredTracks,
        request,
      );

      // Calculate mood match score
      final moodMatch = _calculateMoodMatch(allTracks, request);

      // Extract dominant genres
      final dominantGenres = _extractDominantGenres(allTracks, tasteProfile);

      return EnhancedPlaylist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: playlistName,
        description: description,
        originalTracks: originalTracks,
        discoveredTracks: discoveredTracks,
        allTracks: allTracks,
        moodMatch: moodMatch,
        dominantGenres: dominantGenres,
        createdAt: DateTime.now().toIso8601String(),
        analysisData: {
          'mood': request.mood,
          'activity': request.currentActivity,
          'energy_level': request.energyLevel,
          'danceability': request.danceability,
          'original_tracks_count': originalTracks.length,
          'discovered_tracks_count': discoveredTracks.length,
        },
      );
    } catch (e) {
      throw Exception('Failed to generate enhanced playlist: $e');
    }
  }

  String _generatePlaylistName(String mood, String activity) {
    final moodAdjectives = {
      'happy': ['Upbeat', 'Joyful', 'Bright', 'Cheerful'],
      'sad': ['Melancholy', 'Reflective', 'Moody', 'Contemplative'],
      'energetic': ['High Energy', 'Pumped Up', 'Dynamic', 'Intense'],
      'chill': ['Chill', 'Relaxed', 'Mellow', 'Laid-back'],
      'romantic': ['Romantic', 'Intimate', 'Dreamy', 'Passionate'],
      'focused': ['Focus', 'Concentrated', 'Deep Work', 'Productive'],
    };

    final adjective = moodAdjectives[mood.toLowerCase()]?.first ?? 'Curated';
    final activitySuffix = activity.isNotEmpty ? ' for ${activity}' : ' Vibes';

    return '$adjective$activitySuffix';
  }

  String _generateDescription(
    ExploreModeRequest request,
    UserTasteProfile tasteProfile,
  ) {
    final moodDescription = 'Perfect for when you\'re feeling ${request.mood}';
    final activityDescription = request.currentActivity.isNotEmpty
        ? ' while ${request.currentActivity}'
        : '';
    final discoveryNote = request.includeNewDiscoveries
        ? '. Includes new discoveries based on your taste!'
        : '.';

    return '$moodDescription$activityDescription$discoveryNote';
  }

  Future<List<Track>> _discoverNewTracks(
    ExploreModeRequest request,
    UserTasteProfile tasteProfile,
    List<Track> originalTracks,
  ) async {
    if (!request.includeNewDiscoveries) return [];

    try {
      // Use Spotify recommendations API based on seed tracks and audio features
      final seedTracks = originalTracks.take(5).map((t) => t.id).toList();

      // Get recommendations from Spotify
      final recommendations = await _repository.getRecommendations(
        seedTracks: seedTracks,
        targetEnergy: request.energyLevel,
        targetDanceability: request.danceability,
        targetValence: _moodToValence(request.mood),
        limit: (request.maxTracks * 0.4).round(), // 40% new discoveries
      );

      return recommendations;
    } catch (e) {
      print('Failed to get recommendations: $e');
      return [];
    }
  }

  double _moodToValence(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'energetic':
      case 'excited':
        return 0.8;
      case 'sad':
      case 'melancholy':
        return 0.2;
      case 'chill':
      case 'relaxed':
        return 0.5;
      case 'romantic':
        return 0.6;
      case 'focused':
        return 0.4;
      default:
        return 0.5;
    }
  }

  List<Track> _combineAndArrangeTracks(
    List<Track> originalTracks,
    List<Track> discoveredTracks,
    ExploreModeRequest request,
  ) {
    final combined = <Track>[];

    // Shuffle original tracks
    final shuffledOriginal = List<Track>.from(originalTracks)..shuffle();
    final shuffledDiscovered = List<Track>.from(discoveredTracks)..shuffle();

    // Interleave tracks intelligently
    int originalIndex = 0;
    int discoveredIndex = 0;

    for (
      int i = 0;
      i < request.maxTracks &&
          (originalIndex < shuffledOriginal.length ||
              discoveredIndex < shuffledDiscovered.length);
      i++
    ) {
      if (i % 3 == 0 && discoveredIndex < shuffledDiscovered.length) {
        // Add discovered track every 3rd position
        combined.add(shuffledDiscovered[discoveredIndex++]);
      } else if (originalIndex < shuffledOriginal.length) {
        combined.add(shuffledOriginal[originalIndex++]);
      } else if (discoveredIndex < shuffledDiscovered.length) {
        combined.add(shuffledDiscovered[discoveredIndex++]);
      }
    }

    return combined;
  }

  double _calculateMoodMatch(List<Track> tracks, ExploreModeRequest request) {
    // Simulate mood matching calculation
    // In real implementation, analyze audio features of tracks
    return 0.85; // Mock high match score
  }

  List<String> _extractDominantGenres(
    List<Track> tracks,
    UserTasteProfile tasteProfile,
  ) {
    // Extract genres from taste profile and track analysis
    return tasteProfile.discoveredGenres.take(3).toList();
  }
}

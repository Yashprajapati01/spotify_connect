import 'package:injectable/injectable.dart';
import '../entities/generated_playlist.dart';
import '../entities/track.dart';
import '../../data/services/gemini_service.dart';
import '../repositories/spotify.dart';

@injectable
class GenerateMoodPlaylist {
  final SpotifyRepository spotifyRepository;
  final GeminiService geminiService;

  GenerateMoodPlaylist(this.spotifyRepository, this.geminiService);

  Future<GeneratedPlaylist> call(List<String> playlistIds, String mood) async {
    try {
      // 1. Fetch tracks from selected playlists
      final allTracks = <Track>[];
      for (final playlistId in playlistIds) {
        final tracks = await spotifyRepository.getPlaylistTracks(playlistId);
        allTracks.addAll(tracks);
      }

      // 2. Remove duplicates
      final uniqueTracks = _removeDuplicates(allTracks);
      print(
        '✅ Collected ${uniqueTracks.length} unique tracks from ${playlistIds.length} playlists',
      );

      // 3. Generate playlist using Gemini AI
      final selectedTracks = await geminiService.generatePlaylistFromTracks(
        uniqueTracks,
        mood,
        50, // max tracks
      );

      if (selectedTracks.isEmpty) {
        throw Exception('No tracks selected for the mood "$mood"');
      }

      // 4. Create generated playlist entity
      final generatedPlaylist = GeneratedPlaylist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _generatePlaylistName(mood),
        description: _generatePlaylistDescription(mood, selectedTracks.length),
        mood: mood,
        tracks: selectedTracks,
        sourcePlaylistIds: playlistIds,
        createdAt: DateTime.now(),
        isAddedToSpotify: false,
      );

      return generatedPlaylist;
    } catch (e) {
      print('❌ Error generating mood playlist: $e');
      rethrow;
    }
  }

  List<Track> _removeDuplicates(List<Track> tracks) {
    final seenIds = <String>{};
    return tracks.where((track) => seenIds.add(track.id)).toList();
  }

  String _generatePlaylistName(String mood) {
    final moodCapitalized = mood.isNotEmpty
        ? mood[0].toUpperCase() + mood.substring(1).toLowerCase()
        : 'My';
    return '$moodCapitalized Vibes';
  }

  String _generatePlaylistDescription(String mood, int trackCount) {
    return 'AI-generated playlist for $mood mood • $trackCount tracks • Created by Spotify Connect';
  }
}

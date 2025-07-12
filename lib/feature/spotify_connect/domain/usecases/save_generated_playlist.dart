// domain/usecases/save_generated_playlist.dart
import 'package:injectable/injectable.dart';
import '../entities/generated_playlist.dart';

@injectable
class SaveGeneratedPlaylist {
  SaveGeneratedPlaylist();

  Future<GeneratedPlaylist> call(String generatedPlaylistId) async {
    try {
      // Since we're handling this through the CreateSpotifyPlaylist use case
      // in the UI layer, we'll just return a success state
      // In a real app, you'd save to local storage/database here
      throw UnimplementedError('This is handled by CreateSpotifyPlaylist use case');
    } catch (e) {
      print('❌ Error saving generated playlist: $e');
      rethrow;
    }
  }
}
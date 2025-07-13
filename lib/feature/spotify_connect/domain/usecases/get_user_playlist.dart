import 'package:injectable/injectable.dart';

import '../entities/playlist_entity.dart';
import '../repositories/spotify.dart';
import '../repositories/spotify_playlist_repo.dart';

// @injectable
// class GetUserPlaylists {
//   final SpotifyPlaylistRepository _repo;
//   GetUserPlaylists(this._repo);
//
//   Future<List<Playlist>> call() => _repo.getUserPlaylists();
// }
import 'package:injectable/injectable.dart';

@injectable
class GetUserPlaylists {
  final SpotifyRepository repository;

  GetUserPlaylists(this.repository);

  Future<List<Playlist>> call() async {
    return await repository.getUserPlaylists();
  }
}

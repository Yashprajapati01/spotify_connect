import 'package:equatable/equatable.dart';

class PlaylistGenerationRequest extends Equatable {
  final List<String> playlistIds;
  final String mood;
  final int maxTracks;

  const PlaylistGenerationRequest({
    required this.playlistIds,
    required this.mood,
    this.maxTracks = 30,
  });

  @override
  List<Object?> get props => [playlistIds, mood, maxTracks];
}

// domain/entities/generated_playlist.dart
import 'package:equatable/equatable.dart';
import 'track.dart';

class GeneratedPlaylist extends Equatable {
  final String id;
  final String name;
  final String description;
  final String mood;
  final List<Track> tracks;
  final List<String> sourcePlaylistIds;
  final DateTime createdAt;
  final bool isAddedToSpotify;

  const GeneratedPlaylist({
    required this.id,
    required this.name,
    required this.description,
    required this.mood,
    required this.tracks,
    required this.sourcePlaylistIds,
    required this.createdAt,
    required this.isAddedToSpotify,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    mood,
    tracks,
    sourcePlaylistIds,
    createdAt,
    isAddedToSpotify,
  ];
}
import 'package:equatable/equatable.dart';
import 'track.dart';

class EnhancedPlaylist extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<Track> originalTracks; // From selected playlists
  final List<Track> discoveredTracks; // New recommendations
  final List<Track> allTracks; // Combined tracks
  final Map<String, dynamic> analysisData;
  final double moodMatch; // How well it matches requested mood (0.0-1.0)
  final List<String> dominantGenres;
  final String createdAt;

  const EnhancedPlaylist({
    required this.id,
    required this.name,
    required this.description,
    required this.originalTracks,
    required this.discoveredTracks,
    required this.allTracks,
    this.analysisData = const {},
    this.moodMatch = 0.0,
    this.dominantGenres = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    originalTracks,
    discoveredTracks,
    allTracks,
    analysisData,
    moodMatch,
    dominantGenres,
    createdAt,
  ];

  int get totalTracks => allTracks.length;
  int get originalTracksCount => originalTracks.length;
  int get discoveredTracksCount => discoveredTracks.length;

  EnhancedPlaylist copyWith({
    String? id,
    String? name,
    String? description,
    List<Track>? originalTracks,
    List<Track>? discoveredTracks,
    List<Track>? allTracks,
    Map<String, dynamic>? analysisData,
    double? moodMatch,
    List<String>? dominantGenres,
    String? createdAt,
  }) {
    return EnhancedPlaylist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      originalTracks: originalTracks ?? this.originalTracks,
      discoveredTracks: discoveredTracks ?? this.discoveredTracks,
      allTracks: allTracks ?? this.allTracks,
      analysisData: analysisData ?? this.analysisData,
      moodMatch: moodMatch ?? this.moodMatch,
      dominantGenres: dominantGenres ?? this.dominantGenres,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

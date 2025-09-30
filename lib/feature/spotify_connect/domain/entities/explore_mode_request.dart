import 'package:equatable/equatable.dart';

class ExploreModeRequest extends Equatable {
  final List<String> selectedPlaylistIds;
  final String mood;
  final String currentActivity;
  final List<String> preferredGenres;
  final double energyLevel; // 0.0 to 1.0
  final double danceability; // 0.0 to 1.0
  final bool includeNewDiscoveries;
  final int maxTracks;

  const ExploreModeRequest({
    required this.selectedPlaylistIds,
    required this.mood,
    this.currentActivity = '',
    this.preferredGenres = const [],
    this.energyLevel = 0.5,
    this.danceability = 0.5,
    this.includeNewDiscoveries = true,
    this.maxTracks = 50,
  });

  @override
  List<Object?> get props => [
    selectedPlaylistIds,
    mood,
    currentActivity,
    preferredGenres,
    energyLevel,
    danceability,
    includeNewDiscoveries,
    maxTracks,
  ];

  ExploreModeRequest copyWith({
    List<String>? selectedPlaylistIds,
    String? mood,
    String? currentActivity,
    List<String>? preferredGenres,
    double? energyLevel,
    double? danceability,
    bool? includeNewDiscoveries,
    int? maxTracks,
  }) {
    return ExploreModeRequest(
      selectedPlaylistIds: selectedPlaylistIds ?? this.selectedPlaylistIds,
      mood: mood ?? this.mood,
      currentActivity: currentActivity ?? this.currentActivity,
      preferredGenres: preferredGenres ?? this.preferredGenres,
      energyLevel: energyLevel ?? this.energyLevel,
      danceability: danceability ?? this.danceability,
      includeNewDiscoveries:
          includeNewDiscoveries ?? this.includeNewDiscoveries,
      maxTracks: maxTracks ?? this.maxTracks,
    );
  }
}

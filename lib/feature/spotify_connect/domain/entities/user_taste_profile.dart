import 'package:equatable/equatable.dart';

class UserTasteProfile extends Equatable {
  final Map<String, double>
  genrePreferences; // genre -> preference score (0.0-1.0)
  final Map<String, double> audioFeatures; // feature -> average value
  final List<String> topArtists;
  final List<String> recentlyPlayed;
  final Map<String, int> listeningPatterns; // time_of_day -> frequency
  final double averageEnergy;
  final double averageDanceability;
  final double averageValence; // happiness/positivity
  final List<String> discoveredGenres;

  const UserTasteProfile({
    this.genrePreferences = const {},
    this.audioFeatures = const {},
    this.topArtists = const [],
    this.recentlyPlayed = const [],
    this.listeningPatterns = const {},
    this.averageEnergy = 0.5,
    this.averageDanceability = 0.5,
    this.averageValence = 0.5,
    this.discoveredGenres = const [],
  });

  @override
  List<Object?> get props => [
    genrePreferences,
    audioFeatures,
    topArtists,
    recentlyPlayed,
    listeningPatterns,
    averageEnergy,
    averageDanceability,
    averageValence,
    discoveredGenres,
  ];

  UserTasteProfile copyWith({
    Map<String, double>? genrePreferences,
    Map<String, double>? audioFeatures,
    List<String>? topArtists,
    List<String>? recentlyPlayed,
    Map<String, int>? listeningPatterns,
    double? averageEnergy,
    double? averageDanceability,
    double? averageValence,
    List<String>? discoveredGenres,
  }) {
    return UserTasteProfile(
      genrePreferences: genrePreferences ?? this.genrePreferences,
      audioFeatures: audioFeatures ?? this.audioFeatures,
      topArtists: topArtists ?? this.topArtists,
      recentlyPlayed: recentlyPlayed ?? this.recentlyPlayed,
      listeningPatterns: listeningPatterns ?? this.listeningPatterns,
      averageEnergy: averageEnergy ?? this.averageEnergy,
      averageDanceability: averageDanceability ?? this.averageDanceability,
      averageValence: averageValence ?? this.averageValence,
      discoveredGenres: discoveredGenres ?? this.discoveredGenres,
    );
  }
}

import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String id;
  final String name;
  final String artistName;
  final String albumName;
  final String? imageUrl;
  final int durationMs;
  final String uri;
  final List<String> artists;
  final String? previewUrl;
  final bool isExplicit;
  final int popularity;

  const Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.imageUrl,
    required this.durationMs,
    required this.uri,
    required this.artists,
    this.previewUrl,
    required this.isExplicit,
    required this.popularity,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    artistName,
    albumName,
    imageUrl,
    durationMs,
    uri,
    artists,
    previewUrl,
    isExplicit,
    popularity,
  ];
}
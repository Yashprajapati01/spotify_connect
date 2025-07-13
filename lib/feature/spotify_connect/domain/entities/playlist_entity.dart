import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int trackCount;
  final bool isPublic;
  final String ownerName;
  final String? ownerId;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.trackCount,
    required this.isPublic,
    required this.ownerName,
    this.ownerId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    trackCount,
    isPublic,
    ownerName,
    ownerId,
  ];
}

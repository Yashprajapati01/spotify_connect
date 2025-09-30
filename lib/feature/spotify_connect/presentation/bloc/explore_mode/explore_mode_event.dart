import 'package:equatable/equatable.dart';
import '../../../domain/entities/explore_mode_request.dart';

abstract class ExploreModeEvent extends Equatable {
  const ExploreModeEvent();

  @override
  List<Object?> get props => [];
}

class AnalyzeUserTasteEvent extends ExploreModeEvent {
  final bool? forceRefresh;

  const AnalyzeUserTasteEvent({this.forceRefresh});

  @override
  List<Object?> get props => [forceRefresh];
}

class GenerateEnhancedPlaylistEvent extends ExploreModeEvent {
  final ExploreModeRequest request;

  const GenerateEnhancedPlaylistEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class SaveEnhancedPlaylistEvent extends ExploreModeEvent {
  final String playlistId;

  const SaveEnhancedPlaylistEvent(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

class ResetExploreModeEvent extends ExploreModeEvent {
  const ResetExploreModeEvent();
}

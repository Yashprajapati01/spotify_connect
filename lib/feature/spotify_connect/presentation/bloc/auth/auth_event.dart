import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AppStarted extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LaunchSpotifyAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SpotifyCodeReceived extends AuthEvent {
  final String code;

  const SpotifyCodeReceived(this.code);

  @override
  List<Object?> get props => [code];
}

class LoggedOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthCancelled extends AuthEvent {
  @override
  List<Object?> get props => [];
}

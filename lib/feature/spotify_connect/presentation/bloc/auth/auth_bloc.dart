import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/auth_token.dart';
import '../../../domain/usecases/authenticate_user.dart';
import '../../../domain/usecases/launch_spotify.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LaunchSpotifyAuth _launchAuth;
  final AuthenticateUserWithCode _authenticateWithCode;
  final FlutterSecureStorage _storage;

  AuthBloc(this._launchAuth, this._authenticateWithCode, this._storage)
      : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final token = await _storage.read(key: 'access_token');
      if (token != null) {
        final refresh = await _storage.read(key: 'refresh_token') ?? '';
        emit(AuthAuthenticated(AuthToken(
          accessToken: token,
          refreshToken: refresh,
          expiresIn: 0,
        )));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LaunchSpotifyAuthEvent>((event, emit) async {
      emit(AuthLoading());
      await _launchAuth();
    });

    on<SpotifyCodeReceived>((event, emit) async {
      emit(AuthLoading());
      final token = await _authenticateWithCode(event.code);
      if (token != null) {
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoggedOut>((_, emit) => emit(AuthUnauthenticated()));
  }
}
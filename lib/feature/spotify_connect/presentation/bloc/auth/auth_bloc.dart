
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

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
  Timer? _authTimeout;

  AuthBloc(this._launchAuth, this._authenticateWithCode, this._storage)
    : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final token = await _storage.read(key: 'access_token');
      if (token != null) {
        final refresh = await _storage.read(key: 'refresh_token') ?? '';
        emit(
          AuthAuthenticated(
            AuthToken(accessToken: token, refreshToken: refresh, expiresIn: 0),
          ),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LaunchSpotifyAuthEvent>((event, emit) async {
      // Only emit loading if we're not already loading
      if (state is! AuthLoading) {
        emit(AuthLoading());
      }

      // Cancel any existing timeout
      _authTimeout?.cancel();

      // Set a timeout for the auth process (e.g., 5 minutes)
      _authTimeout = Timer(const Duration(seconds: 10), () {
        if (state is AuthLoading) {
          add(AuthCancelled());
        }
      });

      try {
        await _launchAuth();
        // Don't emit any state here - let the callback handle it
        // The loading state will remain until we get a callback or timeout
      } catch (e) {
        // If launch fails, go back to unauthenticated
        _authTimeout?.cancel();
        emit(AuthUnauthenticated());
      }
    });

    on<SpotifyCodeReceived>((event, emit) async {
      // Cancel timeout since we received a response
      _authTimeout?.cancel();

      // Always emit loading when processing the code
      emit(AuthLoading());

      try {
        final token = await _authenticateWithCode(event.code);
        if (token != null) {
          // Store tokens in secure storage
          await _storage.write(key: 'access_token', value: token.accessToken);
          await _storage.write(key: 'refresh_token', value: token.refreshToken);
          emit(AuthAuthenticated(token));
        } else {
          // Clear any existing tokens if authentication fails
          await _storage.delete(key: 'access_token');
          await _storage.delete(key: 'refresh_token');
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        // If authentication fails, clear tokens and go back to unauthenticated
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        emit(AuthUnauthenticated());
      }
    });

    on<LoggedOut>((_, emit) async {
      // Clear stored tokens
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      emit(AuthUnauthenticated());
    });

    // Add event to handle auth cancellation/failure
    on<AuthCancelled>((_, emit) {
      _authTimeout?.cancel();
      emit(AuthUnauthenticated());
    });
  }

  @override
  Future<void> close() {
    _authTimeout?.cancel();
    return super.close();
  }
}
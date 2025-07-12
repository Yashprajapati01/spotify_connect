import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection.dart';
import 'feature/spotify_connect/presentation/bloc/auth/auth_bloc.dart';
import 'feature/spotify_connect/presentation/bloc/auth/auth_event.dart';
import 'feature/spotify_connect/presentation/bloc/auth/auth_state.dart';
import 'feature/spotify_connect/presentation/screens/splash.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const SpotifyConnectApp());
}

class SpotifyConnectApp extends StatefulWidget {
  const SpotifyConnectApp({super.key});

  @override
  State<SpotifyConnectApp> createState() => _SpotifyConnectAppState();
}

class _SpotifyConnectAppState extends State<SpotifyConnectApp> {
  late AuthBloc _authBloc;
  late AppLinks _appLinks;
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(AppStarted());
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    // Listen for incoming deep links
    _linkSubscription = _appLinks.uriLinkStream.listen(
          (Uri uri) {
        _handleDeepLink(uri.toString());
      },
      onError: (err) {
        print('Deep link error: $err');
      },
    );

    // Handle initial deep link when app is opened
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    });
  }

  void _handleDeepLink(String link) {
    print('📱 Received deep link: $link');

    if (link.startsWith('myspotifyconnect://callback')) {
      final uri = Uri.parse(link);
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];

      if (error != null) {
        print('❌ Spotify auth error: $error');
        _authBloc.add(LoggedOut());
      } else if (code != null) {
        print('✅ Received auth code: $code');
        _authBloc.add(SpotifyCodeReceived(code));
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spotify Connect',
        home: const AuthRouter(),
      ),
    );
  }
}

/// Chooses which screen to show based on AuthState.
class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('🔄 Current auth state: ${state.runtimeType}');

        if (state is AuthLoading || state is AuthInitial) {
          return const SplashScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else {
          print("❌ Unknown state: $state");
          return const SplashScreen();
        }
      },
    );
  }
}
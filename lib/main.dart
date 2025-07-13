// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'core/injection/injection.dart';
// import 'feature/spotify_connect/presentation/bloc/auth/auth_bloc.dart';
// import 'feature/spotify_connect/presentation/bloc/auth/auth_event.dart';
// import 'feature/spotify_connect/presentation/bloc/auth/auth_state.dart';
// import 'feature/spotify_connect/presentation/screens/home_screen.dart';
// import 'feature/spotify_connect/presentation/screens/login_screen.dart';
// import 'feature/spotify_connect/presentation/screens/splash.dart';
// import 'package:app_links/app_links.dart';
// import 'dart:async';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   configureDependencies();
//   runApp(const SpotifyConnectApp());
// }
//
// class SpotifyConnectApp extends StatefulWidget {
//   const SpotifyConnectApp({super.key});
//
//   @override
//   State<SpotifyConnectApp> createState() => _SpotifyConnectAppState();
// }
//
// class _SpotifyConnectAppState extends State<SpotifyConnectApp> {
//   late AuthBloc _authBloc;
//   late AppLinks _appLinks;
//   StreamSubscription? _linkSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _authBloc = getIt<AuthBloc>()..add(AppStarted());
//     _appLinks = AppLinks();
//     _initDeepLinks();
//   }
//
//   void _initDeepLinks() {
//     // Listen for incoming deep links
//     _linkSubscription = _appLinks.uriLinkStream.listen(
//           (Uri uri) {
//         _handleDeepLink(uri.toString());
//       },
//       onError: (err) {
//         print('Deep link error: $err');
//       },
//     );
//
//     // Handle initial deep link when app is opened
//     _appLinks.getInitialLink().then((Uri? uri) {
//       if (uri != null) {
//         _handleDeepLink(uri.toString());
//       }
//     });
//   }
//
//   void _handleDeepLink(String link) {
//     print('📱 Received deep link: $link');
//
//     if (link.startsWith('myspotifyconnect://callback')) {
//       final uri = Uri.parse(link);
//       final code = uri.queryParameters['code'];
//       final error = uri.queryParameters['error'];
//
//       if (error != null) {
//         print('❌ Spotify auth error: $error');
//         _authBloc.add(LoggedOut());
//       } else if (code != null) {
//         print('✅ Received auth code: $code');
//         _authBloc.add(SpotifyCodeReceived(code));
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _linkSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _authBloc,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.dark(),
//         title: 'Spotify Connect',
//         home: const AuthRouter(),
//       ),
//     );
//   }
// }
//
// /// Chooses which screen to show based on AuthState.
// class AuthRouter extends StatelessWidget {
//   const AuthRouter({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         print('🔄 Current auth state: ${state.runtimeType}');
//
//         if (state is AuthLoading || state is AuthInitial) {
//           return const SplashScreen();
//         } else if (state is AuthUnauthenticated) {
//           return const LoginScreen();
//         } else if (state is AuthAuthenticated) {
//           return const HomeScreen();
//         } else {
//           print("❌ Unknown state: $state");
//           return const SplashScreen();
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection.dart';
import 'feature/spotify_connect/presentation/bloc/auth/auth_bloc.dart';
import 'feature/spotify_connect/presentation/bloc/auth/auth_event.dart';
import 'feature/spotify_connect/presentation/bloc/auth/auth_state.dart';
import 'feature/spotify_connect/presentation/screens/home_screen.dart';
import 'feature/spotify_connect/presentation/screens/login_screen.dart';
import 'feature/spotify_connect/presentation/screens/splash.dart';
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
  bool _isProcessingCallback = false;

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
        // Reset processing flag on error
        _isProcessingCallback = false;
        _authBloc.add(AuthCancelled());
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
      // Prevent multiple callback processing
      if (_isProcessingCallback) {
        print('⚠️ Already processing callback, ignoring duplicate');
        return;
      }

      _isProcessingCallback = true;

      final uri = Uri.parse(link);
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];

      if (error != null) {
        print('❌ Spotify auth error: $error');
        _isProcessingCallback = false;
        _authBloc.add(AuthCancelled());
      } else if (code != null) {
        print('✅ Received auth code: $code');
        _authBloc.add(SpotifyCodeReceived(code));

        // Reset processing flag after a delay to allow state to update
        Timer(const Duration(milliseconds: 1000), () {
          _isProcessingCallback = false;
        });
      } else {
        print('⚠️ No code or error in callback');
        _isProcessingCallback = false;
        _authBloc.add(AuthCancelled());
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
        theme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1DB954),
            secondary: Color(0xFF1DB954),
            background: Color(0xFF191414),
            surface: Color(0xFF212121),
          ),
          scaffoldBackgroundColor: const Color(0xFF191414),
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'SF'),
        ),
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

        switch (state.runtimeType) {
          case AuthLoading:
          case AuthInitial:
            return const SplashScreen();
          case AuthUnauthenticated:
            return const LoginScreen();
          case AuthAuthenticated:
            return const HomeScreen();
          default:
            print("❌ Unknown state: $state");
            return const SplashScreen();
        }
      },
    );
  }
}

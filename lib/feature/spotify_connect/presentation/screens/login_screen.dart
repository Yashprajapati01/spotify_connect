import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 600;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF191414), // Spotify's dark background
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1DB954), // Spotify green
                  Color(0xFF191414), // Dark background
                ],
                stops: [0.0, 0.6],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Header with Spotify logo area
                            Expanded(
                              flex: isSmallScreen ? 1 : 2,
                              child: Container(
                                padding: EdgeInsets.all(
                                  isTablet ? 60 : (isSmallScreen ? 20 : 40),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Spotify-like logo/icon
                                    Image.asset(
                                      'assets/logo_spotify.png',
                                      width: isTablet ? 150 : (isSmallScreen ? 80 : 120),
                                      height: isTablet ? 150 : (isSmallScreen ? 80 : 120),
                                    ),
                                    SizedBox(height: isSmallScreen ? 12 : 24),
                                    Text(
                                      'Spotify Connect',
                                      style: TextStyle(
                                        fontSize: isTablet ? 40 : (isSmallScreen ? 24 : 32),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'SF',
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 4 : 8),
                                    Text(
                                      'Connect your music experience',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Main content area
                            Expanded(
                              flex: isSmallScreen ? 2 : 3,
                              child: Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: isTablet ? 400 : double.infinity,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 48 : 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Welcome text
                                    Text(
                                      'Welcome to Spotify Connect',
                                      style: TextStyle(
                                        fontSize: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: isSmallScreen ? 12 : 16),
                                    Text(
                                      'Connect your Spotify account to start enjoying your music with AI playlist generation',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: isSmallScreen ? 32 : 48),
                                    // Connect button
                                    SizedBox(
                                      width: double.infinity,
                                      height: isTablet ? 64 : (isSmallScreen ? 48 : 56),
                                      child: ElevatedButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : () {
                                          context.read<AuthBloc>().add(
                                            LaunchSpotifyAuthEvent(),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF1DB954),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              isTablet ? 32 : (isSmallScreen ? 24 : 28),
                                            ),
                                          ),
                                          elevation: 0,
                                          disabledBackgroundColor: const Color(
                                            0xFF1DB954,
                                          ).withOpacity(0.6),
                                        ),
                                        child: state is AuthLoading
                                            ? SizedBox(
                                          height: isSmallScreen ? 16 : 20,
                                          width: isSmallScreen ? 16 : 20,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                            : Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.music_note,
                                              size: isSmallScreen ? 18 : 20,
                                            ),
                                            SizedBox(width: isSmallScreen ? 6 : 8),
                                            Text(
                                              'Connect with Spotify',
                                              style: TextStyle(
                                                fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Footer
                            Expanded(
                              flex: isSmallScreen ? 1 : 1,
                              child: Container(
                                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'By connecting, you agree to Spotify\'s Terms of Service',
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
                                        color: Colors.white54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
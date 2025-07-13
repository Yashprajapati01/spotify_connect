import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 600;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF191414), // Spotify's dark background
      body: Container(
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
              return Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Spotify-like logo
                        SizedBox(
                          width: isTablet ? 180 : (isSmallScreen ? 100 : 150),
                          height: isTablet ? 180 : (isSmallScreen ? 100 : 150),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer circle with gradient
                              Image.asset(
                                'assets/logo_spotify.png',
                                width: isTablet ? 180 : (isSmallScreen ? 100 : 150),
                                height: isTablet ? 180 : (isSmallScreen ? 100 : 150),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 24 : 32),
                        // App title
                        Text(
                          'Spotify Connect',
                          style: TextStyle(
                            fontSize: isTablet ? 36 : (isSmallScreen ? 24 : 28),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'SF',
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 60 : 24,
                          ),
                          child: Text(
                            'Connecting your music experience',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : (isSmallScreen ? 14 : 16),
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 36 : 48),
                        // Loading indicator
                        SizedBox(
                          width: isTablet ? 40 : (isSmallScreen ? 28 : 32),
                          height: isTablet ? 40 : (isSmallScreen ? 28 : 32),
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1DB954),
                            ),
                            strokeWidth: isTablet ? 4 : (isSmallScreen ? 2.5 : 3),
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
      ),
    );
  }
}
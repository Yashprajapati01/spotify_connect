import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/entities/playlist_entity.dart';
import '../bloc/explore_mode/explore_mode_bloc.dart';
import '../bloc/explore_mode/explore_mode_event.dart';
import '../bloc/explore_mode/explore_mode_state.dart';
import '../widgets/analyze_me_widgets.dart';

class AnalyzeMeScreen extends StatelessWidget {
  final List<Playlist> userPlaylists;

  const AnalyzeMeScreen({super.key, required this.userPlaylists});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ExploreModeBloc>()..add(const AnalyzeUserTasteEvent()),
      child: AnalyzeMeContent(userPlaylists: userPlaylists),
    );
  }
}

class AnalyzeMeContent extends StatefulWidget {
  final List<Playlist> userPlaylists;

  const AnalyzeMeContent({super.key, required this.userPlaylists});

  @override
  State<AnalyzeMeContent> createState() => _AnalyzeMeContentState();
}

class _AnalyzeMeContentState extends State<AnalyzeMeContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: BlocBuilder<ExploreModeBloc, ExploreModeState>(
                builder: (context, state) {
                  if (state is ExploreModeLoading) {
                    return _buildLoadingState(state.message);
                  } else if (state is TasteAnalysisComplete) {
                    return _buildAnalysisResults(state);
                  } else if (state is ExploreModeError) {
                    return _buildErrorState(state.message);
                  }
                  return _buildInitialState();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.spotifyDarkGrey,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8E2DE2),
                Color(0xFF4A00E0),
                Color(0xFF1DB954),
                AppColors.spotifyDarkGrey,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.psychology,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analyze Me',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF',
                              ),
                            ),
                            Text(
                              'Discover your music DNA',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontFamily: 'SF',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Lottie.asset(
              'assets/player_loading.json',
              width: 200,
              height: 200,
              repeat: true,
            ),
            SizedBox(height: 10,),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.spotifyWhite,
                fontSize: 18,
                fontFamily: 'SF',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    // return Container(
    //   height: 400,
    //   child: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //           width: 80,
    //           height: 80,
    //           decoration: BoxDecoration(
    //             color: AppColors.spotifyGreen.withOpacity(0.1),
    //             shape: BoxShape.circle,
    //           ),
    //           child: const CircularProgressIndicator(
    //             color: AppColors.spotifyGreen,
    //             strokeWidth: 3,
    //           ),
    //         ),
    //         const SizedBox(height: 24),
    //         Text(
    //           message,
    //           style: const TextStyle(
    //             color: AppColors.spotifyWhite,
    //             fontSize: 18,
    //             fontFamily: 'SF',
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildAnalysisResults(TasteAnalysisComplete state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Music DNA Card
          MusicDNACard(tasteProfile: state.tasteProfile),

          const SizedBox(height: 24),

          // Audio Features Analysis
          AudioFeaturesAnalysis(tasteProfile: state.tasteProfile),

          const SizedBox(height: 24),

          // Genre Preferences
          GenrePreferencesCard(tasteProfile: state.tasteProfile),

          const SizedBox(height: 24),

          // Listening Insights
          ListeningInsightsCard(tasteProfile: state.tasteProfile),

          const SizedBox(height: 32),

          // Action Buttons
          _buildActionButtons(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _refreshAnalysis(),
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'Refresh Analysis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spotifyGreen,
              foregroundColor: AppColors.spotifyWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 20),
            label: const Text(
              'Back to Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF',
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.spotifyGreen,
              side: const BorderSide(color: AppColors.spotifyGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Analysis Failed',
              style: TextStyle(
                color: AppColors.spotifyWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: AppColors.spotifyTextGrey,
                fontSize: 14,
                fontFamily: 'SF',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _refreshAnalysis(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.spotifyGreen,
                foregroundColor: AppColors.spotifyWhite,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Container(
      height: 200,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.spotifyGreen),
      ),
    );
  }

  void _refreshAnalysis() {
    context.read<ExploreModeBloc>().add(
      const AnalyzeUserTasteEvent(forceRefresh: true),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/entities/explore_mode_request.dart';
import '../../domain/entities/playlist_entity.dart';
import '../bloc/explore_mode/explore_mode_bloc.dart';
import '../bloc/explore_mode/explore_mode_event.dart';
import '../bloc/explore_mode/explore_mode_state.dart';
import '../widgets/explore_mode_widgets.dart';

class ExploreModeScreen extends StatelessWidget {
  final List<Playlist> userPlaylists;

  const ExploreModeScreen({super.key, required this.userPlaylists});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ExploreModeBloc>()..add(const AnalyzeUserTasteEvent()),
      child: ExploreModeContent(userPlaylists: userPlaylists),
    );
  }
}

class ExploreModeContent extends StatefulWidget {
  final List<Playlist> userPlaylists;

  const ExploreModeContent({super.key, required this.userPlaylists});

  @override
  State<ExploreModeContent> createState() => _ExploreModeContentState();
}

class _ExploreModeContentState extends State<ExploreModeContent>
    with TickerProviderStateMixin {
  final Set<String> selectedPlaylistIds = {};
  final TextEditingController moodController = TextEditingController();
  final TextEditingController activityController = TextEditingController();

  double energyLevel = 0.5;
  double danceability = 0.5;
  bool includeNewDiscoveries = true;
  int maxTracks = 50;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    moodController.dispose();
    activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      body: BlocListener<ExploreModeBloc, ExploreModeState>(
        listener: (context, state) {
          if (state is ExploreModeError) {
            _showErrorSnackBar(context, state.message);
          } else if (state is EnhancedPlaylistSaved) {
            _showSuccessSnackBar(
              context,
              'Enhanced playlist saved to Spotify! 🎵',
            );
          }
        },
        child: CustomScrollView(
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
                      return _buildConfigurationSection(state);
                    } else if (state is EnhancedPlaylistGenerated ||
                        state is EnhancedPlaylistSaving ||
                        state is EnhancedPlaylistSaved) {
                      return _buildPlaylistResultSection(state);
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
                Color(0xFF1DB954),
                Color(0xFF1AA34A),
                Color(0xFF168B3A),
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
                          Icons.explore,
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
                              'Explore Mode',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF',
                              ),
                            ),
                            Text(
                              'AI-powered playlist enhancement',
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
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.spotifyGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
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
  }

  Widget _buildConfigurationSection(TasteAnalysisComplete state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Taste Profile Summary
          TasteProfileCard(tasteProfile: state.tasteProfile),

          const SizedBox(height: 24),

          // Playlist Selection
          PlaylistSelectionSection(
            playlists: widget.userPlaylists,
            selectedIds: selectedPlaylistIds,
            onSelectionChanged: (id, selected) {
              setState(() {
                if (selected) {
                  selectedPlaylistIds.add(id);
                } else {
                  selectedPlaylistIds.remove(id);
                }
              });
            },
          ),

          const SizedBox(height: 24),

          // Mood and Activity Input
          MoodActivitySection(
            moodController: moodController,
            activityController: activityController,
          ),

          const SizedBox(height: 24),

          // Audio Features Sliders
          AudioFeaturesSection(
            energyLevel: energyLevel,
            danceability: danceability,
            onEnergyChanged: (value) => setState(() => energyLevel = value),
            onDanceabilityChanged: (value) =>
                setState(() => danceability = value),
          ),

          const SizedBox(height: 24),

          // Settings
          SettingsSection(
            includeNewDiscoveries: includeNewDiscoveries,
            maxTracks: maxTracks,
            onDiscoveryToggled: (value) =>
                setState(() => includeNewDiscoveries = value),
            onMaxTracksChanged: (value) => setState(() => maxTracks = value),
          ),

          const SizedBox(height: 32),

          // Generate Button
          _buildGenerateButton(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    final canGenerate =
        selectedPlaylistIds.isNotEmpty && moodController.text.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canGenerate ? _generateEnhancedPlaylist : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canGenerate
              ? AppColors.spotifyGreen
              : AppColors.spotifyTextGrey,
          foregroundColor: AppColors.spotifyWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: canGenerate ? 8 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 24,
              color: canGenerate
                  ? AppColors.spotifyWhite
                  : AppColors.spotifyTextGrey,
            ),
            const SizedBox(width: 12),
            Text(
              'Generate Enhanced Playlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF',
                color: canGenerate
                    ? AppColors.spotifyWhite
                    : AppColors.spotifyTextGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistResultSection(ExploreModeState state) {
    if (state is EnhancedPlaylistGenerated) {
      return EnhancedPlaylistDisplay(
        playlist: state.playlist,
        onSave: () => context.read<ExploreModeBloc>().add(
          SaveEnhancedPlaylistEvent(state.playlist.id),
        ),
        onBack: () =>
            context.read<ExploreModeBloc>().add(const ResetExploreModeEvent()),
      );
    } else if (state is EnhancedPlaylistSaving) {
      return EnhancedPlaylistDisplay(
        playlist: state.playlist,
        isSaving: true,
        onBack: () =>
            context.read<ExploreModeBloc>().add(const ResetExploreModeEvent()),
      );
    } else if (state is EnhancedPlaylistSaved) {
      return EnhancedPlaylistDisplay(
        playlist: state.playlist,
        isSaved: true,
        onBack: () =>
            context.read<ExploreModeBloc>().add(const ResetExploreModeEvent()),
      );
    }
    return const SizedBox.shrink();
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
            Text(
              'Oops! Something went wrong',
              style: const TextStyle(
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
              onPressed: () => context.read<ExploreModeBloc>().add(
                const AnalyzeUserTasteEvent(),
              ),
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

  void _generateEnhancedPlaylist() {
    final request = ExploreModeRequest(
      selectedPlaylistIds: selectedPlaylistIds.toList(),
      mood: moodController.text,
      currentActivity: activityController.text,
      energyLevel: energyLevel,
      danceability: danceability,
      includeNewDiscoveries: includeNewDiscoveries,
      maxTracks: maxTracks,
    );

    context.read<ExploreModeBloc>().add(GenerateEnhancedPlaylistEvent(request));
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.spotifyGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

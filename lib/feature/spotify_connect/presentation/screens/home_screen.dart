
import 'package:connectspotify/feature/spotify_connect/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/generated_playlist.dart';
import '../bloc/playlist_selection/playlist_selection_bloc.dart';
import '../bloc/playlist_selection/playlist_selection_event.dart';
import '../bloc/playlist_selection/playlist_selection_state.dart';
import '../bloc/playlist_generation/playlist_generation_bloc.dart';
import '../bloc/playlist_generation/playlist_generation_event.dart';
import '../bloc/playlist_generation/playlist_generation_state.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PlaylistBloc>()..add(LoadUserData()),
        ),
        BlocProvider(create: (context) => getIt<PlaylistGenerationBloc>()),
      ],
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with TickerProviderStateMixin {
  final Set<String> selectedPlaylistIds = {};
  final TextEditingController moodController = TextEditingController();
  final FocusNode moodFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool showGeneratedPlaylist = false;

  @override
  void dispose() {
    moodController.dispose();
    moodFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.spotifyBlack,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.spotifyDarkGrey,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: AppColors.spotifyLightGrey,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.spotifyBlack,
        body: Stack(
          children: [
            BlocListener<PlaylistGenerationBloc, PlaylistGenerationState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
                if (state is PlaylistGenerationError) {
                  _showCustomSnackBar(context, state.message, isError: true);
                } else if (state is PlaylistSaved) {
                  _showCustomSnackBar(context, 'Playlist saved to Spotify! 🎵');
                } else if (state is PlaylistGenerationSuccess) {
                  setState(() {
                    showGeneratedPlaylist = true;
                  });
                }
              },
              child: Column(
                children: [
                  // Main content area
                  Expanded(
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        _buildSliverAppBar(),
                        BlocBuilder<PlaylistBloc, PlaylistState>(
                          builder: (context, state) {
                            if (state is PlaylistLoading) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.spotifyGreen,
                                  ),
                                ),
                              );
                            } else if (state is PlaylistError) {
                              return SliverFillRemaining(
                                child: _buildErrorState(state.message),
                              );
                            } else if (state is PlaylistLoaded) {
                              return _buildMainContent(
                                state.userProfile,
                                state.playlists,
                              );
                            }
                            return const SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    color: AppColors.spotifyTextGrey,
                                    fontFamily: 'SF',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Bottom text input (Gemini-style)
                  _buildBottomTextInput(),
                ],
              ),
            ),
            // Generating overlay
            BlocBuilder<PlaylistGenerationBloc, PlaylistGenerationState>(
              builder: (context, state) {
                if (state is PlaylistGenerationLoading) {
                  return _buildGeneratingOverlay();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        UserProfile? userProfile;
        if (state is PlaylistLoaded) {
          userProfile = state.userProfile;
        }

        return SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.spotifyDarkGrey,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1DB954),
                    Color(0xFF1AA34A),
                    AppColors.spotifyDarkGrey,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Profile section
                      if (userProfile != null) ...[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.spotifyWhite,
                              width: 2,
                            ),
                            image: userProfile.imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(userProfile.imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: userProfile.imageUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 25,
                                  color: AppColors.spotifyWhite,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                      ],
                      // Title section
                      if (userProfile != null) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hello',
                              style: TextStyle(
                                color: AppColors.spotifyWhite.withOpacity(0.9),
                                fontSize: 15,
                                fontFamily: 'SF',
                              ),
                            ),
                            Text(
                              userProfile.displayName,
                              style: TextStyle(
                                color: AppColors.spotifyWhite.withOpacity(0.9),
                                fontSize: 25,
                                fontFamily: 'SF',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.spotifyWhite),
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent(UserProfile userProfile, List<Playlist> playlists) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Show original playlists or generated playlist based on state
        if (!showGeneratedPlaylist) ...[
          _buildPlaylistSelectionSection(playlists),
        ] else ...[
          _buildGeneratedPlaylistSection(),
          // Option to go back to playlist selection
          _buildBackToSelectionButton(),
        ],

        const SizedBox(height: 20), // Space for bottom input
      ]),
    );
  }

  Widget _buildGeneratingOverlay() {
    return Container(
      color: AppColors.spotifyBlack.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.spotifyLightGrey,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated music notes or spinning icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.spotifyGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.spotifyGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Generating Your Playlist',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Analyzing your selected playlists and mood...',
                style: TextStyle(
                  color: AppColors.spotifyTextGrey,
                  fontSize: 14,
                  fontFamily: 'SF',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: AppColors.spotifyGreen,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistSelectionSection(List<Playlist> playlists) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.queue_music, color: AppColors.spotifyGreen),
                const SizedBox(width: 8),
                const Text(
                  'Your Playlists',
                  style: TextStyle(
                    color: AppColors.spotifyWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF',
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.spotifyGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${selectedPlaylistIds.length}',
                    style: const TextStyle(
                      color: AppColors.spotifyWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Grid view of playlists
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) =>
                _buildPlaylistCard(playlists[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(Playlist playlist) {
    final isSelected = selectedPlaylistIds.contains(playlist.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedPlaylistIds.remove(playlist.id);
          } else {
            selectedPlaylistIds.add(playlist.id);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.spotifyLightGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.spotifyGreen : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist Image
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      color: AppColors.spotifyBlack,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: playlist.imageUrl != null
                          ? Image.network(
                              playlist.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.music_note,
                                    color: AppColors.spotifyTextGrey,
                                    size: 40,
                                  ),
                            )
                          : const Icon(
                              Icons.music_note,
                              color: AppColors.spotifyTextGrey,
                              size: 40,
                            ),
                    ),
                  ),
                ),
                // Playlist Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.spotifyGreen
                              : AppColors.spotifyWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'SF',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${playlist.trackCount} songs',
                        style: TextStyle(
                          color: AppColors.spotifyTextGrey,
                          fontSize: 12,
                          fontFamily: 'SF',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Selection indicator (Spotify-style)
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.spotifyGreen
                      : AppColors.spotifyBlack.withOpacity(0.6),
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.add,
                  color: AppColors.spotifyWhite,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedPlaylistSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.spotifyGreen),
                SizedBox(width: 8),
                Text(
                  'Generated Playlist',
                  style: TextStyle(
                    color: AppColors.spotifyWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                      fontFamily: 'SF'
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.spotifyLightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: BlocBuilder<PlaylistGenerationBloc, PlaylistGenerationState>(
              builder: (context, state) {
                if (state is PlaylistGenerationLoading) {
                  return _buildLoadingState();
                } else if (state is PlaylistGenerationSuccess) {
                  return _buildGeneratedPlaylist(state.generatedPlaylist);
                } else if (state is PlaylistSaving) {
                  return _buildGeneratedPlaylist(
                    state.generatedPlaylist,
                    isSaving: true,
                  );
                } else if (state is PlaylistSaved) {
                  return _buildGeneratedPlaylist(
                    state.generatedPlaylist,
                    isSaved: true,
                  );
                } else if (state is PlaylistGenerationError) {
                  return _buildGenerationError(state.message);
                }
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToSelectionButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            showGeneratedPlaylist = false;
          });
        },
        icon: const Icon(Icons.arrow_back, color: AppColors.spotifyGreen),
        label: const Text(
          'Back to Playlist Selection',
          style: TextStyle(color: AppColors.spotifyGreen,fontFamily: 'SF'),
        ),
      ),
    );
  }

  Widget _buildBottomTextInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.spotifyDarkGrey,
        border: Border(
          top: BorderSide(color: AppColors.spotifyLightGrey, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.spotifyLightGrey,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: moodFocusNode.hasFocus
                        ? AppColors.spotifyGreen
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: moodController,
                  focusNode: moodFocusNode,
                  style: const TextStyle(color: AppColors.spotifyWhite,fontFamily: 'SF'),
                  decoration: InputDecoration(
                    hintText: 'Describe your mood or vibe...',
                    hintStyle: TextStyle(color: AppColors.spotifyTextGrey,fontFamily: 'SF'),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (_canGeneratePlaylist()) {
                      _generatePlaylist();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton(
                onPressed: _canGeneratePlaylist() ? _generatePlaylist : null,
                backgroundColor: _canGeneratePlaylist()
                    ? AppColors.spotifyGreen
                    : AppColors.spotifyTextGrey,
                elevation: 0,
                child: const Icon(Icons.send, color: AppColors.spotifyWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.spotifyGreen),
            SizedBox(height: 16),
            Text(
              'Creating your perfect playlist...',
              style: TextStyle(color: AppColors.spotifyTextGrey,fontFamily: 'SF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedPlaylist(
    GeneratedPlaylist playlist, {
    bool isSaving = false,
    bool isSaved = false,
  }) {
    return Column(
      children: [
        // Playlist Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        color: AppColors.spotifyWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                          fontFamily: 'SF'
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      playlist.description,
                      style: TextStyle(
                        color: AppColors.spotifyTextGrey,
                        fontSize: 14,
                          fontFamily: 'SF'
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSaved && !isSaving)
                ElevatedButton.icon(
                  onPressed: () => _saveToSpotify(playlist),
                  icon: const Icon(Icons.add),
                  label: const Text('Save to Spotify'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.spotifyGreen,
                    foregroundColor: AppColors.spotifyWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              if (isSaving)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.spotifyGreen,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Saving...',
                      style: TextStyle(color: AppColors.spotifyTextGrey,fontFamily: 'SF'),
                    ),
                  ],
                ),
              if (isSaved)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.spotifyGreen),
                    SizedBox(width: 8),
                    Text(
                      'Saved!',
                      style: TextStyle(color: AppColors.spotifyGreen,fontFamily: 'SF'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        // Tracks List
        Container(
          height: 400,
          child: ListView.builder(
            itemCount: playlist.tracks.length,
            itemBuilder: (context, index) {
              final track = playlist.tracks[index];
              return _buildTrackTile(track, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackTile(Track track, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.spotifyBlack,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: track.imageUrl != null
                ? Image.network(
                    track.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.music_note,
                      color: AppColors.spotifyTextGrey,
                      size: 20,
                    ),
                  )
                : const Icon(
                    Icons.music_note,
                    color: AppColors.spotifyTextGrey,
                    size: 20,
                  ),
          ),
        ),
        title: Text(
          track.name,
          style: const TextStyle(
            color: AppColors.spotifyWhite,
            fontWeight: FontWeight.w500,
              fontFamily: 'SF'
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${track.artistName} • ${track.albumName}',
          style: TextStyle(color: AppColors.spotifyTextGrey, fontSize: 12,fontFamily: 'SF'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _formatDuration(track.durationMs),
          style: TextStyle(color: AppColors.spotifyTextGrey, fontSize: 12,fontFamily: 'SF'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.playlist_add,
              size: 48,
              color: AppColors.spotifyTextGrey,
            ),
            SizedBox(height: 16),
            Text(
              'Select playlists and describe your mood\nto generate a personalized playlist',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.spotifyTextGrey,fontFamily: 'SF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationError(String message) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red,fontFamily: 'SF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(color: AppColors.spotifyTextGrey,fontFamily: 'SF'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PlaylistBloc>().add(RefreshPlaylists());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spotifyGreen,
              foregroundColor: AppColors.spotifyWhite,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showCustomSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.spotifyGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  bool _canGeneratePlaylist() {
    return selectedPlaylistIds.isNotEmpty &&
        moodController.text.trim().isNotEmpty;
  }

  void _generatePlaylist() {
    if (!_canGeneratePlaylist()) return;

    moodFocusNode.unfocus();

    context.read<PlaylistGenerationBloc>().add(
      GeneratePlaylist(
        selectedPlaylistIds: selectedPlaylistIds.toList(),
        mood: moodController.text.trim(),
      ),
    );
  }

  void _saveToSpotify(GeneratedPlaylist playlist) {
    context.read<PlaylistGenerationBloc>().add(
      SaveGeneratedPlaylist(playlist.id),
    );
  }

  String _formatDuration(int durationMs) {
    final duration = Duration(milliseconds: durationMs);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

import 'package:connectspotify/feature/spotify_connect/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        BlocProvider(
          create: (context) => getIt<PlaylistGenerationBloc>(),
        ),
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
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Spotify color scheme
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color spotifyBlack = Color(0xFF121212);
  static const Color spotifyDarkGrey = Color(0xFF191414);
  static const Color spotifyLightGrey = Color(0xFF282828);
  static const Color spotifyWhite = Color(0xFFFFFFFF);
  static const Color spotifyTextGrey = Color(0xFFB3B3B3);

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    moodController.dispose();
    moodFocusNode.dispose();
    scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: spotifyBlack,
        appBarTheme: const AppBarTheme(
          backgroundColor: spotifyDarkGrey,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: spotifyLightGrey,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: spotifyBlack,
        body: BlocListener<PlaylistGenerationBloc, PlaylistGenerationState>(
          listener: (context, state) {
            if(state is AuthUnauthenticated){
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            }
            if (state is PlaylistGenerationError) {
              _showCustomSnackBar(context, state.message, isError: true);
            } else if (state is PlaylistSaved) {
              _showCustomSnackBar(context, 'Playlist saved to Spotify! 🎵');
            }
          },
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
                          color: spotifyGreen,
                        ),
                      ),
                    );
                  } else if (state is PlaylistError) {
                    return SliverFillRemaining(
                      child: _buildErrorState(state.message),
                    );
                  } else if (state is PlaylistLoaded) {
                    return _buildMainContent(state.userProfile, state.playlists);
                  }
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Something went wrong',
                        style: TextStyle(color: spotifyTextGrey),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: spotifyDarkGrey,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1DB954),
                Color(0xFF1AA34A),
                spotifyDarkGrey,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Playlist Generator',
                    style: TextStyle(
                      color: spotifyWhite,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create personalized playlists based on your mood',
                    style: TextStyle(
                      color: spotifyWhite.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: spotifyWhite),
          onPressed: () {
            context.read<AuthBloc>().add(LoggedOut());
          },
        ),
      ],
    );
  }

  Widget _buildMainContent(UserProfile userProfile, List<Playlist> playlists) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // User Profile Section
        _buildUserProfileSection(userProfile),

        // Mood Input Section
        _buildMoodInputSection(),

        // Playlist Selection Section
        _buildPlaylistSelectionSection(playlists),

        // Generated Playlist Section
        _buildGeneratedPlaylistSection(),

        const SizedBox(height: 100), // Space for FAB
      ]),
    );
  }

  Widget _buildUserProfileSection(UserProfile userProfile) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [spotifyLightGrey, Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: spotifyGreen, width: 2),
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
              size: 30,
              color: spotifyGreen,
            )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: spotifyTextGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile.displayName,
                  style: const TextStyle(
                    color: spotifyWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodInputSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: spotifyLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.mood, color: spotifyGreen),
              SizedBox(width: 8),
              Text(
                'What\'s your vibe?',
                style: TextStyle(
                  color: spotifyWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: spotifyBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: moodFocusNode.hasFocus ? spotifyGreen : Colors.transparent,
                width: 2,
              ),
            ),
            child: TextField(
              controller: moodController,
              focusNode: moodFocusNode,
              style: const TextStyle(color: spotifyWhite),
              decoration: InputDecoration(
                hintText: 'happy, energetic, chill, romantic, study...',
                hintStyle: TextStyle(color: spotifyTextGrey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                prefixIcon: const Icon(Icons.search, color: spotifyTextGrey),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && selectedPlaylistIds.isNotEmpty) {
                  _fabAnimationController.forward();
                } else {
                  _fabAnimationController.reverse();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildMoodChips(),
        ],
      ),
    );
  }

  Widget _buildMoodChips() {
    final moodSuggestions = ['Happy', 'Chill', 'Energetic', 'Sad', 'Romantic', 'Study'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: moodSuggestions.map((mood) {
        return GestureDetector(
          onTap: () {
            moodController.text = mood.toLowerCase();
            if (selectedPlaylistIds.isNotEmpty) {
              _fabAnimationController.forward();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: spotifyBlack,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: spotifyTextGrey.withOpacity(0.3)),
            ),
            child: Text(
              mood,
              style: TextStyle(
                color: spotifyTextGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
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
                const Icon(Icons.queue_music, color: spotifyGreen),
                const SizedBox(width: 8),
                const Text(
                  'Select your playlists',
                  style: TextStyle(
                    color: spotifyWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${selectedPlaylistIds.length} selected',
                  style: TextStyle(
                    color: spotifyTextGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: spotifyLightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) => _buildPlaylistTile(playlists[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(Playlist playlist) {
    final isSelected = selectedPlaylistIds.contains(playlist.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? spotifyGreen.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? spotifyGreen : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedPlaylistIds.remove(playlist.id);
            } else {
              selectedPlaylistIds.add(playlist.id);
            }

            if (selectedPlaylistIds.isNotEmpty && moodController.text.trim().isNotEmpty) {
              _fabAnimationController.forward();
            } else {
              _fabAnimationController.reverse();
            }
          });
        },
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: spotifyBlack,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: playlist.imageUrl != null
                ? Image.network(
              playlist.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.music_note, color: spotifyTextGrey),
            )
                : const Icon(Icons.music_note, color: spotifyTextGrey),
          ),
        ),
        title: Text(
          playlist.name,
          style: TextStyle(
            color: isSelected ? spotifyGreen : spotifyWhite,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${playlist.trackCount} tracks • ${playlist.ownerName}',
          style: TextStyle(
            color: spotifyTextGrey,
            fontSize: 12,
          ),
        ),
        trailing: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? spotifyGreen : Colors.transparent,
            border: Border.all(
              color: isSelected ? spotifyGreen : spotifyTextGrey,
              width: 2,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check, color: spotifyWhite, size: 16)
              : null,
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
                Icon(Icons.auto_awesome, color: spotifyGreen),
                SizedBox(width: 8),
                Text(
                  'Generated Playlist',
                  style: TextStyle(
                    color: spotifyWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: spotifyLightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: BlocBuilder<PlaylistGenerationBloc, PlaylistGenerationState>(
              builder: (context, state) {
                if (state is PlaylistGenerationLoading) {
                  return _buildLoadingState();
                } else if (state is PlaylistGenerationSuccess) {
                  return _buildGeneratedPlaylist(state.generatedPlaylist);
                } else if (state is PlaylistSaving) {
                  return _buildGeneratedPlaylist(state.generatedPlaylist, isSaving: true);
                } else if (state is PlaylistSaved) {
                  return _buildGeneratedPlaylist(state.generatedPlaylist, isSaved: true);
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

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: spotifyGreen),
          SizedBox(height: 16),
          Text(
            'Creating your perfect playlist...',
            style: TextStyle(color: spotifyTextGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedPlaylist(GeneratedPlaylist playlist, {bool isSaving = false, bool isSaved = false}) {
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
                        color: spotifyWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      playlist.description,
                      style: TextStyle(
                        color: spotifyTextGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSaved && !isSaving)
                ElevatedButton.icon(
                  onPressed: () => _saveToSpotify(playlist),
                  icon: const Icon(Icons.add),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: spotifyGreen,
                    foregroundColor: spotifyWhite,
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
                        color: spotifyGreen,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('Saving...', style: TextStyle(color: spotifyTextGrey)),
                  ],
                ),
              if (isSaved)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: spotifyGreen),
                    SizedBox(width: 8),
                    Text('Saved!', style: TextStyle(color: spotifyGreen)),
                  ],
                ),
            ],
          ),
        ),
        // Tracks List
        Expanded(
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: spotifyBlack,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: track.imageUrl != null
                ? Image.network(
              track.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.music_note, color: spotifyTextGrey, size: 20),
            )
                : const Icon(Icons.music_note, color: spotifyTextGrey, size: 20),
          ),
        ),
        title: Text(
          track.name,
          style: const TextStyle(
            color: spotifyWhite,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${track.artistName} • ${track.albumName}',
          style: TextStyle(
            color: spotifyTextGrey,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _formatDuration(track.durationMs),
          style: TextStyle(
            color: spotifyTextGrey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_add, size: 48, color: spotifyTextGrey),
          SizedBox(height: 16),
          Text(
            'Select playlists and set your mood\nto generate a personalized playlist',
            textAlign: TextAlign.center,
            style: TextStyle(color: spotifyTextGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerationError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
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
            style: const TextStyle(color: spotifyTextGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PlaylistBloc>().add(RefreshPlaylists());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: spotifyGreen,
              foregroundColor: spotifyWhite,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: _canGeneratePlaylist() ? _generatePlaylist : null,
        backgroundColor: spotifyGreen,
        foregroundColor: spotifyWhite,
        elevation: 8,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate'),
      ),
    );
  }

  void _showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : spotifyGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  bool _canGeneratePlaylist() {
    return selectedPlaylistIds.isNotEmpty && moodController.text.trim().isNotEmpty;
  }

  void _generatePlaylist() {
    if (!_canGeneratePlaylist()) return;

    moodFocusNode.unfocus();
    _fabAnimationController.reverse();

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
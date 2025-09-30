import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../domain/entities/user_taste_profile.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/enhanced_playlist.dart';
import '../../domain/entities/track.dart';

class TasteProfileCard extends StatelessWidget {
  final UserTasteProfile tasteProfile;

  const TasteProfileCard({super.key, required this.tasteProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.spotifyLightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.spotifyGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.spotifyGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: AppColors.spotifyGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Your Music DNA',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Audio Features
          Row(
            children: [
              Expanded(
                child: _buildFeatureIndicator(
                  'Energy',
                  tasteProfile.averageEnergy,
                  Icons.flash_on,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFeatureIndicator(
                  'Dance',
                  tasteProfile.averageDanceability,
                  Icons.music_note,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFeatureIndicator(
                  'Mood',
                  tasteProfile.averageValence,
                  Icons.sentiment_satisfied,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Discovered Genres
          if (tasteProfile.discoveredGenres.isNotEmpty) ...[
            const Text(
              'Your Genres',
              style: TextStyle(
                color: AppColors.spotifyWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tasteProfile.discoveredGenres.take(5).map((genre) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.spotifyGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    genre.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.spotifyGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF',
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureIndicator(String label, double value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.spotifyGreen, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.spotifyTextGrey,
            fontSize: 12,
            fontFamily: 'SF',
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: AppColors.spotifyBlack,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.spotifyGreen,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${(value * 100).round()}%',
          style: const TextStyle(
            color: AppColors.spotifyWhite,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF',
          ),
        ),
      ],
    );
  }
}

class PlaylistSelectionSection extends StatelessWidget {
  final List<Playlist> playlists;
  final Set<String> selectedIds;
  final Function(String, bool) onSelectionChanged;

  const PlaylistSelectionSection({
    super.key,
    required this.playlists,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.spotifyLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.library_music, color: AppColors.spotifyGreen),
              const SizedBox(width: 8),
              const Text(
                'Select Playlists to Enhance',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.spotifyGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedIds.length}',
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
          const SizedBox(height: 16),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                final isSelected = selectedIds.contains(playlist.id);

                return GestureDetector(
                  onTap: () => onSelectionChanged(playlist.id, !isSelected),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.spotifyGreen
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: playlist.imageUrl != null
                                ? Image.network(
                                    playlist.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: AppColors.spotifyBlack,
                                              child: const Icon(
                                                Icons.music_note,
                                                color:
                                                    AppColors.spotifyTextGrey,
                                              ),
                                            ),
                                  )
                                : Container(
                                    color: AppColors.spotifyBlack,
                                    child: const Icon(
                                      Icons.music_note,
                                      color: AppColors.spotifyTextGrey,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          playlist.name,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.spotifyGreen
                                : AppColors.spotifyWhite,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontFamily: 'SF',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MoodActivitySection extends StatelessWidget {
  final TextEditingController moodController;
  final TextEditingController activityController;

  const MoodActivitySection({
    super.key,
    required this.moodController,
    required this.activityController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.spotifyLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.mood, color: AppColors.spotifyGreen),
              SizedBox(width: 8),
              Text(
                'Set the Vibe',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mood Input
          TextField(
            controller: moodController,
            style: const TextStyle(
              color: AppColors.spotifyWhite,
              fontFamily: 'SF',
            ),
            decoration: InputDecoration(
              hintText: 'How are you feeling? (e.g., happy, chill, energetic)',
              hintStyle: TextStyle(
                color: AppColors.spotifyTextGrey,
                fontFamily: 'SF',
              ),
              filled: true,
              fillColor: AppColors.spotifyBlack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.sentiment_satisfied,
                color: AppColors.spotifyGreen,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Activity Input
          TextField(
            controller: activityController,
            style: const TextStyle(
              color: AppColors.spotifyWhite,
              fontFamily: 'SF',
            ),
            decoration: InputDecoration(
              hintText: 'What are you doing? (optional)',
              hintStyle: TextStyle(
                color: AppColors.spotifyTextGrey,
                fontFamily: 'SF',
              ),
              filled: true,
              fillColor: AppColors.spotifyBlack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.directions_run,
                color: AppColors.spotifyGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioFeaturesSection extends StatelessWidget {
  final double energyLevel;
  final double danceability;
  final Function(double) onEnergyChanged;
  final Function(double) onDanceabilityChanged;

  const AudioFeaturesSection({
    super.key,
    required this.energyLevel,
    required this.danceability,
    required this.onEnergyChanged,
    required this.onDanceabilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.spotifyLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, color: AppColors.spotifyGreen),
              SizedBox(width: 8),
              Text(
                'Fine-tune the Sound',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Energy Slider
          _buildSlider(
            'Energy Level',
            energyLevel,
            onEnergyChanged,
            Icons.flash_on,
            'Low energy, calm',
            'High energy, intense',
            context,
          ),

          const SizedBox(height: 20),

          // Danceability Slider
          _buildSlider(
            'Danceability',
            danceability,
            onDanceabilityChanged,
            Icons.music_note,
            'Not danceable',
            'Very danceable',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String title,
    double value,
    Function(double) onChanged,
    IconData icon,
    String lowLabel,
    String highLabel,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.spotifyGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.spotifyWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF',
              ),
            ),
            const Spacer(),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                color: AppColors.spotifyGreen,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.spotifyGreen,
            inactiveTrackColor: AppColors.spotifyBlack,
            thumbColor: AppColors.spotifyGreen,
            overlayColor: AppColors.spotifyGreen.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(value: value, onChanged: onChanged, min: 0.0, max: 1.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lowLabel,
              style: TextStyle(
                color: AppColors.spotifyTextGrey,
                fontSize: 12,
                fontFamily: 'SF',
              ),
            ),
            Text(
              highLabel,
              style: TextStyle(
                color: AppColors.spotifyTextGrey,
                fontSize: 12,
                fontFamily: 'SF',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsSection extends StatelessWidget {
  final bool includeNewDiscoveries;
  final int maxTracks;
  final Function(bool) onDiscoveryToggled;
  final Function(int) onMaxTracksChanged;

  const SettingsSection({
    super.key,
    required this.includeNewDiscoveries,
    required this.maxTracks,
    required this.onDiscoveryToggled,
    required this.onMaxTracksChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.spotifyLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings, color: AppColors.spotifyGreen),
              SizedBox(width: 8),
              Text(
                'Playlist Settings',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // New Discoveries Toggle
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Include New Discoveries',
                      style: TextStyle(
                        color: AppColors.spotifyWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF',
                      ),
                    ),
                    Text(
                      'Add recommended songs based on your taste',
                      style: TextStyle(
                        color: AppColors.spotifyTextGrey,
                        fontSize: 12,
                        fontFamily: 'SF',
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: includeNewDiscoveries,
                onChanged: onDiscoveryToggled,
                activeColor: AppColors.spotifyGreen,
                inactiveThumbColor: AppColors.spotifyTextGrey,
                inactiveTrackColor: AppColors.spotifyBlack,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Max Tracks Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Maximum Tracks',
                    style: TextStyle(
                      color: AppColors.spotifyWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$maxTracks songs',
                    style: const TextStyle(
                      color: AppColors.spotifyGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.spotifyGreen,
                  inactiveTrackColor: AppColors.spotifyBlack,
                  thumbColor: AppColors.spotifyGreen,
                  overlayColor: AppColors.spotifyGreen.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: maxTracks.toDouble(),
                  onChanged: (value) => onMaxTracksChanged(value.round()),
                  min: 20,
                  max: 100,
                  divisions: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnhancedPlaylistDisplay extends StatelessWidget {
  final EnhancedPlaylist playlist;
  final VoidCallback? onSave;
  final VoidCallback? onBack;
  final bool isSaving;
  final bool isSaved;

  const EnhancedPlaylistDisplay({
    super.key,
    required this.playlist,
    this.onSave,
    this.onBack,
    this.isSaving = false,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.spotifyLightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.spotifyGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: AppColors.spotifyGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist.name,
                            style: const TextStyle(
                              color: AppColors.spotifyWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            playlist.description,
                            style: TextStyle(
                              color: AppColors.spotifyTextGrey,
                              fontSize: 14,
                              fontFamily: 'SF',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats
                Row(
                  children: [
                    _buildStat('Total Songs', '${playlist.totalTracks}'),
                    const SizedBox(width: 20),
                    _buildStat('Original', '${playlist.originalTracksCount}'),
                    const SizedBox(width: 20),
                    _buildStat(
                      'Discovered',
                      '${playlist.discoveredTracksCount}',
                    ),
                    const SizedBox(width: 20),
                    _buildStat(
                      'Mood Match',
                      '${(playlist.moodMatch * 100).round()}%',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    if (onBack != null)
                      TextButton.icon(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.spotifyGreen,
                        ),
                        label: const Text(
                          'Back',
                          style: TextStyle(
                            color: AppColors.spotifyGreen,
                            fontFamily: 'SF',
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (!isSaved && !isSaving && onSave != null)
                      ElevatedButton.icon(
                        onPressed: onSave,
                        icon: const Icon(Icons.save),
                        label: const Text('Save to Spotify'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.spotifyGreen,
                          foregroundColor: AppColors.spotifyWhite,
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
                            style: TextStyle(
                              color: AppColors.spotifyTextGrey,
                              fontFamily: 'SF',
                            ),
                          ),
                        ],
                      ),
                    if (isSaved)
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.spotifyGreen,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Saved!',
                            style: TextStyle(
                              color: AppColors.spotifyGreen,
                              fontFamily: 'SF',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Track List
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: AppColors.spotifyLightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.queue_music,
                        color: AppColors.spotifyGreen,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Track List',
                        style: TextStyle(
                          color: AppColors.spotifyWhite,
                          fontSize: 16,
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
                          '${playlist.allTracks.length}',
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
                Expanded(
                  child: ListView.builder(
                    itemCount: playlist.allTracks.length,
                    itemBuilder: (context, index) {
                      final track = playlist.allTracks[index];
                      final isDiscovered = playlist.discoveredTracks.contains(
                        track,
                      );

                      return ListTile(
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          track.artistName,
                          style: TextStyle(
                            color: AppColors.spotifyTextGrey,
                            fontSize: 12,
                            fontFamily: 'SF',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: isDiscovered
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.spotifyGreen.withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: AppColors.spotifyGreen,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF',
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.spotifyGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.spotifyTextGrey,
            fontSize: 12,
            fontFamily: 'SF',
          ),
        ),
      ],
    );
  }
}

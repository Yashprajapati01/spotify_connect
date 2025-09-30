import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../domain/entities/user_taste_profile.dart';

class MusicDNACard extends StatelessWidget {
  final UserTasteProfile tasteProfile;

  const MusicDNACard({super.key, required this.tasteProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1DB954), Color(0xFF1AA34A), Color(0xFF168B3A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.spotifyGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Music DNA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF',
                      ),
                    ),
                    Text(
                      'Based on your listening patterns',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'SF',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // DNA Strands (Audio Features)
          Row(
            children: [
              Expanded(
                child: _buildDNAStrand(
                  'Energy',
                  tasteProfile.averageEnergy,
                  Icons.flash_on,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDNAStrand(
                  'Dance',
                  tasteProfile.averageDanceability,
                  Icons.music_note,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDNAStrand(
                  'Mood',
                  tasteProfile.averageValence,
                  Icons.sentiment_satisfied,
                  Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDNAStrand(
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    // Ensure value is properly clamped between 0.0 and 1.0
    final clampedValue = value.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            height: 60,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: clampedValue,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(clampedValue * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF',
            ),
          ),
        ],
      ),
    );
  }
}

class AudioFeaturesAnalysis extends StatelessWidget {
  final UserTasteProfile tasteProfile;

  const AudioFeaturesAnalysis({super.key, required this.tasteProfile});

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
              const Icon(Icons.analytics, color: AppColors.spotifyGreen),
              const SizedBox(width: 8),
              const Text(
                'Audio Features Analysis',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Feature Bars
          _buildFeatureBar(
            'Energy Level',
            tasteProfile.averageEnergy,
            _getEnergyDescription(tasteProfile.averageEnergy),
          ),
          const SizedBox(height: 16),
          _buildFeatureBar(
            'Danceability',
            tasteProfile.averageDanceability,
            _getDanceabilityDescription(tasteProfile.averageDanceability),
          ),
          const SizedBox(height: 16),
          _buildFeatureBar(
            'Positivity',
            tasteProfile.averageValence,
            _getValenceDescription(tasteProfile.averageValence),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBar(String label, double value, String description) {
    // Ensure value is properly clamped between 0.0 and 1.0
    final clampedValue = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF',
                ),
              ),
            ),
            Text(
              '${(clampedValue * 100).round()}%',
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
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clampedValue,
            backgroundColor: AppColors.spotifyBlack,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getColorForValue(clampedValue),
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: AppColors.spotifyTextGrey,
            fontSize: 12,
            fontFamily: 'SF',
          ),
        ),
      ],
    );
  }

  Color _getColorForValue(double value) {
    if (value < 0.3) return Colors.blue;
    if (value < 0.7) return AppColors.spotifyGreen;
    return Colors.orange;
  }

  String _getEnergyDescription(double energy) {
    if (energy < 0.3) return 'You prefer calm, relaxed music';
    if (energy < 0.7) return 'You enjoy moderate energy levels';
    return 'You love high-energy, intense music';
  }

  String _getDanceabilityDescription(double danceability) {
    if (danceability < 0.3) return 'You prefer non-danceable music';
    if (danceability < 0.7) return 'You enjoy moderately danceable tracks';
    return 'You love music that makes you move';
  }

  String _getValenceDescription(double valence) {
    if (valence < 0.3) return 'You tend toward melancholic music';
    if (valence < 0.7) return 'You enjoy balanced emotional content';
    return 'You prefer upbeat, positive music';
  }
}

class GenrePreferencesCard extends StatelessWidget {
  final UserTasteProfile tasteProfile;

  const GenrePreferencesCard({super.key, required this.tasteProfile});

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
                'Your Genre Universe',
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

          if (tasteProfile.discoveredGenres.isNotEmpty) ...[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tasteProfile.discoveredGenres.take(8).map((genre) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.spotifyGreen.withOpacity(0.8),
                        AppColors.spotifyGreen.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    genre.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF',
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.spotifyBlack.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.spotifyTextGrey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add more playlists to discover your genre preferences',
                      style: TextStyle(
                        color: AppColors.spotifyTextGrey,
                        fontSize: 14,
                        fontFamily: 'SF',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ListeningInsightsCard extends StatelessWidget {
  final UserTasteProfile tasteProfile;

  const ListeningInsightsCard({super.key, required this.tasteProfile});

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
              const Icon(Icons.insights, color: AppColors.spotifyGreen),
              const SizedBox(width: 8),
              const Text(
                'Listening Insights',
                style: TextStyle(
                  color: AppColors.spotifyWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Insights Grid
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  'Music Diversity',
                  '${tasteProfile.discoveredGenres.length} genres',
                  Icons.diversity_3,
                  _getDiversityColor(tasteProfile.discoveredGenres.length),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  'Top Artists',
                  '${tasteProfile.topArtists.length} tracked',
                  Icons.star,
                  AppColors.spotifyGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Music Personality
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.spotifyGreen.withOpacity(0.1),
                  Colors.purple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Music Personality',
                  style: TextStyle(
                    color: AppColors.spotifyWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getMusicPersonality(tasteProfile),
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
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.spotifyBlack.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.spotifyTextGrey,
              fontSize: 12,
              fontFamily: 'SF',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getDiversityColor(int genreCount) {
    if (genreCount < 3) return Colors.orange;
    if (genreCount < 6) return AppColors.spotifyGreen;
    return Colors.purple;
  }

  String _getMusicPersonality(UserTasteProfile profile) {
    final energy = profile.averageEnergy;
    final valence = profile.averageValence;
    final danceability = profile.averageDanceability;

    if (energy > 0.7 && valence > 0.7) {
      return 'The Energizer - You love upbeat, high-energy music that gets you moving!';
    } else if (energy < 0.3 && valence < 0.5) {
      return 'The Contemplator - You prefer calm, introspective music for deep thinking.';
    } else if (danceability > 0.7) {
      return 'The Dancer - Music is your rhythm, and you can\'t help but move to the beat!';
    } else if (valence > 0.7) {
      return 'The Optimist - You gravitate toward positive, uplifting music that brightens your day.';
    } else if (energy > 0.5 && valence < 0.5) {
      return 'The Intensity Seeker - You enjoy powerful music with emotional depth.';
    } else {
      return 'The Balanced Listener - You appreciate a diverse range of musical moods and styles.';
    }
  }
}

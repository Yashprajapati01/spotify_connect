import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_taste_profile.dart';

@injectable
class TasteProfileCacheService {
  final FlutterSecureStorage _storage;

  static const String _cacheKey = 'taste_profile_cache';
  static const String _cacheTimestampKey = 'taste_profile_cache_timestamp';
  static const Duration _cacheExpiry = Duration(days: 7); // Cache for 1 week

  TasteProfileCacheService(this._storage);

  Future<UserTasteProfile?> getCachedProfile() async {
    try {
      final timestampStr = await _storage.read(key: _cacheTimestampKey);
      if (timestampStr == null) return null;

      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();

      // Check if cache has expired
      if (now.difference(timestamp) > _cacheExpiry) {
        await clearCache();
        return null;
      }

      final cachedData = await _storage.read(key: _cacheKey);
      if (cachedData == null) return null;

      final Map<String, dynamic> json = jsonDecode(cachedData);
      return _fromJson(json);
    } catch (e) {
      print('Error reading cached taste profile: $e');
      return null;
    }
  }

  Future<void> cacheProfile(UserTasteProfile profile) async {
    try {
      final json = _toJson(profile);
      final jsonString = jsonEncode(json);

      await _storage.write(key: _cacheKey, value: jsonString);
      await _storage.write(
        key: _cacheTimestampKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('Error caching taste profile: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _storage.delete(key: _cacheKey);
      await _storage.delete(key: _cacheTimestampKey);
    } catch (e) {
      print('Error clearing taste profile cache: $e');
    }
  }

  Future<bool> isCacheValid() async {
    try {
      final timestampStr = await _storage.read(key: _cacheTimestampKey);
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();

      return now.difference(timestamp) <= _cacheExpiry;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> _toJson(UserTasteProfile profile) {
    return {
      'genrePreferences': profile.genrePreferences,
      'audioFeatures': profile.audioFeatures,
      'topArtists': profile.topArtists,
      'recentlyPlayed': profile.recentlyPlayed,
      'listeningPatterns': profile.listeningPatterns,
      'averageEnergy': profile.averageEnergy,
      'averageDanceability': profile.averageDanceability,
      'averageValence': profile.averageValence,
      'discoveredGenres': profile.discoveredGenres,
    };
  }

  UserTasteProfile _fromJson(Map<String, dynamic> json) {
    return UserTasteProfile(
      genrePreferences: Map<String, double>.from(
        json['genrePreferences'] ?? {},
      ),
      audioFeatures: Map<String, double>.from(json['audioFeatures'] ?? {}),
      topArtists: List<String>.from(json['topArtists'] ?? []),
      recentlyPlayed: List<String>.from(json['recentlyPlayed'] ?? []),
      listeningPatterns: Map<String, int>.from(json['listeningPatterns'] ?? {}),
      averageEnergy: (json['averageEnergy'] ?? 0.5).toDouble(),
      averageDanceability: (json['averageDanceability'] ?? 0.5).toDouble(),
      averageValence: (json['averageValence'] ?? 0.5).toDouble(),
      discoveredGenres: List<String>.from(json['discoveredGenres'] ?? []),
    );
  }
}

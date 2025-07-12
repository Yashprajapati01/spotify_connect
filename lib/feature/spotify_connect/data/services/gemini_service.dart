// data/services/gemini_service.dart
import 'dart:convert';
import 'package:connectspotify/feature/secrets.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/track.dart';

abstract class GeminiService {
  Future<List<Track>> generatePlaylistFromTracks(
      List<Track> availableTracks,
      String mood,
      int maxTracks,
      );
}

@LazySingleton(as: GeminiService)
class GeminiServiceImpl implements GeminiService {
  final Dio dio;
  static final String _apiKey = Secrets.geminiKey;
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  GeminiServiceImpl(this.dio);

  @override
  Future<List<Track>> generatePlaylistFromTracks(
      List<Track> availableTracks,
      String mood,
      int maxTracks,
      ) async {
    try {
      final prompt = _buildPrompt(availableTracks, mood, maxTracks);

      final response = await dio.post(
        '$_baseUrl?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 8192,
          }
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final responseText = response.data['candidates'][0]['content']['parts'][0]['text'];
      return _parseGeminiResponse(responseText, availableTracks);
    } catch (e) {
      print('❌ Gemini API error: $e');
      throw Exception('Failed to generate playlist: ${e.toString()}');
    }
  }

  String _buildPrompt(List<Track> tracks, String mood, int maxTracks) {
    final trackList = tracks.map((track) =>
    '${track.id}: "${track.name}" by ${track.artistName} (Album: ${track.albumName}, Popularity: ${track.popularity})'
    ).join('\n');

    return '''
You are a music curator AI. I will provide you with a list of songs and a mood. Your task is to select the best songs from the given list that match the specified mood.

MOOD: $mood

AVAILABLE SONGS:
$trackList

INSTRUCTIONS:
1. Analyze each song based on its title, artist, and album to determine if it matches the mood "$mood"
2. Select up to $maxTracks songs that best fit this mood
3. Consider factors like:
   - Song title sentiment and keywords
   - Artist style and genre associations
   - Album context
   - Popularity (higher is generally better)
4. Prioritize songs that most closely match the mood
5. Ensure variety in artists when possible
6. Return ONLY the track IDs of selected songs, one per line
7. Do not include any explanations or additional text

IMPORTANT: Your response must contain ONLY track IDs (like "4iV5W9uYEdYUVa79Axb7Rh"), one per line, with no other text or formatting.

Example response format:
4iV5W9uYEdYUVa79Axb7Rh
1A2B3C4D5E6F7G8H9I0J1K
9Z8Y7X6W5V4U3T2S1R0Q9P
''';
  }

  List<Track> _parseGeminiResponse(String responseText, List<Track> availableTracks) {
    try {
      final lines = responseText.trim().split('\n');
      final selectedTracks = <Track>[];

      // Create a map for quick lookup
      final trackMap = {for (var track in availableTracks) track.id: track};

      for (final line in lines) {
        final trackId = line.trim();
        if (trackId.isNotEmpty && trackMap.containsKey(trackId)) {
          selectedTracks.add(trackMap[trackId]!);
        }
      }

      print('✅ Selected ${selectedTracks.length} tracks from Gemini response');
      return selectedTracks;
    } catch (e) {
      print('❌ Error parsing Gemini response: $e');
      print('Response text: $responseText');
      throw Exception('Failed to parse AI response');
    }
  }
}
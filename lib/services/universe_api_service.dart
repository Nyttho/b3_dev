// lib/services/universe_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:b3_dev/models/universe.dart';

class UniverseApiService {
  static const String baseUrl = 'https://yodai.wevox.cloud';

  Future<List<Universe>> getUniverses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/universe'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Universe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load universes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching universes: $e');
    }
  }
}
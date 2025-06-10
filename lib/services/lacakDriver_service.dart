import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lacakDriver_model.dart';

class LocationService {
  static Future<List<Location>> fetchLocation() async {
    final response = await http.get(
      Uri.parse('https://localhost:7079/api/LacakDriver'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // Cek apakah response kamu bentuknya langsung objek (1 lokasi)
      if (decoded is Map<String, dynamic>) {
        return [Location.fromJson(decoded)];
      }

      // Kalau ternyata list (misal kamu ubah endpoint ke banyak data)
      if (decoded is List) {
        return decoded.map((json) => Location.fromJson(json)).toList();
      }

      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load location');
    }
  }
}

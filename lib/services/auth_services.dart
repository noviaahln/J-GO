import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:j_go/models/auth.dart';

class ProfilService {
  // Fungsi fetch pengguna berdasarkan id
  static Future<Auth> fetchPenggunaById(int id) async {
    final response = await http.get(
      Uri.parse('https://localhost:7079/api/Pengguna/$id'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return Auth.fromJson(decoded);
    } else {
      throw Exception('Failed to load user with id $id');
    }
  }
}

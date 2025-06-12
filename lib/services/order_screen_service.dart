import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/order_screen_model.dart';

class OrderScreenService {
  // ✅ Simplified base URL - hanya HTTP untuk web
  static String get baseUrl => 'http://localhost:7080/api/Order';
  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ✅ Debug method untuk test koneksi
  static Future<void> debugConnection() async {
    print('=== DEBUG CONNECTION ===');
    print('Flutter web running on: ${Uri.base}');
    print('API URL: $baseUrl');
    print('Headers: $headers');
    
    try {
      print('🔗 Testing GET connection...');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      
      print('✅ GET Response Status: ${response.statusCode}');
      print('✅ GET Response Body: ${response.body}');
    } catch (e) {
      print('❌ GET Connection failed: $e');
      print('❌ Error type: ${e.runtimeType}');
    }
  }
  
  // Create new order dengan extensive debugging
  static Future<OrderScreenModel> createOrder(OrderScreenModel order) async {
    try {
      // Debug connection first
      await debugConnection();
      
      final orderData = order.toJsonWithoutId();
      print('=== CREATING ORDER ===');
      print('🚀 Order data: ${jsonEncode(orderData)}');
      print('📡 POST URL: $baseUrl');
      print('📡 Headers: $headers');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(orderData),
      ).timeout(const Duration(seconds: 30));
      
      print('📊 POST Response Status: ${response.statusCode}');
      print('📄 POST Response Headers: ${response.headers}');
      print('📄 POST Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ Order berhasil dibuat!');
        return OrderScreenModel.fromJson(responseData);
      } else {
        print('❌ HTTP Error ${response.statusCode}: ${response.body}');
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ ClientException: $e');
      throw Exception('Koneksi gagal: $e');
    } catch (e) {
      print('❌ General Error: $e');
      print('❌ Error type: ${e.runtimeType}');
      throw Exception('Error: $e');
    }
  }

  // Simplified fetch orders
  static Future<List<OrderScreenModel>> fetchOrders() async {
    try {
      print('📡 Fetching orders from: $baseUrl');
      
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      
      print('📊 GET Orders Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OrderScreenModel.fromJson(json)).toList();
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Fetch orders error: $e');
      throw Exception('Error: $e');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://uat.api.accelgrowth.in/api/authentication";

  /// LOGIN
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String ipAddress,
    required double latitude,
    required double longitude,
    required String platform,
    required String userAgent,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "ipAddress": ipAddress,
        "latitude": latitude,
        "longitude": longitude,
        "platform": platform,
        "userAgent": userAgent,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // token + user
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "authorization": "Bearer $token",
        "token": "JWT $token",
        "timezone": "Asia/Calcutta",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch profile: ${response.body}");
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _baseUrl = "https://uat.api.accelgrowth.in/api";
  static const _storage = FlutterSecureStorage();

  /// Login API
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl/auth/login");

    final body = jsonEncode({
      "username":"admin@accelgrowthtech.com",
      "password": "Sk@7057250694",
      "latitude": "19.1823872",
      "longitude": "77.3193728",
      "platform": "web",
      "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
    });

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["data"]["accessToken"];

      // Save token securely
      await _storage.write(key: "token", value: token);
      return true;
    } else {
      print("❌ Login failed: ${response.body}");
      return false;
    }
  }

  /// Fetch profile using authenticated token
  static Future<Map<String, dynamic>?> getProfile() async {
    final token = await _storage.read(key: "token");
    if (token == null) return null;

    final url = Uri.parse("$_baseUrl/authentication");

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "authorization": "Bearer JWT $token",
      "token": "JWT $token",
      "timezone": "Asia/Calcutta",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Profile fetch failed: ${response.body}");
      return null;
    }
  }
}

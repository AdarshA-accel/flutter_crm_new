import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';

class UserProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  final String _baseUrl = "https://uat.api.accelgrowth.in/api";

  UserModel? _user;
  DateTime? _clockInTime;
  DateTime? _clockOutTime;
  Duration? _workedDuration;
  String? _token;
  Position? _currentPosition;

  int _totalLeaves = 0;
  int _takenLeaves = 0;
  List<Map<String, dynamic>> _leaveHistory = [];

  // ---------- GETTERS ----------
  UserModel? get user => _user;
  String get userName => _user?.fullName ?? "Your Name";
  String get profileImageUrl => _user?.profileImage ?? "";
  String get userDesignation => _user?.designation ?? "";

  DateTime? get clockInTime => _clockInTime;
  DateTime? get clockOutTime => _clockOutTime;
  Duration? get workedDuration => _workedDuration;

  String? get token => _token;
  Position? get currentPosition => _currentPosition;

  bool get isLoggedIn => _token != null;

  int get totalLeaves => _totalLeaves;
  int get takenLeaves => _takenLeaves;
  double get leaveBalancePercent =>
      _totalLeaves > 0 ? (1 - (_takenLeaves / _totalLeaves)) : 1.0;

  List<Map<String, dynamic>> get leaveHistory => _leaveHistory;

  // ---------- TOKEN & USER PERSIST ----------
  Future<void> persistToken(String token) async {
    // Always store with "JWT " prefix
    if (!token.startsWith("JWT ")) {
      token = "JWT $token";
    }
    await _storage.write(key: "auth_token", value: token);
    _token = token;
    notifyListeners();
  }

  Future<void> loadToken() async {
    _token = await _storage.read(key: "auth_token");
    notifyListeners();
  }

  Future<void> persistUserModel(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_data", jsonEncode(userModel.toJson()));
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user_data");
    if (userJson != null) {
      final Map<String, dynamic> map = jsonDecode(userJson);
      _user = UserModel.fromJson(map);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: "auth_token");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_data");
    reset();
  }

  // ---------- AUTH HEADERS ----------
  Map<String, String> authHeaders() {
    if (_token == null) return {};
    return {
      "authorization": "Bearer $_token",
      "token": _token!,
      "Accept": "application/json",
      "Content-Type": "application/json",
      "timezone": "Asia/Calcutta",
    };
  }

  // ---------- LOCATION ----------
  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return;

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    } catch (e) {
      debugPrint("fetchLocation error: $e");
    }
  }

  // ---------- AUTH (LOGIN) ----------
  Future<bool> login({
    required String username,
    required String password,
    String ipAddress = "223.181.9.186",
    double latitude = 19.1823872,
    double longitude = 77.3193728,
    String platform = "web",
    String userAgent =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
  }) async {
    try {
      await fetchLocation();

      final body = {
        "username": username,
        "password": password,
        "ipAddress": ipAddress,
        "latitude": _currentPosition?.latitude ?? latitude,
        "longitude": _currentPosition?.longitude ?? longitude,
        "platform": platform,
        "userAgent": userAgent,
      };

      final res = await http.post(
        Uri.parse("$_baseUrl/authentication/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        debugPrint("Login API raw response: ${res.body}");

        String? token;
        if (data is Map<String, dynamic>) {
          if (data['data'] is Map<String, dynamic>) {
            final inner = data['data'] as Map<String, dynamic>;
            token = inner['accessToken']; 
          }
          token ??= data['token'] ??
              data['accessToken'] ??
              data['jwt'] ??
              data['authToken'];
        }

        debugPrint("Extracted token: $token");

        if (token != null) {
          await persistToken(token);
          final sessionValid = await authenticateSession();
          if (!sessionValid) return false;
        } else {
          debugPrint("No token found in response");
          return false;
        }

        notifyListeners();
        return true;
      } else {
        debugPrint("Login failed: ${res.statusCode} ${res.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  // ---------- SESSION AUTHENTICATION ----------
  Future<bool> authenticateSession() async {
    if (_token == null) return false;
    try {
      final url = Uri.parse("$_baseUrl/authentication");
      final response = await http.get(url, headers: authHeaders());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        Map<String, dynamic> userJson;
        if (data['user'] != null && data['user'] is Map) {
          userJson = Map<String, dynamic>.from(data['user']);
        } else if (data['data'] != null && data['data'] is Map) {
          userJson = Map<String, dynamic>.from(data['data']);
        } else {
          userJson = Map<String, dynamic>.from(data);
        }

        _user = UserModel.fromJson(userJson);
        await persistUserModel(_user!);
        notifyListeners();
        return true;
      } else {
        debugPrint("Session invalid: ${response.statusCode} ${response.body}");
        await logout();
        return false;
      }
    } catch (e) {
      debugPrint("authenticateSession error: $e");
      await logout();
      return false;
    }
  }

  // ---------- LEAVE APPLY ----------
  Future<Map<String, dynamic>> applyLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    String reason = "",
  }) async {
    if (_token == null) {
      return {"success": false, "message": "No auth token found"};
    }
    try {
      final df = DateFormat("yyyy-MM-dd");

      final response = await http.post(
        Uri.parse("$_baseUrl/leave/apply"),
        headers: authHeaders(),
        body: json.encode({
          "startDate": df.format(startDate),
          "endDate": df.format(endDate),
          "leaveType": type,
          "description": reason,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchLeaveHistory();
        notifyListeners();
        return {"success": true, "message": data["message"] ?? "Leave applied"};
      } else {
        debugPrint("applyLeave failed: ${response.statusCode} ${response.body}");
        return {
          "success": false,
          "message": data["message"] ?? "Failed with ${response.statusCode}"
        };
      }
    } catch (e) {
      debugPrint("applyLeave error: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ---------- LEAVE MANAGEMENT ----------
  Future<void> fetchLeaveBalance() async {
    if (_token == null) return;
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/leave/balance"),
        headers: authHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _totalLeaves = data['totalLeaves'] ?? 0;
        _takenLeaves = data['takenLeaves'] ?? 0;
        notifyListeners();
      } else {
        debugPrint("fetchLeaveBalance failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching leave balance: $e");
    }
  }

  Future<void> fetchLeaveHistory() async {
    if (_token == null) return;
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/leave/history"),
        headers: authHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          _leaveHistory = List<Map<String, dynamic>>.from(data);
          notifyListeners();
        }
      } else {
        debugPrint("fetchLeaveHistory failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching leave history: $e");
    }
  }

  // ---------- CLOCK IN / OUT ----------
  Future<void> syncClockIn(DateTime time) async {
    try {
      await fetchLocation();
      final response = await http.post(
        Uri.parse("$_baseUrl/user/clockin"),
        headers: authHeaders(),
        body: json.encode({
          "clockInTime": time.toIso8601String(),
          "latitude": _currentPosition?.latitude,
          "longitude": _currentPosition?.longitude,
        }),
      );

      if (response.statusCode == 200) {
        setClockInTime(time);
      } else {
        debugPrint("syncClockIn failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      debugPrint("Error clocking in: $e");
      setClockInTime(time);
    }
  }

  Future<void> syncClockOut(DateTime time) async {
    try {
      await fetchLocation();
      final response = await http.post(
        Uri.parse("$_baseUrl/user/clockout"),
        headers: authHeaders(),
        body: json.encode({
          "clockOutTime": time.toIso8601String(),
          "latitude": _currentPosition?.latitude,
          "longitude": _currentPosition?.longitude,
        }),
      );

      if (response.statusCode == 200) {
        setClockOutTime(time);
      } else {
        debugPrint("syncClockOut failed: ${response.statusCode} ${response.body}");
        setClockOutTime(time);
      }
    } catch (e) {
      debugPrint("Error clocking out: $e");
      setClockOutTime(time);
    }
  }

  // ---------- LOCAL CLOCK HELPERS ----------
  void setClockInTime(DateTime time) {
    _clockInTime = time;
    _clockOutTime = null;
    _workedDuration = null;
    notifyListeners();
  }

  void setClockOutTime(DateTime time) {
    _clockOutTime = time;
    if (_clockInTime != null) {
      _workedDuration = _clockOutTime!.difference(_clockInTime!);
    }
    notifyListeners();
  }

  void resetClockData() {
    _clockInTime = null;
    _clockOutTime = null;
    _workedDuration = null;
    notifyListeners();
  }

  // ---------- UPDATE USER LOCALLY ----------
  void updateUserFromMap(Map<String, dynamic> updatedUser) {
    try {
      final merged = {
        ...(_user?.toJson() ?? {}),
        ...updatedUser,
      };
      _user = UserModel.fromJson(merged);
      persistUserModel(_user!);
      notifyListeners();
    } catch (e) {
      debugPrint("updateUserFromMap error: $e");
    }
  }

  void reset() {
    _user = null;
    resetClockData();
    notifyListeners();
  }
}

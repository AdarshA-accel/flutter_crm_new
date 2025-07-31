import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String profileImagePath;
  final String designation;

  UserModel({
    required this.name,
    required this.profileImagePath,
    required this.designation,
  });
}

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    name: 'Your Name',
    profileImagePath: '',
    designation: 'Your Designation',
  );

  DateTime? _clockInTime;
  DateTime? _clockOutTime;
  Duration? _workedDuration;

  // ---------- GETTERS ----------
  UserModel get user => _user;
  String get userName => _user.name;
  String get profileImageUrl => _user.profileImagePath;
  String get userDesignation => _user.designation;

  DateTime? get clockInTime => _clockInTime;
  DateTime? get clockOutTime => _clockOutTime;
  Duration? get workedDuration => _workedDuration;

  // ---------- SETTERS ----------
  void setUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

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

  void setWorkedDuration(Duration duration) {
    _workedDuration = duration;
    notifyListeners();
  }

  void resetClockData() {
    _clockInTime = null;
    _clockOutTime = null;
    _workedDuration = null;
    notifyListeners();
  }

  void reset() {
    _user = UserModel(
      name: 'Your Name',
      profileImagePath: '',
      designation: 'Your Designation',
    );
    resetClockData();
    notifyListeners();
  }
}

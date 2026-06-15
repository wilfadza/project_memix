import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  String _avatarPath = "assets/avatars/avatar_default.png";
  String _userName = "Willyam";
  String _userBio = "Pencinta Musik Sejati";

  String get avatarPath => _avatarPath;
  String get userName => _userName;
  String get userBio => _userBio;

  UserController() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _avatarPath = prefs.getString('avatarPath') ?? "assets/avatars/avatar_default.png";
    _userName = prefs.getString('userName') ?? "Willyam";
    _userBio = prefs.getString('userBio') ?? "Pencinta Musik Sejati";
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String bio,
    required String avatarPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userBio', bio);
    await prefs.setString('avatarPath', avatarPath);

    _userName = name;
    _userBio = bio;
    _avatarPath = avatarPath;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadProfile();
  }
}
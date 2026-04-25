import 'dart:convert';

import 'package:datav8/features/auth/data/model/user_data_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  AuthStorage(this._prefs, this._secureStorage);

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  static const _kUserJson = 'user_data_json';
  static const _kEmail = 'saved_login_email';
  static const _kPassword = 'saved_login_password';

  Future<void> saveUser(UserDataModel user) async {
    await _prefs.setString(_kUserJson, jsonEncode(user.toJson()));
  }

  UserDataModel? readUser() {
    final raw = _prefs.getString(_kUserJson);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return UserDataModel.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _prefs.remove(_kUserJson);
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _secureStorage.write(key: _kEmail, value: email);
    await _secureStorage.write(key: _kPassword, value: password);
  }

  Future<({String email, String password})?> readCredentials() async {
    final email = await _secureStorage.read(key: _kEmail);
    final password = await _secureStorage.read(key: _kPassword);
    if (email == null || email.isEmpty || password == null || password.isEmpty) {
      return null;
    }
    return (email: email, password: password);
  }

  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _kEmail);
    await _secureStorage.delete(key: _kPassword);
  }
}

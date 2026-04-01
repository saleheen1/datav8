import 'dart:convert';

import 'package:datav8/features/auth/data/model/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  AuthStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kUserJson = 'user_data_json';

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
}

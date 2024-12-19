import 'package:shared_preferences/shared_preferences.dart';

import '../dynamic/dtos/responses/login_response.dart';

class SharedPref {
  // INT
  saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  readInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // BOOLEAN
  readBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // DOUBLE
  readDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  // STRING
  readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // REMOVE
  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  initializeVariables() async {
    dynamic isLogin = await readBool("isLogin");
    dynamic roleId = await readInt("roleId");
    dynamic associateId = await readInt("associateId");
    dynamic userId = await readInt("userId");

    if (isLogin == null) {
      await saveBool("isLogin", false);
    }
    if (roleId == null) {
      await saveInt("roleId", 0);
    }
    if (associateId == null) {
      await saveInt("associateId", 0);
    }
    if (userId == null) {
      await saveInt("userId", 0);
    }
  }

  savingFieldsDuringLogin(LoginResponse? response) async {
    await saveInt("roleId", response!.roleId);
    await saveInt("associateId", response.associateId);
    await saveInt("userId", response.userId);
    await saveBool("isLogin", true);
  }
}

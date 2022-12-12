import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  static initSP() async {
    print('initialize pref');
    prefs = await SharedPreferences.getInstance();
  }

  static save(String key, String value) async {
    await prefs?.setString(key, value);
  }

  static get(String key)  {
    return prefs?.get(key);
  }

  static remove(String key) {
    prefs?.remove(key);
  }


  static savebool(String key, bool value) async {
    await prefs?.setBool(key, value);
  }

  static getbool(String key) {
    return prefs?.getBool(key);
  }

}
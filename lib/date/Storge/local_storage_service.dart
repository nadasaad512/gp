import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveUserData({
    required String uid,
    required String name,
    required String phone,
    required String city,
    required String area,
    required String type,
  }) async {
    print('Saving uid: $uid');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('name', name);
    await prefs.setString('phone', phone);
    await prefs.setString('city', city);
    await prefs.setString('area', area);
    await prefs.setString('type', type);
  }

  static Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'uid': prefs.getString('uid'),
      'name': prefs.getString('name'),
      'phone': prefs.getString('phone'),
      'city': prefs.getString('city'),
      'type': prefs.getString('type'),
    };
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('name');
    await prefs.remove('phone');
    await prefs.remove('city');
    await prefs.remove('type');
  }
}

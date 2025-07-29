import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _username;
  String? _fullName;
  String? _role;
  String? _phoneNumber;
  String? _userId;

  // Getterlar
  String? get username => _username;
  String? get fullName => _fullName;
  String? get role => _role;
  String? get phoneNumber => _phoneNumber;
  String? get userId => _userId;

  // ✅ int dönüşümü: Hatalıysa 0 döner
  int get userIdAsInt => int.tryParse(_userId ?? '') ?? 0;

  // 📥 SharedPreferences’ten verileri yükler
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _fullName = prefs.getString('FullName'); // Key büyük harfle
    _role = prefs.getString('role');
    _phoneNumber = prefs.getString('PhoneNumber'); // Key büyük harfle
    _userId = prefs.getString('userId');

    print("👤 Yüklenen userId: $_userId");

    notifyListeners();
  }

  // 🔄 Oturum verilerini temizler
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    await prefs.remove('username');
    await prefs.remove('FullName');
    await prefs.remove('role');
    await prefs.remove('PhoneNumber');
    await prefs.remove('userId');

    _username = null;
    _fullName = null;
    _role = null;
    _phoneNumber = null;
    _userId = null;

    notifyListeners();
  }
}

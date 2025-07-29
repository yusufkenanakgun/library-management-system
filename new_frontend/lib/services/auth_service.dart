import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user_login_dto.dart';
import '../models/user_register_dto.dart';
import '../constants/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = ApiConfig.authBaseUrl;

  static Future<bool> login(UserLoginDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();

      final token = data['token'];
      await prefs.setString('jwt', token);

      final decoded = JwtDecoder.decode(token);

      final username = decoded['sub'];
      final role =
          decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      final fullName = decoded['FullName'];
      final phoneNumber = decoded['PhoneNumber'];
      final userId =
          decoded['sub']; // ✅ Kullanıcı ID burada tutuluyor (aynı zamanda username)

      if (username != null) await prefs.setString('username', username);
      if (role != null) await prefs.setString('role', role);
      if (fullName != null) await prefs.setString('FullName', fullName);
      if (phoneNumber != null)
        await prefs.setString('PhoneNumber', phoneNumber);
      if (userId != null)
        await prefs.setString('userId', userId); // ✅ BURASI EKLENDİ

      print("✅ Kullanıcı bilgileri kaydedildi. userId = $userId");

      return true;
    }

    return false;
  }

  static Future<bool> register(UserRegisterDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    return response.statusCode == 200;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Tüm bilgileri temizle
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  static Future<bool> deleteUser(String username) async {
    final token = await getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$username'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<List<User>> getAllUsers() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Kullanıcılar alınamadı: ${response.statusCode}");
    }
  }
}

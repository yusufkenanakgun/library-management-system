import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';
import '../models/notification_model.dart';

class NotificationService {
  static const String baseUrl = ApiConfig.notificationBaseUrl;

  static Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  /// 🔔 Kullanıcının tüm bildirimlerini getir
  static Future<List<NotificationItem>> fetchUserNotifications() async {
    final username = await _getUsername();
    if (username == null) throw Exception("Kullanıcı oturumu yok.");

    final response = await http.get(Uri.parse('$baseUrl/$username'));

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception("Bildirimler alınamadı (${response.statusCode})");
    }
  }
}

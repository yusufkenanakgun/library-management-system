// ✅ FINAL: reservation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reservation_model.dart';
import '../constants/api_config.dart';

class ReservationService {
  static const String baseUrl = ApiConfig.reservationBaseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  /// 📥 Tüm rezervasyonları getir (admin veya genel amaçlı)
  static Future<List<Reservation>> fetchReservations() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Reservation.fromJson(e)).toList();
    } else {
      throw Exception('Rezervasyonları çekme hatası: ${response.statusCode}');
    }
  }

  /// ➕ Yeni rezervasyon ekle
  static Future<void> reserveBook(Reservation reservation) async {
    final token = await _getToken();
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Rezervasyon başarısız: ${response.statusCode}');
    }
  }

  /// ❌ Rezervasyon iptal et
  static Future<void> cancelReservation(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/$id');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Rezervasyon iptal hatası: ${response.statusCode}');
    }
  }

  /// 📆 ETA (tahmini bekleme süresi) getir (gün cinsinden)
  static Future<int> fetchEta(String username) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/user/$username/eta');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return int.tryParse(response.body) ?? 0;
    } else {
      throw Exception('ETA çekme hatası: ${response.statusCode}');
    }
  }

  /// 📦 Kullanıcının tüm rezervasyonlarını ve ETA'ları getir
  static Future<List<ReservationWithEta>> fetchReservationsWithEta(
    String username,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/user/$username/with-eta');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ReservationWithEta.fromJson(e)).toList();
    } else {
      throw Exception('Rezervasyon + ETA çekme hatası: ${response.statusCode}');
    }
  }
}

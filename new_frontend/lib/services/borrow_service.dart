import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/borrow_model.dart';
import '../constants/api_config.dart';

class BorrowService {
  static const String baseUrl = ApiConfig.borrowBaseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  /// 🔍 Tüm borçları getir (admin)
  static Future<List<Borrow>> fetchAllBorrows() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Borrow.fromJson(e)).toList();
    } else {
      throw Exception('Tüm borrows verisi alınamadı: ${response.statusCode}');
    }
  }

  /// 🔍 Kullanıcının tüm borçlarını getir (iade edilmiş + edilmemiş)
  static Future<List<Borrow>> fetchUserBorrows(String username) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/$username'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Borrow.fromJson(e)).toList();
    } else {
      throw Exception(
        'Kullanıcının borrow verisi alınamadı: ${response.statusCode}',
      );
    }
  }

  /// ✅ Kitap ödünç al
  static Future<void> borrowBook(Borrow borrow) async {
    final token = await _getToken();

    final borrowDate = DateTime(
      borrow.borrowDate.year,
      borrow.borrowDate.month,
      borrow.borrowDate.day,
    );

    final expectedReturnDate = borrowDate.add(
      Duration(days: borrow.borrowDurationInWeeks * 7),
    );

    final borrowData = borrow.copyWith(
      borrowDate: borrowDate,
      expectedReturnDate: expectedReturnDate,
    );

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(borrowData.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Kitap ödünç alma başarısız: ${response.statusCode}');
    }
  }

  /// 🔁 Kitap iade et
  static Future<void> returnBook(int borrowId) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/$borrowId/return'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📦 Return status: ${response.statusCode}');
    if (response.statusCode != 204) {
      throw Exception('Kitap iade hatası: ${response.statusCode}');
    }
  }
}

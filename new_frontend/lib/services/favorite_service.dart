import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_model.dart';
import '../constants/api_config.dart';

class FavoriteService {
  static const String baseUrl = ApiConfig.favoriteBaseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  static Future<List<Favorite>> fetchAllFavorites() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl'); // Tüm favoriler

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Favorite.fromJson(e)).toList();
    } else {
      throw Exception("Tüm favoriler alınamadı: ${response.statusCode}");
    }
  }

  static Future<List<Favorite>> fetchFavorites(String username) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/user/$username');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Favorite.fromJson(e)).toList();
    } else {
      throw Exception(
        'Kullanıcının favorileri alınamadı: ${response.statusCode}',
      );
    }
  }

  static Future<void> addFavorite(
    String bookId,
    String username,
    String fullName,
  ) async {
    final token = await _getToken();
    final url = Uri.parse(baseUrl);

    final isAlreadyFavorite = await isFavorite(bookId);
    if (isAlreadyFavorite) {
      print('⚠️ Kitap zaten favorilerde.');
      return;
    }

    // userId'yi username üzerinden üret
    int? userId;
    try {
      userId = int.parse(username);
    } catch (_) {
      print("❌ Username sayıya çevrilemedi, userId atanamadı");
    }

    final body = jsonEncode({
      'bookId': bookId,
      'username': username,
      'fullName': fullName,
      'userId': userId ?? 0, // null olursa 0 gönder
    });

    print("📤 Favori POST verisi: $body");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Favori eklenemedi. Hata: ${response.statusCode}');
    }
  }

  static Future<void> removeFavorite(String bookId) async {
    final token = await _getToken();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) throw Exception("Kullanıcı oturumu yok.");

    final favorites = await fetchFavorites(username);
    final favorite = favorites.firstWhere(
      (f) => f.bookId == bookId,
      orElse: () => throw Exception('Favori bulunamadı.'),
    );

    final url = Uri.parse('$baseUrl/${favorite.id}');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Favori silinemedi. Hata: ${response.statusCode}');
    }
  }

  static Future<bool> isFavorite(String bookId) async {
    final token = await _getToken();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) throw Exception("Kullanıcı oturumu yok.");

    final url = Uri.parse('$baseUrl/user/$username');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.any((e) => e['bookId'] == bookId);
    } else {
      throw Exception('Favori kontrolü başarısız: ${response.statusCode}');
    }
  }
}

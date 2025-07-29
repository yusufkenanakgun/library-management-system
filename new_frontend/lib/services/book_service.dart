import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';
import '../constants/api_config.dart';

class BookService {
  static const String baseUrl = ApiConfig.bookBaseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  // 📚 Tüm kitapları getir
  static Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print("🔍 BookService Response: ${response.statusCode}");
      print("📦 BookService Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception(
          'Kitapları çekemedik. Hata kodu: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Kitapları çekme hatası: $e');
    }
  }

  // ✅ Yeni kitap ekle
  static Future<bool> addBook(Book book) async {
    final token = await _getToken();
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": book.title,
          "author": book.author,
          "description": book.description,
          "isAvailable": book.isAvailable,
          "image": book.image,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Kitap ekleme hatası: $e');
    }
  }

  // 🗑 Kitap sil
  static Future<void> deleteBook(String id) async {
    final token = await _getToken();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Kitap silinemedi. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kitap silme hatası: $e');
    }
  }

  // 📘 Kitap detayını ID ile getir
  static Future<Book> getBookById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Book.fromJson(data);
    } else {
      throw Exception('Kitap bulunamadı. Hata kodu: ${response.statusCode}');
    }
  }

  // ✏️ Kitap güncelle
  static Future<void> updateBook(Book book) async {
    final token = await _getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${book.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": book.title,
          "author": book.author,
          "description": book.description,
          "isAvailable": book.isAvailable,
          "image": book.image,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Kitap güncellenemedi. Hata kodu: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Kitap güncelleme hatası: $e');
    }
  }

  // 🔮 Önerilen kitapları getir
  static Future<List<Book>> fetchRecommendedBooks(int userId) async {
    final url = Uri.parse(
      'http://34.38.21.220:8085/recommendations/$userId',
    ); // istersen ApiConfig'e taşı
    final response = await http.get(url);

    print('🔄 fetchRecommendedBooks çağrıldı: userId = $userId');
    print('📦 Gelen JSON: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data.map((bookJson) => Book.fromJson(bookJson)).toList();
      } else {
        print("❌ Beklenen liste yerine hata döndü: $data");
        return [];
      }
    } else {
      throw Exception('Önerilen kitaplar alınamadı: ${response.statusCode}');
    }
  }
}

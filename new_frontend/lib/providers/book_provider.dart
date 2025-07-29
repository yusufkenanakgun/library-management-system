// ✅ FINAL: book_provider.dart with `getBookById` method
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _recommendedBooks = []; // 🔁 EKLENDİ

  List<Book> get books => _books;
  List<Book> get recommendedBooks => _recommendedBooks; // 🔁 EKLENDİ

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 📚 Kitapları getir
  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _books = await BookService.fetchBooks();
      print("📚 Kitaplar yüklendi: ${_books.length} kitap");
    } catch (e) {
      print('Kitapları çekerken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🆕 Belirli ID'ye sahip kitabı getir
  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addBook(Book book) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await BookService.addBook(book);
      if (success) {
        _books.add(book);
      }
    } catch (e) {
      print('Kitap eklerken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await BookService.deleteBook(id);
      _books.removeWhere((book) => book.id == id);
    } catch (e) {
      print('Kitap silerken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    _isLoading = true;
    notifyListeners();
    try {
      await BookService.updateBook(updatedBook);
      final index = _books.indexWhere((book) => book.id == updatedBook.id);
      if (index != -1) {
        _books[index] = updatedBook;
      }
    } catch (e) {
      print('Kitap güncellerken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔮 Yeni fonksiyon: Önerilen kitapları getir
  Future<void> fetchRecommendedBooks(int userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final books = await BookService.fetchRecommendedBooks(userId);
      _recommendedBooks = books;
    } catch (e) {
      print("❌ Backend hata mesajı döndürdü: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

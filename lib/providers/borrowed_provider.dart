import 'package:flutter/material.dart';

class BorrowedProvider extends ChangeNotifier {
  final List<Map<String, String>> _borrowedBooks = [];

  List<Map<String, String>> get borrowedBooks => _borrowedBooks;

  void borrowBook(Map<String, String> book, String username) {
    final newEntry = {
      'title': book['title'] ?? '',
      'author': book['author'] ?? '',
      'image': book['image'] ?? '',
      'borrowedBy': username,
    };
    _borrowedBooks.add(newEntry);
    notifyListeners();
  }

  void returnBook(String title, String username) {
    _borrowedBooks.removeWhere(
      (book) => book['title'] == title && book['borrowedBy'] == username,
    );
    notifyListeners();
  }
}

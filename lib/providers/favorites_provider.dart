import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, String>> _favorites = [];

  List<Map<String, String>> get favorites => _favorites;

  void addFavorite(Map<String, String> book, String username) {
    if (!_favorites.any((b) => b['title'] == book['title'])) {
      final newBook = Map<String, String>.from(book);
      newBook['favoritedBy'] = username;
      _favorites.add(newBook);
      notifyListeners();
    }
  }

  void removeFavorite(String title) {
    _favorites.removeWhere((book) => book['title'] == title);
    notifyListeners();
  }
}

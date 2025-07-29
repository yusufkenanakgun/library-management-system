import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../services/favorite_service.dart';

class FavoritesProvider with ChangeNotifier {
  List<Favorite> _favorites = [];
  bool _isLoading = false;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchFavoritesByUsername(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await FavoriteService.fetchFavorites(username);
    } catch (e) {
      print('Favoriler yüklenemedi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(
    String username,
    String fullName,
    String bookId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FavoriteService.addFavorite(bookId, username, fullName);
      await fetchFavoritesByUsername(username); // öneri ve listelemeler için
    } catch (e) {
      print('Favori ekleme hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFavoriteByUsername(String username, String bookId) async {
    try {
      await FavoriteService.removeFavorite(bookId);
      _favorites.removeWhere((f) => f.bookId == bookId);
      notifyListeners();
    } catch (e) {
      print('Favori silme hatası: $e');
    }
  }

  bool isFavorite(String bookId) {
    return _favorites.any((f) => f.bookId == bookId);
  }
}

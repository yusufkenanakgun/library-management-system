import 'package:flutter/material.dart';
import '../models/borrow_model.dart';
import '../services/borrow_service.dart';

class BorrowedProvider with ChangeNotifier {
  List<Borrow> _borrowedBooks = [];
  bool _isLoading = false;

  List<Borrow> get borrowedBooks => _borrowedBooks;
  bool get isLoading => _isLoading;

  Future<void> fetchBorrowHistoryByUsername(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      _borrowedBooks = await BorrowService.fetchUserBorrows(username);
    } catch (e) {
      print('❌ Kullanıcının geçmiş borrow verisi alınamadı: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllBorrows() async {
    _isLoading = true;
    notifyListeners();

    try {
      _borrowedBooks = await BorrowService.fetchAllBorrows();
    } catch (e) {
      print('❌ Tüm borçlar alınamadı: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActiveBorrowsByUsername(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      final allBorrows = await BorrowService.fetchUserBorrows(username);
      _borrowedBooks = allBorrows.where((b) => !b.isReturned).toList();
    } catch (e) {
      print('❌ Aktif borçlar alınamadı: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> borrowBook(
    String username,
    String fullName,
    String bookId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final borrow = Borrow(
        id: 0,
        username: username,
        fullName: fullName,
        bookId: bookId,
        borrowDate: now,
        expectedReturnDate: now.add(const Duration(days: 14)),
        actualReturnDate: null,
        borrowDurationInWeeks: 2,
      );

      await BorrowService.borrowBook(borrow);
      await fetchActiveBorrowsByUsername(username);
    } catch (e) {
      print('❌ Ödünç alma hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> returnBook(String username, int borrowId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await BorrowService.returnBook(borrowId);
      await fetchActiveBorrowsByUsername(username);
    } catch (e) {
      print('❌ Kitap iade hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

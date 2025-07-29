// ✅ FINAL: reservation_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation_model.dart';
import '../services/reservation_service.dart';
import 'user_provider.dart';

class ReservationProvider with ChangeNotifier {
  List<Reservation> _reservations = [];
  bool _isLoading = false;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;

  /// 👤 Kullanıcının tüm rezervasyonlarını getirir
  Future<void> fetchReservations() async {
    _isLoading = true;
    notifyListeners();
    try {
      _reservations = await ReservationService.fetchReservations();
    } catch (e) {
      debugPrint('Rezervasyonlar çekilemedi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ❌ Belirli bir rezervasyonu iptal eder
  Future<void> cancelReservation(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ReservationService.cancelReservation(id);
      await fetchReservations(); // 📌 listeyi güncelle
    } catch (e) {
      debugPrint('Rezervasyon iptali başarısız: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ➕ Belirli bir kitabı rezerve eder (2 hafta sabit süreyle)
  Future<void> reserveBook(BuildContext context, String bookId) async {
    _isLoading = true;
    notifyListeners();

    final user = Provider.of<UserProvider>(context, listen: false);
    final username = user.username;
    final fullName = user.fullName;

    if (username == null || fullName == null) {
      debugPrint('Kullanıcı bilgisi eksik. Giriş yapılmamış olabilir.');
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final now = DateTime.now();
      final reservation = Reservation(
        id: 0,
        username: username,
        fullName: fullName,
        bookId: bookId,
        reservationDate: now,
        expirationDate: now.add(const Duration(days: 7)),
        borrowDurationInWeeks: 2,
      );

      await ReservationService.reserveBook(reservation);
      await fetchReservations();
    } catch (e) {
      debugPrint('Rezervasyon oluşturulamadı: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

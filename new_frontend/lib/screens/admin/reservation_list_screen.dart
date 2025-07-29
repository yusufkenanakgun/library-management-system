import 'package:flutter/material.dart';
import '../../models/reservation_model.dart';
import '../../services/reservation_service.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  late Future<List<Reservation>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _reservationsFuture = ReservationService.fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reservations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<List<Reservation>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz rezervasyon yok.'));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final res = reservations[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.bookmark, color: Colors.indigo),
                  title: Text('Book ID: ${res.bookId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kullanıcı: ${res.fullName} (${res.username})'),
                      Text(
                        'Başlangıç: ${res.reservationDate.toLocal().toString().split(" ").first}',
                      ),
                      Text(
                        'Son Tarih: ${res.expirationDate.toLocal().toString().split(" ").first}',
                      ),
                      Text(
                        res.isExpired ? '⛔ Süresi dolmuş' : '✅ Aktif',
                        style: TextStyle(
                          color: res.isExpired ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

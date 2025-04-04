import 'package:flutter/material.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Şimdilik örnek veri - gerçek veriler eklendiğinde burası dinamik hale gelir
    final List<Map<String, String>> reservations = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reservations"),
        backgroundColor: Colors.blueAccent,
      ),
      body:
          reservations.isEmpty
              ? const Center(child: Text("You have no reservations yet."))
              : ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final book = reservations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.bookmark),
                      title: Text(book['title'] ?? ''),
                      subtitle: Text(book['author'] ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Detay ekranına yönlendirme yapılabilir
                      },
                    ),
                  );
                },
              ),
    );
  }
}

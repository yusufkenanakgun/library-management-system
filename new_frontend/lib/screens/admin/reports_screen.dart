import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../services/auth_service.dart';
import '../../services/favorite_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int totalFavorites = 0;
  int totalUsers = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final users = await AuthService.getAllUsers();
        final allFavorites = await FavoriteService.fetchAllFavorites();

        setState(() {
          totalUsers = users.length;
          totalFavorites = allFavorites.length;
        });
      } catch (e) {
        print('Veriler alınırken hata oluştu: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookCount = context.watch<BookProvider>().books.length;
    final borrowCount = context.watch<BorrowedProvider>().borrowedBooks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Statistics"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📊 General Statistics",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatBox(
                  "Total Books",
                  bookCount.toString(),
                  Icons.menu_book,
                ),
                _buildStatBox(
                  "Total Users",
                  totalUsers.toString(),
                  Icons.people,
                ),
                _buildStatBox(
                  "Borrowed",
                  borrowCount.toString(),
                  Icons.shopping_cart,
                ),
                _buildStatBox(
                  "Favorites",
                  totalFavorites.toString(),
                  Icons.favorite,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "📈 Insights",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.green),
                title: const Text("Top Activity Day"),
                subtitle: const Text("Most books borrowed on Mondays 📅"),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: const Text("Most Favorited Book"),
                subtitle: const Text("'Atomic Habits' is favored by 17 users"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.indigo),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

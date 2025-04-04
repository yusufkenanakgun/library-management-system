import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Statistics"),
        backgroundColor: Colors.white, // AppBar beyaz
        foregroundColor: Colors.black, // Yazı ve ikonlar siyah
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatCard("Total Books", "120", Icons.book),
            const SizedBox(height: 12),
            _buildStatCard("Total Users", "85", Icons.people),
            const SizedBox(height: 12),
            _buildStatCard("Books Borrowed", "37", Icons.library_books),
            const SizedBox(height: 12),
            _buildStatCard("Favorites Marked", "64", Icons.favorite),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildActivityItem("Zeynep Kaya borrowed 'Sapiens'"),
            _buildActivityItem(
              "Ahmet Yılmaz added 'The Alchemist' to favorites",
            ),
            _buildActivityItem("User1 returned '1984'"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blueAccent),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String text) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline, color: Colors.grey),
      title: Text(text),
    );
  }
}

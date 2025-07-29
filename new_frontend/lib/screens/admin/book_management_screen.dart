import 'package:flutter/material.dart';

class BookManagementScreen extends StatelessWidget {
  const BookManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Book Management"),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOption(
            context,
            "Manage Books",
            Icons.settings,
            '/manage-books',
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            "View Total Books",
            Icons.menu_book,
            '/total-books',
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            "View Available Books",
            Icons.book_outlined,
            '/available-books',
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            "View Favorite Books",
            Icons.favorite,
            '/favorites',
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            "View Borrowed Books",
            Icons.shopping_cart,
            '/borrowed',
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            "View Reservations",
            Icons.bookmark_added_outlined,
            '/reservations',
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pushNamed(context, routeName),
      ),
    );
  }
}

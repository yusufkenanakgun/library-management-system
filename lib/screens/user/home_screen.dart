import 'package:flutter/material.dart';
import 'book_detail_screen.dart';
import '../../widgets/flexible_image.dart';
import '../../data/books.dart'; // veya relative path'e göre ../data/books.dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome, User1 👋",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Recommended for You"),
          _bookList(context, books),
          const SizedBox(height: 24),
          _sectionTitle("New Arrivals"),
          _bookList(context, books),
          const SizedBox(height: 24),
          _sectionTitle("Most Borrowed"),
          _bookList(context, books),
          const SizedBox(height: 32),
          Center(
            child: Text(
              "YURead © 2025 – Powered by Yeditepe University",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _bookList(BuildContext context, List<Map<String, String>> books) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final book = books[index];
          return _bookCard(
            context,
            title: book['title']!,
            author: book['author']!,
            imageUrl: book['image']!,
          );
        },
      ),
    );
  }

  Widget _bookCard(
    BuildContext context, {
    required String title,
    required String author,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BookDetailScreen(
                  title: title,
                  author: author,
                  imageUrl: imageUrl,
                ),
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            flexibleImage(
              imageUrl,
              height: 140,
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              author,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

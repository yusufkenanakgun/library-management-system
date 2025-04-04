import 'package:flutter/material.dart';
import '../../data/books.dart';
import 'book_detail_screen.dart';
import '../../widgets/flexible_image.dart';

class RecommendedBooksScreen extends StatelessWidget {
  const RecommendedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommended Books"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: ListTile(
              leading: flexibleImage(
                book['image'] ?? '',
                height: 70,
                width: 50,
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(book['title'] ?? 'No Title'),
              subtitle: Text(book['author'] ?? 'No Author'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BookDetailScreen(
                          title: book['title'] ?? '',
                          author: book['author'] ?? '',
                          imageUrl: book['image'] ?? '',
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

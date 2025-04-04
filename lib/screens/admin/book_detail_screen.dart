import 'package:flutter/material.dart';
import '../../data/books.dart';
import 'edit_book_screen.dart';
import '../../widgets/flexible_image.dart';

class AdminBookDetailScreen extends StatelessWidget {
  final Map<String, String> book;

  const AdminBookDetailScreen({super.key, required this.book});

  void _removeBook(BuildContext context) {
    books.removeWhere((b) => b['title'] == book['title']);
    Navigator.pop(context); // Detay ekranından çık
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Book removed successfully")));
  }

  void _editBook(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditBookScreen(book: book)),
    );
    Navigator.pop(context); // Düzenlemeden dönünce bu sayfayı da kapat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            flexibleImage(
              book['image'] ?? '',
              height: 180,
              width: 130,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 24),
            Text(
              book['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              book['author'] ?? 'No Author',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editBook(context),
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Book"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _removeBook(context),
                    icon: const Icon(Icons.delete),
                    label: const Text("Remove Book"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import 'edit_book_screen.dart';
import '../../widgets/flexible_image.dart';

class AdminBookDetailScreen extends StatelessWidget {
  final Book book;

  const AdminBookDetailScreen({super.key, required this.book});

  Future<void> _deleteBook(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Book'),
            content: const Text('Are you sure you want to delete this book?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final provider = Provider.of<BookProvider>(context, listen: false);
      await provider.deleteBook(book.id);
      await provider.fetchBooks();

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Book deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to delete book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editBook(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditBookScreen(book: book)),
    );

    await Provider.of<BookProvider>(context, listen: false).fetchBooks();
    if (context.mounted) Navigator.pop(context); // Return after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: flexibleImage(
                book.image.isNotEmpty && book.image.startsWith("http")
                    ? book.image
                    : "https://via.placeholder.com/140x200.png?text=No+Image",
                height: 200,
                width: 140,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'by ${book.author}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              book.description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  book.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: book.isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  book.isAvailable ? 'Available' : 'Currently Borrowed',
                  style: TextStyle(
                    color: book.isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editBook(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteBook(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Book'),
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

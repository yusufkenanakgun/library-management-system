import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../providers/favorites_provider.dart';
import '../user/book_detail_screen.dart';
import '../../widgets/flexible_image.dart';

class BorrowedScreen extends StatelessWidget {
  const BorrowedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final borrowed = context.watch<BorrowedProvider>().borrowedBooks;
    final favorites = context.watch<FavoritesProvider>().favorites;

    const currentUsername = 'User1'; // geçici çözüm

    return borrowed.isEmpty
        ? const Center(child: Text("You haven't borrowed any books."))
        : ListView.builder(
          itemCount: borrowed.length,
          itemBuilder: (context, index) {
            final book = borrowed[index];
            final isFavorite = favorites.any(
              (f) => f['title'] == book['title'],
            );

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BookDetailScreen(
                            title: book['title']!,
                            author: book['author']!,
                            imageUrl: book['image']!,
                          ),
                    ),
                  );
                },
                leading: flexibleImage(
                  book['image']!,
                  height: 70,
                  width: 50,
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(book['title']!),
                subtitle: Text(book['author']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.library_books, color: Colors.blueAccent),
                    if (isFavorite)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.favorite, color: Colors.red),
                      ),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: () {
                        context.read<BorrowedProvider>().returnBook(
                          book['title']!,
                          currentUsername,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/borrowed_provider.dart';
import '../user/book_detail_screen.dart';
import '../../widgets/flexible_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;
    final borrowed = context.watch<BorrowedProvider>().borrowedBooks;

    return favorites.isEmpty
        ? const Center(child: Text("You have no favorite books yet."))
        : ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final book = favorites[index];
            final isBorrowed = borrowed.any((b) => b['title'] == book['title']);

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
                    const Icon(Icons.favorite, color: Colors.red),
                    if (isBorrowed)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.library_books,
                          color: Colors.blueAccent,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<FavoritesProvider>().removeFavorite(
                          book['title']!,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../widgets/flexible_image.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;
    final borrowed = context.watch<BorrowedProvider>().borrowedBooks;

    final isFavorite = favorites.any((book) => book['title'] == title);
    final isBorrowed = borrowed.any((book) => book['title'] == title);

    const currentUsername =
        'User1'; // 🔧 Gerçek sistemde burayı dinamik yaparız

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: flexibleImage(imageUrl, height: 250),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "by $author",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            if (isFavorite)
              Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.red),
                  SizedBox(width: 8),
                  Text("This book is in your favorites."),
                ],
              ),
            if (isBorrowed)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: const [
                    Icon(Icons.book, color: Colors.green),
                    SizedBox(width: 8),
                    Text("You have borrowed this book."),
                  ],
                ),
              ),

            const SizedBox(height: 24),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This is a placeholder description for the selected book. You can integrate backend data later to show actual book descriptions, ratings, and more.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                // FAVORİ TOGGLE
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final provider = Provider.of<FavoritesProvider>(
                        context,
                        listen: false,
                      );
                      if (isFavorite) {
                        provider.removeFavorite(title);
                      } else {
                        provider.addFavorite({
                          'title': title,
                          'author': author,
                          'image': imageUrl,
                        }, currentUsername); // 🔧 kullanıcı adı gönderildi
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // KİRALAMA TOGGLE
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final provider = Provider.of<BorrowedProvider>(
                        context,
                        listen: false,
                      );
                      if (isBorrowed) {
                        provider.returnBook(title, currentUsername); // 🔧
                      } else {
                        provider.borrowBook({
                          'title': title,
                          'author': author,
                          'image': imageUrl,
                        }, currentUsername); // 🔧
                      }
                    },
                    icon: Icon(
                      isBorrowed ? Icons.undo : Icons.shopping_cart_outlined,
                    ),
                    label: Text(isBorrowed ? "Return Book" : "Borrow"),
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

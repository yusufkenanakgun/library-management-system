import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/flexible_image.dart';

class FavoriteBooksScreen extends StatefulWidget {
  const FavoriteBooksScreen({super.key});

  @override
  State<FavoriteBooksScreen> createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = context.read<UserProvider>();
      await userProvider.loadUser();
      final username = userProvider.username;
      if (username != null) {
        await context.read<FavoritesProvider>().fetchFavoritesByUsername(
          username,
        );
        await context.read<BookProvider>().fetchBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final userProvider = context.watch<UserProvider>();
    final username = userProvider.username;
    final isLoading = bookProvider.isLoading || favoritesProvider.isLoading;

    final books = bookProvider.books;
    final favorites = favoritesProvider.favorites;

    final filteredFavorites =
        favorites.where((fav) {
          final book = books.firstWhere(
            (b) => b.id == fav.bookId,
            orElse:
                () => Book(
                  id: fav.bookId,
                  title: 'Unknown Book',
                  author: '',
                  description: '',
                  isAvailable: false,
                  image: '',
                ),
          );
          final q = searchQuery.toLowerCase();
          return book.title.toLowerCase().contains(q) ||
              book.author.toLowerCase().contains(q);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Books"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search favorites...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredFavorites.isEmpty
                    ? const Center(child: Text('No favorite books yet.'))
                    : ListView.builder(
                      itemCount: filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final fav = filteredFavorites[index];
                        final book = books.firstWhere(
                          (b) => b.id == fav.bookId,
                          orElse:
                              () => Book(
                                id: fav.bookId,
                                title: 'Unknown Book',
                                author: '',
                                description: '',
                                isAvailable: false,
                                image: '',
                              ),
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                width: 50,
                                height: 70,
                                child: flexibleImage(
                                  book.image.isNotEmpty &&
                                          book.image.startsWith("http")
                                      ? book.image
                                      : "https://via.placeholder.com/140x200.png?text=No+Image",
                                  width: 50,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(book.title),
                            subtitle: Text(book.author),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Remove from favorites",
                              onPressed:
                                  username == null
                                      ? null
                                      : () async {
                                        await favoritesProvider
                                            .removeFavoriteByUsername(
                                              username,
                                              book.id,
                                            );
                                      },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

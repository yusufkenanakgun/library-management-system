// ✅ FINAL: FavoritesScreen (optimize edilmiş)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/flexible_image.dart';
import '../user/book_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = context.read<UserProvider>();
      await userProvider.loadUser();

      if (!mounted) return;

      final username = userProvider.username;
      if (username == null) return;

      final borrowedProvider = context.read<BorrowedProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();
      final bookProvider = context.read<BookProvider>();

      await borrowedProvider.fetchActiveBorrowsByUsername(username);
      await favoritesProvider.fetchFavoritesByUsername(username);
      await bookProvider.fetchBooks();
    });
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Favorites Help"),
            content: const Text(
              "This page shows all books you've marked as favorite.\n\n"
              "You can tap a book to view details, or tap the trash icon to remove it from favorites.\n"
              "A blue book icon indicates you also borrowed that book.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<
      FavoritesProvider,
      BookProvider,
      BorrowedProvider,
      UserProvider
    >(
      builder: (
        context,
        favoritesProvider,
        bookProvider,
        borrowedProvider,
        userProvider,
        _,
      ) {
        final isLoading = favoritesProvider.isLoading || bookProvider.isLoading;
        final favorites = favoritesProvider.favorites;
        final borrowed = borrowedProvider.borrowedBooks;
        final books = bookProvider.books;

        final filtered =
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
              return book.title.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  book.author.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Favorites"),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => _showHelp(context),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search favorites...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
              ),
              Expanded(
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filtered.isEmpty
                        ? const Center(
                          child: Text("You have no favorite books yet."),
                        )
                        : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final fav = filtered[index];
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
                            final isBorrowed = borrowed.any(
                              (b) => b.bookId == book.id,
                            );

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => BookDetailScreen(book: book),
                                    ),
                                  );
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    width: 50,
                                    height: 70,
                                    child: flexibleImage(
                                      book.image.isNotEmpty ? book.image : '',
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                title: Text(book.title),
                                subtitle: Text(book.author),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
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
                                      onPressed: () async {
                                        final username = userProvider.username;
                                        if (username != null) {
                                          await favoritesProvider
                                              .removeFavoriteByUsername(
                                                username,
                                                book.id,
                                              );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

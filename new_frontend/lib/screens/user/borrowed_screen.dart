// ✅ FINAL: borrowed_screen.dart + borrowed_provider.dart
// Bu sürüm: İade işlemi sonrası listeyi anında günceller

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/favorites_provider.dart';
import '../user/book_detail_screen.dart';
import '../../widgets/flexible_image.dart';

class BorrowedScreen extends StatefulWidget {
  const BorrowedScreen({super.key});

  @override
  State<BorrowedScreen> createState() => _BorrowedScreenState();
}

class _BorrowedScreenState extends State<BorrowedScreen> {
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
            title: const Text("Borrowed Books Help"),
            content: const Text(
              "This screen lists books you've currently borrowed.\n\n"
              "Tap a book to view its details.\n"
              "Red heart icon indicates it's in your favorites.\n"
              "Tap the undo icon to return the book.",
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
      BorrowedProvider,
      BookProvider,
      FavoritesProvider,
      UserProvider
    >(
      builder: (
        context,
        borrowedProvider,
        bookProvider,
        favoritesProvider,
        userProvider,
        _,
      ) {
        final borrowedBooks = borrowedProvider.borrowedBooks;
        final books = bookProvider.books;
        final favorites = favoritesProvider.favorites;
        final isLoading = borrowedProvider.isLoading || bookProvider.isLoading;

        final filtered =
            borrowedBooks.where((borrow) {
              final book = books.firstWhere(
                (b) => b.id == borrow.bookId,
                orElse:
                    () => Book(
                      id: borrow.bookId,
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
              child: Text("Borrowed Books"),
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
                    hintText: "Search borrowed books...",
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
                          child: Text("You haven't borrowed any books."),
                        )
                        : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final borrow = filtered[index];
                            final book = books.firstWhere(
                              (b) => b.id == borrow.bookId,
                              orElse:
                                  () => Book(
                                    id: borrow.bookId,
                                    title: 'Unknown Book',
                                    author: '',
                                    description: '',
                                    isAvailable: false,
                                    image: '',
                                  ),
                            );
                            final isFavorite = favorites.any(
                              (f) => f.bookId == book.id,
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
                                    width: 60,
                                    height: 90,
                                    child: flexibleImage(
                                      book.image.isNotEmpty ? book.image : '',
                                      width: 60,
                                      height: 90,
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
                                      Icons.library_books,
                                      color: Colors.blueAccent,
                                    ),
                                    if (isFavorite)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.undo),
                                      tooltip: "Return this book",
                                      onPressed: () async {
                                        final username = userProvider.username;
                                        if (username != null) {
                                          await borrowedProvider.returnBook(
                                            username,
                                            borrow.id,
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

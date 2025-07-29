import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/flexible_image.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _recommendationFuture = Future.value();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final bookProvider = context.read<BookProvider>();
      final userProvider = context.read<UserProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();
      final userIdStr = userProvider.userId;
      final username = userProvider.username;

      if (userIdStr != null && userIdStr.isNotEmpty && username != null) {
        final int userId = int.tryParse(userIdStr) ?? 0;

        if (userId == 0) {
          print("⚠️ Geçersiz userId, öneri alınmadı.");
          return;
        }

        await bookProvider.fetchBooks();
        await favoritesProvider.fetchFavoritesByUsername(
          username,
        ); // 🔑 Burada bekliyoruz

        setState(() {
          _recommendationFuture = bookProvider.fetchRecommendedBooks(userId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final books = bookProvider.books;
    final recommended = bookProvider.recommendedBooks;
    final fullName = context.watch<UserProvider>().fullName ?? 'Reader';

    return Scaffold(
      body:
          bookProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  await bookProvider.fetchBooks();
                  final userIdStr = context.read<UserProvider>().userId;
                  if (userIdStr != null && int.tryParse(userIdStr) != null) {
                    final userId = int.parse(userIdStr);
                    _recommendationFuture = bookProvider.fetchRecommendedBooks(
                      userId,
                    );
                    await _recommendationFuture;
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, $fullName 👋",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _sectionTitle("Recommended for You"),
                      FutureBuilder(
                        future: _recommendationFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 220,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (recommended.isEmpty) {
                            return const SizedBox(
                              height: 220,
                              child: Center(
                                child: Text("No recommendations available."),
                              ),
                            );
                          } else {
                            return _bookList(context, recommended);
                          }
                        },
                      ),

                      const SizedBox(height: 24),
                      _sectionTitle("Available Books"),
                      _bookList(
                        context,
                        books.where((b) => b.isAvailable).toList(),
                      ),

                      const SizedBox(height: 24),
                      _sectionTitle("Most Borrowed"),
                      _bookList(context, books.reversed.toList()),

                      const SizedBox(height: 24),
                      _sectionTitle("New Arrivals"),
                      _bookList(context, books.reversed.take(5).toList()),

                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          "YURead © 2025 – Powered by Yeditepe University",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("No books found.")),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final book = books[index];
          return _bookCard(context, book);
        },
      ),
    );
  }

  Widget _bookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
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
              book.image,
              height: 140,
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                book.author,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

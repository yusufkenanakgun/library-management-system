import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/user_provider.dart';
import 'book_detail_screen.dart';
import '../../widgets/flexible_image.dart';
import '../../models/book_model.dart';

class RecommendedBooksScreen extends StatefulWidget {
  const RecommendedBooksScreen({super.key});

  @override
  State<RecommendedBooksScreen> createState() => _RecommendedBooksScreenState();
}

class _RecommendedBooksScreenState extends State<RecommendedBooksScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserProvider>().userIdAsInt;

      if (userId == 0) {
        print("🚫 Kullanıcı ID geçersiz, öneri istenmeyecek.");
        return;
      }

      context.read<BookProvider>().fetchRecommendedBooks(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final List<Book> recommendedBooks = bookProvider.recommendedBooks;
    final bool isLoading = bookProvider.isLoading;

    final filteredBooks =
        recommendedBooks.where((book) {
          final query = _searchQuery.toLowerCase();
          return book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Books'),
        backgroundColor: Colors.blueAccent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search by title or author...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredBooks.isEmpty
              ? const Center(child: Text("No recommendations found."))
              : ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: flexibleImage(book.image, width: 50, height: 80),
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailScreen(book: book),
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

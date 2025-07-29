import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../user/book_detail_screen.dart';
import '../../widgets/flexible_image.dart';

class AvailableBooksScreen extends StatefulWidget {
  const AvailableBooksScreen({super.key});

  @override
  State<AvailableBooksScreen> createState() => _AvailableBooksScreenState();
}

class _AvailableBooksScreenState extends State<AvailableBooksScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    await Provider.of<BookProvider>(context, listen: false).fetchBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final availableBooks =
        bookProvider.books.where((b) => b.isAvailable).toList();

    final filteredBooks =
        availableBooks.where((book) {
          final query = searchQuery.toLowerCase();
          return book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Books"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child:
                bookProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredBooks.isEmpty
                    ? const Center(child: Text('No available books found.'))
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredBooks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 70,
                              child: flexibleImage(
                                book.image.startsWith("http")
                                    ? book.image
                                    : "https://via.placeholder.com/140x200.png?text=No+Image",
                                width: 50,
                                height: 70,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
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
          ),
        ],
      ),
    );
  }
}

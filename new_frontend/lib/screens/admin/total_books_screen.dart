import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';

class TotalBooksScreen extends StatefulWidget {
  const TotalBooksScreen({super.key});

  @override
  State<TotalBooksScreen> createState() => _TotalBooksScreenState();
}

class _TotalBooksScreenState extends State<TotalBooksScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    await Provider.of<BookProvider>(context, listen: false).fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final books = bookProvider.books;

    final filteredBooks =
        books.where((book) {
          return book.title.toLowerCase().contains(searchQuery);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Books"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) => setState(() => searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child:
                bookProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredBooks.isEmpty
                    ? const Center(child: Text('No books found.'))
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
                            leading:
                                book.image.isNotEmpty
                                    ? Image.network(
                                      book.image,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.image_not_supported,
                                          ),
                                    )
                                    : const Icon(Icons.book),
                            title: Text(book.title),
                            subtitle: Text(book.author),
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

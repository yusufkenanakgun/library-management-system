import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../screens/admin/edit_book_screen.dart';
import 'admin_book_detail_screen.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBooks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    await Provider.of<BookProvider>(context, listen: false).fetchBooks();
  }

  Future<void> _confirmDelete(BuildContext context, String bookId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this book?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await Provider.of<BookProvider>(
          context,
          listen: false,
        ).deleteBook(bookId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Book deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Failed to delete book: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final filteredBooks =
        bookProvider.books.where((book) {
          return book.title.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-book');
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchBooks,
              child:
                  bookProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 3,
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
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditBookScreen(book: book),
                                      ),
                                    );
                                    await _fetchBooks(); // geri dönünce güncelle
                                  } else if (value == 'delete') {
                                    await _confirmDelete(context, book.id);
                                  }
                                },
                                itemBuilder:
                                    (_) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            AdminBookDetailScreen(book: book),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

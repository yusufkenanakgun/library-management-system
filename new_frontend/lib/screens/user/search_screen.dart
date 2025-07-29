import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../widgets/flexible_image.dart';
import 'book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];
  List<Book> _allBooks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final books = Provider.of<BookProvider>(context).books;
    _allBooks = books;
    _filteredBooks = books; // Başta hepsini göster
  }

  void _filterBooks(String query) {
    final filtered =
        _allBooks.where((book) {
          final title = book.title.toLowerCase();
          final author = book.author.toLowerCase();
          final input = query.toLowerCase();
          return title.contains(input) || author.contains(input);
        }).toList();

    setState(() {
      _filteredBooks = query.isEmpty ? _allBooks : filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredBooks = _allBooks;
    });
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Search Help"),
            content: const Text(
              "You can search by book title or author name.\nStart typing to filter results in real time.",
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
    final isEmpty = _filteredBooks.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Search Books"),
        ),
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
                hintText: "Search for books...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _filterBooks,
            ),
          ),
          Expanded(
            child:
                isEmpty
                    ? const Center(child: Text("No books found."))
                    : ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return _bookListItem(context, book: book);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _bookListItem(BuildContext context, {required Book book}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 50,
            height: 70,
            child: flexibleImage(
              book.image,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(book.author),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
          );
        },
      ),
    );
  }
}

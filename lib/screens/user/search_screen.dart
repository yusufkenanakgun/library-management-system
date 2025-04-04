import 'package:flutter/material.dart';
import 'book_detail_screen.dart';
import '../../widgets/flexible_image.dart';
import '../../data/books.dart'; // ✅ Ortak kitap listesi

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _filteredBooks = books; // ✅ artık books.dart üzerinden alıyoruz
  }

  void _filterBooks(String query) {
    final result =
        books.where((book) {
          final title = book['title']!.toLowerCase();
          final author = book['author']!.toLowerCase();
          return title.contains(query.toLowerCase()) ||
              author.contains(query.toLowerCase());
        }).toList();

    setState(() {
      _filteredBooks = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search for books...",
              prefixIcon: const Icon(Icons.search),
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
              _filteredBooks.isEmpty
                  ? const Center(child: Text("No books found."))
                  : ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return _bookListItem(
                        context,
                        title: book['title']!,
                        author: book['author']!,
                        imageUrl: book['image']!,
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _bookListItem(
    BuildContext context, {
    required String title,
    required String author,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: flexibleImage(
          imageUrl,
          height: 70,
          width: 50,
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(author),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BookDetailScreen(
                    title: title,
                    author: author,
                    imageUrl: imageUrl,
                  ),
            ),
          );
        },
      ),
    );
  }
}

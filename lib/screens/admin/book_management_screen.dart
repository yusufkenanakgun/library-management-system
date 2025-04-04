import 'package:flutter/material.dart';
import '../../data/books.dart';
import 'edit_book_screen.dart';
import 'add_book_screen.dart';
import 'book_detail_screen.dart'; // Detay ekranı importu

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  void _navigateToEdit(Map<String, String> book) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditBookScreen(book: book)),
    );
    setState(() {}); // Geri dönünce listeyi yenile
  }

  void _navigateToAdd() async {
    final newBook = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddBookScreen()),
    );

    if (newBook != null) {
      setState(() {
        books.add(newBook);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Books"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body:
          books.isEmpty
              ? const Center(child: Text("No books available."))
              : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminBookDetailScreen(book: book),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      leading:
                          book['image'] != null && book['image']!.isNotEmpty
                              ? Image.asset(
                                book['image']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.book, size: 40),
                      title: Text(book['title'] ?? "No Title"),
                      subtitle: Text(book['author'] ?? "No Author"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _navigateToEdit(book),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}

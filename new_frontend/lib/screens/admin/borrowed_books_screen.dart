import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../providers/borrowed_provider.dart';

class BorrowedBooksScreen extends StatefulWidget {
  const BorrowedBooksScreen({super.key});

  @override
  State<BorrowedBooksScreen> createState() => _BorrowedBooksScreenState();
}

class _BorrowedBooksScreenState extends State<BorrowedBooksScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<BookProvider>().fetchBooks();
      await context
          .read<BorrowedProvider>()
          .fetchAllBorrows(); // ✅ tüm borçları getir
    });
  }

  @override
  Widget build(BuildContext context) {
    final borrowedProvider = context.watch<BorrowedProvider>();
    final borrowedBooks = borrowedProvider.borrowedBooks;
    final isLoading = borrowedProvider.isLoading;
    final books = context.watch<BookProvider>().books;

    final filtered =
        borrowedBooks.where((borrow) {
          final book = books.firstWhere(
            (b) => b.id == borrow.bookId,
            orElse:
                () => Book(
                  id: borrow.bookId,
                  title: 'Unknown',
                  author: '',
                  description: '',
                  isAvailable: false,
                  image: '',
                ),
          );
          return book.title.toLowerCase().contains(searchQuery);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Borrowed Books'),
        backgroundColor: Colors.indigo,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search by book title...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => searchQuery = value.toLowerCase());
                      },
                    ),
                  ),
                  Expanded(
                    child:
                        filtered.isEmpty
                            ? const Center(
                              child: Text('No borrow records found.'),
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
                                        title: 'Unknown',
                                        author: '',
                                        description: '',
                                        isAvailable: false,
                                        image: '',
                                      ),
                                );

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.book),
                                    title: Text(book.title),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kullanıcı: ${borrow.fullName} (${borrow.username})',
                                        ),
                                        Text(
                                          'Alış: ${borrow.borrowDate.toLocal().toString().split(" ").first}',
                                        ),
                                        Text(
                                          'Teslim: ${borrow.expectedReturnDate.toLocal().toString().split(" ").first}',
                                        ),
                                        if (borrow.isReturned)
                                          Text(
                                            'İade edildi: ${borrow.actualReturnDate!.toLocal().toString().split(" ").first}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          )
                                        else
                                          const Text(
                                            '⏳ Hâlâ ödünçte',
                                            style: TextStyle(color: Colors.red),
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
  }
}

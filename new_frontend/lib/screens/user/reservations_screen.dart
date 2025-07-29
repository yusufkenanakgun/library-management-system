import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/book_model.dart';
import '../../widgets/flexible_image.dart';
import '../user/book_detail_screen.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      Future.microtask(() async {
        final userProvider = context.read<UserProvider>();
        final bookProvider = context.read<BookProvider>();

        final userIdStr = userProvider.userId;
        final userId = int.tryParse(userIdStr ?? '') ?? 0;

        await bookProvider.fetchBooks();
        if (userId != 0) {
          await bookProvider.fetchRecommendedBooks(userId);
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => searchQuery = '');
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Reservations Help"),
            content: const Text(
              "This page shows the books you've reserved.\n\n"
              "Reserved books are held for a limited time. "
              "You can tap to view the book details or cancel your reservation.",
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
    final reservationProvider = context.watch<ReservationProvider>();
    final bookProvider = context.watch<BookProvider>();

    final lowercaseQuery = searchQuery.toLowerCase();
    final filteredReservations =
        reservationProvider.reservations.where((res) {
          final book = bookProvider.books.firstWhere(
            (b) => b.id == res.bookId,
            orElse:
                () => Book(
                  id: res.bookId,
                  title: '',
                  author: '',
                  description: '',
                  isAvailable: false,
                  image: '',
                ),
          );
          return book.title.toLowerCase().contains(lowercaseQuery);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reservations"),
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
                hintText: "Search your reservations...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchQuery.isNotEmpty
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
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child:
                reservationProvider.isLoading || bookProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredReservations.isEmpty
                    ? const Center(child: Text("You have no reservations yet."))
                    : ListView.builder(
                      itemCount: filteredReservations.length,
                      itemBuilder: (context, index) {
                        final res = filteredReservations[index];
                        final book = bookProvider.books.firstWhere(
                          (b) => b.id == res.bookId,
                          orElse:
                              () => Book(
                                id: res.bookId,
                                title: 'Unknown Book',
                                author: '',
                                description: '',
                                isAvailable: false,
                                image: '',
                              ),
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 70,
                              child: flexibleImage(
                                book.image,
                                width: 50,
                                height: 70,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            title: Text(book.title),
                            subtitle: Text(
                              "Until: ${res.expirationDate.toLocal().toString().split(' ')[0]}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                Provider.of<ReservationProvider>(
                                  context,
                                  listen: false,
                                ).cancelReservation(res.id);
                              },
                            ),
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

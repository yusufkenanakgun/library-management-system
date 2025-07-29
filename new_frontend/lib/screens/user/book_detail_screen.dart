// ✅ FINAL: book_detail_screen.dart (Reserve button always visible, disabled when not applicable)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../models/reservation_model.dart';
import '../../providers/borrowed_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../services/reservation_service.dart';
import '../../widgets/flexible_image.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Book _book;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    Future.microtask(() async {
      final reservationProvider = context.read<ReservationProvider>();
      await reservationProvider.fetchReservations();
    });
  }

  Future<void> _refreshBook() async {
    final bookProvider = context.read<BookProvider>();
    await bookProvider.fetchBooks();
    final updated = bookProvider.getBookById(_book.id);
    if (updated != null) setState(() => _book = updated);
  }

  Future<void> _showReservationDialog(BuildContext context) async {
    final user = context.read<UserProvider>();
    final eta = await ReservationService.fetchEta(user.username!);

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Reserve this book?"),
            content: Text("Estimated wait time: $eta day(s)"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                child: const Text("Confirm"),
                onPressed: () async {
                  Navigator.pop(ctx);
                  await context.read<ReservationProvider>().reserveBook(
                    context,
                    _book.id,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Book reserved successfully."),
                    ),
                  );
                  await _refreshBook();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<
      FavoritesProvider,
      BorrowedProvider,
      UserProvider,
      ReservationProvider
    >(
      builder: (
        context,
        favoritesProvider,
        borrowedProvider,
        userProvider,
        reservationProvider,
        _,
      ) {
        final favorites = favoritesProvider.favorites;
        final borrowed = borrowedProvider.borrowedBooks;
        final reservations = reservationProvider.reservations;
        final user = userProvider;

        final isFavorite = favorites.any((f) => f.bookId == _book.id);
        final isBorrowedByCurrentUser = borrowed.any(
          (b) => b.bookId == _book.id && b.username == user.username,
        );
        final userReservation = reservations.firstWhere(
          (r) => r.bookId == _book.id && r.username == user.username,
          orElse: () => Reservation.empty(),
        );
        final hasReserved = userReservation.id != 0;

        final borrowButtonText =
            isBorrowedByCurrentUser
                ? "Return Book"
                : _book.isAvailable
                ? "Borrow Book"
                : "Not Available";

        final borrowButtonIcon =
            isBorrowedByCurrentUser
                ? Icons.undo
                : _book.isAvailable
                ? Icons.shopping_cart_outlined
                : Icons.block;

        final borrowButtonEnabled =
            user.username != null &&
            user.fullName != null &&
            (_book.isAvailable || isBorrowedByCurrentUser);

        final reserveButtonEnabled =
            !_book.isAvailable && !isBorrowedByCurrentUser && !hasReserved;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Book Details"),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: flexibleImage(_book.image, height: 250),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _book.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "by ${_book.author}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                if (isFavorite)
                  const Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red),
                      SizedBox(width: 8),
                      Text("This book is in your favorites."),
                    ],
                  ),
                if (isBorrowedByCurrentUser)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.book, color: Colors.green),
                        SizedBox(width: 8),
                        Text("You have borrowed this book."),
                      ],
                    ),
                  ),
                if (hasReserved)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.bookmark, color: Colors.orange),
                        SizedBox(width: 8),
                        Text("You have reserved this book."),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _book.description.isNotEmpty
                      ? _book.description
                      : "No description available.",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            user.username == null
                                ? null
                                : () async {
                                  final username = user.username!;
                                  final fullName = user.fullName!;
                                  if (isFavorite) {
                                    await favoritesProvider
                                        .removeFavoriteByUsername(
                                          username,
                                          _book.id,
                                        );
                                  } else {
                                    await favoritesProvider.addFavorite(
                                      username,
                                      fullName,
                                      _book.id,
                                    );
                                  }
                                  await _refreshBook();
                                },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        label: Text(
                          isFavorite ? "Remove Favorite" : "Add to Favorites",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isFavorite
                                  ? Colors.red.shade100
                                  : Colors.blueAccent,
                          foregroundColor:
                              isFavorite ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            borrowButtonEnabled
                                ? () async {
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  try {
                                    if (isBorrowedByCurrentUser) {
                                      final borrow = borrowed.firstWhere(
                                        (b) =>
                                            b.bookId == _book.id &&
                                            b.username == user.username,
                                      );
                                      await borrowedProvider.returnBook(
                                        user.username!,
                                        borrow.id,
                                      );
                                    } else {
                                      await borrowedProvider.borrowBook(
                                        user.username!,
                                        user.fullName!,
                                        _book.id,
                                      );
                                    }
                                    await _refreshBook();
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isBorrowedByCurrentUser
                                              ? "Book returned successfully."
                                              : "Book borrowed successfully.",
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }
                                }
                                : null,
                        icon: Icon(borrowButtonIcon),
                        label: Text(borrowButtonText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton.icon(
                    onPressed:
                        hasReserved
                            ? () async {
                              await reservationProvider.cancelReservation(
                                userReservation.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reservation cancelled."),
                                ),
                              );
                              await _refreshBook();
                            }
                            : reserveButtonEnabled
                            ? () => _showReservationDialog(context)
                            : null,
                    icon:
                        hasReserved
                            ? const Icon(Icons.cancel)
                            : const Icon(Icons.bookmark_add),
                    label: Text(
                      hasReserved ? "Cancel Reservation" : "Reserve Book",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasReserved ? Colors.redAccent : Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

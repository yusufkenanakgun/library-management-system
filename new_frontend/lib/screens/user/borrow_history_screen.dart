import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../providers/user_provider.dart';

class BorrowHistoryScreen extends StatefulWidget {
  const BorrowHistoryScreen({super.key});

  @override
  State<BorrowHistoryScreen> createState() => _BorrowHistoryScreenState();
}

class _BorrowHistoryScreenState extends State<BorrowHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = context.read<UserProvider>();
      if (user.username == null) await user.loadUser();
      if (!mounted || user.username == null) return;

      await context.read<BorrowedProvider>().fetchBorrowHistoryByUsername(
        user.username!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final borrowedProvider = context.watch<BorrowedProvider>();
    final borrows = borrowedProvider.borrowedBooks;

    return Scaffold(
      appBar: AppBar(title: const Text('Borrow History')),
      body:
          borrowedProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : borrows.isEmpty
              ? const Center(child: Text('No borrow history found.'))
              : ListView.builder(
                itemCount: borrows.length,
                itemBuilder: (context, index) {
                  final borrow = borrows[index];
                  return ListTile(
                    title: Text('📚 Book ID: ${borrow.bookId}'),
                    subtitle: Text(
                      'Borrowed: ${borrow.borrowDate.toLocal().toString().split(' ')[0]}\n'
                      'Expected Return: ${borrow.expectedReturnDate.toLocal().toString().split(' ')[0]}\n'
                      'Actual Return: ${borrow.actualReturnDate?.toLocal().toString().split(' ')[0] ?? 'Not returned'}',
                    ),
                  );
                },
              ),
    );
  }
}

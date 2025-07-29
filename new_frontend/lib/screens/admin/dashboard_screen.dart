import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/borrowed_provider.dart';
import '../../services/reservation_service.dart';
import 'admin_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int reservationCount = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<BookProvider>().fetchBooks();
      await context.read<BorrowedProvider>().fetchAllBorrows();

      final reservations = await ReservationService.fetchReservations();
      setState(() {
        reservationCount = reservations.length;
      });
    });
  }

  void _navigateToTab(BuildContext context, int tabIndex) {
    final navState = AdminBottomNav.of(context);
    if (navState != null) {
      navState.setIndex(tabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final borrowedProvider = context.watch<BorrowedProvider>();
    final userProvider = context.watch<UserProvider>();

    final lastBooks = bookProvider.books.reversed.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📊 System Overview",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildStatRow(
                "Total Books",
                bookProvider.books.length.toString(),
                Icons.book,
              ),
              _buildStatRow(
                "Total Borrows",
                borrowedProvider.borrowedBooks.length.toString(),
                Icons.shopping_cart,
              ),
              _buildStatRow(
                "Total Reservations",
                reservationCount.toString(),
                Icons.bookmark_added,
              ),

              const SizedBox(height: 24),
              const Text(
                "Admin Capabilities",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                title: "📚 Book Management",
                description: "Add, update, delete and view books.",
                tabIndex: 1,
              ),
              _buildFeatureCard(
                context,
                title: "👥 User Management",
                description: "Monitor user activities and manage access.",
                tabIndex: 3,
              ),
              _buildFeatureCard(
                context,
                title: "📈 Reports",
                description: "Track usage, popular books, and overdue stats.",
                tabIndex: 2,
              ),
              _buildFeatureCard(
                context,
                title: "⚙️ Settings",
                description: "Configure system preferences.",
                tabIndex: 4,
              ),

              const SizedBox(height: 24),
              const Text(
                "📘 Recently Added Books",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...lastBooks.map(
                (book) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const Icon(Icons.new_releases, color: Colors.blue),
                  title: Text(book.title),
                  subtitle: Text("by ${book.author}"),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "🛠️ System Announcements",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.orange.shade50,
                elevation: 2,
                child: const ListTile(
                  leading: Icon(Icons.warning, color: Colors.orange),
                  title: Text("System Maintenance"),
                  subtitle: Text(
                    "Scheduled maintenance on 30 April, 02:00 - 04:00 AM.",
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.green.shade50,
                elevation: 2,
                child: const ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.green),
                  title: Text("New Feature: Favorites"),
                  subtitle: Text("Admins can now track user favorite books."),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "👤 Logged-in Admin",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.blueAccent,
                  ),
                  title: Text(userProvider.fullName ?? 'Unknown'),
                  subtitle: Text(
                    "Username: ${userProvider.username ?? '-'}\nRole: ${userProvider.role ?? '-'}",
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                "Tip",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage all book-related content directly from the 'Books' tab for full control over library records.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required int tabIndex,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.arrow_forward_ios),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: () => _navigateToTab(context, tabIndex),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

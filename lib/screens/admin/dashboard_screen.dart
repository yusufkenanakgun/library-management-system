import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/books.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/borrowed_provider.dart';
import 'book_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? activeList;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final borrowedProvider = context.watch<BorrowedProvider>();

    final allBooks = books;
    final borrowedBooks = borrowedProvider.borrowedBooks;
    final availableBooks =
        books.where((book) {
          return !borrowedBooks.any((b) => b['title'] == book['title']);
        }).toList();
    final favoriteBooks = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard(
              context,
              title: "Total Books",
              value: allBooks.length.toString(),
              icon: Icons.menu_book,
              color: Colors.blue,
              onTap: () => setState(() => activeList = "all"),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              title: "Available Books",
              value: availableBooks.length.toString(),
              icon: Icons.book_outlined,
              color: Colors.teal,
              onTap: () => setState(() => activeList = "available"),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              title: "Total Favorites",
              value: favoriteBooks.length.toString(),
              icon: Icons.favorite,
              color: Colors.redAccent,
              onTap: () => setState(() => activeList = "favorites"),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              title: "Books Borrowed",
              value: borrowedBooks.length.toString(),
              icon: Icons.shopping_cart,
              color: Colors.green,
              onTap: () => setState(() => activeList = "borrowed"),
            ),
            const SizedBox(height: 20),
            if (activeList != null) ...[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search books...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (value) =>
                        setState(() => searchQuery = value.toLowerCase()),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildDetailList(
                  activeList!,
                  availableBooks,
                  favoriteBooks,
                  borrowedBooks,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(title),
          trailing: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailList(
    String type,
    List<Map<String, String>> availableBooks,
    List<Map<String, String>> favorites,
    List<Map<String, String>> borrowed,
  ) {
    if (type == "all") {
      return _buildSimpleList(books, "All Books");
    } else if (type == "available") {
      return _buildSimpleList(availableBooks, "Available Books");
    } else if (type == "favorites") {
      return _buildFavoritesWithTabs();
    } else if (type == "borrowed") {
      return _buildBorrowedList(borrowed);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSimpleList(List<Map<String, String>> list, String title) {
    final filteredList =
        list.where((book) {
          return book['title']!.toLowerCase().contains(searchQuery);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (_, i) {
              final book = filteredList[i];
              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(book['title'] ?? ''),
                subtitle: Text(book['author'] ?? ''),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminBookDetailScreen(book: book),
                      ),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesWithTabs() {
    final favoriteGrouped = <String, List<String>>{};

    for (var book in context.read<FavoritesProvider>().favorites) {
      final title = book['title']!;
      final user = book['favoritedBy'] ?? 'Unknown';

      if (!favoriteGrouped.containsKey(title)) {
        favoriteGrouped[title] = [];
      }
      favoriteGrouped[title]!.add(user);
    }

    final titles =
        favoriteGrouped.keys
            .where((t) => t.toLowerCase().contains(searchQuery))
            .toList();

    if (titles.isEmpty) {
      return const Text('No favorites found.');
    }

    return DefaultTabController(
      length: titles.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            labelColor: Colors.redAccent,
            tabs: titles.map((title) => Tab(text: title)).toList(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children:
                  titles.map((title) {
                    final users = favoriteGrouped[title]!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder:
                          (_, i) => ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(users[i]),
                          ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowedList(List<Map<String, String>> borrowedBooks) {
    final filtered =
        borrowedBooks.where((book) {
          return book['title']!.toLowerCase().contains(searchQuery);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Borrowed Books",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final book = filtered[i];
              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(book['title'] ?? ''),
                subtitle: Text(
                  "Borrowed by: ${book['borrowedBy'] ?? 'Unknown'}",
                ),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminBookDetailScreen(book: book),
                      ),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'borrowed_screen.dart';
import 'settings_screen.dart';
import 'recommended_books_screen.dart';
import 'reservations_screen.dart';
import 'notification_screen.dart'; // ✅ Eklendi
import 'user_profile_screen.dart';
import '../auth/login_screen.dart';
import 'help_screen.dart';
import '../../providers/book_provider.dart';
import '../../providers/user_provider.dart';

class UserBottomNav extends StatefulWidget {
  const UserBottomNav({super.key});

  @override
  State<UserBottomNav> createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final bookProvider = Provider.of<BookProvider>(context, listen: false);

      await userProvider.loadUser();

      final userIdStr = userProvider.userId;
      final userId = int.tryParse(userIdStr ?? '') ?? 0;

      await bookProvider.fetchBooks();
      await bookProvider.fetchRecommendedBooks(userId);
    });
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    BorrowedScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Drawer _buildDrawer(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            accountName: Text(user.fullName ?? "Yeditepe User"),
            accountEmail: Text(user.username ?? "No username found"),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _drawerItem(Icons.home, "Home", 0),
                _drawerItem(Icons.search, "Search Books", 1),
                _drawerItem(Icons.favorite, "Favorites", 2),
                _drawerItem(Icons.library_books, "My Borrowings", 3),
                _routeItem(Icons.bookmark, "My Reservations", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReservationsScreen(),
                    ),
                  );
                }),
                _routeItem(Icons.thumb_up, "Recommended Books", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecommendedBooksScreen(),
                    ),
                  );
                }),
                _drawerItem(Icons.settings, "Settings", 4),
                _routeItem(Icons.notifications, "Notifications", () {
                  // ✅ Bildirim menüsü
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text(
                        "Do you want to log out and return to login screen?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Coming soon...")));
              },
              child: const Text(
                "Privacy Policy of Yeditepe University",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        setState(() => _selectedIndex = index);
      },
    );
  }

  Widget _routeItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YURead"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: "Notifications",
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: "Help",
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),

      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Borrowed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

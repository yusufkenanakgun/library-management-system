import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'book_management_screen.dart';
import 'reports_screen.dart';
import 'user_management_screen.dart';
import 'settings_screen.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  static _AdminBottomNavState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AdminBottomNavState>();
  }

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _selectedIndex = 0;

  void setIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<Widget> _pages = const [
    DashboardScreen(),
    BookManagementScreen(),
    ReportsScreen(),
    UserManagementScreen(),
    SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YURead Admin Panel"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/admin-help');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: setIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Center(
              child: Text(
                "Admin Menu",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard", 0),
          _buildDrawerItem(Icons.book, "Books", 1),
          _buildDrawerItem(Icons.bar_chart, "Reports", 2),
          _buildDrawerItem(Icons.people, "Users", 3),
          _buildDrawerItem(Icons.settings, "Settings", 4),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Do you want to log out?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          child: const Text("Log Out"),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blueAccent.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context);
        setIndex(index);
      },
    );
  }
}

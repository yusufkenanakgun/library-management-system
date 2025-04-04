import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'book_management_screen.dart';
import 'reports_screen.dart';
import 'user_management_screen.dart';
import '../auth/login_screen.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const BookManagementScreen(),
    const ReportsScreen(),
    const UserManagementScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Center(
              child: Text(
                "Admin Panel",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context); // drawer'ı kapat
              setState(() => _selectedIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Manage Books"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Reports"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Users"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 3);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("You will be logged out."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text("Log Out"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YURead"), // Sabit başlık
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

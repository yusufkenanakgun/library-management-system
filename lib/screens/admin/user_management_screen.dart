import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  // 🔧 Geçici kullanıcı verisi (ileride backend'den alınacak)
  final List<Map<String, String>> users = const [
    {
      'name': 'Kaya Berk Karakelle',
      'email': 'kaya@example.com',
      'role': 'Admin',
    },
    {'name': 'Gamze Binici', 'email': 'gamze@example.com', 'role': 'User'},
    {'name': 'Ece Çarpıcı', 'email': 'ece@example.com', 'role': 'User'},
    {'name': 'Sipan Açar', 'email': 'sipan@example.com', 'role': 'User'},
    {'name': 'Berfin Özdemir', 'email': 'berfin@example.com', 'role': 'User'},
    {'name': 'Damla Tatlısu', 'email': 'damla@example.com', 'role': 'User'},
    {
      'name': 'Osman Furkan Bayram',
      'email': 'furkan@example.com',
      'role': 'User',
    },
    {'name': 'Yusuf Kenan Akgün', 'email': 'yusuf@example.com', 'role': 'User'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.white, // AppBar beyaz
        foregroundColor: Colors.black, // Yazı ve ikonlar siyah
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(user['name']!),
              subtitle: Text("${user['email']} - ${user['role']}"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Deleted ${user['name']}")),
                    );
                  } else if (value == 'edit') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Edit ${user['name']}")),
                    );
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(value: 'edit', child: Text("Edit")),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                    ],
              ),
            ),
          );
        },
      ),
    );
  }
}

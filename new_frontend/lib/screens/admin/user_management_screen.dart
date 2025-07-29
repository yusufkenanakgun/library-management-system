import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> _users = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final fetchedUsers = await AuthService.getAllUsers();
      setState(() {
        _users = fetchedUsers;
      });
    } catch (e) {
      print('Kullanıcıları çekerken hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _deleteUser(User user) async {
    final confirm = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Deletion"),
            content: Text("${user.fullName} adlı kullanıcı silinsin mi?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Sil"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await AuthService.deleteUser(user.username);
      if (success) {
        setState(() => _users.removeWhere((u) => u.username == user.username));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${user.fullName} silindi.")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Silme başarısız.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _users.where((user) {
          final query = _searchQuery.toLowerCase();
          return user.fullName.toLowerCase().contains(query) ||
              user.username.toLowerCase().contains(query) ||
              user.role.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged:
                          (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final user = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(user.fullName),
                            subtitle: Text("${user.username} - ${user.role}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
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

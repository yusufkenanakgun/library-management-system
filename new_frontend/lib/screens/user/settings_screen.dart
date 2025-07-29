import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../services/borrow_service.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';
import '../../constants/api_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final username = userProvider.username;

    if (username == null) return;

    try {
      // 1. Aktif borç kontrolü
      final userBorrows = await BorrowService.fetchUserBorrows(username);
      final activeBorrows =
          userBorrows.where((b) => b.actualReturnDate == null).toList();

      if (activeBorrows.isNotEmpty) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Cannot Delete Account"),
                content: const Text(
                  "You must return all borrowed books before deleting your account.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
        return;
      }

      // 2. Favorileri sil
      await http.delete(
        Uri.parse('${ApiConfig.favoriteBaseUrl}/user/$username'),
        headers: {'Authorization': 'Bearer ${await AuthService.getToken()}'},
      );

      // 3. Rezervasyonları sil
      await http.delete(
        Uri.parse('${ApiConfig.reservationBaseUrl}/user/$username'),
        headers: {'Authorization': 'Bearer ${await AuthService.getToken()}'},
      );

      // 4. Kullanıcıyı sil
      final success = await AuthService.deleteUser(username);
      if (success) {
        await AuthService.logout();
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deletion failed.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "General",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Enable Notifications"),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ),
          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text("Delete Account"),
            onTap: () => _deleteAccount(context),
          ),
          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Help & Legal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help & Support"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

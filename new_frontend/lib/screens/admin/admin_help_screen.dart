// 📄 admin_help_screen.dart
import 'package:flutter/material.dart';

class AdminHelpScreen extends StatelessWidget {
  const AdminHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Help"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            "🛠 About the Admin Panel",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "The Admin Panel allows authorized personnel to manage book records, view reports, and oversee user activity in the system. It is a crucial tool to ensure the library's digital inventory is up to date and organized.",
          ),
          SizedBox(height: 24),

          Text(
            "📦 Admin Capabilities",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "- View overall dashboard statistics\n- Manage book inventory (add, edit, remove)\n- View and export usage reports\n- See user data and interactions\n- Access settings for system behavior",
          ),
          SizedBox(height: 24),

          Text(
            "📈 Dashboard Explanation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "The dashboard displays statistics such as total books, available books, most favorited items, and borrowing trends. Each stat box can be tapped to view more details.",
          ),
          SizedBox(height: 24),

          Text(
            "📬 Support",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Need help? Contact: admin-support@yuread.com"),
        ],
      ),
    );
  }
}

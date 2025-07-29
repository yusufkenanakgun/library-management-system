// 📄 help_screen.dart
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Guide"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            "📚 About YURead",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "YURead is a digital library platform designed for university students and faculty. It provides access to physical and digital book records, borrowing features, favorites tracking, and more.",
          ),
          SizedBox(height: 24),

          Text(
            "👤 What Can a User Do?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "- Search for available books\n- Add books to favorites\n- Borrow books and view current borrowings\n- Make and manage reservations\n- View recommended books\n- Edit user profile and settings",
          ),
          SizedBox(height: 24),

          Text(
            "🔒 Account Types",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "There are two types of accounts: User and Admin. Users can browse and borrow books while Admins manage the book database and user records.",
          ),
          SizedBox(height: 24),

          Text(
            "🛠 Troubleshooting",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "If you encounter issues such as login errors or missing books, please contact the library support or check your internet connection.",
          ),
          SizedBox(height: 24),

          Text(
            "📞 Contact & Support",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("For help and feedback, reach out to: help@yuread.com"),
        ],
      ),
    );
  }
}

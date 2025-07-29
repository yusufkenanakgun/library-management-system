import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            Text(
              "🔐 Privacy Policy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "YURead is committed to protecting your personal data and privacy. All information collected through our application is stored securely and used solely for enhancing your library experience.",
            ),
            SizedBox(height: 16),
            Text(
              "📦 What Data We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "- Username, full name, and contact info\n"
              "- Borrowing history and preferences\n"
              "- Login session information (via JWT)",
            ),
            SizedBox(height: 16),
            Text(
              "🔍 How We Use Your Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "Your data is used to:\n"
              "- Personalize your experience\n"
              "- Track and manage borrowings\n"
              "- Ensure account security\n"
              "- Improve overall system performance",
            ),
            SizedBox(height: 16),
            Text(
              "🧾 Data Sharing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "YURead does not share your data with third parties. Your data will never be sold or exposed without your explicit consent.",
            ),
            SizedBox(height: 16),
            Text(
              "📬 Contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "If you have any concerns or questions about our privacy policy, please reach out to: privacy@yuread.com",
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                "By Yeditepe University",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

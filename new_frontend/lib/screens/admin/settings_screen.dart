import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Settings"),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notification Settings"),
            subtitle: Text("Manage email and app notifications."),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.backup),
            title: Text("System Backup"),
            subtitle: Text("Backup library data to secure storage."),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text("Security"),
            subtitle: Text("Password, 2FA and access control."),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          SwitchListTile(
            value: true,
            onChanged: (value) {},
            title: const Text("Enable Maintenance Mode"),
            secondary: const Icon(Icons.build),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationItem>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationService.fetchUserNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
      body: FutureBuilder<List<NotificationItem>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          final notifications = snapshot.data!;
          if (notifications.isEmpty) {
            return const Center(child: Text("📭 Hiç bildiriminiz yok."));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    notification.isRead
                        ? Icons.mark_email_read_outlined
                        : Icons.notifications_active,
                    color: notification.isRead ? Colors.grey : Colors.blue,
                  ),
                  title: Text(notification.message),
                  subtitle: Text(
                    notification.createdAt.toLocal().toString().split('.')[0],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

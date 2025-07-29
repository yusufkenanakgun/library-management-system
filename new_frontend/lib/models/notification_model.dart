class NotificationItem {
  final int id;
  final String username;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.username,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      username: json['username'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

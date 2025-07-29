import 'package:intl/intl.dart';

class Favorite {
  final int id;
  final String username;
  final String fullName;
  final String bookId;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.username,
    required this.fullName,
    required this.bookId,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    id: json['id'],
    username: json['username'],
    fullName: json['fullName'],
    bookId: json['bookId'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'bookId': bookId,
    'createdAt': createdAt.toIso8601String(),
  };

  String get formattedDate =>
      DateFormat('dd MMM yyyy – HH:mm').format(createdAt);
}

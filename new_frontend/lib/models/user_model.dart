import 'user_type.dart';

class User {
  final int id;
  final String username;
  final String role;
  final String fullName;
  final String phoneNumber;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.fullName,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    role: json['role'],
    fullName: json['fullName'],
    phoneNumber: json['phoneNumber'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'role': role,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  };

  /// 🔄 Enum uyumluluğu
  UserType get userType => role == 'admin' ? UserType.admin : UserType.user;

  bool get isAdmin => userType == UserType.admin;
  bool get isUser => userType == UserType.user;
}

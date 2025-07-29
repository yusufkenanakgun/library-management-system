class UserRegisterDto {
  final String username;
  final String password;
  final String fullName;
  final String phoneNumber;
  final String role;

  UserRegisterDto({
    required this.username,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'role': role,
  };

  String? validate() {
    if (username.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        phoneNumber.isEmpty) {
      return 'Tüm alanlar doldurulmalı.';
    }
    if (password.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    if (!phoneNumber.contains(RegExp(r'^[0-9+\- ]+$'))) {
      return 'Telefon numarası geçerli değil.';
    }
    return null;
  }
}

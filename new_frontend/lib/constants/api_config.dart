class ApiConfig {
  static const String baseIp = 'localhost'; // veya bilgisayarın IP'si

  static const String authBaseUrl = '$baseIp:8080/api/auth';
  static const String bookBaseUrl = '$baseIp:8081/api/books';
  static const String borrowBaseUrl = '$baseIp:8082/api/borrow';
  static const String reservationBaseUrl = '$baseIp:8084/api/reservation';
  static const String favoriteBaseUrl = '$baseIp:8083/api/favorite';
  static const String notificationBaseUrl = '$baseIp:8086/api/notification';
} //http://34.38.21.220

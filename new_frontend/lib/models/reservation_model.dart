class Reservation {
  final int id;
  final String username;
  final String fullName;
  final String bookId;
  final DateTime reservationDate;
  final DateTime expirationDate;
  final int borrowDurationInWeeks;

  Reservation({
    required this.id,
    required this.username,
    required this.fullName,
    required this.bookId,
    required this.reservationDate,
    required this.expirationDate,
    required this.borrowDurationInWeeks,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json['id'],
    username: json['username'],
    fullName: json['fullName'] ?? '',
    bookId: json['bookId'].toString(),
    reservationDate:
        DateTime.tryParse(json['reservationDate'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    expirationDate:
        DateTime.tryParse(json['expirationDate'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    borrowDurationInWeeks: json['borrowDurationInWeeks'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'bookId': bookId,
    'reservationDate': reservationDate.toIso8601String(),
    'expirationDate': expirationDate.toIso8601String(),
    'borrowDurationInWeeks': borrowDurationInWeeks,
  };

  bool get isExpired => DateTime.now().isAfter(expirationDate);

  factory Reservation.empty() => Reservation(
    id: 0,
    username: '',
    fullName: '',
    bookId: '',
    reservationDate: DateTime.fromMillisecondsSinceEpoch(0),
    expirationDate: DateTime.fromMillisecondsSinceEpoch(0),
    borrowDurationInWeeks: 0,
  );

  Reservation copyWith({
    int? id,
    String? username,
    String? fullName,
    String? bookId,
    DateTime? reservationDate,
    DateTime? expirationDate,
    int? borrowDurationInWeeks,
  }) {
    return Reservation(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      bookId: bookId ?? this.bookId,
      reservationDate: reservationDate ?? this.reservationDate,
      expirationDate: expirationDate ?? this.expirationDate,
      borrowDurationInWeeks:
          borrowDurationInWeeks ?? this.borrowDurationInWeeks,
    );
  }
}

class ReservationWithEta {
  final int id;
  final String username;
  final String bookId;
  final DateTime reservationDate;
  final int borrowDurationInWeeks;
  final int estimatedWaitDays;

  ReservationWithEta({
    required this.id,
    required this.username,
    required this.bookId,
    required this.reservationDate,
    required this.borrowDurationInWeeks,
    required this.estimatedWaitDays,
  });

  factory ReservationWithEta.fromJson(Map<String, dynamic> json) =>
      ReservationWithEta(
        id: json['id'],
        username: json['username'],
        bookId: json['bookId'].toString(),
        reservationDate:
            DateTime.tryParse(json['reservationDate'] ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        borrowDurationInWeeks: json['borrowDurationInWeeks'] ?? 0,
        estimatedWaitDays: json['estimatedWaitDays'] ?? 0,
      );
}

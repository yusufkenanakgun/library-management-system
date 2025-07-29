class Borrow {
  final int id;
  final String username;
  final String fullName;
  final String bookId;
  final DateTime borrowDate;
  final DateTime expectedReturnDate;
  final DateTime? actualReturnDate;
  final int borrowDurationInWeeks;

  Borrow({
    required this.id,
    required this.username,
    required this.fullName,
    required this.bookId,
    required this.borrowDate,
    required this.expectedReturnDate,
    this.actualReturnDate,
    this.borrowDurationInWeeks = 2,
  });

  factory Borrow.fromJson(Map<String, dynamic> json) => Borrow(
    id: json['id'],
    username: json['username'],
    fullName: json['fullName'],
    bookId: json['bookId'].toString(),
    borrowDate: DateTime.parse(json['borrowDate']),
    expectedReturnDate: DateTime.parse(json['expectedReturnDate']),
    actualReturnDate:
        json['actualReturnDate'] != null
            ? DateTime.parse(json['actualReturnDate'])
            : null,
    borrowDurationInWeeks: json['borrowDurationInWeeks'] ?? 2,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'bookId': bookId,
    'borrowDate': borrowDate.toIso8601String(),
    'expectedReturnDate': expectedReturnDate.toIso8601String(),
    'actualReturnDate': actualReturnDate?.toIso8601String(),
    'borrowDurationInWeeks': borrowDurationInWeeks,
  };

  bool get isReturned => actualReturnDate != null;

  Borrow copyWith({
    int? id,
    String? username,
    String? fullName,
    String? bookId,
    DateTime? borrowDate,
    DateTime? expectedReturnDate,
    DateTime? actualReturnDate,
    int? borrowDurationInWeeks,
  }) {
    return Borrow(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      bookId: bookId ?? this.bookId,
      borrowDate: borrowDate ?? this.borrowDate,
      expectedReturnDate: expectedReturnDate ?? this.expectedReturnDate,
      actualReturnDate: actualReturnDate ?? this.actualReturnDate,
      borrowDurationInWeeks:
          borrowDurationInWeeks ?? this.borrowDurationInWeeks,
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final bool isAvailable;
  final String image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.isAvailable,
    required this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'].toString(),
    title: json['title'] ?? '',
    author: json['author'] ?? '',
    description: json['description'] ?? '',
    isAvailable: json['isAvailable'] ?? true,
    image: json['image'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'description': description,
    'isAvailable': isAvailable,
    'image': image,
  };

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    bool? isAvailable,
    String? image,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      image: image ?? this.image,
    );
  }
}

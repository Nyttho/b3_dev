// models/universe.dart
class Universe {
  final dynamic id; // Accepte String ou int
  final String name;
  final String? description;
  final String? image;
  final int characterCount;
  final String? createdAt;
  final String? updatedAt;

  Universe({
    required this.id,
    required this.name,
    this.description = '',
    this.image,
    this.characterCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      characterCount: json['characterCount'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

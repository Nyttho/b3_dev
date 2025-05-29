// models/character.dart
class Character {
  final dynamic id;
  final dynamic universeId;
  final String name;
  final String? description;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Character({
    required this.id,
    required this.universeId,
    required this.name,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      universeId: json['universeId'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

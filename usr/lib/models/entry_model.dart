import 'dart:convert';

class Entry {
  int? id;
  String description;
  double rating;
  String solution;
  DateTime createdAt;

  Entry({
    this.id,
    required this.description,
    required this.rating,
    required this.solution,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'rating': rating,
      'solution': solution,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id']?.toInt(),
      description: map['description'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      solution: map['solution'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  String toJson() {
    final map = toMap();
    // Don't include the id when creating a new entry, as the database will generate it.
    if (id == null) {
      map.remove('id');
    }
    return json.encode(map);
  }

  Map<String, dynamic> toJsonMap() {
    final map = toMap();
     if (id == null) {
      map.remove('id');
      map.remove('created_at');
    }
    return map;
  }

  factory Entry.fromJson(String source) => Entry.fromMap(json.decode(source));
}

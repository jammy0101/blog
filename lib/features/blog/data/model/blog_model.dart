import 'package:blog/features/blog/domain/entites/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
  });


  /// ✅ Convert Blog → Map (for Firestore, Supabase, etc.)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(), // store as String
    };
  }

  /// ✅ Create Blog from Map/JSON
  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []), // safe conversion
      updatedAt: map['updated_at'] == null ? DateTime.now() : DateTime.parse(map['updated_at']), // parse ISO8601 string
    );
  }
}

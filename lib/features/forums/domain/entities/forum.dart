import 'package:equatable/equatable.dart';

class Forum extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isPublic;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? postsCount;
  final int? membersCount;
  final Map<String, dynamic>? creator;

  const Forum({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isPublic,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.postsCount,
    this.membersCount,
    this.creator,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      isPublic: json['is_public'] ?? true,
      createdBy: json['created_by'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'] ?? json['created_at']),
      postsCount: _extractCount(json['posts_count']),
      membersCount: _extractCount(json['members_count']),
      creator: json['creator'] as Map<String, dynamic>?,
    );
  }

  static int? _extractCount(dynamic countData) {
    if (countData is int) return countData;
    if (countData is List && countData.isNotEmpty) {
      final count = countData.first;
      return count['count'] as int?;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'is_public': isPublic,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'posts_count': postsCount,
      'members_count': membersCount,
      'creator': creator,
    };
  }

  Forum copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    bool? isPublic,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? postsCount,
    int? membersCount,
    Map<String, dynamic>? creator,
  }) {
    return Forum(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isPublic: isPublic ?? this.isPublic,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postsCount: postsCount ?? this.postsCount,
      membersCount: membersCount ?? this.membersCount,
      creator: creator ?? this.creator,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        isPublic,
        createdBy,
        createdAt,
        updatedAt,
        postsCount,
        membersCount,
        creator,
      ];
}
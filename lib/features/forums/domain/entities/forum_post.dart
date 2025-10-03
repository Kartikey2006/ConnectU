import 'package:equatable/equatable.dart';
import 'forum.dart';

class ForumPost extends Equatable {
  final String id;
  final String forumId;
  final String authorId;
  final String title;
  final String content;
  final String? imagePath;
  final int likesCount;
  final int repliesCount;
  final int viewsCount;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? author;
  final Forum? forum;

  const ForumPost({
    required this.id,
    required this.forumId,
    required this.authorId,
    required this.title,
    required this.content,
    this.imagePath,
    required this.likesCount,
    required this.repliesCount,
    required this.viewsCount,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    this.author,
    this.forum,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'].toString(),
      forumId: json['forum_id'].toString(),
      authorId:
          json['author_id']?.toString() ?? json['user_id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imagePath: json['image_path'],
      likesCount: json['likes_count'] ?? 0,
      repliesCount: _extractCount(json['replies_count']),
      viewsCount: json['views_count'] ?? 0,
      isPinned: json['is_pinned'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'] ?? json['created_at']),
      author: json['author'] as Map<String, dynamic>?,
      forum: json['forum'] != null ? Forum.fromJson(json['forum']) : null,
    );
  }

  static int _extractCount(dynamic countData) {
    if (countData is int) return countData;
    if (countData is List && countData.isNotEmpty) {
      final count = countData.first;
      return count['count'] as int? ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'forum_id': forumId,
      'author_id': authorId,
      'title': title,
      'content': content,
      'image_path': imagePath,
      'likes_count': likesCount,
      'replies_count': repliesCount,
      'views_count': viewsCount,
      'is_pinned': isPinned,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author': author,
      'forum': forum?.toJson(),
    };
  }

  ForumPost copyWith({
    String? id,
    String? forumId,
    String? authorId,
    String? title,
    String? content,
    String? imagePath,
    int? likesCount,
    int? repliesCount,
    int? viewsCount,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? author,
    Forum? forum,
  }) {
    return ForumPost(
      id: id ?? this.id,
      forumId: forumId ?? this.forumId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      forum: forum ?? this.forum,
    );
  }

  @override
  List<Object?> get props => [
        id,
        forumId,
        authorId,
        title,
        content,
        imagePath,
        likesCount,
        repliesCount,
        viewsCount,
        isPinned,
        createdAt,
        updatedAt,
        author,
        forum,
      ];
}

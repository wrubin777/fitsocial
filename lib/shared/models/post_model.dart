import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String? userProfileImage;
  final String content;
  final List<String> imageUrls;
  final String? workoutId;
  final List<String> likes;
  final List<Map<String, dynamic>> comments;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userProfileImage,
    required this.content,
    this.imageUrls = const [],
    this.workoutId,
    this.likes = const [],
    this.comments = const [],
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return PostModel(
      id: id ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfileImage: map['userProfileImage'],
      content: map['content'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      workoutId: map['workoutId'],
      likes: List<String>.from(map['likes'] ?? []),
      comments: List<Map<String, dynamic>>.from(map['comments'] ?? []),
      createdAt: map['createdAt'] != null 
        ? (map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.parse(map['createdAt']))
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'content': content,
      'imageUrls': imageUrls,
      'workoutId': workoutId,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userProfileImage,
    String? content,
    List<String>? imageUrls,
    String? workoutId,
    List<String>? likes,
    List<Map<String, dynamic>>? comments,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      workoutId: workoutId ?? this.workoutId,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

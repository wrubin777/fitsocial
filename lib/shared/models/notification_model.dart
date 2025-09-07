class NotificationModel {
  final String id;
  final String type; // 'like', 'follow', 'comment', 'workout_saved', 'achievement'
  final String fromUserId;
  final String fromUsername;
  final String? fromUserProfileImage;
  final String message;
  final String? relatedId; // ID of related post, workout, etc.
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.fromUserId,
    required this.fromUsername,
    this.fromUserProfileImage,
    required this.message,
    this.relatedId,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? type,
    String? fromUserId,
    String? fromUsername,
    String? fromUserProfileImage,
    String? message,
    String? relatedId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUsername: fromUsername ?? this.fromUsername,
      fromUserProfileImage: fromUserProfileImage ?? this.fromUserProfileImage,
      message: message ?? this.message,
      relatedId: relatedId ?? this.relatedId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fromUserId': fromUserId,
      'fromUsername': fromUsername,
      'fromUserProfileImage': fromUserProfileImage,
      'message': message,
      'relatedId': relatedId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      fromUserId: json['fromUserId'],
      fromUsername: json['fromUsername'],
      fromUserProfileImage: json['fromUserProfileImage'],
      message: json['message'],
      relatedId: json['relatedId'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }
}

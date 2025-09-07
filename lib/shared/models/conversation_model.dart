
class ConversationModel {
  final String id;
  final List<String> participantIds;
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final Map<String, bool> readStatus; // userId -> isRead
  final Map<String, DateTime> lastSeen; // userId -> lastSeenAt
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? name; // For group chats
  final String? imageUrl; // For group chats

  ConversationModel({
    required this.id,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageAt,
    required this.readStatus,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.name,
    this.imageUrl,
  });

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] ?? '',
      participantIds: List<String>.from(map['participantIds'] ?? []),
      lastMessageId: map['lastMessageId'],
      lastMessageAt: map['lastMessageAt'] != null 
        ? (map['lastMessageAt'] is DateTime 
          ? map['lastMessageAt'] 
          : DateTime.parse(map['lastMessageAt'])) 
        : null,
      readStatus: Map<String, bool>.from(map['readStatus'] ?? {}),
      lastSeen: map['lastSeen'] != null 
        ? Map<String, DateTime>.from(
            (map['lastSeen'] as Map).map(
              (key, value) => MapEntry(
                key.toString(),
                value is DateTime ? value : DateTime.parse(value.toString()),
              ),
            ),
          )
        : {},
      createdAt: map['createdAt'] != null 
        ? (map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.parse(map['createdAt'])) 
        : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
        ? (map['updatedAt'] is DateTime 
          ? map['updatedAt'] 
          : DateTime.parse(map['updatedAt'])) 
        : DateTime.now(),
      isActive: map['isActive'] ?? true,
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'readStatus': readStatus,
      'lastSeen': lastSeen.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  ConversationModel copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessageId,
    DateTime? lastMessageAt,
    Map<String, bool>? readStatus,
    Map<String, DateTime>? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? name,
    String? imageUrl,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      readStatus: readStatus ?? this.readStatus,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Helper methods
  bool isUnreadForUser(String userId) {
    return readStatus[userId] == false;
  }

  String getOtherParticipantId(String currentUserId) {
    return participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => participantIds.first,
    );
  }

  bool isGroupChat() {
    return participantIds.length > 2;
  }
}

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isRead;
  final String? replyToMessageId;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.replyToMessageId,
    this.metadata,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      conversationId: map['conversationId'] ?? '',
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${map['type']}',
        orElse: () => MessageType.text,
      ),
      createdAt: map['createdAt'] != null 
        ? (map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.parse(map['createdAt'])) 
        : DateTime.now(),
      isRead: map['isRead'] ?? false,
      replyToMessageId: map['replyToMessageId'],
      metadata: map['metadata'] != null 
        ? Map<String, dynamic>.from(map['metadata']) 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'replyToMessageId': replyToMessageId,
      'metadata': metadata,
    };
  }

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    bool? isRead,
    String? replyToMessageId,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum MessageType {
  text,
  image,
  workout,
  post,
  system,
}

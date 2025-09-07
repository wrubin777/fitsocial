import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final ConversationModel conversation;
  final UserModel otherUser;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.otherUser,
    required this.currentUserId,
  });
  
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Mock messages for this conversation
  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() {
    // Mock messages for the conversation
    _messages = [
      MessageModel(
        id: 'msg1',
        conversationId: widget.conversation.id,
        senderId: widget.otherUser.id,
        content: 'Hey! How was your workout today?',
        type: MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      MessageModel(
        id: 'msg2',
        conversationId: widget.conversation.id,
        senderId: widget.currentUserId,
        content: 'It was amazing! I hit a new PR on deadlifts 💪',
        type: MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      MessageModel(
        id: 'msg3',
        conversationId: widget.conversation.id,
        senderId: widget.otherUser.id,
        content: 'That\'s awesome! What weight did you lift?',
        type: MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      MessageModel(
        id: 'msg4',
        conversationId: widget.conversation.id,
        senderId: widget.currentUserId,
        content: '315 lbs! I\'ve been working on my form and it really paid off',
        type: MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        isRead: true,
      ),
      MessageModel(
        id: 'msg5',
        conversationId: widget.conversation.id,
        senderId: widget.otherUser.id,
        content: 'Incredible! I\'m still working on getting to 225. Any tips?',
        type: MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ];
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final newMessage = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: widget.conversation.id,
      senderId: widget.currentUserId,
      content: content,
      type: MessageType.text,
      createdAt: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    _scrollToBottom();

    // In a real app, you would send this message to the server
    // messageService.sendMessage(newMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isCurrentUser = message.senderId == widget.currentUserId;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.darkGrey,
              backgroundImage: widget.otherUser.profileImageUrl != null
                  ? NetworkImage(widget.otherUser.profileImageUrl!)
                  : null,
              child: widget.otherUser.profileImageUrl == null
                  ? Text(
                      widget.otherUser.displayName?.isNotEmpty == true
                          ? widget.otherUser.displayName![0].toUpperCase()
                          : widget.otherUser.username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCurrentUser ? AppTheme.accentColor : AppTheme.darkGrey,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isCurrentUser 
                      ? const Radius.circular(20) 
                      : const Radius.circular(4),
                  bottomRight: isCurrentUser 
                      ? const Radius.circular(4) 
                      : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.black : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMessageTime(message.createdAt),
                    style: TextStyle(
                      color: isCurrentUser 
                          ? Colors.black.withOpacity(0.6) 
                          : Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.accentColor,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.darkGrey,
              backgroundImage: widget.otherUser.profileImageUrl != null
                  ? NetworkImage(widget.otherUser.profileImageUrl!)
                  : null,
              child: widget.otherUser.profileImageUrl == null
                  ? Text(
                      widget.otherUser.displayName?.isNotEmpty == true
                          ? widget.otherUser.displayName![0].toUpperCase()
                          : widget.otherUser.username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUser.displayName ?? widget.otherUser.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.otherUser.bio ?? 'Active now',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              AppUtils.showSnackBar(context, 'Video call coming soon!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              AppUtils.showSnackBar(context, 'Voice call coming soon!');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  AppUtils.showSnackBar(context, 'Viewing ${widget.otherUser.username}\'s profile');
                  break;
                case 'block':
                  AppUtils.showSnackBar(context, 'Block user feature coming soon!');
                  break;
                case 'report':
                  AppUtils.showSnackBar(context, 'Report user feature coming soon!');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block),
                    SizedBox(width: 8),
                    Text('Block User'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report),
                    SizedBox(width: 8),
                    Text('Report User'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              border: Border(
                top: BorderSide(
                  color: AppTheme.darkGrey,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    AppUtils.showSnackBar(context, 'Attachment options coming soon!');
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkGrey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

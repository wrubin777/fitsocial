import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/message_model.dart';
import '../../shared/widgets/common_widgets.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Mock data - in a real app, this would come from a service/provider
  final String _currentUserId = 'currentUser';
  
  final List<ConversationModel> _conversations = [
    ConversationModel(
      id: 'conv1',
      participantIds: ['currentUser', 'user1'],
      lastMessageId: 'msg1',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)),
      readStatus: {'currentUser': true, 'user1': false},
      lastSeen: {
        'currentUser': DateTime.now().subtract(const Duration(minutes: 5)),
        'user1': DateTime.now().subtract(const Duration(minutes: 2)),
      },
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isActive: true,
    ),
    ConversationModel(
      id: 'conv2',
      participantIds: ['currentUser', 'user2'],
      lastMessageId: 'msg2',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
      readStatus: {'currentUser': false, 'user2': true},
      lastSeen: {
        'currentUser': DateTime.now().subtract(const Duration(hours: 2)),
        'user2': DateTime.now().subtract(const Duration(minutes: 30)),
      },
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      isActive: true,
    ),
    ConversationModel(
      id: 'conv3',
      participantIds: ['currentUser', 'user3'],
      lastMessageId: 'msg3',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      readStatus: {'currentUser': true, 'user3': true},
      lastSeen: {
        'currentUser': DateTime.now().subtract(const Duration(hours: 1)),
        'user3': DateTime.now().subtract(const Duration(days: 1)),
      },
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
    ),
  ];

  final Map<String, UserModel> _users = {
    'user1': UserModel(
      id: 'user1',
      username: 'john_fitness',
      email: 'john@example.com',
      displayName: 'John Fitness',
      bio: 'Fitness enthusiast and personal trainer',
      profileImageUrl: null,
      followers: [],
      following: [],
      workouts: [],
      savedWorkouts: [],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      stats: {},
    ),
    'user2': UserModel(
      id: 'user2',
      username: 'maria_fit',
      email: 'maria@example.com',
      displayName: 'Maria Fit',
      bio: 'Morning workout lover',
      profileImageUrl: null,
      followers: [],
      following: [],
      workouts: [],
      savedWorkouts: [],
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      stats: {},
    ),
    'user3': UserModel(
      id: 'user3',
      username: 'fitness_guru',
      email: 'guru@example.com',
      displayName: 'Fitness Guru',
      bio: 'Transformation specialist',
      profileImageUrl: null,
      followers: [],
      following: [],
      workouts: [],
      savedWorkouts: [],
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
      stats: {},
    ),
  };

  final Map<String, MessageModel> _lastMessages = {
    'msg1': MessageModel(
      id: 'msg1',
      conversationId: 'conv1',
      senderId: 'user1',
      content: 'Hey! How was your workout today?',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    'msg2': MessageModel(
      id: 'msg2',
      conversationId: 'conv2',
      senderId: 'user2',
      content: 'Thanks for the workout tips! They really helped 💪',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    'msg3': MessageModel(
      id: 'msg3',
      conversationId: 'conv3',
      senderId: 'user3',
      content: 'Check out my latest transformation post!',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  };

  void _navigateToChat(ConversationModel conversation) {
    final otherUserId = conversation.getOtherParticipantId(_currentUserId);
    final otherUser = _users[otherUserId];
    
    if (otherUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            conversation: conversation,
            otherUser: otherUser,
            currentUserId: _currentUserId,
          ),
        ),
      ).then((_) {
        // Refresh conversations when returning from chat
        setState(() {
          // In a real app, you would refresh from the service
        });
      });
    }
  }

  void _startNewConversation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Start New Conversation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // In a real app, this would show a list of users to message
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search users...'),
              onTap: () {
                Navigator.pop(context);
                AppUtils.showSnackBar(context, 'User search coming soon!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Message a follower'),
              onTap: () {
                Navigator.pop(context);
                AppUtils.showSnackBar(context, 'Follower list coming soon!');
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastMessageTime(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Messages',
          style: AppTheme.headerAltStyle.copyWith(
            fontSize: 26,
            color: AppTheme.accentColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _startNewConversation,
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? const AppEmptyState(
              message: 'No conversations yet. Start a conversation with someone!',
              icon: Icons.message_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                final otherUserId = conversation.getOtherParticipantId(_currentUserId);
                final otherUser = _users[otherUserId];
                final lastMessage = conversation.lastMessageId != null 
                    ? _lastMessages[conversation.lastMessageId!] 
                    : null;
                final isUnread = conversation.isUnreadForUser(_currentUserId);
                
                if (otherUser == null) return const SizedBox.shrink();
                
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.darkGrey,
                    backgroundImage: otherUser.profileImageUrl != null
                        ? NetworkImage(otherUser.profileImageUrl!)
                        : null,
                    child: otherUser.profileImageUrl == null
                        ? Text(
                            otherUser.displayName?.isNotEmpty == true
                                ? otherUser.displayName![0].toUpperCase()
                                : otherUser.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentColor,
                            ),
                          )
                        : null,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherUser.displayName ?? otherUser.username,
                          style: TextStyle(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                            color: isUnread ? AppTheme.accentColor : null,
                          ),
                        ),
                      ),
                      if (conversation.lastMessageAt != null)
                        Text(
                          _formatLastMessageTime(conversation.lastMessageAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnread ? AppTheme.accentColor : AppTheme.lightGrey,
                          ),
                        ),
                    ],
                  ),
                  subtitle: lastMessage != null
                      ? Row(
                          children: [
                            Expanded(
                              child: Text(
                                lastMessage.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isUnread ? AppTheme.accentColor : AppTheme.lightGrey,
                                  fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        )
                      : null,
                  onTap: () => _navigateToChat(conversation),
                );
              },
            ),
    );
  }
}

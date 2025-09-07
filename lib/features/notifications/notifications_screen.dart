import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/notification_model.dart';
import '../../shared/widgets/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications data - in a real app, this would come from an API or service
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      type: 'like',
      fromUserId: 'user2',
      fromUsername: 'maria_fit',
      fromUserProfileImage: null,
      message: 'liked your workout "Morning HIIT Routine"',
      relatedId: 'workout1',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      type: 'follow',
      fromUserId: 'user3',
      fromUsername: 'fitness_guru',
      fromUserProfileImage: null,
      message: 'started following you',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      type: 'comment',
      fromUserId: 'user4',
      fromUsername: 'gym_buddy',
      fromUserProfileImage: null,
      message: 'commented on your post: "Great workout routine! 💪"',
      relatedId: 'post1',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      type: 'workout_saved',
      fromUserId: 'user5',
      fromUsername: 'cardio_queen',
      fromUserProfileImage: null,
      message: 'saved your workout "Leg Day Blast"',
      relatedId: 'workout2',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      type: 'achievement',
      fromUserId: 'system',
      fromUsername: 'FitBud',
      fromUserProfileImage: null,
      message: 'Congratulations! You\'ve completed 10 workouts this month! 🏆',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      type: 'like',
      fromUserId: 'user6',
      fromUsername: 'strength_trainer',
      fromUserProfileImage: null,
      message: 'liked your post about your fitness journey',
      relatedId: 'post2',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTheme.headerAltStyle.copyWith(fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const AppEmptyState(
              message: 'No notifications yet.',
              icon: Icons.notifications_none_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.transparent : AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? Colors.transparent : AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildNotificationIcon(notification),
        title: Text(
          notification.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
              ),
        ),
        subtitle: Row(
          children: [
            Text(
              '@${notification.fromUsername}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              AppUtils.formatRelativeTime(notification.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightGrey,
                  ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationModel notification) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'like':
        iconData = FontAwesomeIcons.solidHeart;
        iconColor = Colors.red;
        break;
      case 'follow':
        iconData = FontAwesomeIcons.userPlus;
        iconColor = AppTheme.accentColor;
        break;
      case 'comment':
        iconData = FontAwesomeIcons.comment;
        iconColor = AppTheme.primaryColor;
        break;
      case 'workout_saved':
        iconData = FontAwesomeIcons.bookmark;
        iconColor = Colors.orange;
        break;
      case 'achievement':
        iconData = FontAwesomeIcons.trophy;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.lightGrey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read if not already read
    if (!notification.isRead) {
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = notification.copyWith(isRead: true);
        }
      });
    }

    // Handle navigation based on notification type
    switch (notification.type) {
      case 'like':
      case 'comment':
        if (notification.relatedId != null) {
          // Navigate to post or workout details
          AppUtils.showSnackBar(context, 'Navigating to ${notification.type}...');
        }
        break;
      case 'follow':
        // Navigate to user profile
        AppUtils.showSnackBar(context, 'Navigating to @${notification.fromUsername}\'s profile...');
        break;
      case 'workout_saved':
        if (notification.relatedId != null) {
          // Navigate to workout details
          AppUtils.showSnackBar(context, 'Navigating to saved workout...');
        }
        break;
      case 'achievement':
        // Navigate to achievements screen
        AppUtils.showSnackBar(context, 'Navigating to achievements...');
        break;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
      }
    });
    AppUtils.showSnackBar(context, 'All notifications marked as read');
  }
}

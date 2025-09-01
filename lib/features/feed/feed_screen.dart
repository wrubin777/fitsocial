import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/post_model.dart';
import '../../shared/widgets/feed_widgets.dart';
import '../../shared/widgets/common_widgets.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This would be replaced with actual data from a provider or API
    final List<PostModel> mockPosts = [
      PostModel(
        id: '1',
        userId: 'user1',
        username: 'john_fitness',
        userProfileImage: null,
        content: 'Just finished an intense leg day workout! 💪 Feeling the burn but it\'s worth it. #legday #fitness #nopainnogain',
        imageUrls: [],
        workoutId: 'workout1',
        likes: ['user2', 'user3'],
        comments: [
          {'userId': 'user2', 'username': 'maria_fit', 'text': 'Great job! Keep pushing!', 'createdAt': DateTime.now().toString()}
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostModel(
        id: '2',
        userId: 'user2',
        username: 'maria_fit',
        userProfileImage: null,
        content: 'Morning cardio session complete! Starting the day with some endorphins.',
        imageUrls: [],
        likes: [],
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'FitBud',
          style: AppTheme.headerAltStyle.copyWith(
            fontSize: 26,
            color: AppTheme.accentColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.solidPaperPlane),
            onPressed: () {
              // Navigate to messages screen
            },
          ),
        ],
      ),
      body: mockPosts.isEmpty
          ? const AppEmptyState(
              message: 'No posts yet. Follow some users to see their posts here.',
              icon: Icons.feed_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: mockPosts.length,
              itemBuilder: (context, index) {
                final post = mockPosts[index];
                return FeedPostCard(
                  post: post,
                  onLike: (postId) {
                    // Like functionality would go here
                  },
                  onComment: (postId) {
                    // Comment functionality would go here
                  },
                  onShare: (postId) {
                    // Share functionality would go here
                  },
                  onUserTap: () {
                    // Navigate to user profile
                  },
                  onWorkoutTap: post.workoutId != null
                      ? () {
                          // Navigate to workout details
                        }
                      : null,
                );
              },
            ),
    );
  }
}

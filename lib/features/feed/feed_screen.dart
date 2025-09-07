import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/post_model.dart';
import '../../shared/widgets/feed_widgets.dart';
import '../../shared/widgets/common_widgets.dart';
import 'post_details_screen.dart';
import '../messages/messages_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // This would be replaced with actual data from a provider or API
  final List<PostModel> _mockPosts = [
    PostModel(
      id: '1',
      userId: 'user1',
      username: 'john_fitness',
      userProfileImage: null,
      content: 'Just finished an intense leg day workout! 💪 Feeling the burn but it\'s worth it. #legday #fitness #nopainnogain',
      imageUrls: [],
      workoutId: 'workout1',
      category: 'Workout',
      hashtags: ['#legday', '#fitness', '#nopainnogain'],
      location: 'Gym',
      isPublic: true,
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
      content: 'Morning cardio session complete! Starting the day with some endorphins. #morningworkout #cardio #motivation',
      imageUrls: [],
      category: 'Progress',
      hashtags: ['#morningworkout', '#cardio', '#motivation'],
      isPublic: true,
      likes: [],
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: '3',
      userId: 'user3',
      username: 'fitness_guru',
      userProfileImage: null,
      content: 'Check out this amazing transformation! 6 months of consistent training and proper nutrition. #transformation #fitness #motivation',
      imageUrls: ['https://example.com/before.jpg', 'https://example.com/after.jpg'],
      category: 'Progress',
      hashtags: ['#transformation', '#fitness', '#motivation'],
      isPublic: true,
      likes: ['user1', 'user2', 'user4'],
      comments: [
        {'userId': 'user1', 'username': 'john_fitness', 'text': 'Incredible progress! 🔥', 'createdAt': DateTime.now().toString()}
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  
  // Current user ID (would come from auth service in a real app)
  final String _currentUserId = 'currentUser';

  // Handle liking a post
  void _handleLike(String postId) {
    setState(() {
      final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
      if (postIndex >= 0) {
        final post = _mockPosts[postIndex];
        List<String> updatedLikes = List.from(post.likes);
        
        if (updatedLikes.contains(_currentUserId)) {
          // Unlike if already liked
          updatedLikes.remove(_currentUserId);
        } else {
          // Like if not already liked
          updatedLikes.add(_currentUserId);
        }
        
        // Update the post with new likes
        _mockPosts[postIndex] = post.copyWith(likes: updatedLikes);
        
        // In a real app, you would also update the database
        // postService.toggleLike(postId, _currentUserId);
        
        // Show feedback
        AppUtils.showSnackBar(
          context, 
          updatedLikes.contains(_currentUserId) ? 'Post liked' : 'Post unliked'
        );
      }
    });
  }

  // Handle commenting on a post
  void _handleComment(String postId) {
    // Find the post
    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex >= 0) {
      final post = _mockPosts[postIndex];
      
      // Navigate to post details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailsScreen(post: post),
        ),
      ).then((updatedPost) {
        // Handle updated post data when returning from details screen
        if (updatedPost is PostModel) {
          setState(() {
            _mockPosts[postIndex] = updatedPost;
          });
        }
      });
    }
  }

  // Handle sharing a post
  void _handleShare(String postId) {
    // Find the post (used for real sharing in a production app)
    final post = _mockPosts.firstWhere(
      (p) => p.id == postId,
      orElse: () => _mockPosts.first,
    );
    
    // Show a snackbar with the post's content (just for debugging)
    print('Sharing post: ${post.content}');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Post',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareOption(
                  context,
                  icon: FontAwesomeIcons.instagram,
                  label: 'Instagram',
                  onTap: () {
                    Navigator.pop(context);
                    AppUtils.showSnackBar(context, 'Sharing to Instagram...');
                  },
                ),
                _shareOption(
                  context,
                  icon: FontAwesomeIcons.twitter,
                  label: 'Twitter',
                  onTap: () {
                    Navigator.pop(context);
                    AppUtils.showSnackBar(context, 'Sharing to Twitter...');
                  },
                ),
                _shareOption(
                  context,
                  icon: FontAwesomeIcons.facebookF,
                  label: 'Facebook',
                  onTap: () {
                    Navigator.pop(context);
                    AppUtils.showSnackBar(context, 'Sharing to Facebook...');
                  },
                ),
                _shareOption(
                  context,
                  icon: Icons.message_outlined,
                  label: 'Message',
                  onTap: () {
                    Navigator.pop(context);
                    AppUtils.showSnackBar(context, 'Sharing via Message...');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                AppUtils.showSnackBar(context, 'Link copied to clipboard');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _shareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.darkGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              AppUtils.showSnackBar(context, 'Search feature coming soon!');
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.solidPaperPlane),
            onPressed: () {
              // Navigate to messages screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _mockPosts.isEmpty
          ? const AppEmptyState(
              message: 'No posts yet. Follow some users to see their posts here.',
              icon: Icons.feed_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: _mockPosts.length,
              itemBuilder: (context, index) {
                final post = _mockPosts[index];
                return FeedPostCard(
                  post: post,
                  onLike: _handleLike,
                  onComment: _handleComment,
                  onShare: _handleShare,
                  onUserTap: () {
                    // Navigate to user profile
                    AppUtils.showSnackBar(context, 'Viewing ${post.username}\'s profile');
                  },
                  onWorkoutTap: post.workoutId != null
                      ? () {
                          // Navigate to workout details
                          AppUtils.showSnackBar(context, 'Viewing linked workout');
                        }
                      : null,
                );
              },
            ),
    );
  }
}


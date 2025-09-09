import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/post_model.dart';
import '../../shared/services/posts_store.dart';
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
  final PostsStore _postsStore = PostsStore.instance;
  
  // Current user ID (would come from auth service in a real app)
  final String _currentUserId = 'currentUser';

  // Handle liking a post
  void _handleLike(String postId) {
    _postsStore.likePost(postId, _currentUserId);
    setState(() {}); // Trigger rebuild to show updated likes
    
    // Show feedback
    final post = _postsStore.getPostById(postId);
    if (post != null) {
      AppUtils.showSnackBar(
        context, 
        post.likes.contains(_currentUserId) ? 'Post liked' : 'Post unliked'
      );
    }
  }

  // Handle commenting on a post
  void _handleComment(String postId) {
    final post = _postsStore.getPostById(postId);
    if (post != null) {
      // Navigate to post details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailsScreen(post: post),
        ),
      ).then((updatedPost) {
        // Handle updated post data when returning from details screen
        if (updatedPost is PostModel) {
          _postsStore.updatePost(updatedPost);
          setState(() {}); // Trigger rebuild
        }
      });
    }
  }

  // Handle sharing a post
  void _handleShare(String postId) {
    // Find the post (used for real sharing in a production app)
    final post = _postsStore.getPostById(postId);
    if (post == null) return;
    
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
      body: _postsStore.posts.isEmpty
          ? const AppEmptyState(
              message: 'No posts yet. Follow some users to see their posts here.',
              icon: Icons.feed_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: _postsStore.posts.length,
              itemBuilder: (context, index) {
                final post = _postsStore.posts[index];
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


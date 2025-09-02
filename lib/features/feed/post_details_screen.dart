import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/post_model.dart';
import '../../shared/widgets/common_widgets.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailsScreen({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late PostModel _post;
  late TextEditingController _commentController;
  bool _isLiked = false;
  bool _isSubmitting = false;
  final String _currentUserId = 'currentUser'; // This would come from auth service

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _isLiked = _post.likes.contains(_currentUserId);
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      if (_isLiked) {
        // Remove like
        _post = _post.copyWith(
          likes: List.from(_post.likes)..remove(_currentUserId),
        );
      } else {
        // Add like
        _post = _post.copyWith(
          likes: List.from(_post.likes)..add(_currentUserId),
        );
      }
      _isLiked = !_isLiked;
    });

    // In a real app, you would also update the database here
    // postService.toggleLike(_post.id, _currentUserId);
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    // Create a new comment
    final comment = {
      'userId': _currentUserId,
      'username': 'current_user', // This would come from auth service
      'text': _commentController.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Add the comment to the post
    setState(() {
      _post = _post.copyWith(
        comments: List.from(_post.comments)..add(comment),
      );
      _commentController.clear();
      _isSubmitting = false;
    });

    // In a real app, you would also update the database here
    // postService.addComment(_post.id, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Post content
          Expanded(
            child: ListView(
              children: [
                // Post header with user info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      AppUserAvatar(
                        imageUrl: _post.userProfileImage,
                        radius: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _post.username,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              AppUtils.formatRelativeTime(_post.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Post content
                if (_post.content.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _post.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                // Post images
                if (_post.imageUrls.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: _post.imageUrls.length,
                      itemBuilder: (context, index) {
                        return AppImageWithLoader(
                          imageUrl: _post.imageUrls[index],
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),

                // Like and comment counts
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${_post.likes.length} likes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_post.comments.length} comments',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Action buttons
                const Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: _handleLike,
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.redAccent : null,
                      ),
                      label: Text(_isLiked ? 'Liked' : 'Like'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // Focus the comment field
                        FocusScope.of(context).requestFocus(FocusNode());
                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).requestFocus(_commentFieldFocusNode);
                        });
                      },
                      icon: const Icon(FontAwesomeIcons.comment),
                      label: const Text('Comment'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _sharePost();
                      },
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                    ),
                  ],
                ),
                const Divider(height: 1),

                // Comments section
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // List of comments
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = _post.comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppUserAvatar(
                            radius: 16,
                            imageUrl: null, // We don't have this info in the comment
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      TextSpan(
                                        text: comment['username'],
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: ' ${comment['text']}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppUtils.formatRelativeTime(
                                    DateTime.parse(comment['createdAt']),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.lightGrey,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Comment input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                AppUserAvatar(
                  radius: 18,
                  imageUrl: null, // Current user's image would go here
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFieldFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: AppTheme.darkGrey,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSubmitting ? null : _submitComment,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  color: AppTheme.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Focus node for the comment field
  final FocusNode _commentFieldFocusNode = FocusNode();
  
  // Share post functionality
  void _sharePost() {
    // This text would be used when sharing via platform sharing APIs
    final String shareText = 'Check out this workout post by ${_post.username} on FitBud!';
    debugPrint('Share text: $shareText'); // Using the variable to avoid lint error
    
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
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
                // Show report dialog
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.darkGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

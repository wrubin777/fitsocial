import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/post_model.dart';
import '../../shared/models/workout_model.dart';
import '../../core/utils/app_utils.dart';
import 'common_widgets.dart';

class FeedPostCard extends StatelessWidget {
  final PostModel post;
  final Function(String) onLike;
  final Function(String) onComment;
  final Function(String) onShare;
  final Function() onUserTap;
  final Function()? onWorkoutTap;

  const FeedPostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onUserTap,
    this.onWorkoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AppUserAvatar(
                  imageUrl: post.userProfileImage,
                  radius: 20,
                  onTap: onUserTap,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onUserTap,
                        child: Text(
                          post.username,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Text(
                        AppUtils.formatRelativeTime(post.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    // Show post options menu
                  },
                ),
              ],
            ),
          ),

          // Post content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                post.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

          // Post images
          if (post.imageUrls.isNotEmpty)
            AspectRatio(
              aspectRatio: 1.0,
              child: post.imageUrls.length == 1
                  ? AppImageWithLoader(
                      imageUrl: post.imageUrls.first,
                      borderRadius: BorderRadius.zero,
                    )
                  : GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: post.imageUrls
                          .take(4)
                          .map(
                            (url) => AppImageWithLoader(
                              imageUrl: url,
                              borderRadius: BorderRadius.zero,
                            ),
                          )
                          .toList(),
                    ),
            ),

          // Workout card if there's a linked workout
          if (post.workoutId != null && onWorkoutTap != null)
            InkWell(
              onTap: onWorkoutTap,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.darkGrey.withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.dumbbell,
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'View linked workout',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppTheme.accentColor,
                    ),
                  ],
                ),
              ),
            ),

          // Divider
          const Divider(height: 1),

          // Action buttons and stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like button
                TextButton.icon(
                  icon: Icon(
                    post.likes.isNotEmpty
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.likes.isNotEmpty ? Colors.redAccent : null,
                    size: 20,
                  ),
                  label: Text(
                    post.likes.isNotEmpty
                        ? AppUtils.formatCount(post.likes.length)
                        : 'Like',
                  ),
                  onPressed: () => onLike(post.id),
                ),
                // Comment button
                TextButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.comment,
                    size: 18,
                  ),
                  label: Text(
                    post.comments.isNotEmpty
                        ? AppUtils.formatCount(post.comments.length)
                        : 'Comment',
                  ),
                  onPressed: () => onComment(post.id),
                ),
                // Share button
                TextButton.icon(
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                  ),
                  label: const Text('Share'),
                  onPressed: () => onShare(post.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;
  final Function()? onTap;
  final Function()? onSave;
  final Function()? onLike;
  final bool isSaved;
  final bool isLiked;
  final bool showUser;
  final String? username;
  final String? userProfileImage;

  const WorkoutCard({
    Key? key,
    required this.workout,
    this.onTap,
    this.onSave,
    this.onLike,
    this.isSaved = false,
    this.isLiked = false,
    this.showUser = false,
    this.username,
    this.userProfileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Image with overlay
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: workout.imageUrls.isNotEmpty
                      ? AppImageWithLoader(
                          imageUrl: workout.imageUrls.first,
                          height: 160,
                          width: double.infinity,
                          borderRadius: BorderRadius.zero,
                        )
                      : Container(
                          height: 160,
                          width: double.infinity,
                          color: AppTheme.darkGrey,
                          child: const Icon(
                            FontAwesomeIcons.dumbbell,
                            size: 48,
                            color: Colors.white30,
                          ),
                        ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Title at bottom of image
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.title,
                        style: AppTheme.headerAltStyle.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Color.fromARGB(150, 0, 0, 0),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (showUser && username != null)
                        Row(
                          children: [
                            AppUserAvatar(
                              imageUrl: userProfileImage,
                              radius: 10,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              username!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Difficulty badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      workout.difficulty,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),

            // Workout info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      // Duration
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 16,
                            color: AppTheme.lightGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppUtils.formatDuration(workout.durationMinutes),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Exercise count
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.listUl,
                            size: 14,
                            color: AppTheme.lightGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${workout.exercises.length} exercises',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Category
                      Row(
                        children: [
                          const Icon(
                            Icons.category,
                            size: 16,
                            color: AppTheme.lightGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            workout.category,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description text
                  if (workout.description != null && workout.description!.isNotEmpty)
                    Text(
                      workout.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like button
                  if (onLike != null)
                    TextButton.icon(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.redAccent : null,
                        size: 20,
                      ),
                      label: Text(
                        workout.likes.isNotEmpty
                            ? AppUtils.formatCount(workout.likes.length)
                            : 'Like',
                      ),
                      onPressed: onLike,
                    ),
                  // Save button
                  if (onSave != null)
                    TextButton.icon(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? AppTheme.accentColor : null,
                        size: 20,
                      ),
                      label: Text(isSaved ? 'Saved' : 'Save'),
                      onPressed: onSave,
                    ),
                  const Spacer(),
                  // View details
                  TextButton.icon(
                    icon: const Icon(
                      Icons.visibility,
                      size: 20,
                    ),
                    label: const Text('View'),
                    onPressed: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

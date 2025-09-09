import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/workout_model.dart';
import '../../shared/services/posts_store.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/widgets/feed_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PostsStore _postsStore = PostsStore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Added Posts tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock user data - in a real app, this would come from auth service
  final UserModel _mockUser = UserModel(
    id: 'user1',
    username: 'fitness_warrior',
    email: 'user@example.com',
    displayName: 'Alex Johnson',
    bio: 'Fitness enthusiast | Personal Trainer | Sharing my fitness journey and helping others achieve their goals 💪',
    profileImageUrl: null,
    followers: ['user2', 'user3', 'user4'],
    following: ['user2', 'user5'],
    workouts: ['workout1', 'workout2'],
    savedWorkouts: ['workout3'],
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
    stats: {
      'workoutsCompleted': 125,
      'totalMinutes': 7500,
    },
  );

  // Mock workout data
  final List<WorkoutModel> _mockWorkouts = [
    WorkoutModel(
      id: 'workout1',
      userId: 'user1',
      title: 'Morning HIIT Routine',
      description: 'Quick but intense morning workout to start the day right.',
      category: 'HIIT',
      difficulty: 'Intermediate',
      durationMinutes: 30,
      exercises: [
        Exercise(
          name: 'Jumping Jacks',
          sets: 3,
          repsPerSet: 20,
        ),
        Exercise(
          name: 'Push-ups',
          sets: 3,
          repsPerSet: 15,
        ),
      ],
      imageUrls: [],
      likes: ['user2', 'user3'],
      saves: ['user4'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 320, // Increased height to prevent overflow
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      // Navigate to settings
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: SingleChildScrollView(
                    child: _buildProfileHeader(),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.accentColor,
                    unselectedLabelColor: AppTheme.lightGrey,
                    indicatorColor: AppTheme.accentColor,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on), text: 'Workouts'),
                      Tab(icon: Icon(Icons.photo_library), text: 'Posts'),
                      Tab(icon: Icon(FontAwesomeIcons.chartLine), text: 'Stats'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // Workouts tab
              _mockWorkouts.isEmpty
                  ? const AppEmptyState(
                      message: 'No workouts created yet.',
                      icon: Icons.fitness_center_outlined,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: _mockWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = _mockWorkouts[index];
                        return WorkoutCard(
                          workout: workout,
                          onTap: () {
                            // Navigate to workout details
                          },
                          onLike: () {
                            // Like functionality
                          },
                          onSave: () {
                            // Save functionality
                          },
                          isLiked: false,
                          isSaved: false,
                        );
                      },
                    ),

              // Posts tab
              _buildPostsTab(),

              // Stats tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsCard(),
                    const SizedBox(height: 16),
                    _buildAchievementsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: AppTheme.darkBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          AppUserAvatar(
            imageUrl: _mockUser.profileImageUrl,
            radius: 45, // Slightly smaller avatar
            showBorder: true,
          ),
          const SizedBox(height: 10),
          
          // Display name
          Text(
            _mockUser.displayName ?? _mockUser.username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          
          // Username
          Text(
            '@${_mockUser.username}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightGrey,
                ),
          ),
          
          // Bio
          if (_mockUser.bio != null && _mockUser.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 60), // Limit height
                child: Text(
                  _mockUser.bio!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Followers/Following count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn(_mockUser.workouts.length, 'Workouts'),
              Container(
                height: 24,
                width: 1,
                color: AppTheme.darkGrey,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              _buildStatColumn(_postsStore.getPostsCount(_mockUser.id), 'Posts'),
              Container(
                height: 24,
                width: 1,
                color: AppTheme.darkGrey,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              _buildStatColumn(_mockUser.followers.length, 'Followers'),
              Container(
                height: 24,
                width: 1,
                color: AppTheme.darkGrey,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              _buildStatColumn(_mockUser.following.length, 'Following'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Edit profile button
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to edit profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkGrey,
                foregroundColor: Colors.white,
              ),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    final stats = _mockUser.stats;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Stats',
              style: AppTheme.headerAltStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatTile(
                  icon: FontAwesomeIcons.dumbbell,
                  value: stats['workoutsCompleted']?.toString() ?? '0',
                  label: 'Workouts',
                  color: AppTheme.primaryColor,
                ),
                _buildStatTile(
                  icon: Icons.timer,
                  value: AppUtils.formatDuration(stats['totalMinutes'] ?? 0),
                  label: 'Total Time',
                  color: AppTheme.accentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: AppTheme.headerAltStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            // This would be populated with actual achievements in a real app
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Complete workouts to earn achievements!',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    final userPosts = _postsStore.getPostsByUser(_mockUser.id);
    
    if (userPosts.isEmpty) {
      return const AppEmptyState(
        message: 'No posts yet. Create your first post to share your fitness journey!',
        icon: Icons.photo_library_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        return FeedPostCard(
          post: post,
          onLike: (postId) {
            _postsStore.likePost(postId, _mockUser.id);
            setState(() {}); // Trigger rebuild
          },
          onComment: (postId) {
            // Navigate to post details for commenting
            AppUtils.showSnackBar(context, 'Navigate to post details');
          },
          onShare: (postId) {
            AppUtils.showSnackBar(context, 'Share post');
          },
          onUserTap: () {
            // Already on user's profile
          },
          onWorkoutTap: post.workoutId != null
              ? () {
                  AppUtils.showSnackBar(context, 'View linked workout');
                }
              : null,
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.darkBackground,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

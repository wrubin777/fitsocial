import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../shared/models/workout_model.dart';
import '../../shared/widgets/feed_widgets.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/services/workout_store.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final String _currentUserId = 'currentUser'; // This would come from auth service

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  // Listen to external tab requests (e.g., show My Workouts)
  WorkoutStore.instance.selectedTab.addListener(_onExternalTabRequest);
  }

  @override
  void dispose() {
    WorkoutStore.instance.selectedTab.removeListener(_onExternalTabRequest);
    _tabController.dispose();
    super.dispose();
  }

  void _onExternalTabRequest() {
    final requested = WorkoutStore.instance.selectedTab.value;
    if (_tabController.index != requested && requested >= 0 && requested < 3) {
      // Avoid calling setState synchronously during layout/paint; schedule for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _tabController.index = requested;
          });
        }
      });
    }
  }

  // Toggle save state of a workout
  void _toggleSaveWorkout(String workoutId) {
    setState(() {
      final workouts = store.workouts.value;
      final workoutIndex = workouts.indexWhere((w) => w.id == workoutId);
      if (workoutIndex != -1) {
        final workout = workouts[workoutIndex];
        final List<String> updatedSaves = List.from(workout.saves);

        if (updatedSaves.contains(_currentUserId)) {
          updatedSaves.remove(_currentUserId);
        } else {
          updatedSaves.add(_currentUserId);
        }

        final updated = WorkoutModel(
          id: workout.id,
          userId: workout.userId,
          title: workout.title,
          description: workout.description,
          category: workout.category,
          difficulty: workout.difficulty,
          durationMinutes: workout.durationMinutes,
          exercises: workout.exercises,
          imageUrls: workout.imageUrls,
          likes: workout.likes,
          saves: updatedSaves,
          createdAt: workout.createdAt,
        );

        store.updateWorkout(updated);
      }
    });
  }

  // Mock data - in a real app, this would come from an API or database
  // Use WorkoutStore for centralized, observable workouts list
  final store = WorkoutStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workouts',
          style: AppTheme.headerAltStyle.copyWith(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to workout search screen
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          labelColor: AppTheme.accentColor,
          unselectedLabelColor: AppTheme.lightGrey,
          indicatorColor: AppTheme.accentColor,
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'Saved'),
            Tab(text: 'My Workouts'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category filter chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('All'),
                  ...AppConstants.workoutCategories
                      .map((category) => _buildCategoryChip(category))
                      ,
                ],
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Discover / Saved / My Workouts driven by the store
                ValueListenableBuilder<List<WorkoutModel>>(
                  valueListenable: store.workouts,
                  builder: (context, workouts, _) {
                    return _buildWorkoutList(workouts);
                  },
                ),

                ValueListenableBuilder<List<WorkoutModel>>(
                  valueListenable: store.workouts,
                  builder: (context, workouts, _) {
                    final saved = workouts.where((workout) => workout.saves.contains(_currentUserId)).toList();
                    return _buildWorkoutList(saved, isSavedTab: true);
                  },
                ),

                ValueListenableBuilder<List<WorkoutModel>>(
                  valueListenable: store.workouts,
                  builder: (context, workouts, _) {
                    final mine = workouts.where((w) => w.userId == _currentUserId).toList();
                    if (mine.isEmpty) {
                      return const AppEmptyState(
                        message: 'You haven\'t created any workouts yet.',
                        icon: Icons.fitness_center_outlined,
                      );
                    }
                    return _buildWorkoutList(mine);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        showCheckmark: false,
        backgroundColor: AppTheme.darkGrey,
        selectedColor: AppTheme.primaryColor.withOpacity(0.7),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.lightGrey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildWorkoutList(List<WorkoutModel> workouts, {bool isSavedTab = false}) {
    if (workouts.isEmpty) {
      return AppEmptyState(
        message: isSavedTab 
            ? 'You haven\'t saved any workouts yet.' 
            : 'No workouts found.',
        icon: isSavedTab ? Icons.bookmark_outline : Icons.fitness_center_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return WorkoutCard(
          workout: workout,
          onTap: () {
            // Navigate to workout details
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Workout details coming soon!')),
            );
          },
          onLike: () {
            // Like functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Like feature coming soon!')),
            );
          },
          onSave: () {
            // Save functionality
            _toggleSaveWorkout(workout.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  workout.saves.contains(_currentUserId) 
                      ? 'Workout removed from saved' 
                      : 'Workout saved successfully'
                ),
              ),
            );
          },
          isLiked: workout.likes.contains(_currentUserId),
          isSaved: workout.saves.contains(_currentUserId),
          showUser: true,
          username: 'username', // This would be fetched in a real app
          userProfileImage: null,
        );
      },
    );
  }
}

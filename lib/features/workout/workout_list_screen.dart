import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../shared/models/workout_model.dart';
import '../../shared/widgets/feed_widgets.dart';
import '../../shared/widgets/common_widgets.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Toggle save state of a workout
  void _toggleSaveWorkout(String workoutId) {
    setState(() {
      final workoutIndex = _mockWorkouts.indexWhere((w) => w.id == workoutId);
      if (workoutIndex != -1) {
        final workout = _mockWorkouts[workoutIndex];
        final List<String> updatedSaves = List.from(workout.saves);
        
        if (updatedSaves.contains(_currentUserId)) {
          // Unsave workout
          updatedSaves.remove(_currentUserId);
        } else {
          // Save workout
          updatedSaves.add(_currentUserId);
        }

        // Update the workout in the list with new saves list
        _mockWorkouts[workoutIndex] = WorkoutModel(
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

        // In a real app, this would be a call to a service
        // workoutService.toggleSave(workoutId, _currentUserId);
      }
    });
  }

  // Mock data - in a real app, this would come from an API or database
  final List<WorkoutModel> _mockWorkouts = [
    WorkoutModel(
      id: '1',
      userId: 'user1',
      title: 'Full Body HIIT',
      description: 'High intensity interval training workout that targets all major muscle groups.',
      category: 'HIIT',
      difficulty: 'Intermediate',
      durationMinutes: 45,
      exercises: [
        Exercise(
          name: 'Burpees',
          sets: 3,
          repsPerSet: 15,
          muscleGroup: 'Full Body',
        ),
        Exercise(
          name: 'Mountain Climbers',
          sets: 3,
          repsPerSet: 20,
          muscleGroup: 'Core',
        ),
      ],
      imageUrls: [],
      likes: ['user2', 'user3'],
      saves: ['user4'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    WorkoutModel(
      id: '2',
      userId: 'user2',
      title: 'Upper Body Strength',
      description: 'Build upper body strength with this comprehensive workout routine.',
      category: 'Strength Training',
      difficulty: 'Advanced',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Bench Press',
          sets: 4,
          repsPerSet: 10,
          muscleGroup: 'Chest',
        ),
        Exercise(
          name: 'Pull-ups',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Back',
        ),
      ],
      imageUrls: [],
      likes: ['user1'],
      saves: [],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

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
                // Discover Tab
                _buildWorkoutList(_mockWorkouts),
                
                // Saved Tab
                _buildWorkoutList(
                  _mockWorkouts.where((workout) => workout.saves.contains(_currentUserId)).toList(),
                  isSavedTab: true,
                ),
                
                // My Workouts Tab
                const AppEmptyState(
                  message: 'You haven\'t created any workouts yet.',
                  icon: Icons.fitness_center_outlined,
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

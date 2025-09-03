import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutStore {
  WorkoutStore._internal() {
    // initialize with some mock data
    workouts.value = [
      WorkoutModel(
        id: '1',
        userId: 'user1',
        title: 'Full Body HIIT',
        description: 'High intensity interval training workout that targets all major muscle groups.',
        category: 'HIIT',
        difficulty: 'Intermediate',
        durationMinutes: 45,
        exercises: [
          Exercise(name: 'Burpees', sets: 3, repsPerSet: 15, muscleGroup: 'Full Body'),
          Exercise(name: 'Mountain Climbers', sets: 3, repsPerSet: 20, muscleGroup: 'Core'),
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
          Exercise(name: 'Bench Press', sets: 4, repsPerSet: 10, muscleGroup: 'Chest'),
          Exercise(name: 'Pull-ups', sets: 4, repsPerSet: 8, muscleGroup: 'Back'),
        ],
        imageUrls: [],
        likes: ['user1'],
        saves: [],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  static final WorkoutStore instance = WorkoutStore._internal();

  /// Observable list of workouts
  final ValueNotifier<List<WorkoutModel>> workouts = ValueNotifier<List<WorkoutModel>>([]);

  /// Notifier to request the workout screen to show a particular tab (0=Discover,1=Saved,2=My Workouts)
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);

  void addWorkout(WorkoutModel workout) {
    workouts.value = [workout, ...workouts.value];
  }

  void updateWorkout(WorkoutModel workout) {
    final idx = workouts.value.indexWhere((w) => w.id == workout.id);
    if (idx == -1) return;
    final newList = [...workouts.value];
    newList[idx] = workout;
    workouts.value = newList;
  }
}

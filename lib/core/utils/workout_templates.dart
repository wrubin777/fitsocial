import '../../shared/models/workout_model.dart';

/// Predefined workout templates that users can select as a starting point
class WorkoutTemplates {
  // Unique identifier for template types
  static const String upperLower = 'upper_lower';
  static const String pushPullLegs = 'push_pull_legs';
  static const String fullBody = 'full_body';
  static const String cardio = 'cardio';
  static const String hiit = 'hiit';
  static const String yoga = 'yoga';
  
  // Get all available templates
  static List<WorkoutTemplate> getAllTemplates() {
    return [
      getUpperDayTemplate(),
      getLowerDayTemplate(),
      getPushDayTemplate(),
      getPullDayTemplate(),
      getLegDayTemplate(),
      getFullBodyTemplate(),
      getHIITTemplate(),
      getCardioTemplate(),
    ];
  }
  
  // Upper body workout template
  static WorkoutTemplate getUpperDayTemplate() {
    return WorkoutTemplate(
      type: upperLower,
      name: 'Upper Body Day',
      description: 'Focus on chest, back, shoulders and arms.',
      category: 'Strength Training',
      difficulty: 'Intermediate',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Bench Press',
          instructions: 'Lie on bench with feet on ground. Lower bar to chest and press back up.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Chest',
          equipment: 'Barbell, Bench',
        ),
        Exercise(
          name: 'Pull-Ups',
          instructions: 'Grip bar with hands wider than shoulder width. Pull body up until chin over bar.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Back',
          equipment: 'Pull-Up Bar',
        ),
        Exercise(
          name: 'Seated Dumbbell Press',
          instructions: 'Sit on bench with back support. Press dumbbells overhead.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Shoulders',
          equipment: 'Dumbbells, Bench',
        ),
        Exercise(
          name: 'Bicep Curls',
          instructions: 'Stand with dumbbells at sides. Curl weights upward rotating wrists.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Dumbbells',
        ),
        Exercise(
          name: 'Tricep Pushdowns',
          instructions: 'Stand facing cable machine. Push rope or bar downward extending arms fully.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Cable Machine',
        ),
        Exercise(
          name: 'Face Pulls',
          instructions: 'Pull rope attachment toward face with elbows high.',
          sets: 3,
          repsPerSet: 15,
          muscleGroup: 'Shoulders',
          equipment: 'Cable Machine',
        ),
      ],
    );
  }
  
  // Lower body workout template
  static WorkoutTemplate getLowerDayTemplate() {
    return WorkoutTemplate(
      type: upperLower,
      name: 'Lower Body Day',
      description: 'Focus on quads, hamstrings, glutes and calves.',
      category: 'Strength Training',
      difficulty: 'Intermediate',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Barbell Squats',
          instructions: 'Place bar on upper back. Bend knees to lower body, then stand back up.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Legs',
          equipment: 'Barbell, Squat Rack',
        ),
        Exercise(
          name: 'Romanian Deadlifts',
          instructions: 'Hold bar at hip level. Bend at hips while keeping back straight until stretch is felt.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Legs',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Leg Press',
          instructions: 'Sit in leg press machine. Press platform away by extending knees.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Legs',
          equipment: 'Leg Press Machine',
        ),
        Exercise(
          name: 'Walking Lunges',
          instructions: 'Step forward into lunge position, then bring back leg forward to step into next lunge.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Legs',
          equipment: 'Dumbbells (Optional)',
        ),
        Exercise(
          name: 'Leg Extensions',
          instructions: 'Sit in machine with pads on lower shins. Extend legs to straight position.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Legs',
          equipment: 'Leg Extension Machine',
        ),
        Exercise(
          name: 'Standing Calf Raises',
          instructions: 'Stand on edge of platform. Raise heels as high as possible, then lower.',
          sets: 4,
          repsPerSet: 15,
          muscleGroup: 'Legs',
          equipment: 'Calf Raise Machine or Step',
        ),
      ],
    );
  }
  
  // Push day workout template
  static WorkoutTemplate getPushDayTemplate() {
    return WorkoutTemplate(
      type: pushPullLegs,
      name: 'Push Day',
      description: 'Focus on chest, shoulders and triceps.',
      category: 'Strength Training',
      difficulty: 'Intermediate',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Incline Bench Press',
          instructions: 'Lie on incline bench. Lower bar to upper chest and press back up.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Chest',
          equipment: 'Barbell, Incline Bench',
        ),
        Exercise(
          name: 'Seated Shoulder Press',
          instructions: 'Sit with back supported. Press dumbbells overhead until arms are extended.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Shoulders',
          equipment: 'Dumbbells, Bench',
        ),
        Exercise(
          name: 'Dumbbell Chest Flyes',
          instructions: 'Lie on bench holding dumbbells above chest. Lower weights out to sides in arc motion.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Chest',
          equipment: 'Dumbbells, Bench',
        ),
        Exercise(
          name: 'Lateral Raises',
          instructions: 'Stand holding dumbbells at sides. Raise arms out to sides to shoulder height.',
          sets: 3,
          repsPerSet: 15,
          muscleGroup: 'Shoulders',
          equipment: 'Dumbbells',
        ),
        Exercise(
          name: 'Tricep Dips',
          instructions: 'Support body on parallel bars. Lower body by bending arms, then push back up.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Arms',
          equipment: 'Parallel Bars or Bench',
        ),
        Exercise(
          name: 'Overhead Tricep Extension',
          instructions: 'Hold weight behind head with both hands. Raise until arms fully extended.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Dumbbell or Cable',
        ),
      ],
    );
  }
  
  // Pull day workout template
  static WorkoutTemplate getPullDayTemplate() {
    return WorkoutTemplate(
      type: pushPullLegs,
      name: 'Pull Day',
      description: 'Focus on back and biceps.',
      category: 'Strength Training',
      difficulty: 'Intermediate',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Barbell Rows',
          instructions: 'Bend at hips holding barbell. Pull bar to lower chest keeping back straight.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Back',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Lat Pulldowns',
          instructions: 'Sit at pulldown machine. Pull bar down to upper chest.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Back',
          equipment: 'Cable Machine',
        ),
        Exercise(
          name: 'Seated Cable Rows',
          instructions: 'Sit at row machine with knees bent. Pull handle to torso keeping back straight.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Back',
          equipment: 'Cable Machine',
        ),
        Exercise(
          name: 'Barbell Bicep Curls',
          instructions: 'Stand with barbell at thighs. Curl weight upward while keeping elbows fixed.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Hammer Curls',
          instructions: 'Stand with dumbbells at sides with palms facing inward. Curl weights keeping palms neutral.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Dumbbells',
        ),
        Exercise(
          name: 'Reverse Flyes',
          instructions: 'Bend at hips holding dumbbells. Raise arms out to sides keeping elbows slightly bent.',
          sets: 3,
          repsPerSet: 15,
          muscleGroup: 'Shoulders',
          equipment: 'Dumbbells',
        ),
      ],
    );
  }
  
  // Leg day workout template
  static WorkoutTemplate getLegDayTemplate() {
    return WorkoutTemplate(
      type: pushPullLegs,
      name: 'Leg Day',
      description: 'Focus on quadriceps, hamstrings, glutes and calves.',
      category: 'Strength Training',
      difficulty: 'Intermediate',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Back Squats',
          instructions: 'Rest barbell on upper back. Bend knees to lower body, then stand back up.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Legs',
          equipment: 'Barbell, Squat Rack',
        ),
        Exercise(
          name: 'Deadlifts',
          instructions: 'Stand with bar over feet. Bend to grab bar, then drive hips forward to stand up.',
          sets: 4,
          repsPerSet: 8,
          muscleGroup: 'Legs',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Bulgarian Split Squats',
          instructions: 'Place one foot behind on bench. Lower back knee toward floor, then push back up.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Legs',
          equipment: 'Dumbbells, Bench',
        ),
        Exercise(
          name: 'Lying Leg Curls',
          instructions: 'Lie face down on machine. Curl legs up by bending knees.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Legs',
          equipment: 'Leg Curl Machine',
        ),
        Exercise(
          name: 'Hip Thrusts',
          instructions: 'Sit with upper back against bench. Lift hips until body forms straight line.',
          sets: 3,
          repsPerSet: 12,
          muscleGroup: 'Glutes',
          equipment: 'Barbell, Bench',
        ),
        Exercise(
          name: 'Seated Calf Raises',
          instructions: 'Sit with weight on knees. Raise heels as high as possible, then lower.',
          sets: 4,
          repsPerSet: 15,
          muscleGroup: 'Legs',
          equipment: 'Calf Raise Machine',
        ),
      ],
    );
  }
  
  // Full body workout template
  static WorkoutTemplate getFullBodyTemplate() {
    return WorkoutTemplate(
      type: fullBody,
      name: 'Full Body Workout',
      description: 'Complete workout targeting all major muscle groups.',
      category: 'Strength Training',
      difficulty: 'Intermediate',
      durationMinutes: 60,
      exercises: [
        Exercise(
          name: 'Barbell Squats',
          instructions: 'Place bar on upper back. Bend knees to lower body, then stand back up.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Legs',
          equipment: 'Barbell, Squat Rack',
        ),
        Exercise(
          name: 'Bench Press',
          instructions: 'Lie on bench with feet on ground. Lower bar to chest and press back up.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Chest',
          equipment: 'Barbell, Bench',
        ),
        Exercise(
          name: 'Bent Over Rows',
          instructions: 'Bend at hips holding barbell. Pull bar to lower chest keeping back straight.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Back',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Overhead Press',
          instructions: 'Stand holding barbell at shoulders. Press weight overhead until arms extended.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Shoulders',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Romanian Deadlifts',
          instructions: 'Hold bar at hip level. Bend at hips while keeping back straight until stretch is felt.',
          sets: 3,
          repsPerSet: 10,
          muscleGroup: 'Legs',
          equipment: 'Barbell',
        ),
        Exercise(
          name: 'Dumbbell Curls',
          instructions: 'Stand with dumbbells at sides. Curl weights upward rotating wrists.',
          sets: 2,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Dumbbells',
        ),
        Exercise(
          name: 'Tricep Pushdowns',
          instructions: 'Stand facing cable machine. Push bar downward extending arms fully.',
          sets: 2,
          repsPerSet: 12,
          muscleGroup: 'Arms',
          equipment: 'Cable Machine',
        ),
      ],
    );
  }
  
  // HIIT workout template
  static WorkoutTemplate getHIITTemplate() {
    return WorkoutTemplate(
      type: hiit,
      name: 'HIIT Workout',
      description: 'High intensity interval training to burn fat and improve conditioning.',
      category: 'HIIT',
      difficulty: 'Advanced',
      durationMinutes: 30,
      exercises: [
        Exercise(
          name: 'Burpees',
          instructions: 'Start standing, drop to floor, perform push-up, jump back to standing, jump up with hands overhead.',
          sets: 4,
          repsPerSet: 15,
          muscleGroup: 'Full Body',
          equipment: 'None',
        ),
        Exercise(
          name: 'Mountain Climbers',
          instructions: 'Start in push-up position. Alternately bring knees toward chest in running motion.',
          sets: 4,
          repsPerSet: 30,
          muscleGroup: 'Core',
          equipment: 'None',
        ),
        Exercise(
          name: 'Jump Squats',
          instructions: 'Perform squat, then jump explosively. Land softly and repeat.',
          sets: 4,
          repsPerSet: 20,
          muscleGroup: 'Legs',
          equipment: 'None',
        ),
        Exercise(
          name: 'Kettlebell Swings',
          instructions: 'Bend at hips with kettlebell between legs. Thrust hips forward to swing weight up to shoulder height.',
          sets: 4,
          repsPerSet: 20,
          muscleGroup: 'Full Body',
          equipment: 'Kettlebell',
        ),
        Exercise(
          name: 'Box Jumps',
          instructions: 'Stand before box. Jump onto box, stand fully, then step down and repeat.',
          sets: 4,
          repsPerSet: 12,
          muscleGroup: 'Legs',
          equipment: 'Plyo Box',
        ),
        Exercise(
          name: 'Battle Ropes',
          instructions: 'Hold rope ends. Create waves by rapidly raising and lowering arms alternately.',
          duration: '30 seconds',
          sets: 4,
          muscleGroup: 'Upper Body',
          equipment: 'Battle Ropes',
        ),
      ],
    );
  }
  
  // Cardio workout template
  static WorkoutTemplate getCardioTemplate() {
    return WorkoutTemplate(
      type: cardio,
      name: 'Cardio Session',
      description: 'Improve heart health and endurance.',
      category: 'Cardio',
      difficulty: 'Beginner',
      durationMinutes: 45,
      exercises: [
        Exercise(
          name: 'Treadmill Run/Walk',
          instructions: 'Begin with 5 min warm-up walk, then alternate 5 min jogging with 2 min walking recovery.',
          duration: '25 minutes',
          sets: 1,
          muscleGroup: 'Full Body',
          equipment: 'Treadmill',
        ),
        Exercise(
          name: 'Stationary Bike',
          instructions: 'Begin with 2 min easy pedaling, then alternate 1 min high intensity with 1 min recovery.',
          duration: '15 minutes',
          sets: 1,
          muscleGroup: 'Lower Body',
          equipment: 'Stationary Bike',
        ),
        Exercise(
          name: 'Jump Rope',
          instructions: 'Jump rope at steady pace, focusing on consistency rather than speed.',
          duration: '5 minutes',
          sets: 1,
          muscleGroup: 'Full Body',
          equipment: 'Jump Rope',
        ),
      ],
    );
  }
  
  // List of common exercises by muscle group
  static Map<String, List<Exercise>> getCommonExercisesByMuscleGroup() {
    return {
      'Chest': [
        Exercise(name: 'Bench Press', sets: 3, repsPerSet: 10, muscleGroup: 'Chest', equipment: 'Barbell, Bench'),
        Exercise(name: 'Incline Bench Press', sets: 3, repsPerSet: 10, muscleGroup: 'Chest', equipment: 'Barbell, Incline Bench'),
        Exercise(name: 'Decline Bench Press', sets: 3, repsPerSet: 10, muscleGroup: 'Chest', equipment: 'Barbell, Decline Bench'),
        Exercise(name: 'Dumbbell Bench Press', sets: 3, repsPerSet: 10, muscleGroup: 'Chest', equipment: 'Dumbbells, Bench'),
        Exercise(name: 'Dumbbell Flyes', sets: 3, repsPerSet: 12, muscleGroup: 'Chest', equipment: 'Dumbbells, Bench'),
        Exercise(name: 'Push-Ups', sets: 3, repsPerSet: 15, muscleGroup: 'Chest', equipment: 'None'),
        Exercise(name: 'Cable Crossovers', sets: 3, repsPerSet: 12, muscleGroup: 'Chest', equipment: 'Cable Machine'),
      ],
      'Back': [
        Exercise(name: 'Pull-Ups', sets: 3, repsPerSet: 8, muscleGroup: 'Back', equipment: 'Pull-Up Bar'),
        Exercise(name: 'Lat Pulldowns', sets: 3, repsPerSet: 10, muscleGroup: 'Back', equipment: 'Cable Machine'),
        Exercise(name: 'Barbell Rows', sets: 3, repsPerSet: 10, muscleGroup: 'Back', equipment: 'Barbell'),
        Exercise(name: 'Dumbbell Rows', sets: 3, repsPerSet: 10, muscleGroup: 'Back', equipment: 'Dumbbell, Bench'),
        Exercise(name: 'Seated Cable Rows', sets: 3, repsPerSet: 10, muscleGroup: 'Back', equipment: 'Cable Machine'),
        Exercise(name: 'T-Bar Rows', sets: 3, repsPerSet: 10, muscleGroup: 'Back', equipment: 'T-Bar Row Machine'),
      ],
      'Shoulders': [
        Exercise(name: 'Overhead Press', sets: 3, repsPerSet: 10, muscleGroup: 'Shoulders', equipment: 'Barbell'),
        Exercise(name: 'Seated Dumbbell Press', sets: 3, repsPerSet: 10, muscleGroup: 'Shoulders', equipment: 'Dumbbells, Bench'),
        Exercise(name: 'Lateral Raises', sets: 3, repsPerSet: 12, muscleGroup: 'Shoulders', equipment: 'Dumbbells'),
        Exercise(name: 'Front Raises', sets: 3, repsPerSet: 12, muscleGroup: 'Shoulders', equipment: 'Dumbbells'),
        Exercise(name: 'Reverse Flyes', sets: 3, repsPerSet: 12, muscleGroup: 'Shoulders', equipment: 'Dumbbells'),
        Exercise(name: 'Face Pulls', sets: 3, repsPerSet: 15, muscleGroup: 'Shoulders', equipment: 'Cable Machine'),
      ],
      'Arms': [
        Exercise(name: 'Barbell Curls', sets: 3, repsPerSet: 10, muscleGroup: 'Arms', equipment: 'Barbell'),
        Exercise(name: 'Dumbbell Curls', sets: 3, repsPerSet: 10, muscleGroup: 'Arms', equipment: 'Dumbbells'),
        Exercise(name: 'Hammer Curls', sets: 3, repsPerSet: 10, muscleGroup: 'Arms', equipment: 'Dumbbells'),
        Exercise(name: 'Preacher Curls', sets: 3, repsPerSet: 10, muscleGroup: 'Arms', equipment: 'Barbell, Preacher Bench'),
        Exercise(name: 'Tricep Pushdowns', sets: 3, repsPerSet: 12, muscleGroup: 'Arms', equipment: 'Cable Machine'),
        Exercise(name: 'Skull Crushers', sets: 3, repsPerSet: 10, muscleGroup: 'Arms', equipment: 'Barbell, Bench'),
        Exercise(name: 'Overhead Tricep Extension', sets: 3, repsPerSet: 12, muscleGroup: 'Arms', equipment: 'Dumbbell'),
        Exercise(name: 'Dips', sets: 3, repsPerSet: 10, muscleGroup: 'Arms', equipment: 'Dip Bars'),
      ],
      'Legs': [
        Exercise(name: 'Back Squats', sets: 3, repsPerSet: 10, muscleGroup: 'Legs', equipment: 'Barbell, Squat Rack'),
        Exercise(name: 'Front Squats', sets: 3, repsPerSet: 10, muscleGroup: 'Legs', equipment: 'Barbell, Squat Rack'),
        Exercise(name: 'Deadlifts', sets: 3, repsPerSet: 8, muscleGroup: 'Legs', equipment: 'Barbell'),
        Exercise(name: 'Romanian Deadlifts', sets: 3, repsPerSet: 10, muscleGroup: 'Legs', equipment: 'Barbell'),
        Exercise(name: 'Leg Press', sets: 3, repsPerSet: 12, muscleGroup: 'Legs', equipment: 'Leg Press Machine'),
        Exercise(name: 'Lunges', sets: 3, repsPerSet: 10, muscleGroup: 'Legs', equipment: 'Dumbbells (Optional)'),
        Exercise(name: 'Leg Extensions', sets: 3, repsPerSet: 12, muscleGroup: 'Legs', equipment: 'Leg Extension Machine'),
        Exercise(name: 'Leg Curls', sets: 3, repsPerSet: 12, muscleGroup: 'Legs', equipment: 'Leg Curl Machine'),
        Exercise(name: 'Calf Raises', sets: 3, repsPerSet: 15, muscleGroup: 'Legs', equipment: 'Calf Machine or Step'),
      ],
      'Core': [
        Exercise(name: 'Crunches', sets: 3, repsPerSet: 15, muscleGroup: 'Core', equipment: 'None'),
        Exercise(name: 'Leg Raises', sets: 3, repsPerSet: 12, muscleGroup: 'Core', equipment: 'None'),
        Exercise(name: 'Planks', duration: '30-60 seconds', sets: 3, muscleGroup: 'Core', equipment: 'None'),
        Exercise(name: 'Russian Twists', sets: 3, repsPerSet: 20, muscleGroup: 'Core', equipment: 'Weight (Optional)'),
        Exercise(name: 'Bicycle Crunches', sets: 3, repsPerSet: 20, muscleGroup: 'Core', equipment: 'None'),
        Exercise(name: 'Mountain Climbers', sets: 3, repsPerSet: 20, muscleGroup: 'Core', equipment: 'None'),
      ],
      'Full Body': [
        Exercise(name: 'Burpees', sets: 3, repsPerSet: 15, muscleGroup: 'Full Body', equipment: 'None'),
        Exercise(name: 'Kettlebell Swings', sets: 3, repsPerSet: 15, muscleGroup: 'Full Body', equipment: 'Kettlebell'),
        Exercise(name: 'Clean and Press', sets: 3, repsPerSet: 8, muscleGroup: 'Full Body', equipment: 'Barbell'),
        Exercise(name: 'Thrusters', sets: 3, repsPerSet: 10, muscleGroup: 'Full Body', equipment: 'Barbell or Dumbbells'),
        Exercise(name: 'Turkish Get-Ups', sets: 3, repsPerSet: 5, muscleGroup: 'Full Body', equipment: 'Kettlebell'),
      ],
    };
  }
}

/// Template workout model for predefined workouts
class WorkoutTemplate {
  final String type;
  final String name;
  final String description;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final List<Exercise> exercises;
  
  const WorkoutTemplate({
    required this.type,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.exercises,
  });
}

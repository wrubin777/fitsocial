class AppConstants {
  // App info
  static const String appName = 'FitBud';
  static const String appTagline = 'Connect. Train. Inspire.';
  static const String appVersion = '1.0.0';
  
  // Shared preferences keys
  static const String prefUserId = 'user_id';
  static const String prefUsername = 'username';
  static const String prefEmail = 'email';
  static const String prefProfilePic = 'profile_pic';
  static const String prefDarkMode = 'dark_mode';
  
  // Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet = 'No internet connection. Please check your connection and try again.';
  static const String errorInvalidLogin = 'Invalid email or password. Please try again.';
  static const String errorWeakPassword = 'Password should be at least 6 characters long.';
  
  // Content
  static const int maxPostCharacters = 500;
  static const int maxCommentCharacters = 200;
  static const int maxWorkoutNameLength = 50;
  static const int maxWorkoutDescriptionLength = 500;
  
  // Workout categories
  static const List<String> workoutCategories = [
    'Strength Training',
    'Cardio',
    'HIIT',
    'Yoga',
    'CrossFit',
    'Bodyweight',
    'Powerlifting',
    'Calisthenics',
    'Functional Training',
    'Recovery',
  ];
  
  // Difficulty levels
  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Elite',
  ];
  
  // Muscle groups
  static const List<String> muscleGroups = [
    'Full Body',
    'Upper Body',
    'Lower Body',
    'Core',
    'Back',
    'Chest',
    'Shoulders',
    'Arms',
    'Legs',
    'Glutes',
  ];
  
  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
}

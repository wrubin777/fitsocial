class UserModel {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? bio;
  final String? profileImageUrl;
  final List<String> followers;
  final List<String> following;
  final List<String> workouts;
  final List<String> savedWorkouts;
  final DateTime createdAt;
  final Map<String, dynamic> stats;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.bio,
    this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.workouts,
    required this.savedWorkouts,
    required this.createdAt,
    required this.stats,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      bio: map['bio'],
      profileImageUrl: map['profileImageUrl'],
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      workouts: List<String>.from(map['workouts'] ?? []),
      savedWorkouts: List<String>.from(map['savedWorkouts'] ?? []),
      createdAt: map['createdAt'] != null 
        ? (map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.parse(map['createdAt'])) 
        : DateTime.now(),
      stats: Map<String, dynamic>.from(map['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'workouts': workouts,
      'savedWorkouts': savedWorkouts,
      'createdAt': createdAt.toIso8601String(),
      'stats': stats,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? bio,
    String? profileImageUrl,
    List<String>? followers,
    List<String>? following,
    List<String>? workouts,
    List<String>? savedWorkouts,
    DateTime? createdAt,
    Map<String, dynamic>? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      workouts: workouts ?? this.workouts,
      savedWorkouts: savedWorkouts ?? this.savedWorkouts,
      createdAt: createdAt ?? this.createdAt,
      stats: stats ?? this.stats,
    );
  }
}

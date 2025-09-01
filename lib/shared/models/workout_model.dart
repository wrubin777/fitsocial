import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String name;
  final String? instructions;
  final int sets;
  final int? repsPerSet;
  final String? duration;
  final String? muscleGroup;
  final String? equipment;
  
  Exercise({
    required this.name,
    this.instructions,
    required this.sets,
    this.repsPerSet,
    this.duration,
    this.muscleGroup,
    this.equipment,
  });
  
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] ?? '',
      instructions: map['instructions'],
      sets: map['sets'] ?? 0,
      repsPerSet: map['repsPerSet'],
      duration: map['duration'],
      muscleGroup: map['muscleGroup'],
      equipment: map['equipment'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'instructions': instructions,
      'sets': sets,
      'repsPerSet': repsPerSet,
      'duration': duration,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
    };
  }
}

class WorkoutModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final List<Exercise> exercises;
  final List<String> imageUrls;
  final List<String> likes;
  final List<String> saves;
  final List<Map<String, dynamic>> comments;
  final DateTime createdAt;
  final bool isPublic;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.exercises,
    this.imageUrls = const [],
    this.likes = const [],
    this.saves = const [],
    this.comments = const [],
    required this.createdAt,
    this.isPublic = true,
  });

  factory WorkoutModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return WorkoutModel(
      id: id ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      exercises: List<Exercise>.from(
        (map['exercises'] ?? []).map((x) => Exercise.fromMap(x)),
      ),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      saves: List<String>.from(map['saves'] ?? []),
      comments: List<Map<String, dynamic>>.from(map['comments'] ?? []),
      createdAt: map['createdAt'] != null 
        ? (map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.parse(map['createdAt']))
        : DateTime.now(),
      isPublic: map['isPublic'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'durationMinutes': durationMinutes,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'imageUrls': imageUrls,
      'likes': likes,
      'saves': saves,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  WorkoutModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    String? difficulty,
    int? durationMinutes,
    List<Exercise>? exercises,
    List<String>? imageUrls,
    List<String>? likes,
    List<String>? saves,
    List<Map<String, dynamic>>? comments,
    DateTime? createdAt,
    bool? isPublic,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exercises: exercises ?? this.exercises,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      saves: saves ?? this.saves,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}

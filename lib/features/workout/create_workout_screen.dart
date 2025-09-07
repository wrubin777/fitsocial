import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/workout_templates.dart';
import '../../shared/models/workout_model.dart';
import 'edit_exercise_screen.dart';

class CreateWorkoutScreen extends StatefulWidget {
  final WorkoutTemplate? initialTemplate;
  
  const CreateWorkoutScreen({
    super.key,
    this.initialTemplate,
  });

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _category = AppConstants.workoutCategories.first;
  String _difficulty = AppConstants.difficultyLevels.first;
  int _durationMinutes = 45;
  List<Exercise> _exercises = [];
  bool _isPublic = true;
  final String _currentUserId = 'currentUser';  // This would come from auth service

  @override
  void initState() {
    super.initState();
    
    // If a template was provided, pre-populate the form
    if (widget.initialTemplate != null) {
      final template = widget.initialTemplate!;
      
      _titleController.text = template.name;
      _descriptionController.text = template.description;
      _category = template.category;
      _difficulty = template.difficulty;
      _durationMinutes = template.durationMinutes;
      _exercises = [...template.exercises];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addExercise() async {
    final result = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (context) => const EditExerciseScreen(),
      ),
    );
    
    if (result != null) {
      setState(() {
        _exercises.add(result);
      });
    }
  }

  void _editExercise(int index) async {
    final result = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (context) => EditExerciseScreen(
          exercise: _exercises[index],
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _exercises[index] = result;
      });
    }
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, item);
    });
  }

  void _chooseWorkoutTemplate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return _buildTemplateList(scrollController);
          },
        );
      },
    );
  }

  Widget _buildTemplateList(ScrollController scrollController) {
    final templates = WorkoutTemplates.getAllTemplates();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Workout Templates',
            style: AppTheme.headerAltStyle.copyWith(fontSize: 18),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: templates.length,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final template = templates[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                title: Text(
                  template.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(template.description),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTemplateInfoChip(
                          template.category,
                          Icons.category,
                        ),
                        const SizedBox(width: 8),
                        _buildTemplateInfoChip(
                          template.difficulty,
                          Icons.fitness_center,
                        ),
                        const SizedBox(width: 8),
                        _buildTemplateInfoChip(
                          '${template.durationMinutes} min',
                          Icons.timer,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Apply the template
                  setState(() {
                    _titleController.text = template.name;
                    _descriptionController.text = template.description;
                    _category = template.category;
                    _difficulty = template.difficulty;
                    _durationMinutes = template.durationMinutes;
                    _exercises = [...template.exercises];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.lightGrey),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate() || _exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields and add at least one exercise.'),
        ),
      );
      return;
    }

    // Create workout model
    final workout = WorkoutModel(
      id: const Uuid().v4(),
      userId: _currentUserId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      difficulty: _difficulty,
      durationMinutes: _durationMinutes,
      exercises: _exercises,
      imageUrls: const [], // Image upload would be handled separately
      createdAt: DateTime.now(),
      isPublic: _isPublic,
    );

    // In a real app, this would be saved to Firestore or another database
    // workoutService.saveWorkout(workout);
    
    // Show success message and navigate back
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout created successfully!'),
        ),
      );
      Navigator.pop(context, workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Workout',
          style: AppTheme.headerAltStyle.copyWith(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.article_outlined),
            onPressed: _chooseWorkoutTemplate,
            tooltip: 'Choose Template',
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveWorkout,
            tooltip: 'Save Workout',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Workout Title*',
                hintText: 'e.g., Upper Body Strength',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                if (value.length > AppConstants.maxWorkoutNameLength) {
                  return 'Title too long (max ${AppConstants.maxWorkoutNameLength} characters)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your workout...',
              ),
              maxLines: 3,
              validator: (value) {
                if (value != null && value.length > AppConstants.maxWorkoutDescriptionLength) {
                  return 'Description too long (max ${AppConstants.maxWorkoutDescriptionLength} characters)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Category dropdown
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category*',
              ),
              items: AppConstants.workoutCategories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Difficulty dropdown
            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty*',
              ),
              items: AppConstants.difficultyLevels
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _difficulty = value;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a difficulty level';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Duration slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duration: $_durationMinutes minutes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _durationMinutes.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  label: '$_durationMinutes min',
                  onChanged: (value) {
                    setState(() {
                      _durationMinutes = value.round();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Public/Private toggle
            SwitchListTile(
              title: const Text('Make Public'),
              subtitle: const Text('Allow other users to see and save this workout'),
              value: _isPublic,
              onChanged: (value) {
                setState(() {
                  _isPublic = value;
                });
              },
              activeThumbColor: AppTheme.accentColor,
            ),
            const SizedBox(height: 24),
            
            // Exercises section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercises (${_exercises.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                      onPressed: _addExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_exercises.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No exercises added yet.\nTap "Add Exercise" to get started.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _exercises.length,
                    onReorder: _reorderExercises,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return _buildExerciseCard(exercise, index);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise, int index) {
    return Card(
      key: Key('exercise_$index'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Drag handle
                const Icon(
                  Icons.drag_handle,
                  color: AppTheme.lightGrey,
                ),
                const SizedBox(width: 8),
                // Exercise name
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Edit button
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                  onPressed: () => _editExercise(index),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                  tooltip: 'Edit',
                ),
                // Delete button
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => _removeExercise(index),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Exercise details
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (exercise.muscleGroup != null)
                  _buildExerciseChip(
                    Icons.fitness_center,
                    exercise.muscleGroup!,
                  ),
                _buildExerciseChip(
                  FontAwesomeIcons.repeat,
                  '${exercise.sets} sets',
                ),
                if (exercise.repsPerSet != null)
                  _buildExerciseChip(
                    FontAwesomeIcons.listOl,
                    '${exercise.repsPerSet} reps',
                  ),
                if (exercise.duration != null)
                  _buildExerciseChip(
                    Icons.timer,
                    exercise.duration!,
                  ),
                if (exercise.equipment != null)
                  _buildExerciseChip(
                    Icons.sports_gymnastics,
                    exercise.equipment!,
                  ),
              ],
            ),
            if (exercise.instructions != null && exercise.instructions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  exercise.instructions!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppTheme.lightGrey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/workout_templates.dart';
import '../../shared/models/workout_model.dart';

class EditExerciseScreen extends StatefulWidget {
  final Exercise? exercise;
  
  const EditExerciseScreen({
    super.key,
    this.exercise,
  });

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  
  int _sets = 3;
  int _reps = 10;
  String? _duration;
  String _muscleGroup = AppConstants.muscleGroups.first;
  String? _equipment;
  bool _isReps = true; // Toggle between reps and duration

  // Map of muscle groups to their respective exercises
  late final Map<String, List<Exercise>> _exercisesByMuscleGroup;

  @override
  void initState() {
    super.initState();
    _exercisesByMuscleGroup = WorkoutTemplates.getCommonExercisesByMuscleGroup();

    // Pre-populate form if editing an existing exercise
    if (widget.exercise != null) {
      _nameController.text = widget.exercise!.name;
      _instructionsController.text = widget.exercise!.instructions ?? '';
      _sets = widget.exercise!.sets;
      
      if (widget.exercise!.repsPerSet != null) {
        _reps = widget.exercise!.repsPerSet!;
        _isReps = true;
      } else {
        _isReps = false;
        _duration = widget.exercise!.duration;
      }
      
      if (widget.exercise!.muscleGroup != null) {
        _muscleGroup = widget.exercise!.muscleGroup!;
      }
      
      _equipment = widget.exercise!.equipment;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _selectExistingExercise() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return _buildExerciseList(scrollController);
          },
        );
      },
    );
  }

  Widget _buildExerciseList(ScrollController scrollController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Select Exercise',
            style: AppTheme.headerAltStyle.copyWith(fontSize: 18),
          ),
        ),
        
        // Muscle group filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.muscleGroups.length,
            itemBuilder: (context, index) {
              final muscleGroup = AppConstants.muscleGroups[index];
              final isSelected = muscleGroup == _muscleGroup;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(muscleGroup),
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
                      _muscleGroup = muscleGroup;
                      Navigator.pop(context);
                      _selectExistingExercise();
                    });
                  },
                ),
              );
            },
          ),
        ),
        
        // Exercise list
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: _exercisesByMuscleGroup[_muscleGroup]?.length ?? 0,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final exercise = _exercisesByMuscleGroup[_muscleGroup]![index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                title: Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (exercise.instructions != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          exercise.instructions!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        _buildInfoChip('${exercise.sets} sets'),
                        const SizedBox(width: 8),
                        if (exercise.repsPerSet != null)
                          _buildInfoChip('${exercise.repsPerSet} reps')
                        else if (exercise.duration != null)
                          _buildInfoChip(exercise.duration!),
                        const SizedBox(width: 8),
                        if (exercise.equipment != null)
                          _buildInfoChip(exercise.equipment!),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Apply the exercise
                  setState(() {
                    _nameController.text = exercise.name;
                    _instructionsController.text = exercise.instructions ?? '';
                    _sets = exercise.sets;
                    if (exercise.repsPerSet != null) {
                      _reps = exercise.repsPerSet!;
                      _isReps = true;
                    } else {
                      _isReps = false;
                      _duration = exercise.duration;
                    }
                    _muscleGroup = exercise.muscleGroup ?? _muscleGroup;
                    _equipment = exercise.equipment;
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

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.lightGrey,
        ),
      ),
    );
  }

  void _saveExercise() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exercise = Exercise(
      name: _nameController.text.trim(),
      instructions: _instructionsController.text.trim().isNotEmpty
          ? _instructionsController.text.trim()
          : null,
      sets: _sets,
      repsPerSet: _isReps ? _reps : null,
      duration: !_isReps ? _duration : null,
      muscleGroup: _muscleGroup,
      equipment: _equipment,
    );

    Navigator.pop(context, exercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exercise == null ? 'Add Exercise' : 'Edit Exercise',
          style: AppTheme.headerAltStyle.copyWith(fontSize: 24),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.library_books),
            label: const Text('Select Existing'),
            onPressed: _selectExistingExercise,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name*',
                hintText: 'e.g., Bench Press',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an exercise name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Instructions field
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                hintText: 'Describe how to perform this exercise...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Sets counter
            Row(
              children: [
                const Text('Sets:'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _sets > 1
                      ? () {
                          setState(() {
                            _sets--;
                          });
                        }
                      : null,
                ),
                Text('$_sets', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      _sets++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Reps/Duration toggle
            SwitchListTile(
              title: const Text('Count by'),
              value: _isReps,
              onChanged: (value) {
                setState(() {
                  _isReps = value;
                });
              },
              subtitle: Text(_isReps ? 'Repetitions' : 'Duration'),
              activeThumbColor: AppTheme.accentColor,
            ),
            const SizedBox(height: 8),
            
            // Reps counter or Duration field
            if (_isReps)
              Row(
                children: [
                  const Text('Reps:'),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _reps > 1
                        ? () {
                            setState(() {
                              _reps--;
                            });
                          }
                        : null,
                  ),
                  Text('$_reps', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        _reps++;
                      });
                    },
                  ),
                ],
              )
            else
              TextFormField(
                initialValue: _duration,
                decoration: const InputDecoration(
                  labelText: 'Duration*',
                  hintText: 'e.g., 30 seconds, 1 minute',
                ),
                onChanged: (value) {
                  setState(() {
                    _duration = value;
                  });
                },
                validator: (value) {
                  if (!_isReps && (value == null || value.trim().isEmpty)) {
                    return 'Please enter a duration';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 16),
            
            // Muscle group dropdown
            DropdownButtonFormField<String>(
              initialValue: _muscleGroup,
              decoration: const InputDecoration(
                labelText: 'Muscle Group*',
              ),
              items: AppConstants.muscleGroups
                  .map((group) => DropdownMenuItem(
                        value: group,
                        child: Text(group),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _muscleGroup = value;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a muscle group';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Equipment field
            TextFormField(
              initialValue: _equipment,
              decoration: const InputDecoration(
                labelText: 'Equipment',
                hintText: 'e.g., Barbell, Dumbbells, None',
              ),
              onChanged: (value) {
                setState(() {
                  _equipment = value.trim().isNotEmpty ? value.trim() : null;
                });
              },
            ),
            const SizedBox(height: 32),
            
            // Save button
            ElevatedButton(
              onPressed: _saveExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save Exercise',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

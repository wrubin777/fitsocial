import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../shared/models/post_model.dart';
import '../../shared/models/workout_model.dart';
import '../../shared/services/workout_store.dart';
import '../../shared/widgets/common_widgets.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _imagePicker = ImagePicker();
  
  final List<File> _selectedImages = [];
  WorkoutModel? _selectedWorkout;
  String _selectedCategory = 'General';
  bool _isLoading = false;
  
  // Fitness categories for posts
  final List<String> _categories = [
    'General',
    'Workout',
    'Progress',
    'Nutrition',
    'Motivation',
    'Tips',
    'Achievement',
    'Question',
  ];

  // Fitness hashtags suggestions
  final List<String> _hashtagSuggestions = [
    '#fitness',
    '#workout',
    '#gains',
    '#motivation',
    '#health',
    '#strength',
    '#cardio',
    '#muscle',
    '#progress',
    '#fitspo',
    '#gym',
    '#training',
    '#wellness',
    '#lifestyle',
    '#transformation',
  ];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: AppTheme.headerAltStyle.copyWith(fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _publishPost,
            child: Text(
              'Publish',
              style: TextStyle(
                color: _isLoading ? AppTheme.lightGrey : AppTheme.accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info section
              _buildUserInfoSection(),
              const SizedBox(height: 20),
              
              // Content input
              _buildContentInput(),
              const SizedBox(height: 20),
              
              // Category selection
              _buildCategorySelection(),
              const SizedBox(height: 20),
              
              // Image selection
              _buildImageSelection(),
              const SizedBox(height: 20),
              
              // Workout linking
              _buildWorkoutLinking(),
              const SizedBox(height: 20),
              
              // Hashtag suggestions
              _buildHashtagSuggestions(),
              const SizedBox(height: 20),
              
              // Post preview
              if (_contentController.text.isNotEmpty || _selectedImages.isNotEmpty)
                _buildPostPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Row(
      children: [
        const AppUserAvatar(
          radius: 20,
          showBorder: true,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alex Johnson', // This would come from auth service
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '@fitness_warrior',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightGrey,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.darkGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _selectedCategory,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s on your mind?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contentController,
          maxLines: 6,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Share your fitness journey, tips, or motivation...',
            hintStyle: TextStyle(color: AppTheme.lightGrey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.darkGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.darkGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.accentColor),
            ),
            filled: true,
            fillColor: AppTheme.darkGrey.withOpacity(0.3),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: (value) => setState(() {}),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please write something to share';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_contentController.text.length}/500',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightGrey,
                  ),
            ),
            if (_contentController.text.length > 400)
              Text(
                'Almost at limit!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accentColor : AppTheme.darkGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.accentColor : AppTheme.darkGrey,
                  ),
                ),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (_selectedImages.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _selectedImages.clear()),
                child: Text(
                  'Clear all',
                  style: TextStyle(color: AppTheme.accentColor),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Selected images
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImages.removeAt(index)),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Add image buttons
        Row(
          children: [
            _buildImageButton(
              icon: FontAwesomeIcons.camera,
              label: 'Camera',
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(width: 12),
            _buildImageButton(
              icon: FontAwesomeIcons.image,
              label: 'Gallery',
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.darkGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.darkGrey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accentColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutLinking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Link Workout (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showWorkoutSelector,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.darkGrey),
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.dumbbell,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _selectedWorkout != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedWorkout!.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              '${_selectedWorkout!.durationMinutes} min • ${_selectedWorkout!.difficulty}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightGrey,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          'Select a workout to link to this post',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.lightGrey,
                              ),
                        ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.lightGrey,
                ),
              ],
            ),
          ),
        ),
        if (_selectedWorkout != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () => setState(() => _selectedWorkout = null),
              child: Text(
                'Remove workout link',
                style: TextStyle(color: AppTheme.accentColor),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHashtagSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Hashtags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _hashtagSuggestions.map((hashtag) {
            return GestureDetector(
              onTap: () => _addHashtag(hashtag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.darkGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.darkGrey),
                ),
                child: Text(
                  hashtag,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentColor,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPostPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.darkGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.darkGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  const AppUserAvatar(radius: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Johnson',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '@fitness_warrior • now',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightGrey,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Content
              Text(
                _contentController.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              // Category and hashtags preview
              if (_selectedCategory != 'General' || PostModel.extractHashtags(_contentController.text).isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (_selectedCategory != 'General')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedCategory,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ...PostModel.extractHashtags(_contentController.text).map((hashtag) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hashtag,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              
              // Images preview
              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              // Workout link preview
              if (_selectedWorkout != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.dumbbell,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedWorkout!.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              '${_selectedWorkout!.durationMinutes} min • ${_selectedWorkout!.difficulty}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightGrey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      AppUtils.showSnackBar(context, 'Failed to pick image: $e', isError: true);
    }
  }

  void _showWorkoutSelector() {
    final store = WorkoutStore.instance;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Text(
                'Select Workout',
                style: AppTheme.headerAltStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              if (store.workouts.value.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No workouts available'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: store.workouts.value.length,
                  itemBuilder: (context, index) {
                    final workout = store.workouts.value[index];
                    return ListTile(
                      leading: Icon(
                        FontAwesomeIcons.dumbbell,
                        color: AppTheme.accentColor,
                      ),
                      title: Text(workout.title),
                      subtitle: Text('${workout.durationMinutes} min • ${workout.difficulty}'),
                      onTap: () {
                        setState(() => _selectedWorkout = workout);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _addHashtag(String hashtag) {
    final currentText = _contentController.text;
    final newText = currentText.isEmpty ? hashtag : '$currentText $hashtag';
    _contentController.text = newText;
    _contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
    setState(() {});
  }

  Future<void> _publishPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Extract hashtags from content
      final hashtags = PostModel.extractHashtags(_contentController.text);
      
      // Create post model
      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'currentUser', // This would come from auth service
        username: 'fitness_warrior',
        content: _contentController.text,
        imageUrls: [], // In real app, upload images and get URLs
        workoutId: _selectedWorkout?.id,
        category: _selectedCategory,
        hashtags: hashtags,
        location: null, // Could add location picker in future
        isPublic: true, // Could add privacy settings in future
        createdAt: DateTime.now(),
      );

      // In a real app, you would save this to your backend
      print('Post created: ${post.toMap()}');

      AppUtils.showSnackBar(context, 'Post published successfully!');
      Navigator.pop(context, post);
    } catch (e) {
      AppUtils.showSnackBar(context, 'Failed to publish post: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

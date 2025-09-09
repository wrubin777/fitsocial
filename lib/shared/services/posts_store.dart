import 'package:flutter/foundation.dart';
import '../models/post_model.dart';

class PostsStore {
  PostsStore._internal() {
    // Initialize with some mock data
    _posts.value = [
      PostModel(
        id: '1',
        userId: 'user1',
        username: 'john_fitness',
        userProfileImage: null,
        content: 'Just finished an intense leg day workout! 💪 Feeling the burn but it\'s worth it. #legday #fitness #nopainnogain',
        imageUrls: [],
        workoutId: 'workout1',
        category: 'Workout',
        hashtags: ['#legday', '#fitness', '#nopainnogain'],
        location: 'Gym',
        isPublic: true,
        likes: ['user2', 'user3'],
        comments: [
          {'userId': 'user2', 'username': 'maria_fit', 'text': 'Great job! Keep pushing!', 'createdAt': DateTime.now().toString()}
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostModel(
        id: '2',
        userId: 'user2',
        username: 'maria_fit',
        userProfileImage: null,
        content: 'Morning cardio session complete! Starting the day with some endorphins. #morningworkout #cardio #motivation',
        imageUrls: [],
        category: 'Progress',
        hashtags: ['#morningworkout', '#cardio', '#motivation'],
        isPublic: true,
        likes: [],
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      PostModel(
        id: '3',
        userId: 'user3',
        username: 'fitness_guru',
        userProfileImage: null,
        content: 'Check out this amazing transformation! 6 months of consistent training and proper nutrition. #transformation #fitness #motivation',
        imageUrls: ['https://example.com/before.jpg', 'https://example.com/after.jpg'],
        category: 'Progress',
        hashtags: ['#transformation', '#fitness', '#motivation'],
        isPublic: true,
        likes: ['user1', 'user2', 'user4'],
        comments: [
          {'userId': 'user1', 'username': 'john_fitness', 'text': 'Incredible progress! 🔥', 'createdAt': DateTime.now().toString()}
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static final PostsStore instance = PostsStore._internal();

  /// Observable list of all posts
  final ValueNotifier<List<PostModel>> _posts = ValueNotifier<List<PostModel>>([]);
  
  /// Get all posts (for feed)
  List<PostModel> get posts => _posts.value;
  
  /// Get posts by user ID
  List<PostModel> getPostsByUser(String userId) {
    return _posts.value.where((post) => post.userId == userId).toList();
  }
  
  /// Get posts by category
  List<PostModel> getPostsByCategory(String category) {
    return _posts.value.where((post) => post.category == category).toList();
  }
  
  /// Get posts with hashtag
  List<PostModel> getPostsByHashtag(String hashtag) {
    return _posts.value.where((post) => 
      post.hashtags.any((tag) => tag.toLowerCase() == hashtag.toLowerCase())
    ).toList();
  }

  /// Add a new post
  void addPost(PostModel post) {
    _posts.value = [post, ..._posts.value];
  }

  /// Update an existing post
  void updatePost(PostModel post) {
    final index = _posts.value.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      final newPosts = [..._posts.value];
      newPosts[index] = post;
      _posts.value = newPosts;
    }
  }

  /// Delete a post
  void deletePost(String postId) {
    _posts.value = _posts.value.where((post) => post.id != postId).toList();
  }

  /// Like a post
  void likePost(String postId, String userId) {
    final index = _posts.value.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts.value[index];
      final newLikes = [...post.likes];
      if (newLikes.contains(userId)) {
        newLikes.remove(userId); // Unlike
      } else {
        newLikes.add(userId); // Like
      }
      
      final updatedPost = post.copyWith(likes: newLikes);
      updatePost(updatedPost);
    }
  }

  /// Add a comment to a post
  void addComment(String postId, Map<String, dynamic> comment) {
    final index = _posts.value.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts.value[index];
      final newComments = [...post.comments, comment];
      final updatedPost = post.copyWith(comments: newComments);
      updatePost(updatedPost);
    }
  }

  /// Get post by ID
  PostModel? getPostById(String postId) {
    try {
      return _posts.value.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  /// Get recent posts (last 24 hours)
  List<PostModel> getRecentPosts() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _posts.value.where((post) => post.createdAt.isAfter(yesterday)).toList();
  }

  /// Get trending posts (most liked in last week)
  List<PostModel> getTrendingPosts() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentPosts = _posts.value.where((post) => post.createdAt.isAfter(weekAgo)).toList();
    recentPosts.sort((a, b) => b.likes.length.compareTo(a.likes.length));
    return recentPosts.take(10).toList();
  }

  /// Search posts by content
  List<PostModel> searchPosts(String query) {
    if (query.isEmpty) return [];
    
    final lowercaseQuery = query.toLowerCase();
    return _posts.value.where((post) => 
      post.content.toLowerCase().contains(lowercaseQuery) ||
      post.hashtags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
      post.username.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  /// Get posts count for a user
  int getPostsCount(String userId) {
    return _posts.value.where((post) => post.userId == userId).length;
  }

  /// Get total likes count for a user
  int getTotalLikesCount(String userId) {
    return _posts.value
        .where((post) => post.userId == userId)
        .fold(0, (sum, post) => sum + post.likes.length);
  }
}

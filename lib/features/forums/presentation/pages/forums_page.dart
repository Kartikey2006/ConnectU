import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/forums/data/services/global_forums_service.dart';
import 'package:connectu_alumni_platform/features/forums/domain/entities/forum.dart';
import 'package:connectu_alumni_platform/features/forums/domain/entities/forum_post.dart';
import 'package:connectu_alumni_platform/features/forums/presentation/pages/forum_detail_page.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({super.key});

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> with TickerProviderStateMixin {
  final GlobalForumsService _forumsService = GlobalForumsService();
  final TextEditingController _searchController = TextEditingController();

  List<Forum> _forums = [];
  List<ForumPost> _recentPosts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'General',
    'Career',
    'Alumni',
    'Events',
    'Mentorship',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupRealtimeSubscriptions();
    _loadForums();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _forumsService.dispose();
    super.dispose();
  }

  void _setupRealtimeSubscriptions() {
    // Subscribe to real-time updates
    _forumsService.subscribeToForums();

    // Listen to forums stream
    _forumsService.forumsStream.listen(
      (forums) {
        if (mounted) {
          setState(() {
            _forums = forums;
            _isLoading = false;
          });
          print('📰 Updated forums: ${forums.length}');
        }
      },
      onError: (error) {
        print('❌ Forum stream error: $error');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );

    // Listen to posts stream
    _forumsService.postsStream.listen(
      (posts) {
        if (mounted) {
          setState(() {
            _recentPosts = posts;
            _isLoading = false;
          });
          print('📰 Updated posts: ${posts.length}');
        }
      },
      onError: (error) {
        print('❌ Posts stream error: $error');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _loadForums() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final forums = await _forumsService.getForums();
      final recentPosts = await _forumsService.getAllRecentPosts();

      print('🔄 ForumsPage: Loaded ${forums.length} forums');
      print('🔄 ForumsPage: Loaded ${recentPosts.length} recent posts');
      for (var post in recentPosts) {
        print(
            '🔄 ForumsPage: Post: ${post.title} by ${post.author?['name']} (ID: ${post.id})');
      }

      setState(() {
        _forums = forums;
        _recentPosts = recentPosts;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading forums: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchForums(String query) async {
    if (query.isEmpty) {
      _loadForums();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _forumsService.searchForumsAndPosts(query: query);
      setState(() {
        _forums = (results['forums'] as List?)
                ?.map((f) => Forum.fromJson(f))
                .toList() ??
            [];
        _recentPosts = (results['posts'] as List?)
                ?.map((p) => ForumPost.fromJson(p))
                .toList() ??
            [];
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error searching forums: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _joinForum(Forum forum) async {
    try {
      final success = await _forumsService.joinForum(
        forumId: forum.id,
        userId: 'current_user',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${forum.name}!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Error joining forum: $e');
    }
  }

  void _viewForum(Forum forum) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForumDetailPage(forum: forum.toJson()),
      ),
    );
  }

  void _viewPost(ForumPost post) {
    // Find the forum for this post
    final forum = _forums.firstWhere(
      (forum) => forum.id == post.forumId,
      orElse: () => Forum(
        id: 'unknown',
        name: 'Unknown Forum',
        description: '',
        category: 'General',
        isPublic: true,
        createdBy: 'unknown',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForumDetailPage(forum: forum.toJson()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Forums',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/student-dashboard'),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        actions: [
          IconButton(
            onPressed: _forceReloadData,
            icon: const Icon(Icons.refresh, color: Color(0xFF1F2937)),
            tooltip: 'Force Reload',
          ),
          IconButton(
            onPressed: _createTestPost,
            icon: const Icon(Icons.add, color: Color(0xFF1F2937)),
            tooltip: 'Create Test Post',
          ),
          IconButton(
            onPressed: _debugCrossAccountVisibility,
            icon: const Icon(Icons.bug_report, color: Color(0xFF1F2937)),
            tooltip: 'Debug Cross-Account',
          ),
          IconButton(
            onPressed: _resetToNewSampleData,
            icon: const Icon(Icons.refresh_outlined, color: Color(0xFF1F2937)),
            tooltip: 'Reset Sample Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search forums and posts...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _loadForums();
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryColor),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
              ),
              onChanged: _searchForums,
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      // TODO: Filter forums by category
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : const Color(0xFF6B7280),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: const Color(0xFF6B7280),
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Forums'),
                Tab(text: 'Recent Posts'),
                Tab(text: 'My Activity'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildForumsTab(),
                _buildRecentPostsTab(),
                _buildMyActivityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumsTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      );
    }

    if (_forums.isEmpty) {
      return _buildEmptyState(
        icon: Icons.forum_outlined,
        title: 'No Forums Found',
        subtitle: 'No forums match your current search criteria.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadForums,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _forums.length,
        itemBuilder: (context, index) {
          final forum = _forums[index];
          return _buildForumCard(forum);
        },
      ),
    );
  }

  Widget _buildRecentPostsTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      );
    }

    if (_recentPosts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.article_outlined,
        title: 'No Recent Posts',
        subtitle: 'No recent posts found. Be the first to start a discussion!',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadForums,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _recentPosts.length,
        itemBuilder: (context, index) {
          final post = _recentPosts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildMyActivityTab() {
    return _buildEmptyState(
      icon: Icons.person_outline,
      title: 'My Activity',
      subtitle: 'Your forum activity will appear here.',
    );
  }

  Widget _buildForumCard(Forum forum) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewForum(forum),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(forum.category),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      forum.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${forum.membersCount ?? 0} members',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                forum.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                forum.description,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${forum.postsCount ?? 0} posts',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 200) {
                        // Stack vertically on small screens
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => _joinForum(forum),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                  side: const BorderSide(
                                      color: AppTheme.primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Join'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _viewForum(forum),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('View'),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Side by side on larger screens
                        return Row(
                          children: [
                            OutlinedButton(
                              onPressed: () => _joinForum(forum),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: const BorderSide(
                                    color: AppTheme.primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Join'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _viewForum(forum),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('View'),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(ForumPost post) {
    final author = post.author ?? {};
    final forum = post.forum;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewPost(post),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(
                      (author['name'] ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author['name'] ?? 'Unknown User',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          forum?.name ?? 'Unknown Forum',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(post.createdAt.toIso8601String()),
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.content,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (post.imagePath != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(post.imagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.likesCount}',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.repliesCount}',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (post.isPinned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PINNED',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: const Color(0xFFD1D5DB),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'general':
        return const Color(0xFF3B82F6);
      case 'career':
        return const Color(0xFF10B981);
      case 'alumni':
        return const Color(0xFF8B5CF6);
      case 'events':
        return const Color(0xFFF59E0B);
      case 'mentorship':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Post'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Forum',
                  border: OutlineInputBorder(),
                ),
                items: _forums.map((forum) {
                  return DropdownMenuItem(
                    value: forum.id,
                    child: Text(forum.name),
                  );
                }).toList(),
                onChanged: (value) {
                  // Handle forum selection
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Post Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Post Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Create post
              Navigator.pop(context);
            },
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }

  void _createTestPost() async {
    try {
      final authState = context.read<AuthBloc>().state;
      String authorId = 'current_user';
      String? authorName;
      String? authorEmail;

      if (authState is Authenticated) {
        authorId = authState.user.user.id.toString();
        authorName = authState.user.user.name;
        authorEmail = authState.user.user.email;
      }

      String selectedForumId = _forums.isNotEmpty ? _forums.first.id : '1';

      final success = await _forumsService.createPost(
        forumId: selectedForumId,
        authorId: authorId,
        title: 'Test Post from ${authorName ?? 'User'}',
        content: 'This is a test post created at ${DateTime.now().toString()}',
        authorName: authorName,
        authorEmail: authorEmail,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test post created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        );
        _loadForums(); // Reload to show the new post
      }
    } catch (e) {
      print('❌ Error creating test post: $e');
    }
  }

  void _forceReloadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _forumsService.forceReloadData();
      await _loadForums();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data reloaded successfully!'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    } catch (e) {
      print('❌ Error reloading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _debugCrossAccountVisibility() async {
    try {
      await _forumsService.debugCrossAccountVisibility();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debug info printed to console!'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('❌ Error debugging: $e');
    }
  }

  void _resetToNewSampleData() async {
    try {
      await _forumsService.resetToNewSampleData();
      await _loadForums();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sample data reset! New Indian posts loaded.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('❌ Error resetting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error resetting data: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

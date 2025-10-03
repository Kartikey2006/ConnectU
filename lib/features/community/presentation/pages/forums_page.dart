import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({super.key});

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'General',
    'Technology',
    'Finance',
    'Career',
    'Alumni Events',
    'Mentorship'
  ];
  final List<String> _sortOptions = ['Latest', 'Most Popular', 'Most Replies'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: NavigationUtils.safeBackButton(
          context: context,
          iconColor: const Color(0xFF0E141B),
          iconSize: 24,
        ),
        title: const Text(
          'Community Forums',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _createPost,
            icon: const Icon(
              Icons.add,
              color: Color(0xFF1979E6),
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0E141B),
          unselectedLabelColor: const Color(0xFF4E7097),
          indicatorColor: const Color(0xFF1979E6),
          tabs: const [
            Tab(text: 'All Posts'),
            Tab(text: 'My Posts'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search discussions...',
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF4E7097)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear,
                                color: Color(0xFF4E7097)),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE7EDF3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE7EDF3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1979E6)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterChip('Category: $_selectedCategory',
                          () => _showCategoryFilter()),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip('Sort: Latest', () => _showSortFilter()),
                  ],
                ),
              ],
            ),
          ),

          // Forums Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllPostsTab(),
                _buildMyPostsTab(),
                _buildFollowingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7EDF3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0E141B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF4E7097),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getFilteredPosts().length,
      itemBuilder: (context, index) {
        final post = _getFilteredPosts()[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildMyPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getMyPosts().length,
      itemBuilder: (context, index) {
        final post = _getMyPosts()[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildFollowingTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _getFollowingPosts().length,
      itemBuilder: (context, index) {
        final post = _getFollowingPosts()[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1979E6).withOpacity(0.1),
                backgroundImage: post['authorAvatar'] != null
                    ? NetworkImage(post['authorAvatar'])
                    : null,
                child: post['authorAvatar'] == null
                    ? Text(
                        post['authorName'].split(' ').map((e) => e[0]).join(''),
                        style: const TextStyle(
                          color: Color(0xFF1979E6),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['authorName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E141B),
                      ),
                    ),
                    Text(
                      post['authorRole'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(post['category']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post['category'],
                  style: TextStyle(
                    fontSize: 10,
                    color: _getCategoryColor(post['category']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Post Content
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E141B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post['content'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4E7097),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          if (post['imageUrl'] != null) ...[
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(post['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Stats and Actions
          Row(
            children: [
              const Icon(
                Icons.thumb_up_outlined,
                size: 16,
                color: Color(0xFF4E7097),
              ),
              const SizedBox(width: 4),
              Text(
                '${post['likes']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.comment_outlined,
                size: 16,
                color: Color(0xFF4E7097),
              ),
              const SizedBox(width: 4),
              Text(
                '${post['replies']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.visibility_outlined,
                size: 16,
                color: Color(0xFF4E7097),
              ),
              const SizedBox(width: 4),
              Text(
                '${post['views']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
              const Spacer(),
              Text(
                post['timeAgo'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _likePost(post),
                  icon: Icon(
                    post['isLiked'] ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 16,
                    color: post['isLiked']
                        ? const Color(0xFF1979E6)
                        : const Color(0xFF4E7097),
                  ),
                  label: Text(
                    post['isLiked'] ? 'Liked' : 'Like',
                    style: TextStyle(
                      color: post['isLiked']
                          ? const Color(0xFF1979E6)
                          : const Color(0xFF4E7097),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: post['isLiked']
                          ? const Color(0xFF1979E6)
                          : const Color(0xFFE7EDF3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _replyToPost(post),
                  icon: const Icon(
                    Icons.reply,
                    size: 16,
                    color: Color(0xFF4E7097),
                  ),
                  label: const Text(
                    'Reply',
                    style: TextStyle(color: Color(0xFF4E7097)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE7EDF3)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _sharePost(post),
                icon: const Icon(
                  Icons.share,
                  size: 16,
                  color: Color(0xFF4E7097),
                ),
                label: const Text(
                  'Share',
                  style: TextStyle(color: Color(0xFF4E7097)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EDF3)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPosts() {
    // Mock data - replace with actual API call
    List<Map<String, dynamic>> posts = [
      {
        'id': '1',
        'title': 'New Job Opportunities in Tech',
        'content':
            'I wanted to share some exciting job opportunities I came across in the tech industry. Many companies are hiring for remote positions...',
        'authorName': 'Sarah Chen',
        'authorRole': 'Alumni - Class of 2018',
        'authorAvatar': null,
        'category': 'Career',
        'likes': 24,
        'replies': 8,
        'views': 156,
        'timeAgo': '2 hours ago',
        'isLiked': false,
        'imageUrl': null,
      },
      {
        'id': '2',
        'title': 'Alumni Meetup in Mumbai - This Weekend!',
        'content':
            'Hey everyone! We\'re organizing an alumni meetup this Saturday at Marine Drive. It would be great to catch up with everyone...',
        'authorName': 'Rajesh Kumar',
        'authorRole': 'Alumni - Class of 2017',
        'authorAvatar': null,
        'category': 'Alumni Events',
        'likes': 42,
        'replies': 15,
        'views': 234,
        'timeAgo': '5 hours ago',
        'isLiked': true,
        'imageUrl': 'https://via.placeholder.com/400x200',
      },
      {
        'id': '3',
        'title': 'Mentorship Program Success Stories',
        'content':
            'I wanted to share some amazing success stories from our mentorship program. Many students have landed great jobs with the help of alumni mentors...',
        'authorName': 'Priya Sharma',
        'authorRole': 'Alumni - Class of 2016',
        'authorAvatar': null,
        'category': 'Mentorship',
        'likes': 18,
        'replies': 6,
        'views': 89,
        'timeAgo': '1 day ago',
        'isLiked': false,
        'imageUrl': null,
      },
    ];

    return posts.where((post) {
      bool matchesSearch = _searchController.text.isEmpty ||
          post['title']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          post['content']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      bool matchesCategory =
          _selectedCategory == 'All' || post['category'] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Map<String, dynamic>> _getMyPosts() {
    return _getFilteredPosts()
        .where((post) => post['authorName'] == 'You')
        .toList();
  }

  List<Map<String, dynamic>> _getFollowingPosts() {
    return _getFilteredPosts()
        .where((post) => post['isFollowing'] == true)
        .toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Technology':
        return const Color(0xFF1979E6);
      case 'Career':
        return const Color(0xFF10B981);
      case 'Alumni Events':
        return const Color(0xFFF59E0B);
      case 'Mentorship':
        return const Color(0xFF8B5CF6);
      case 'Finance':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF4E7097);
    }
  }

  void _createPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCreatePostBottomSheet(),
    );
  }

  Widget _buildCreatePostBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE7EDF3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Create New Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Post title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.skip(1).map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSnackBar('Post created successfully!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1979E6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Post'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterBottomSheet(
          'Category', _categories, _selectedCategory, (value) {
        setState(() => _selectedCategory = value);
        Navigator.pop(context);
      }),
    );
  }

  void _showSortFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          _buildFilterBottomSheet('Sort By', _sortOptions, 'Latest', (value) {
        Navigator.pop(context);
      }),
    );
  }

  Widget _buildFilterBottomSheet(String title, List<String> options,
      String selected, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select $title',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E141B),
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((option) {
            final isSelected = option == selected;
            return ListTile(
              title: Text(option),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Color(0xFF1979E6))
                  : null,
              onTap: () => onChanged(option),
            );
          }),
        ],
      ),
    );
  }

  void _likePost(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] += post['isLiked'] ? 1 : -1;
    });
  }

  void _replyToPost(Map<String, dynamic> post) {
    _showSnackBar('Reply to ${post['title']}');
  }

  void _sharePost(Map<String, dynamic> post) {
    _showSnackBar('Shared: ${post['title']}');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

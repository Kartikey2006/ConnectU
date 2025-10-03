import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/events/data/services/events_service.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_widgets.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  final EventsService _eventsService = EventsService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _myEvents = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  bool _showVirtualOnly = false;

  late TabController _tabController;

  final List<String> _eventTypes = [
    'All',
    'Alumni Reunion',
    'Webinar',
    'Networking',
    'Workshop',
    'Conference',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvents();
    _loadMyEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final events = await _eventsService.getEvents(
        eventType: _selectedFilter == 'All'
            ? null
            : _selectedFilter.toLowerCase().replaceAll(' ', '_'),
        isVirtual: _showVirtualOnly ? true : null,
      );

      // If no events from database, use sample data
      if (events.isEmpty) {
        setState(() {
          _events = _getSampleEvents();
          _isLoading = false;
        });
      } else {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading events: $e');
      // Use sample data on error
      setState(() {
        _events = _getSampleEvents();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMyEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final myEventsJson = prefs.getString('my_registered_events');
      if (myEventsJson != null) {
        final List<dynamic> myEventsList = jsonDecode(myEventsJson);
        setState(() {
          _myEvents = myEventsList.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('❌ Error loading my events: $e');
    }
  }

  Future<void> _saveMyEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final myEventsJson = jsonEncode(_myEvents);
      await prefs.setString('my_registered_events', myEventsJson);
    } catch (e) {
      print('❌ Error saving my events: $e');
    }
  }

  void _addToMyEvents(Map<String, dynamic> event) {
    // Check if event is already registered
    final isAlreadyRegistered = _myEvents.any((e) => e['id'] == event['id']);
    if (!isAlreadyRegistered) {
      setState(() {
        _myEvents.add({
          ...event,
          'registered_at': DateTime.now().toIso8601String(),
          'registration_status': 'confirmed',
        });
      });
      _saveMyEvents();
    }
  }

  List<Map<String, dynamic>> _getSampleEvents() {
    final now = DateTime.now();
    return [
      {
        'id': '1',
        'title': 'Alumni Reunion 2024',
        'description':
            'Join us for our annual alumni reunion! Network with fellow graduates, share memories, and celebrate our achievements.',
        'event_type': 'alumni_reunion',
        'start_date': now.add(const Duration(days: 7)).toIso8601String(),
        'end_date':
            now.add(const Duration(days: 7, hours: 4)).toIso8601String(),
        'location': 'University Campus, Main Hall',
        'is_virtual': false,
        'cover_image_url':
            'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
        'organizer': {
          'name': 'Alumni Association',
          'email': 'alumni@university.edu'
        },
        'registrations_count': 156,
        'registration_fee': 25.0,
      },
      {
        'id': '2',
        'title': 'Tech Innovation Summit',
        'description':
            'Explore the latest trends in technology, AI, and digital transformation. Featuring industry leaders and startup founders.',
        'event_type': 'conference',
        'start_date': now.add(const Duration(days: 14)).toIso8601String(),
        'end_date': now.add(const Duration(days: 15)).toIso8601String(),
        'location': 'Convention Center',
        'is_virtual': false,
        'cover_image_url':
            'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
        'organizer': {
          'name': 'Tech Alumni Network',
          'email': 'tech@alumni.edu'
        },
        'registrations_count': 89,
        'registration_fee': 50.0,
      },
      {
        'id': '3',
        'title': 'Career Development Workshop',
        'description':
            'Master your job search with expert tips on resume writing, interview skills, and networking strategies.',
        'event_type': 'workshop',
        'start_date': now.add(const Duration(days: 21)).toIso8601String(),
        'end_date':
            now.add(const Duration(days: 21, hours: 3)).toIso8601String(),
        'location': 'Virtual Event',
        'is_virtual': true,
        'virtual_link': 'https://meet.google.com/abc-defg-hij',
        'cover_image_url':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
        'organizer': {
          'name': 'Career Services',
          'email': 'career@university.edu'
        },
        'registrations_count': 234,
        'registration_fee': 0.0,
      },
      {
        'id': '4',
        'title': 'Networking Mixer',
        'description':
            'Connect with alumni from various industries. Perfect for expanding your professional network and finding new opportunities.',
        'event_type': 'networking',
        'start_date': now.add(const Duration(days: 28)).toIso8601String(),
        'end_date':
            now.add(const Duration(days: 28, hours: 2)).toIso8601String(),
        'location': 'Downtown Business Center',
        'is_virtual': false,
        'cover_image_url':
            'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=800',
        'organizer': {
          'name': 'Business Alumni',
          'email': 'business@alumni.edu'
        },
        'registrations_count': 67,
        'registration_fee': 15.0,
      },
      {
        'id': '5',
        'title': 'Startup Pitch Competition',
        'description':
            'Watch innovative startups pitch their ideas to a panel of investors and industry experts. Great for entrepreneurs and investors.',
        'event_type': 'conference',
        'start_date': now.add(const Duration(days: 35)).toIso8601String(),
        'end_date':
            now.add(const Duration(days: 35, hours: 5)).toIso8601String(),
        'location': 'Innovation Hub',
        'is_virtual': false,
        'cover_image_url':
            'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800',
        'organizer': {
          'name': 'Entrepreneurship Club',
          'email': 'startup@university.edu'
        },
        'registrations_count': 123,
        'registration_fee': 30.0,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Column(
        children: [
          // Modern Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: AppTheme.floatingShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        String dashboardRoute = '/student-dashboard';
                        if (state is Authenticated) {
                          if (state.user.user.role.name == 'alumni') {
                            dashboardRoute = '/alumni-dashboard';
                          }
                        }
                        return ModernIconButton(
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => context.go(dashboardRoute),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          iconColor: Colors.white,
                          size: 40,
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Events & Webinars',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ModernIconButton(
                      icon: Icons.add_rounded,
                      onPressed: () => _showCreateEventDialog(),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      iconColor: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect with alumni through amazing events',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Modern Search bar
                ModernSearchField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                    _loadEvents();
                  },
                  onClear: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          // Modern Filter chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildModernFilterChip(
                      'Type: $_selectedFilter', () => _showTypeFilter()),
                  const SizedBox(width: 12),
                  _buildModernFilterChip(
                    _showVirtualOnly ? 'Virtual Only' : 'All Events',
                    () => setState(() {
                      _showVirtualOnly = !_showVirtualOnly;
                      _loadEvents();
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Modern Tab bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppTheme.cardShadow,
            ),
            child: ModernTabBar(
              tabs: const ['Upcoming', 'My Events', 'Past Events'],
              selectedIndex: _tabController.index,
              onTap: (index) {
                _tabController.animateTo(index);
              },
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventsList(),
                _buildMyEventsList(),
                _buildPastEventsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFilterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.primaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModernLoadingIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading events...',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No events found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for new events',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Refresh',
              onPressed: _loadEvents,
              type: ModernButtonType.secondary,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildMyEventsList() {
    if (_myEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Registered Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register for events to see them here',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Browse Events',
              onPressed: () {
                _tabController.animateTo(0); // Switch to Upcoming tab
              },
              type: ModernButtonType.primary,
              icon: Icons.explore,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMyEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _myEvents.length,
        itemBuilder: (context, index) {
          final event = _myEvents[index];
          return _buildMyEventCard(event);
        },
      ),
    );
  }

  Widget _buildMyEventCard(Map<String, dynamic> event) {
    final startDate = DateTime.parse(event['start_date']);
    final endDate = DateTime.parse(event['end_date']);
    final isVirtual = event['is_virtual'] ?? false;
    final registeredAt = event['registered_at'] != null
        ? DateTime.parse(event['registered_at'])
        : null;

    return ModernCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event header
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'] ?? 'Untitled Event',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVirtual ? Icons.video_call : Icons.location_on,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            isVirtual
                                ? 'Virtual Event'
                                : event['location'] ?? 'Location TBD',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                ),
                child: const Text(
                  'Registered',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Event details
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (registeredAt != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppTheme.successColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Registered on ${_formatDate(registeredAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.successColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 300) {
                // Horizontal layout for larger screens
                return Row(
                  children: [
                    Expanded(
                      child: ModernButton(
                        text: 'View Details',
                        onPressed: () => _viewEventDetails(event),
                        type: ModernButtonType.secondary,
                        icon: Icons.visibility_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ModernButton(
                        text: 'Cancel',
                        onPressed: () => _cancelEventRegistration(event),
                        type: ModernButtonType.outline,
                        icon: Icons.cancel_outlined,
                      ),
                    ),
                  ],
                );
              } else {
                // Vertical layout for smaller screens
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'View Details',
                        onPressed: () => _viewEventDetails(event),
                        type: ModernButtonType.secondary,
                        icon: Icons.visibility_rounded,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'Cancel Registration',
                        onPressed: () => _cancelEventRegistration(event),
                        type: ModernButtonType.outline,
                        icon: Icons.cancel_outlined,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _cancelEventRegistration(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => ModernAlertDialog(
        title: 'Cancel Registration',
        message:
            'Are you sure you want to cancel your registration for ${event['title']}?',
        confirmText: 'Cancel Registration',
        cancelText: 'Keep Registration',
        onConfirm: () {
          Navigator.of(context).pop();

          setState(() {
            _myEvents.removeWhere((e) => e['id'] == event['id']);
          });
          _saveMyEvents();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration cancelled for ${event['title']}'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        onCancel: () {
          // Just close the dialog
        },
      ),
    );
  }

  Widget _buildPastEventsList() {
    return const Center(
      child: Text('Past Events - Coming Soon'),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final startDate = DateTime.parse(event['start_date']);
    final endDate = DateTime.parse(event['end_date']);
    final isUpcoming = startDate.isAfter(DateTime.now());
    final isVirtual = event['is_virtual'] ?? false;

    return ModernCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image/cover
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: AppTheme.primaryGradient,
            ),
            child: Stack(
              children: [
                if (event['cover_image_url'] != null)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      event['cover_image_url'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Text(
                      isUpcoming ? 'Upcoming' : 'Past',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVirtual ? Icons.video_call : Icons.location_on,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isVirtual
                              ? 'Virtual Event'
                              : event['location'] ?? 'TBA',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Event details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] ?? 'Event Title',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  event['description'] ?? 'No description available.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Event info
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person,
                            size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Organized by ${event['organizer']?['name'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.group,
                            size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${event['registrations_count'] ?? 0} registered',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 300) {
                      return Row(
                        children: [
                          Expanded(
                            child: ModernButton(
                              text: 'View Details',
                              onPressed: () => _viewEventDetails(event),
                              type: ModernButtonType.secondary,
                              icon: Icons.visibility_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernButton(
                              text: isUpcoming ? 'Register' : 'Past Event',
                              onPressed: isUpcoming
                                  ? () => _registerForEvent(event)
                                  : null,
                              type: ModernButtonType.primary,
                              icon: Icons.event_available_rounded,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          ModernButton(
                            text: 'View Details',
                            onPressed: () => _viewEventDetails(event),
                            type: ModernButtonType.secondary,
                            icon: Icons.visibility_rounded,
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 12),
                          ModernButton(
                            text: isUpcoming ? 'Register' : 'Past Event',
                            onPressed: isUpcoming
                                ? () => _registerForEvent(event)
                                : null,
                            type: ModernButtonType.primary,
                            icon: Icons.event_available_rounded,
                            isFullWidth: true,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Event Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ..._eventTypes.map((type) => ListTile(
                  title: Text(
                    type,
                    style: TextStyle(
                      color: _selectedFilter == type
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                      fontWeight: _selectedFilter == type
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: _selectedFilter == type
                      ? const Icon(Icons.check_rounded,
                          color: AppTheme.primaryColor)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFilter = type;
                    });
                    Navigator.of(context).pop(); // Close the modal
                    _loadEvents();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _viewEventDetails(Map<String, dynamic> event) {
    final startDate = DateTime.parse(event['start_date']);
    final endDate = DateTime.parse(event['end_date']);
    final isVirtual = event['is_virtual'] ?? false;
    final isUpcoming = startDate.isAfter(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event['title'] ?? 'Event Title',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        isUpcoming ? 'Upcoming' : 'Past Event',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      if (event['description'] != null) ...[
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Event Information
                      const Text(
                        'Event Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildEventInfoRow(
                        Icons.calendar_today,
                        'Date & Time',
                        '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                      ),
                      const SizedBox(height: 8),

                      _buildEventInfoRow(
                        isVirtual ? Icons.video_call : Icons.location_on,
                        'Location',
                        isVirtual
                            ? 'Virtual Event'
                            : (event['location'] ?? 'Location TBD'),
                      ),
                      const SizedBox(height: 8),

                      if (event['organizer'] != null) ...[
                        _buildEventInfoRow(
                          Icons.person,
                          'Organizer',
                          event['organizer']['name'] ?? 'Unknown',
                        ),
                        const SizedBox(height: 8),
                      ],

                      _buildEventInfoRow(
                        Icons.category,
                        'Event Type',
                        event['event_type'] ?? 'General',
                      ),
                      const SizedBox(height: 8),

                      _buildEventInfoRow(
                        Icons.people,
                        'Capacity',
                        event['capacity']?.toString() ?? 'Unlimited',
                      ),

                      const SizedBox(height: 20),

                      // Registration Status (for My Events)
                      if (event['registered_at'] != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.successColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.successColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Registration Confirmed',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.successColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Registered on ${_formatDate(DateTime.parse(event['registered_at']))}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.successColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 400) {
                      // Horizontal layout for larger screens
                      return Row(
                        children: [
                          if (event['registered_at'] == null && isUpcoming) ...[
                            Expanded(
                              child: ModernButton(
                                text: 'Register',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _registerForEvent(event);
                                },
                                type: ModernButtonType.primary,
                                icon: Icons.event_available_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (event['registered_at'] != null) ...[
                            Expanded(
                              child: ModernButton(
                                text: 'Cancel',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _cancelEventRegistration(event);
                                },
                                type: ModernButtonType.outline,
                                icon: Icons.cancel_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: ModernButton(
                              text: 'Close',
                              onPressed: () => Navigator.of(context).pop(),
                              type: ModernButtonType.secondary,
                              icon: Icons.close,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Vertical layout for smaller screens
                      return Column(
                        children: [
                          if (event['registered_at'] == null && isUpcoming) ...[
                            SizedBox(
                              width: double.infinity,
                              child: ModernButton(
                                text: 'Register',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _registerForEvent(event);
                                },
                                type: ModernButtonType.primary,
                                icon: Icons.event_available_rounded,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (event['registered_at'] != null) ...[
                            SizedBox(
                              width: double.infinity,
                              child: ModernButton(
                                text: 'Cancel Registration',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _cancelEventRegistration(event);
                                },
                                type: ModernButtonType.outline,
                                icon: Icons.cancel_outlined,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: ModernButton(
                              text: 'Close',
                              onPressed: () => Navigator.of(context).pop(),
                              type: ModernButtonType.secondary,
                              icon: Icons.close,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _registerForEvent(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => ModernAlertDialog(
        title: 'Register for Event',
        message: 'Are you sure you want to register for ${event['title']}?',
        confirmText: 'Register',
        cancelText: 'Cancel',
        onConfirm: () async {
          // Close the confirmation dialog first
          Navigator.of(context).pop();

          // Add event to My Events
          _addToMyEvents(event);

          // Show success message immediately (simulating registration)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully registered for ${event['title']}!'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          // Refresh the events list
          _loadEvents();

          print('✅ Event registration completed for: ${event['title']}');
        },
        onCancel: () {
          // Just close the dialog, don't navigate away
        },
      ),
    );
  }

  void _showCreateEventDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateEventDialog(
        onEventCreated: (event) {
          setState(() {
            _events.insert(0, event);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Event "${event['title']}" created successfully!'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CreateEventDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onEventCreated;

  const CreateEventDialog({
    super.key,
    required this.onEventCreated,
  });

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxAttendeesController = TextEditingController();
  final _registrationFeeController = TextEditingController();

  String _selectedEventType = 'Alumni Reunion';
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 7, hours: 4));
  DateTime? _registrationDeadline;
  bool _isVirtual = false;
  bool _isLoading = false;

  final List<String> _eventTypes = [
    'Alumni Reunion',
    'Conference',
    'Workshop',
    'Networking',
    'Webinar',
    'Seminar',
    'Social Event',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    _registrationFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.event_rounded,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Create New Event',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                ModernIconButton(
                  icon: Icons.close_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: AppTheme.textSecondary.withOpacity(0.1),
                  iconColor: AppTheme.textSecondary,
                  size: 36,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title
                    _buildFormField(
                      label: 'Event Title',
                      controller: _titleController,
                      icon: Icons.title_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event title';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Event Type
                    _buildDropdownField(
                      label: 'Event Type',
                      value: _selectedEventType,
                      items: _eventTypes,
                      icon: Icons.category_rounded,
                      onChanged: (value) {
                        setState(() {
                          _selectedEventType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Description
                    _buildFormField(
                      label: 'Description',
                      controller: _descriptionController,
                      icon: Icons.description_rounded,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event description';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Virtual Event Toggle
                    _buildToggleField(
                      label: 'Virtual Event',
                      value: _isVirtual,
                      icon: Icons.video_call_rounded,
                      onChanged: (value) {
                        setState(() {
                          _isVirtual = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Location (if not virtual)
                    if (!_isVirtual) ...[
                      _buildFormField(
                        label: 'Location',
                        controller: _locationController,
                        icon: Icons.location_on_rounded,
                        validator: (value) {
                          if (!_isVirtual && (value == null || value.isEmpty)) {
                            return 'Please enter event location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Date and Time Section
                    _buildSectionHeader('Date & Time'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'Start Date',
                            value: _startDate,
                            icon: Icons.calendar_today_rounded,
                            onChanged: (date) {
                              if (date != null) {
                                setState(() {
                                  _startDate = date;
                                  if (_endDate.isBefore(_startDate)) {
                                    _endDate = _startDate
                                        .add(const Duration(hours: 2));
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            label: 'End Date',
                            value: _endDate,
                            icon: Icons.calendar_today_rounded,
                            onChanged: (date) {
                              if (date != null) {
                                setState(() {
                                  _endDate = date;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Registration Deadline
                    _buildDateField(
                      label: 'Registration Deadline (Optional)',
                      value: _registrationDeadline,
                      icon: Icons.schedule_rounded,
                      onChanged: (date) {
                        setState(() {
                          _registrationDeadline = date;
                        });
                      },
                      isOptional: true,
                    ),

                    const SizedBox(height: 20),

                    // Capacity and Pricing Section
                    _buildSectionHeader('Capacity & Pricing'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            label: 'Max Attendees',
                            controller: _maxAttendeesController,
                            icon: Icons.people_rounded,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final attendees = int.tryParse(value);
                                if (attendees == null || attendees <= 0) {
                                  return 'Enter valid number';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFormField(
                            label: 'Registration Fee (\$)',
                            controller: _registrationFeeController,
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final fee = double.tryParse(value);
                                if (fee == null || fee < 0) {
                                  return 'Enter valid amount';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: _isLoading ? 'Creating Event...' : 'Create Event',
                        onPressed: _isLoading ? null : _createEvent,
                        type: ModernButtonType.primary,
                        icon: Icons.add_rounded,
                        isFullWidth: true,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
            boxShadow: AppTheme.cardShadow,
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              prefixIcon: Icon(icon, color: AppTheme.primaryColor),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
            boxShadow: AppTheme.cardShadow,
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primaryColor),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleField({
    required String label,
    required bool value,
    required IconData icon,
    required void Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required IconData icon,
    required void Function(DateTime?) onChanged,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value != null
                        ? '${value.day}/${value.month}/${value.year}'
                        : isOptional
                            ? 'Select date (optional)'
                            : 'Select date',
                    style: TextStyle(
                      fontSize: 16,
                      color: value != null
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final newEvent = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'description': _descriptionController.text,
      'event_type': _selectedEventType.toLowerCase().replaceAll(' ', '_'),
      'start_date': _startDate.toIso8601String(),
      'end_date': _endDate.toIso8601String(),
      'location': _isVirtual ? 'Virtual Event' : _locationController.text,
      'is_virtual': _isVirtual,
      'cover_image_url':
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
      'organizer': {'name': 'You', 'email': 'you@example.com'},
      'registrations_count': 0,
      'registration_fee':
          double.tryParse(_registrationFeeController.text) ?? 0.0,
      'max_attendees': int.tryParse(_maxAttendeesController.text),
      'registration_deadline': _registrationDeadline?.toIso8601String(),
    };

    setState(() {
      _isLoading = false;
    });

    context.go('/alumni-dashboard');
    widget.onEventCreated(newEvent);
  }
}

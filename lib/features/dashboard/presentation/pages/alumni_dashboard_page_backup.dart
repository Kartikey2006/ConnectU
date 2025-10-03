import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class AlumniDashboardPage extends StatefulWidget {
  const AlumniDashboardPage({super.key});

  @override
  State<AlumniDashboardPage> createState() => _AlumniDashboardPageState();
}

class _AlumniDashboardPageState extends State<AlumniDashboardPage> {
  int _selectedIndex = 0;
  bool _isSideMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surfaceColor,
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: Stack(
        children: [
          // Main Content
          Column(
            children: [
                // Modern Header
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isSideMenuOpen = !_isSideMenuOpen;
                        });
                      },
                      icon: const Icon(
                                  Icons.menu_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alumni Dashboard',
                        style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 24,
                          fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Share your expertise and connect with students',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                      onPressed: () => context.go('/notifications'),
                      icon: const Icon(
                        Icons.notifications_outlined,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // Welcome Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.floatingShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.work_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BlocBuilder<AuthBloc, AuthState>(
                                          builder: (context, state) {
                                            String userName = 'Alumni';
                                            if (state is Authenticated) {
                                              userName = state.user.user.name;
                                            }
                                            return Text(
                                              'Welcome back, $userName!',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Ready to mentor the next generation?',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickStat(
                                      'Active Mentees',
                                      '5',
                                      Icons.people_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickStat(
                                      'Sessions This Month',
                                      '12',
                                      Icons.calendar_today_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mentorship Requests Section
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.people_alt_rounded,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Mentorship Requests',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),

                        // Mentorship Requests Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            children: [
                              Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Mentorship',
                                      style: TextStyle(
                                            color: AppTheme.textSecondary,
                                        fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Pending Requests',
                                      style: TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'You have 3 pending mentorship requests from students.',
                                      style: TextStyle(
                                            color: AppTheme.textSecondary,
                                        fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                        const SizedBox(height: 16),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.primaryGradient,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: AppTheme.cardShadow,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // TODO: Navigate to mentorship requests
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Mentorship requests coming soon!')),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 12),
                                            ),
                                            child: const Text(
                                              'View Requests',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCfC_Y-PRg5dsPyd6AzUrR4yPWjGo2-uzZRcypWeXy_8gcmKmNj0MMsHP04akgKanrgcC4mAAi9SMQmmBMm3JGSZa5AZB5vrTDY8s0PlnoRkgGrx8Rk7ytykhzpBRqdcPVQcrfaiaGjeBLRI24lxzwNDRMh0kHu3g56gtykggkXU7sEgALbD2Qanw_dZlKjevnLR3s_hqN2ZLnVxuBDIi-7H_fFk3_J4b2oCANfRkcxWzWHL7hAJZdMa9wxqqs4Fl0cnKwodeK4wZA'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Webinars Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Webinars',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Host a Paid Webinar',
                                      style: TextStyle(
                                        color: Color(0xFF0E141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Share your expertise and earn by hosting a webinar for students.',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Navigate to create webinar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Create webinar coming soon!')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE7EDF3),
                                        foregroundColor:
                                            const Color(0xFF0E141B),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Host Webinar',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAxuaXmmzGeUrIz8rQVz6XfMBBf4_tYM3Aj-JzcfSgBzNL1wjNPxieGCAIPP5ALl1d8lGwy58jB8H4PTj6yAUBmIP85RtdOBhVuL7LIVSseJEBEUoBYj3aiOvX9-ur-EpvKCt_pLnLIr3wJWiQ7SPfYVeT5apzXSiklapPrOcGZlxsmxaSV9TlPYhXR_I6jlg-bxtUjf5YW_dE0iBOxcn10U5qSRTW1c4OiEI-tnTWTg2kmr5Cvo2E-r2FAo7LAtJtD7B_uDo_TUBM'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Donations Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Donations',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Donation History',
                                      style: TextStyle(
                                        color: Color(0xFF0E141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'View your past donations and support the university\'s initiatives.',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Navigate to donation history
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Donation history coming soon!')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE7EDF3),
                                        foregroundColor:
                                            const Color(0xFF0E141B),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'View History',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDiDbgnsOGu5TqyjneuMbs1Dou6IaE50BP5wgOy928zFr0-L2jM9kdzO74I5ojk6zQPKdlKpyF1k6pe_YizFF9E1rIz-SCjG4UL340j9l91iphmc62ToRuxcqc5Q4EDET8_hp9i1eEWn08W36Ltugs2yUrvlDrj0CqGAWKdyLytjFV2BSkY9K_omECEbUnIJWzvrKIb4_qUUXOtDu3rYZA3JP2EyfeORG4Ftvpi4jkVEM0Eyp-Ax13ZXZcvq9EguY4WTAHrkQRbEyU'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Student Success Stories Section
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Student Success Stories',
                            style: TextStyle(
                              color: Color(0xFF0E141B),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ),
                      ),

                      // Ethan's Journey Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ethan\'s Journey',
                                      style: TextStyle(
                                        color: Color(0xFF0E141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Ethan, a recent graduate, credits the alumni mentorship program for his successful career in tech.',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Navigate to full story
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Full story coming soon!')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE7EDF3),
                                        foregroundColor:
                                            const Color(0xFF0E141B),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Read More',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBkbCAtO-VFwThdj9lOp808IzkRqdbNj7MUSxFvC_eA8aEqRhVgeiy6rfq4O0xaODnICgAULmqHEcunizctaGhgrduasuEQLfVbXrS7Aumj0wuGHZB4Y8P5nRy29-KdxhdgpJWmzLk_vxUj4CpYafK79GX_kxz6GFzUhRQM9aoDoY0IIQKclOS3lkEumAEfpMLuaqBBzb1YzA5f_vikec7ItPD3ghsisid59PLPynObfBCw6eyaLK8fzaks8r12KkhEB_ekcNZ77_0'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Olivia's Breakthrough Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Olivia\'s Breakthrough',
                                      style: TextStyle(
                                        color: Color(0xFF0E141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Olivia, a scholarship recipient, shares how alumni donations helped her pursue her passion in environmental science.',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Navigate to full story
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Full story coming soon!')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE7EDF3),
                                        foregroundColor:
                                            const Color(0xFF0E141B),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Read More',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCz7_DmCNKKFL8NXFhOlcZEm3Sml-WBU7VBjw67qlAH91dcZSJDOR1OCVnIB6MewqBuY3Zvi04EQKQKrE74SPtytGhQ_nniqpVM7Rca7RIdTfGOnfBlP7FAv4tgbgr0SvgnStAMucFwLOcjTkciAs9ioWZD9GjYoCV2MF4SYplUVaPbIzmgibD-hgryKbLghADqJ8PEvrogDo0q1xmqaJwI1DE-PhQpUjvV1neCWkwyagANe2yK-Y4yIdP-90RxoRQojZxen_93sAI'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Upcoming Networking Events Section
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Upcoming Networking Events',
                            style: TextStyle(
                              color: Color(0xFF0E141B),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ),
                      ),

                      // Alumni Mixer Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Alumni Mixer',
                                      style: TextStyle(
                                        color: Color(0xFF0E141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Join us for an evening of networking and reconnecting with fellow alumni.',
                                      style: TextStyle(
                                        color: Color(0xFF4E7097),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Navigate to event registration
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Event registration coming soon!')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE7EDF3),
                                        foregroundColor:
                                            const Color(0xFF0E141B),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Register Now',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDOzIoG8NvNa3GqvRxKdDOAzc2ZssT3vwnG2AT383NxuMGvPE-Tx2hWiXK-j33jnpqMYKF7N4CvaT8jNgSRdtmLUgcrBEA-2_blMI7B5LbsYv_IQ6el8y2rzy5xfdn290MlacbACdicDVe7OmQWGssRgZqjlBCUqLSjAM-gpqM-cZ_CkaAcQpXNl_JueyTyLoW3J2zU5Rj_qa4ojFvbJ4SgfBa2hsC1chZ_4JI3-Q6SeubUNWW_WObS0DndE9rp6neUm9WuLbmq3to'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Community Forums Section
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Community Forums',
                            style: TextStyle(
                              color: Color(0xFF0E141B),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ),
                      ),

                      // Community Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () => context.go('/forums'),
                          child: Container(
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
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1979E6)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.forum,
                                    color: Color(0xFF1979E6),
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Join Discussions',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0E141B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Connect with alumni, share insights, and participate in community discussions',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4E7097),
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              '24 active discussions',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF10B981),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1979E6)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              '156 members online',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF1979E6),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF4E7097),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Side Navigation Menu
          if (_isSideMenuOpen) {
            SideNavigation(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                  _isSideMenuOpen = false;
                });
                _navigateSideMenuToPage(index);
              },
              onClose: () {
                setState(() {
                  _isSideMenuOpen = false;
                });
              },
            )
          },
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppTheme.cardShadow,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _navigateToPage(index);
          },
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.textSecondary,
            backgroundColor: Colors.white,
          elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded, size: 24),
              label: 'Alumni',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_rounded, size: 24),
              label: 'Mentorship',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded, size: 24),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake_rounded, size: 24),
              label: 'Referrals',
            ),
          ],
          ),
        ),
      ),
    )
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        // Alumni Network - navigate to enhanced alumni network page
        context.go('/alumni-network');
        break;
      case 2:
        context.go('/alumni-mentorship');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        context.go('/referrals');
        break;
    }
  }

  void _navigateSideMenuToPage(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        // Student Requests - navigate to dedicated alumni requests page
        context.go('/alumni-requests');
        break;
      case 2:
        // Referrals - navigate to referrals page
        context.go('/referrals');
        break;
      case 3:
        // Webinars - navigate to webinars page
        context.go('/webinars');
        break;
      case 4:
        // Donations - navigate to dedicated alumni donations page
        context.go('/alumni-donations');
        break;
      case 5:
        // Profile
        context.go('/profile');
        break;
    }
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SideNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onClose;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.83,
            height: double.infinity,
            color: const Color(0xFFF8FAFC),
            child: Column(
              children: [
                // User name
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String userName = 'Alumni';
                      if (state is Authenticated) {
                        userName = state.user.user.name;
                      }
                      return Text(
                        userName,
                        style: const TextStyle(
                          color: Color(0xFF0E141B),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      );
                    },
                  ),
                ),

                // Navigation items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildNavItem(
                        icon: Icons.home,
                        label: 'Dashboard',
                        isSelected: selectedIndex == 0,
                        onTap: () => onItemSelected(0),
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.people,
                        label: 'Student Requests',
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.handshake,
                        label: 'Referrals',
                        isSelected: selectedIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.video_call,
                        label: 'Webinars',
                        isSelected: selectedIndex == 3,
                        onTap: () => onItemSelected(3),
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.attach_money,
                        label: 'Donations',
                        isSelected: selectedIndex == 4,
                        onTap: () => onItemSelected(4),
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.person,
                        label: 'Profile',
                        isSelected: selectedIndex == 5,
                        onTap: () => onItemSelected(5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7EDF3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF0E141B),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0E141B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

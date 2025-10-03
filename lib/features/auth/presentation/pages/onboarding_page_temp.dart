import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/login_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/signup_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111922),
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and login button
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'ConnectU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF93ACC8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.015,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation tabs
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildTab('Home', true),
                          _buildTab('Alumni', false),
                          _buildTab('Students', false),
                          _buildTab('Events', false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hero section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero section with background image
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 480,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBN5eysxF_Id3nR43pojIRo9LWMb0dlmB5D8nZFjWBzv9NVLftHsyqVdDDBVcUwJvG2MrE-3KHdXaJhT0OnnvjGXOMQgDDi_U4XkF8m0j_zzPVlu3Stfvg8_v08QgpBxQ1KWd7vcItRExm5arZKQAlxDKQkM2RofQi-3QYVbtO0D4TqY5WxDmlNEMVkheLWafuHlY543X-_LUg8MbMAPRELXYmNJJhK-QlVnKKjmQB-eUytVg2CdRm5LgRFpqSXacAKusjK53Jy8IY',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title and subtitle
                            Column(
                              children: [
                                Text(
                                  'ConnectU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.033,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Connect with fellow alumni and current students. Expand your network, find mentors, and explore opportunities.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // For Students section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Student image
                          Container(
                            width: 120,
                            height: 67.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAVwak4CXtsNxdK6Jg0TdImswZ8MgMijzEuNmAY2bTTpNF05Snf2rYWybi9h96uuJaDxwesI_FjSLpZY7JXqUaUtwQdINhioOZNqJ_hV5vAOtRHFaomcNnTN-qO3i77FYzDeQSghEYiZ_AsGqd3GfvqMVcfg4kjJOaqTOKvW_dOlOb3LKD71ltEGdplGAduyDd2yCVxsRWApKOav8AMLgX6NcpVHEfc3JmZo1I5wzw-MDvgKB0C33X4AS09wch_5PR-Jbzw2DFI0ZQ',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Student content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'For Students',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.015,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Find mentors, get referrals, and explore career paths.',
                                        style: TextStyle(
                                          color: Color(0xFF93ACC8),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage()),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1979E6),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        minimumSize: const Size(0, 32),
                                      ),
                                      child: const Text(
                                        'Explore',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // For Alumni section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Alumni image
                          Container(
                            width: 120,
                            height: 67.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCNgVJ6umN0IugWdQnOAXQD37n24YHz_BEoo6vDD93qJJbnfFBiE0uqKPHhAZh1TjIoajj6Dt_4SGEKNLsUdbGMkU0NNg0djRjHbG5ltyB0BmDmJdYqv90fGPoJjcQgUJznu0jMO-2iOtymWNqHcDLGQj4mBgJy9eQ4N4H_svzti6pXts8CUYfF6-gLcQAOczFeOm_mkV0LyNTH6762UoBsukXkJu9dOZwS877P6dqDAdrx6-yuJKjqypTIuL9ay5HQ_IoBaGkx2Ok',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Alumni content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'For Alumni',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.015,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Host webinars, donate to the university, and network with peers.',
                                        style: TextStyle(
                                          color: Color(0xFF93ACC8),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage()),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1979E6),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        minimumSize: const Size(0, 32),
                                      ),
                                      child: const Text(
                                        'Explore',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF1979E6) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF93ACC8),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.015,
            ),
          ),
        ),
      ),
    );
  }
}

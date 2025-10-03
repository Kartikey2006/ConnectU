import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class MentorshipMatchingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// AI-powered matching algorithm that considers multiple factors
  Future<List<Map<String, dynamic>>> findMatchingMentors({
    required String menteeId,
    required List<String> interests,
    required String careerGoal,
    required String experienceLevel,
    int limit = 10,
  }) async {
    try {
      // Get mentee profile
      final menteeProfile = await _getUserProfile(menteeId);
      if (menteeProfile == null) {
        throw Exception('Mentee profile not found');
      }

      // Get all potential mentors (alumni with mentorship enabled)
      final mentors = await _getAvailableMentors();

      // Calculate compatibility scores for each mentor
      final List<Map<String, dynamic>> scoredMentors = [];

      for (final mentor in mentors) {
        final score = await _calculateCompatibilityScore(
          mentee: menteeProfile,
          mentor: mentor,
          interests: interests,
          careerGoal: careerGoal,
          experienceLevel: experienceLevel,
        );

        scoredMentors.add({
          ...mentor,
          'compatibility_score': score,
          'match_reasons': _getMatchReasons(menteeProfile, mentor, score),
        });
      }

      // Sort by compatibility score (highest first)
      scoredMentors.sort((a, b) => (b['compatibility_score'] as double)
          .compareTo(a['compatibility_score'] as double));

      // Return top matches
      return scoredMentors.take(limit).toList();
    } catch (e) {
      print('❌ Error finding matching mentors: $e');
      rethrow;
    }
  }

  /// Calculate compatibility score between mentee and mentor
  Future<double> _calculateCompatibilityScore({
    required Map<String, dynamic> mentee,
    required Map<String, dynamic> mentor,
    required List<String> interests,
    required String careerGoal,
    required String experienceLevel,
  }) async {
    double totalScore = 0.0;
    int factors = 0;

    // 1. Industry/Field Match (30% weight)
    final industryScore = _calculateIndustryMatch(mentee, mentor);
    totalScore += industryScore * 0.3;
    factors++;

    // 2. Skills and Expertise Match (25% weight)
    final skillsScore = _calculateSkillsMatch(mentee, mentor, interests);
    totalScore += skillsScore * 0.25;
    factors++;

    // 3. Experience Level Compatibility (20% weight)
    final experienceScore =
        _calculateExperienceCompatibility(mentee, mentor, experienceLevel);
    totalScore += experienceScore * 0.2;
    factors++;

    // 4. Career Goal Alignment (15% weight)
    final goalScore = _calculateGoalAlignment(mentee, mentor, careerGoal);
    totalScore += goalScore * 0.15;
    factors++;

    // 5. Location and Time Zone (5% weight)
    final locationScore = _calculateLocationCompatibility(mentee, mentor);
    totalScore += locationScore * 0.05;
    factors++;

    // 6. Communication Style and Availability (5% weight)
    final communicationScore =
        _calculateCommunicationCompatibility(mentee, mentor);
    totalScore += communicationScore * 0.05;
    factors++;

    return totalScore / factors;
  }

  /// Calculate industry/field match score
  double _calculateIndustryMatch(
      Map<String, dynamic> mentee, Map<String, dynamic> mentor) {
    final menteeIndustry = mentee['industry']?.toString().toLowerCase() ?? '';
    final mentorIndustry = mentor['industry']?.toString().toLowerCase() ?? '';

    if (menteeIndustry.isEmpty || mentorIndustry.isEmpty) return 0.5;

    // Exact match
    if (menteeIndustry == mentorIndustry) return 1.0;

    // Related industries (you can expand this mapping)
    final relatedIndustries = {
      'technology': ['software', 'it', 'tech', 'engineering', 'data science'],
      'finance': ['banking', 'investment', 'accounting', 'consulting'],
      'healthcare': ['medical', 'pharmaceutical', 'biotech', 'health'],
      'education': ['academic', 'training', 'research'],
      'marketing': [
        'advertising',
        'branding',
        'digital marketing',
        'communications'
      ],
    };

    for (final entry in relatedIndustries.entries) {
      if (entry.value.contains(menteeIndustry) &&
          entry.value.contains(mentorIndustry)) {
        return 0.8;
      }
    }

    return 0.3; // Default for unrelated industries
  }

  /// Calculate skills and expertise match score
  double _calculateSkillsMatch(Map<String, dynamic> mentee,
      Map<String, dynamic> mentor, List<String> interests) {
    final menteeSkills = (mentee['skills'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();
    final mentorSkills = (mentor['skills'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();

    if (menteeSkills.isEmpty || mentorSkills.isEmpty) return 0.5;

    // Calculate skill overlap
    final commonSkills =
        menteeSkills.where((skill) => mentorSkills.contains(skill)).length;
    final totalSkills =
        menteeSkills.length + mentorSkills.length - commonSkills;

    if (totalSkills == 0) return 0.5;

    final skillOverlapScore = commonSkills / totalSkills;

    // Bonus for interest alignment
    final interestBonus = interests.any((interest) =>
            mentorSkills.any((skill) => skill.contains(interest.toLowerCase())))
        ? 0.2
        : 0.0;

    return min(1.0, skillOverlapScore + interestBonus);
  }

  /// Calculate experience level compatibility
  double _calculateExperienceCompatibility(Map<String, dynamic> mentee,
      Map<String, dynamic> mentor, String experienceLevel) {
    final menteeExperience = mentee['experience_years'] ?? 0;
    final mentorExperience = mentor['experience_years'] ?? 0;

    // Ideal mentor has 3-10 years more experience than mentee
    const idealGap = 5.0;
    final actualGap = (mentorExperience - menteeExperience).abs();

    if (actualGap <= 2) return 0.6; // Too close in experience
    if (actualGap >= 15) return 0.4; // Too much gap

    // Calculate score based on how close to ideal gap
    final gapScore = 1.0 - (actualGap - idealGap).abs() / 10.0;
    return max(0.0, min(1.0, gapScore));
  }

  /// Calculate career goal alignment
  double _calculateGoalAlignment(Map<String, dynamic> mentee,
      Map<String, dynamic> mentor, String careerGoal) {
    final mentorGoals = (mentor['mentorship_goals'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();

    if (mentorGoals.isEmpty) return 0.5;

    final goalKeywords = careerGoal.toLowerCase().split(' ');
    final matchingGoals = mentorGoals
        .where((goal) => goalKeywords.any((keyword) => goal.contains(keyword)))
        .length;

    return min(1.0, matchingGoals / mentorGoals.length + 0.3);
  }

  /// Calculate location and time zone compatibility
  double _calculateLocationCompatibility(
      Map<String, dynamic> mentee, Map<String, dynamic> mentor) {
    final menteeLocation = mentee['location']?.toString().toLowerCase() ?? '';
    final mentorLocation = mentor['location']?.toString().toLowerCase() ?? '';

    if (menteeLocation.isEmpty || mentorLocation.isEmpty) return 0.5;

    // Same city/region
    if (menteeLocation == mentorLocation) return 1.0;

    // Same country (simplified check)
    final menteeCountry = menteeLocation.split(',').last.trim();
    final mentorCountry = mentorLocation.split(',').last.trim();

    if (menteeCountry == mentorCountry) return 0.7;

    // Different countries
    return 0.3;
  }

  /// Calculate communication style and availability compatibility
  double _calculateCommunicationCompatibility(
      Map<String, dynamic> mentee, Map<String, dynamic> mentor) {
    final menteePrefs = mentee['communication_preferences'] ?? {};
    final mentorPrefs = mentor['communication_preferences'] ?? {};

    // Check preferred communication methods
    final menteeMethods = (menteePrefs['methods'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();
    final mentorMethods = (mentorPrefs['methods'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();

    if (menteeMethods.isEmpty || mentorMethods.isEmpty) return 0.5;

    final commonMethods =
        menteeMethods.where((method) => mentorMethods.contains(method)).length;
    final methodScore =
        commonMethods / max(menteeMethods.length, mentorMethods.length);

    // Check availability overlap (simplified)
    const availabilityScore = 0.7; // Assume 70% availability overlap

    return (methodScore + availabilityScore) / 2;
  }

  /// Get match reasons for display
  List<String> _getMatchReasons(
      Map<String, dynamic> mentee, Map<String, dynamic> mentor, double score) {
    final reasons = <String>[];

    // Industry match
    final menteeIndustry = mentee['industry']?.toString() ?? '';
    final mentorIndustry = mentor['industry']?.toString() ?? '';
    if (menteeIndustry == mentorIndustry && menteeIndustry.isNotEmpty) {
      reasons.add('Same industry: $menteeIndustry');
    }

    // Skills match
    final menteeSkills = (mentee['skills'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    final mentorSkills = (mentor['skills'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final commonSkills =
        menteeSkills.where((skill) => mentorSkills.contains(skill)).toList();
    if (commonSkills.isNotEmpty) {
      reasons.add('Shared skills: ${commonSkills.take(3).join(', ')}');
    }

    // Experience level
    final menteeExp = mentee['experience_years'] ?? 0;
    final mentorExp = mentor['experience_years'] ?? 0;
    if (mentorExp > menteeExp + 3) {
      reasons.add('${mentorExp - menteeExp} years more experience');
    }

    // Location
    final menteeLocation = mentee['location']?.toString() ?? '';
    final mentorLocation = mentor['location']?.toString() ?? '';
    if (menteeLocation == mentorLocation && menteeLocation.isNotEmpty) {
      reasons.add('Same location: $menteeLocation');
    }

    // High compatibility score
    if (score > 0.8) {
      reasons.add('Excellent compatibility match');
    } else if (score > 0.6) {
      reasons.add('Good compatibility match');
    }

    return reasons.take(3).toList();
  }

  /// Get user profile from database
  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final response = await _supabase.from('users').select('''
            *,
            alumnidetails(*),
            studentdetails(*)
          ''').eq('supabase_auth_id', userId).single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }

  /// Get available mentors (alumni with mentorship enabled)
  Future<List<Map<String, dynamic>>> _getAvailableMentors() async {
    try {
      final response = await _supabase.from('users').select('''
            *,
            alumnidetails(*)
          ''').eq('role', 'alumni').eq('is_mentor', true).eq('is_active', true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching available mentors: $e');
      return [];
    }
  }

  /// Get mentorship recommendations based on user behavior
  Future<List<Map<String, dynamic>>> getPersonalizedRecommendations(
      String userId) async {
    try {
      // Get user's past mentorship interactions
      final pastSessions = await _supabase
          .from('mentorship_sessions')
          .select('*')
          .eq('mentee_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      // Analyze preferences from past sessions
      final preferences = _analyzeUserPreferences(pastSessions);

      // Get recommendations based on preferences
      return await findMatchingMentors(
        menteeId: userId,
        interests: preferences['interests'] ?? [],
        careerGoal: preferences['career_goal'] ?? '',
        experienceLevel: preferences['experience_level'] ?? 'beginner',
      );
    } catch (e) {
      print('❌ Error getting personalized recommendations: $e');
      return [];
    }
  }

  /// Analyze user preferences from past mentorship sessions
  Map<String, dynamic> _analyzeUserPreferences(List<dynamic> pastSessions) {
    final interests = <String>{};
    final careerGoals = <String>{};
    String experienceLevel = 'beginner';

    for (final session in pastSessions) {
      // Extract interests from session topics
      final topic = session['topic']?.toString() ?? '';
      if (topic.isNotEmpty) {
        interests.addAll(topic.split(',').map((e) => e.trim()));
      }

      // Extract career goals
      final goal = session['career_goal']?.toString() ?? '';
      if (goal.isNotEmpty) {
        careerGoals.add(goal);
      }

      // Determine experience level based on session complexity
      final complexity = session['complexity']?.toString() ?? 'beginner';
      if (complexity == 'advanced') {
        experienceLevel = 'advanced';
      } else if (complexity == 'intermediate' &&
          experienceLevel != 'advanced') {
        experienceLevel = 'intermediate';
      }
    }

    return {
      'interests': interests.toList(),
      'career_goal': careerGoals.isNotEmpty ? careerGoals.first : '',
      'experience_level': experienceLevel,
    };
  }

  /// Create a mentorship session with AI-suggested parameters
  Future<Map<String, dynamic>> createSmartMentorshipSession({
    required String menteeId,
    required String mentorId,
    required String topic,
    String? suggestedDuration,
    String? suggestedFormat,
  }) async {
    try {
      // Get mentor and mentee profiles for smart suggestions
      final mentor = await _getUserProfile(mentorId);
      final mentee = await _getUserProfile(menteeId);

      if (mentor == null || mentee == null) {
        throw Exception('Mentor or mentee profile not found');
      }

      // AI-suggested session parameters
      final suggestedParams = _generateSessionParameters(mentor, mentee, topic);

      final sessionData = {
        'mentee_id': menteeId,
        'mentor_id': mentorId,
        'topic': topic,
        'duration': suggestedDuration ?? suggestedParams['duration'],
        'format': suggestedFormat ?? suggestedParams['format'],
        'suggested_agenda': suggestedParams['agenda'],
        'learning_objectives': suggestedParams['objectives'],
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('mentorship_sessions')
          .insert(sessionData)
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('❌ Error creating smart mentorship session: $e');
      rethrow;
    }
  }

  /// Generate AI-suggested session parameters
  Map<String, dynamic> _generateSessionParameters(
    Map<String, dynamic> mentor,
    Map<String, dynamic> mentee,
    String topic,
  ) {
    // Analyze topic complexity and suggest appropriate duration
    String duration = '60'; // Default 60 minutes
    if (topic.toLowerCase().contains('career') ||
        topic.toLowerCase().contains('strategy')) {
      duration = '90'; // Longer for strategic discussions
    } else if (topic.toLowerCase().contains('quick') ||
        topic.toLowerCase().contains('brief')) {
      duration = '30'; // Shorter for quick questions
    }

    // Suggest format based on mentor preferences and topic
    String format = 'video_call'; // Default
    final mentorPrefs = mentor['communication_preferences'] ?? {};
    final preferredMethods = (mentorPrefs['methods'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();

    if (preferredMethods.contains('in_person')) {
      format = 'in_person';
    } else if (preferredMethods.contains('phone_call')) {
      format = 'phone_call';
    }

    // Generate suggested agenda based on topic
    final agenda = _generateAgenda(topic, mentor, mentee);

    // Generate learning objectives
    final objectives = _generateLearningObjectives(topic, mentee);

    return {
      'duration': duration,
      'format': format,
      'agenda': agenda,
      'objectives': objectives,
    };
  }

  /// Generate suggested agenda for the session
  List<String> _generateAgenda(
      String topic, Map<String, dynamic> mentor, Map<String, dynamic> mentee) {
    final agenda = <String>[];

    // Topic-specific agenda items
    if (topic.toLowerCase().contains('career')) {
      agenda.addAll([
        'Career goals and aspirations discussion',
        'Current challenges and obstacles',
        'Skill gap analysis',
        'Action plan development',
        'Next steps and follow-up',
      ]);
    } else if (topic.toLowerCase().contains('technical')) {
      agenda.addAll([
        'Technical concept overview',
        'Hands-on demonstration',
        'Practice exercises',
        'Q&A and clarifications',
        'Resources and next steps',
      ]);
    } else {
      agenda.addAll([
        'Introduction and context setting',
        'Main topic discussion',
        'Practical examples and case studies',
        'Q&A session',
        'Summary and action items',
      ]);
    }

    return agenda;
  }

  /// Generate learning objectives for the session
  List<String> _generateLearningObjectives(
      String topic, Map<String, dynamic> mentee) {
    final objectives = <String>[];

    if (topic.toLowerCase().contains('career')) {
      objectives.addAll([
        'Define clear career goals and milestones',
        'Identify key skills needed for advancement',
        'Create a personalized development plan',
        'Understand industry trends and opportunities',
      ]);
    } else if (topic.toLowerCase().contains('leadership')) {
      objectives.addAll([
        'Learn core leadership principles',
        'Develop communication and delegation skills',
        'Understand team dynamics and management',
        'Create a leadership development plan',
      ]);
    } else {
      objectives.addAll([
        'Gain practical knowledge in the topic area',
        'Apply concepts to current challenges',
        'Develop actionable next steps',
        'Build confidence in the subject matter',
      ]);
    }

    return objectives;
  }
}

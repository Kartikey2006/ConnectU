import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Update basic profile information
  Future<Map<String, dynamic>> updateBasicProfile({
    required int userId,
    required String name,
    required String email,
  }) async {
    try {
      final response = await _supabase
          .from('users')
          .update({
            'name': name,
            'email': email,
          })
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to update basic profile: $e');
    }
  }

  // Update personal information
  Future<Map<String, dynamic>> updatePersonalInfo({
    required int userId,
    required String phoneNumber,
    required String address,
    required String bio,
  }) async {
    try {
      // Update users table with personal info
      final response = await _supabase
          .from('users')
          .update({
            'phone_number': phoneNumber,
            'bio': bio,
            'address': address,
          })
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to update personal information: $e');
    }
  }

  // Update professional information
  Future<Map<String, dynamic>> updateProfessionalInfo({
    required int userId,
    required String company,
    required String position,
    required int experience,
    required String skills,
    required String userRole,
  }) async {
    try {
      Map<String, dynamic> response;

      if (userRole == 'alumni') {
        // Update alumnidetails table
        response = await _supabase
            .from('alumnidetails')
            .upsert({
              'user_id': userId,
              'company': company,
              'designation': position,
              'experience_years': experience,
              'skills': skills,
            })
            .select()
            .single();
      } else {
        // Update studentdetails table
        response = await _supabase
            .from('studentdetails')
            .upsert({
              'user_id': userId,
              'current_company': company,
              'position': position,
              'experience_years': experience,
              'skills': skills,
            })
            .select()
            .single();
      }

      return response;
    } catch (e) {
      throw Exception('Failed to update professional information: $e');
    }
  }

  // Add achievement
  Future<Map<String, dynamic>> addAchievement({
    required int userId,
    required String title,
    required String description,
    String? emoji,
  }) async {
    try {
      final response = await _supabase
          .from('achievements')
          .insert({
            'user_id': userId,
            'title': title,
            'description': description,
            'emoji': emoji ?? '🏆',
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to add achievement: $e');
    }
  }

  // Get user achievements
  Future<List<Map<String, dynamic>>> getUserAchievements(int userId) async {
    try {
      final response = await _supabase
          .from('achievements')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get achievements: $e');
    }
  }

  // Delete achievement
  Future<void> deleteAchievement(int achievementId) async {
    try {
      await _supabase.from('achievements').delete().eq('id', achievementId);
    } catch (e) {
      throw Exception('Failed to delete achievement: $e');
    }
  }

  // Update notification preferences
  Future<Map<String, dynamic>> updateNotificationPreferences({
    required int userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool eventReminders,
    required bool mentorshipUpdates,
  }) async {
    try {
      final response = await _supabase
          .from('notification_preferences')
          .upsert({
            'user_id': userId,
            'push_notifications': pushNotifications,
            'email_notifications': emailNotifications,
            'event_reminders': eventReminders,
            'mentorship_updates': mentorshipUpdates,
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  // Get notification preferences
  Future<Map<String, dynamic>> getNotificationPreferences(int userId) async {
    try {
      final response = await _supabase
          .from('notification_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      return response ??
          {
            'push_notifications': true,
            'email_notifications': true,
            'event_reminders': false,
            'mentorship_updates': true,
          };
    } catch (e) {
      throw Exception('Failed to get notification preferences: $e');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Update profile image
  Future<String> updateProfileImage({
    required int userId,
    required String imagePath,
  }) async {
    try {
      // Upload image to Supabase Storage
      final fileName =
          'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage
          .from('profile-images')
          .upload(fileName, File(imagePath));

      // Get public URL
      final imageUrl =
          _supabase.storage.from('profile-images').getPublicUrl(fileName);

      // Update user record with new image URL
      await _supabase
          .from('users')
          .update({'profile_image_url': imageUrl}).eq('id', userId);

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }

  // Get user profile with all details
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final userResponse =
          await _supabase.from('users').select().eq('id', userId).single();

      Map<String, dynamic> profile = Map<String, dynamic>.from(userResponse);

      // Get role-specific details
      if (userResponse['role'] == 'alumni') {
        final alumniDetails = await _supabase
            .from('alumnidetails')
            .select()
            .eq('user_id', userId)
            .maybeSingle();
        if (alumniDetails != null) {
          profile.addAll(alumniDetails);
        }
      } else if (userResponse['role'] == 'student') {
        final studentDetails = await _supabase
            .from('studentdetails')
            .select()
            .eq('user_id', userId)
            .maybeSingle();
        if (studentDetails != null) {
          profile.addAll(studentDetails);
        }
      }

      // Get achievements
      final achievements = await getUserAchievements(userId);
      profile['achievements'] = achievements;

      // Get notification preferences
      final notificationPrefs = await getNotificationPreferences(userId);
      profile['notification_preferences'] = notificationPrefs;

      return profile;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Submit support message
  Future<Map<String, dynamic>> submitSupportMessage({
    required int userId,
    required String message,
    required String category,
  }) async {
    try {
      final response = await _supabase
          .from('support_messages')
          .insert({
            'user_id': userId,
            'message': message,
            'category': category,
            'status': 'pending',
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to submit support message: $e');
    }
  }

  // Submit bug report
  Future<Map<String, dynamic>> submitBugReport({
    required int userId,
    required String description,
    required String steps,
    String? deviceInfo,
  }) async {
    try {
      final response = await _supabase
          .from('bug_reports')
          .insert({
            'user_id': userId,
            'description': description,
            'steps_to_reproduce': steps,
            'device_info': deviceInfo,
            'status': 'pending',
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to submit bug report: $e');
    }
  }
}

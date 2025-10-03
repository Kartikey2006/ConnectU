import 'package:connectu_alumni_platform/core/models/user.dart';

abstract class ProfileRepository {
  Future<User> updateBasicProfile({
    required int userId,
    required String name,
    required String email,
  });

  Future<Map<String, dynamic>> updatePersonalInfo({
    required int userId,
    required String phoneNumber,
    required String address,
    required String bio,
  });

  Future<Map<String, dynamic>> updateProfessionalInfo({
    required int userId,
    required String company,
    required String position,
    required int experience,
    required String skills,
    required String userRole,
  });

  Future<Map<String, dynamic>> addAchievement({
    required int userId,
    required String title,
    required String description,
    String? emoji,
  });

  Future<List<Map<String, dynamic>>> getUserAchievements(int userId);

  Future<void> deleteAchievement(int achievementId);

  Future<Map<String, dynamic>> updateNotificationPreferences({
    required int userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool eventReminders,
    required bool mentorshipUpdates,
  });

  Future<Map<String, dynamic>> getNotificationPreferences(int userId);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<String> updateProfileImage({
    required int userId,
    required String imagePath,
  });

  Future<Map<String, dynamic>> getUserProfile(int userId);

  Future<Map<String, dynamic>> submitSupportMessage({
    required int userId,
    required String message,
    required String category,
  });

  Future<Map<String, dynamic>> submitBugReport({
    required int userId,
    required String description,
    required String steps,
    String? deviceInfo,
  });
}

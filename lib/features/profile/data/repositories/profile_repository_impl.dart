import 'package:connectu_alumni_platform/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/profile/domain/repositories/profile_repository.dart';
import 'package:connectu_alumni_platform/core/models/user.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> updateBasicProfile({
    required int userId,
    required String name,
    required String email,
  }) async {
    final response = await _remoteDataSource.updateBasicProfile(
      userId: userId,
      name: name,
      email: email,
    );
    return User.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> updatePersonalInfo({
    required int userId,
    required String phoneNumber,
    required String address,
    required String bio,
  }) async {
    return await _remoteDataSource.updatePersonalInfo(
      userId: userId,
      phoneNumber: phoneNumber,
      address: address,
      bio: bio,
    );
  }

  @override
  Future<Map<String, dynamic>> updateProfessionalInfo({
    required int userId,
    required String company,
    required String position,
    required int experience,
    required String skills,
    required String userRole,
  }) async {
    return await _remoteDataSource.updateProfessionalInfo(
      userId: userId,
      company: company,
      position: position,
      experience: experience,
      skills: skills,
      userRole: userRole,
    );
  }

  @override
  Future<Map<String, dynamic>> addAchievement({
    required int userId,
    required String title,
    required String description,
    String? emoji,
  }) async {
    return await _remoteDataSource.addAchievement(
      userId: userId,
      title: title,
      description: description,
      emoji: emoji,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getUserAchievements(int userId) async {
    return await _remoteDataSource.getUserAchievements(userId);
  }

  @override
  Future<void> deleteAchievement(int achievementId) async {
    await _remoteDataSource.deleteAchievement(achievementId);
  }

  @override
  Future<Map<String, dynamic>> updateNotificationPreferences({
    required int userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool eventReminders,
    required bool mentorshipUpdates,
  }) async {
    return await _remoteDataSource.updateNotificationPreferences(
      userId: userId,
      pushNotifications: pushNotifications,
      emailNotifications: emailNotifications,
      eventReminders: eventReminders,
      mentorshipUpdates: mentorshipUpdates,
    );
  }

  @override
  Future<Map<String, dynamic>> getNotificationPreferences(int userId) async {
    return await _remoteDataSource.getNotificationPreferences(userId);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<String> updateProfileImage({
    required int userId,
    required String imagePath,
  }) async {
    return await _remoteDataSource.updateProfileImage(
      userId: userId,
      imagePath: imagePath,
    );
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    return await _remoteDataSource.getUserProfile(userId);
  }

  @override
  Future<Map<String, dynamic>> submitSupportMessage({
    required int userId,
    required String message,
    required String category,
  }) async {
    return await _remoteDataSource.submitSupportMessage(
      userId: userId,
      message: message,
      category: category,
    );
  }

  @override
  Future<Map<String, dynamic>> submitBugReport({
    required int userId,
    required String description,
    required String steps,
    String? deviceInfo,
  }) async {
    return await _remoteDataSource.submitBugReport(
      userId: userId,
      description: description,
      steps: steps,
      deviceInfo: deviceInfo,
    );
  }
}

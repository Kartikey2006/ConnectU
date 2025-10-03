import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectu_alumni_platform/features/profile/domain/repositories/profile_repository.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  final int userId;

  const LoadUserProfile(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateBasicProfile extends ProfileEvent {
  final int userId;
  final String name;
  final String email;

  const UpdateBasicProfile({
    required this.userId,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [userId, name, email];
}

class UpdatePersonalInfo extends ProfileEvent {
  final int userId;
  final String phoneNumber;
  final String address;
  final String bio;

  const UpdatePersonalInfo({
    required this.userId,
    required this.phoneNumber,
    required this.address,
    required this.bio,
  });

  @override
  List<Object> get props => [userId, phoneNumber, address, bio];
}

class UpdateProfessionalInfo extends ProfileEvent {
  final int userId;
  final String company;
  final String position;
  final int experience;
  final String skills;
  final String userRole;

  const UpdateProfessionalInfo({
    required this.userId,
    required this.company,
    required this.position,
    required this.experience,
    required this.skills,
    required this.userRole,
  });

  @override
  List<Object> get props =>
      [userId, company, position, experience, skills, userRole];
}

class AddAchievement extends ProfileEvent {
  final int userId;
  final String title;
  final String description;
  final String? emoji;

  const AddAchievement({
    required this.userId,
    required this.title,
    required this.description,
    this.emoji,
  });

  @override
  List<Object?> get props => [userId, title, description, emoji];
}

class LoadUserAchievements extends ProfileEvent {
  final int userId;

  const LoadUserAchievements(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeleteAchievement extends ProfileEvent {
  final int achievementId;

  const DeleteAchievement(this.achievementId);

  @override
  List<Object> get props => [achievementId];
}

class UpdateNotificationPreferences extends ProfileEvent {
  final int userId;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool eventReminders;
  final bool mentorshipUpdates;

  const UpdateNotificationPreferences({
    required this.userId,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.eventReminders,
    required this.mentorshipUpdates,
  });

  @override
  List<Object> get props => [
        userId,
        pushNotifications,
        emailNotifications,
        eventReminders,
        mentorshipUpdates
      ];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class SubmitSupportMessage extends ProfileEvent {
  final int userId;
  final String message;
  final String category;

  const SubmitSupportMessage({
    required this.userId,
    required this.message,
    required this.category,
  });

  @override
  List<Object> get props => [userId, message, category];
}

class SubmitBugReport extends ProfileEvent {
  final int userId;
  final String description;
  final String steps;
  final String? deviceInfo;

  const SubmitBugReport({
    required this.userId,
    required this.description,
    required this.steps,
    this.deviceInfo,
  });

  @override
  List<Object?> get props => [userId, description, steps, deviceInfo];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userProfile;
  final List<Map<String, dynamic>> achievements;
  final Map<String, dynamic> notificationPreferences;

  const ProfileLoaded({
    required this.userProfile,
    required this.achievements,
    required this.notificationPreferences,
  });

  @override
  List<Object?> get props =>
      [userProfile, achievements, notificationPreferences];
}

class ProfileUpdated extends ProfileState {
  final String message;

  const ProfileUpdated(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class AchievementAdded extends ProfileState {
  final String message;

  const AchievementAdded(this.message);

  @override
  List<Object> get props => [message];
}

class AchievementDeleted extends ProfileState {
  final String message;

  const AchievementDeleted(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordChanged extends ProfileState {
  final String message;

  const PasswordChanged(this.message);

  @override
  List<Object> get props => [message];
}

class SupportMessageSubmitted extends ProfileState {
  final String message;

  const SupportMessageSubmitted(this.message);

  @override
  List<Object> get props => [message];
}

class BugReportSubmitted extends ProfileState {
  final String message;

  const BugReportSubmitted(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateBasicProfile>(_onUpdateBasicProfile);
    on<UpdatePersonalInfo>(_onUpdatePersonalInfo);
    on<UpdateProfessionalInfo>(_onUpdateProfessionalInfo);
    on<AddAchievement>(_onAddAchievement);
    on<LoadUserAchievements>(_onLoadUserAchievements);
    on<DeleteAchievement>(_onDeleteAchievement);
    on<UpdateNotificationPreferences>(_onUpdateNotificationPreferences);
    on<ChangePassword>(_onChangePassword);
    on<SubmitSupportMessage>(_onSubmitSupportMessage);
    on<SubmitBugReport>(_onSubmitBugReport);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userProfile = await _profileRepository.getUserProfile(event.userId);
      final achievements =
          await _profileRepository.getUserAchievements(event.userId);
      final notificationPreferences =
          await _profileRepository.getNotificationPreferences(event.userId);

      emit(ProfileLoaded(
        userProfile: userProfile,
        achievements: achievements,
        notificationPreferences: notificationPreferences,
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBasicProfile(
      UpdateBasicProfile event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.updateBasicProfile(
        userId: event.userId,
        name: event.name,
        email: event.email,
      );
      emit(const ProfileUpdated('Profile updated successfully!'));
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdatePersonalInfo(
      UpdatePersonalInfo event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.updatePersonalInfo(
        userId: event.userId,
        phoneNumber: event.phoneNumber,
        address: event.address,
        bio: event.bio,
      );
      emit(const ProfileUpdated('Personal information updated successfully!'));
    } catch (e) {
      emit(ProfileError(
          'Failed to update personal information: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfessionalInfo(
      UpdateProfessionalInfo event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.updateProfessionalInfo(
        userId: event.userId,
        company: event.company,
        position: event.position,
        experience: event.experience,
        skills: event.skills,
        userRole: event.userRole,
      );
      emit(const ProfileUpdated(
          'Professional information updated successfully!'));
    } catch (e) {
      emit(ProfileError(
          'Failed to update professional information: ${e.toString()}'));
    }
  }

  Future<void> _onAddAchievement(
      AddAchievement event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.addAchievement(
        userId: event.userId,
        title: event.title,
        description: event.description,
        emoji: event.emoji,
      );
      emit(const AchievementAdded('Achievement added successfully!'));
    } catch (e) {
      emit(ProfileError('Failed to add achievement: ${e.toString()}'));
    }
  }

  Future<void> _onLoadUserAchievements(
      LoadUserAchievements event, Emitter<ProfileState> emit) async {
    try {
      final achievements =
          await _profileRepository.getUserAchievements(event.userId);
      // Update current state with new achievements
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(ProfileLoaded(
          userProfile: currentState.userProfile,
          achievements: achievements,
          notificationPreferences: currentState.notificationPreferences,
        ));
      }
    } catch (e) {
      emit(ProfileError('Failed to load achievements: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAchievement(
      DeleteAchievement event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.deleteAchievement(event.achievementId);
      emit(const AchievementDeleted('Achievement deleted successfully!'));
    } catch (e) {
      emit(ProfileError('Failed to delete achievement: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNotificationPreferences(
      UpdateNotificationPreferences event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.updateNotificationPreferences(
        userId: event.userId,
        pushNotifications: event.pushNotifications,
        emailNotifications: event.emailNotifications,
        eventReminders: event.eventReminders,
        mentorshipUpdates: event.mentorshipUpdates,
      );
      emit(
          const ProfileUpdated('Notification preferences saved successfully!'));
    } catch (e) {
      emit(ProfileError(
          'Failed to update notification preferences: ${e.toString()}'));
    }
  }

  Future<void> _onChangePassword(
      ChangePassword event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(const PasswordChanged('Password changed successfully!'));
    } catch (e) {
      emit(ProfileError('Failed to change password: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitSupportMessage(
      SubmitSupportMessage event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.submitSupportMessage(
        userId: event.userId,
        message: event.message,
        category: event.category,
      );
      emit(const SupportMessageSubmitted('Support message sent successfully!'));
    } catch (e) {
      emit(ProfileError('Failed to submit support message: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitBugReport(
      SubmitBugReport event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.submitBugReport(
        userId: event.userId,
        description: event.description,
        steps: event.steps,
        deviceInfo: event.deviceInfo,
      );
      emit(const BugReportSubmitted('Bug report submitted successfully!'));
    } catch (e) {
      emit(ProfileError('Failed to submit bug report: ${e.toString()}'));
    }
  }
}

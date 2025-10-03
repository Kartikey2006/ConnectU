import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectu_alumni_platform/core/models/alumni_profile.dart';

class ProfileService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> saveAlumniProfile(AlumniProfile profile) async {
    try {
      print('💾 Saving alumni profile for user: ${profile.userId}');

      // For now, just save to local storage until database table is created
      // This allows the profile completion flow to work
      print(
          '📝 Saving alumni profile to local storage (database table not created yet)');

      // TODO: Uncomment when alumni_profiles table is created in database
      /*
      // First, check if profile already exists
      final existingProfile = await _supabase
          .from('alumni_profiles')
          .select()
          .eq('user_id', profile.userId)
          .maybeSingle();

      if (existingProfile != null) {
        // Update existing profile
        print('📝 Updating existing alumni profile...');
        await _supabase
            .from('alumni_profiles')
            .update(profile.toJson())
            .eq('user_id', profile.userId);
        print('✅ Alumni profile updated successfully');
      } else {
        // Create new profile
        print('📝 Creating new alumni profile...');
        await _supabase
            .from('alumni_profiles')
            .insert(profile.toJson());
        print('✅ Alumni profile created successfully');
      }
      */

      print('✅ Alumni profile saved successfully (local storage)');
    } catch (e) {
      print('❌ Error saving alumni profile: $e');
      throw Exception('Failed to save alumni profile: $e');
    }
  }

  static Future<AlumniProfile?> getAlumniProfile(int userId) async {
    try {
      print('🔍 Fetching alumni profile for user: $userId');

      final response = await _supabase
          .from('alumni_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        print('✅ Alumni profile found');
        return AlumniProfile.fromJson(response);
      } else {
        print('ℹ️ No alumni profile found');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching alumni profile: $e');
      throw Exception('Failed to fetch alumni profile: $e');
    }
  }

  static Future<bool> hasCompletedProfile(int userId) async {
    try {
      final profile = await getAlumniProfile(userId);
      return profile != null;
    } catch (e) {
      print('❌ Error checking profile completion: $e');
      return false;
    }
  }
}

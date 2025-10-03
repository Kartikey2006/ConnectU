import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectu_alumni_platform/core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Setting up database tables...');
  
  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    
    final supabase = Supabase.instance.client;
    
    // Test 1: Check if alumni_profiles table exists
    print('🔍 Checking if alumni_profiles table exists...');
    try {
      final result = await supabase
          .from('alumni_profiles')
          .select('id')
          .limit(1);
      print('✅ alumni_profiles table exists');
    } catch (e) {
      print('❌ alumni_profiles table does not exist: $e');
      print('📝 You need to run the SQL migration in your Supabase dashboard');
      print('📄 Run the SQL from: Database/create_alumni_profiles_table.sql');
    }
    
    // Test 2: Check if users table has supabase_auth_id column
    print('🔍 Checking if users table has supabase_auth_id column...');
    try {
      final result = await supabase
          .from('users')
          .select('id, name, email, role, supabase_auth_id')
          .limit(1);
      print('✅ users table has supabase_auth_id column');
    } catch (e) {
      print('❌ users table missing supabase_auth_id column: $e');
      print('📝 You need to run the SQL migration in your Supabase dashboard');
      print('📄 Run the SQL from: Database/migration_add_supabase_auth_id.sql');
    }
    
    print('✅ Database setup check completed');
    
  } catch (e) {
    print('❌ Error setting up database: $e');
  }
}

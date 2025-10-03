# Signup Page Fix Guide

## Problem Identified
The signup page was appearing blank due to a database linking issue between Supabase Auth and the local users table.

## Root Cause
1. **Missing Database Link**: The `supabase_auth_id` field was commented out in the signup process
2. **User Lookup Failure**: The `_getUserFromSupabase` method was trying to find users by email instead of the proper `supabase_auth_id`
3. **Database Migration**: The migration to add `supabase_auth_id` column needs to be run on the Supabase database

## Fixes Applied

### 1. Fixed AuthRemoteDataSourceImpl
- **File**: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- **Changes**:
  - Uncommented the `supabase_auth_id` field in the signup method (line 89)
  - Updated `_getUserFromSupabase` method to use `supabase_auth_id` for user lookup
  - Added fallback to email-based lookup for backward compatibility

### 2. Database Migration Required
- **File**: `Database/migration_add_supabase_auth_id.sql`
- **Action**: Run this migration on your Supabase database to add the `supabase_auth_id` column

## Steps to Complete the Fix

### 1. Run Database Migration
Execute the following SQL in your Supabase SQL editor:

```sql
-- Migration to add supabase_auth_id field to users table
ALTER TABLE public.users 
ADD COLUMN supabase_auth_id text UNIQUE;

-- Create an index for better performance
CREATE INDEX idx_users_supabase_auth_id ON public.users(supabase_auth_id);

-- Add a comment to explain the field
COMMENT ON COLUMN public.users.supabase_auth_id IS 'Supabase Auth user ID for linking with authentication system';
```

### 2. Verify RLS Policies
Ensure your Supabase database has proper RLS policies for the users table:

```sql
-- Enable RLS on users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Allow users to insert their own records
CREATE POLICY "Users can insert their own records" ON public.users
FOR INSERT WITH CHECK (auth.uid()::text = supabase_auth_id);

-- Allow users to read their own records
CREATE POLICY "Users can read their own records" ON public.users
FOR SELECT USING (auth.uid()::text = supabase_auth_id);

-- Allow users to update their own records
CREATE POLICY "Users can update their own records" ON public.users
FOR UPDATE USING (auth.uid()::text = supabase_auth_id);
```

### 3. Test the Signup
1. Run the app: `flutter run`
2. Navigate to the signup page
3. Fill in the form with test data
4. Submit the form
5. Verify that the user is created and redirected to the appropriate dashboard

## Testing
A test file has been created at `lib/test_signup.dart` to verify the signup functionality works correctly.

## Files Modified
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/test_signup.dart` (new test file)

## Expected Result
After applying these fixes and running the database migration, the signup page should work correctly:
1. Users can fill out the signup form
2. Upon submission, a new user is created in both Supabase Auth and the users table
3. The user is properly linked via `supabase_auth_id`
4. The user is redirected to the appropriate dashboard based on their role

## Troubleshooting
If the signup still doesn't work:
1. Check Supabase logs for any RLS policy violations
2. Verify the migration was run successfully
3. Check that the Supabase project URL and keys are correct in `lib/core/config/app_config.dart`
4. Run `flutter clean && flutter pub get` to ensure all dependencies are properly installed

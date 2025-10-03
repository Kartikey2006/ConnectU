# Student Signup Fix Guide

## 🚨 Problem
Student signup redirects back to login/signup page instead of going to student dashboard.

## 🔍 Root Cause
From the terminal logs, I can see:
1. ✅ User is created successfully in database
2. ❌ User lookup fails because `supabase_auth_id` column doesn't exist
3. ❌ Email lookup fails due to case sensitivity issues

## 🛠️ Solution

### Step 1: Run Database Migration
Run this SQL in your Supabase SQL Editor:

```sql
-- Add supabase_auth_id column if it doesn't exist
ALTER TABLE users ADD COLUMN IF NOT EXISTS supabase_auth_id TEXT;

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_users_supabase_auth_id ON users(supabase_auth_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Update RLS policies to allow proper access
DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;

-- Create new RLS policies
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid()::text = supabase_auth_id OR email = auth.jwt() ->> 'email');

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid()::text = supabase_auth_id OR email = auth.jwt() ->> 'email');

CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT WITH CHECK (true);

-- Grant necessary permissions
GRANT ALL ON users TO authenticated;
GRANT ALL ON users TO anon;
```

### Step 2: Test the Fix
1. Run the app: `flutter run --debug`
2. Try signing up as a student
3. Should redirect to student dashboard

### Step 3: Alternative Test
Run the test app: `flutter run lib/test_student_signup_simple.dart --debug`

## 🔧 Code Changes Made

### 1. Improved User Lookup Logic
- Added multiple email variations (original, lowercase, uppercase)
- Enhanced case-insensitive search
- Better error handling and logging

### 2. Database Migration Script
- Added missing `supabase_auth_id` column
- Created proper indexes
- Updated RLS policies

### 3. Test Files
- `lib/test_student_signup_simple.dart` - Simple test app
- `Database/quick_fix_student_signup.sql` - Database migration

## 📱 Expected Results

After running the migration:
1. **Student Signup** → Creates user → Redirects to `/student-dashboard` ✅
2. **Alumni Signup** → Creates user → Redirects to `/alumni-profile-completion` ✅
3. **Proper Error Handling** → Clear error messages if something goes wrong ✅

## 🐛 Debugging

If it still doesn't work, check:
1. Database migration was successful
2. Check terminal logs for specific error messages
3. Verify user is created in Supabase dashboard
4. Check RLS policies are correct

## 📋 Files Modified

- `lib/features/auth/data/datasources/auth_remote_datasource.dart` - Improved user lookup
- `Database/quick_fix_student_signup.sql` - Database migration
- `lib/test_student_signup_simple.dart` - Test app

The fix should resolve the student signup redirect issue! 🎉

# Database Migration Guide for Signup Fix

## Problem
After signup, users are being redirected back to login/signup page instead of dashboard. This is because the `supabase_auth_id` column doesn't exist in the database yet.

## Solution
You need to run the database migration in your Supabase dashboard.

## Steps to Fix

### 1. Open Supabase Dashboard
1. Go to [https://supabase.com](https://supabase.com)
2. Sign in to your account
3. Select your project: `cudwwhohzfxmflquizhk`

### 2. Run the Migration
1. Go to **SQL Editor** in the left sidebar
2. Click **New Query**
3. Copy and paste the following SQL:

```sql
-- Migration to add supabase_auth_id field to users table
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS supabase_auth_id text UNIQUE;

-- Create an index for better performance
CREATE INDEX IF NOT EXISTS idx_users_supabase_auth_id ON public.users(supabase_auth_id);

-- Add a comment to explain the field
COMMENT ON COLUMN public.users.supabase_auth_id IS 'Supabase Auth user ID for linking with authentication system';
```

4. Click **Run** to execute the migration

### 3. Set up RLS Policies
After running the migration, also run these RLS policies:

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

### 4. Test the Signup
1. Run the app: `flutter run`
2. Try to sign up with a new user
3. Check the console logs for detailed error messages
4. The user should now be redirected to the dashboard after successful signup

## Alternative: Manual Database Check
If you want to check if the migration was successful:

1. Go to **Table Editor** in Supabase
2. Select the `users` table
3. Check if the `supabase_auth_id` column exists
4. If it doesn't exist, run the migration above

## Expected Result
After running the migration:
- New users can sign up successfully
- Users are properly linked between Supabase Auth and the users table
- After signup, users are redirected to the appropriate dashboard
- No more redirects back to login/signup page

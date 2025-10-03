# 🔐 Make User Admin Guide

## Quick Steps to Make Your User Admin

### **Step 1: Run the SQL Script**
1. **Open Supabase Dashboard**
   - Go to [https://supabase.com](https://supabase.com)
   - Sign in to your account
   - Select your project

2. **Go to SQL Editor**
   - Click on **SQL Editor** in the left sidebar
   - Click **New Query**

3. **Run the Admin Update Script**
   - Copy and paste the contents of `Database/make_user_admin.sql`
   - Click **Run** to execute

### **Step 2: Verify the Update**
After running the script, you should see:
- Your user's current data (before update)
- Confirmation of the update
- Your user's new data (after update)
- List of all admin users

### **Step 3: Test Admin Access**
1. **Restart your Flutter app** (important!)
2. **Login** with your account (`kartikeyupadhyay450@gmail.com`)
3. **You should be redirected to `/admin-dashboard`** instead of `/student-dashboard`

## Alternative Methods

### Method 1: Direct Database Update
```sql
-- Update existing user to admin
UPDATE public.users 
SET role = 'admin' 
WHERE supabase_auth_id = 'fba29511-91a2-4dfc-8513-033e5449710e';
```

### Method 2: Create New Admin User
```sql
-- Create new admin user
INSERT INTO public.users (
    name,
    email,
    password_hash,
    role,
    supabase_auth_id,
    is_profile_completed,
    created_at
) VALUES (
    'Admin User',
    'admin@example.com',
    '$2a$10$dummy.hash',
    'admin',
    'YOUR_AUTH_UID',
    true,
    NOW()
);
```

### Method 3: Through Supabase Dashboard
1. Go to **Authentication** → **Users**
2. Find your user
3. Go to **Database** → **Users table**
4. Edit the user record
5. Change `role` field to `admin`

## Troubleshooting

### Issue: "User not found"
**Solution**: Make sure the user exists in the `users` table first
```sql
-- Check if user exists
SELECT * FROM public.users WHERE email = 'kartikeyupadhyay450@gmail.com';
```

### Issue: "Permission denied"
**Solution**: Make sure you have admin access to the database
- Check your Supabase project permissions
- Ensure you're using the correct database credentials

### Issue: "Role not updating"
**Solution**: Check for typos and verify the user ID
```sql
-- Verify the exact user ID
SELECT id, name, email, role, supabase_auth_id 
FROM public.users 
WHERE email = 'kartikeyupadhyay450@gmail.com';
```

### Issue: "App still redirects to student dashboard"
**Solution**: 
1. **Restart the Flutter app completely**
2. **Clear app cache/data**
3. **Logout and login again**
4. **Check the auth state in the app**

## Verification Steps

### 1. Check Database
```sql
-- Verify admin role
SELECT id, name, email, role, supabase_auth_id, created_at 
FROM public.users 
WHERE email = 'kartikeyupadhyay450@gmail.com';
```

### 2. Check App Behavior
- Login should redirect to `/admin-dashboard`
- Admin dashboard should be accessible
- User management features should be available

### 3. Check Admin Features
- Can view all users
- Can access admin settings
- Can moderate content
- Can view analytics

## Security Notes

⚠️ **Important Security Considerations**:
- Admin access grants full system control
- Only trusted users should have admin roles
- Admin actions are logged for audit purposes
- Use strong passwords for admin accounts

## Support

If you encounter any issues:
1. **Check the logs** in Supabase dashboard
2. **Verify database permissions**
3. **Restart the application**
4. **Contact the development team**

## Next Steps

After becoming an admin:
1. **Review the Admin Access Guide** (`ADMIN_ACCESS_GUIDE.md`)
2. **Explore admin features** in the dashboard
3. **Configure platform settings**
4. **Set up content moderation policies**
5. **Review user management procedures**

-- Create Admin User Script
-- This script creates an admin user in the system

-- First, create the user in Supabase Auth (this needs to be done through Supabase Dashboard or API)
-- Then run this script to add the user to the users table with admin role

-- Insert admin user into users table
-- Replace 'YOUR_SUPABASE_AUTH_UID' with the actual UID from Supabase Auth
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
    'admin@connectu.com',
    '$2a$10$dummy.hash.for.admin.user', -- This will be handled by Supabase Auth
    'admin',
    'YOUR_SUPABASE_AUTH_UID', -- Replace with actual UID
    true,
    NOW()
) ON CONFLICT (email) DO UPDATE SET
    role = 'admin',
    updated_at = NOW();

-- Verify the admin user was created
SELECT id, name, email, role, supabase_auth_id, created_at 
FROM public.users 
WHERE role = 'admin';

-- Create admin profile details (optional)
INSERT INTO public.alumnidetails (
    user_id,
    graduation_year,
    degree,
    major,
    current_company,
    current_position,
    industry,
    location,
    bio,
    linkedin_url,
    github_url,
    website_url,
    created_at
) VALUES (
    (SELECT id FROM public.users WHERE role = 'admin' LIMIT 1),
    2020,
    'Bachelor of Technology',
    'Computer Science',
    'ConnectU Platform',
    'System Administrator',
    'Technology',
    'Global',
    'System administrator for the ConnectU Alumni Platform',
    'https://linkedin.com/in/admin',
    'https://github.com/admin',
    'https://connectu.com',
    NOW()
) ON CONFLICT (user_id) DO NOTHING;

-- Grant admin permissions (if needed)
-- Note: RLS policies should handle permissions, but this is for reference
-- The admin user should have access to all admin functions through RLS policies

-- Log the admin creation action
INSERT INTO public.admin_actions (
    admin_id,
    action,
    description,
    metadata,
    created_at
) VALUES (
    (SELECT id FROM public.users WHERE role = 'admin' LIMIT 1),
    'admin_created',
    'Admin user created through database script',
    '{"method": "database_script", "script_version": "1.0"}',
    NOW()
);

-- Display success message
SELECT 'Admin user created successfully!' as message;

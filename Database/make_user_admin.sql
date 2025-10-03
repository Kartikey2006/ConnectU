-- Make specific user admin by Supabase Auth UID
-- This script updates the user with UID 'fba29511-91a2-4dfc-8513-033e5449710e' to admin role

-- First, let's check the current user data
SELECT id, name, email, role, supabase_auth_id, created_at 
FROM public.users 
WHERE supabase_auth_id = 'fba29511-91a2-4dfc-8513-033e5449710e';

-- Update the user role to admin
UPDATE public.users 
SET role = 'admin' 
WHERE supabase_auth_id = 'fba29511-91a2-4dfc-8513-033e5449710e';

-- Verify the update
SELECT id, name, email, role, supabase_auth_id, created_at 
FROM public.users 
WHERE supabase_auth_id = 'fba29511-91a2-4dfc-8513-033e5449710e';

-- Alternative: If the user doesn't exist yet, create them as admin
-- Uncomment the following if the user doesn't exist in the database:

-- INSERT INTO public.users (
--     name,
--     email,
--     password_hash,
--     role,
--     supabase_auth_id,
--     is_profile_completed,
--     created_at
-- ) VALUES (
--     'Kartikey Upadhyay',
--     'kartikeyupadhyay450@gmail.com',
--     '$2a$10$dummy.hash.for.admin.user',
--     'admin',
--     'fba29511-91a2-4dfc-8513-033e5449710e',
--     true,
--     NOW()
-- ) ON CONFLICT (email) DO UPDATE SET
--     role = 'admin',
--     updated_at = NOW();

-- Log the admin role change
INSERT INTO public.admin_actions (
    admin_id,
    action,
    description,
    metadata,
    created_at
) VALUES (
    (SELECT id FROM public.users WHERE supabase_auth_id = 'fba29511-91a2-4dfc-8513-033e5449710e'),
    'role_updated',
    'User role updated to admin',
    '{"previous_role": "student", "new_role": "admin", "updated_by": "database_script"}',
    NOW()
);

-- Display all admin users
SELECT id, name, email, role, supabase_auth_id, created_at 
FROM public.users 
WHERE role = 'admin'
ORDER BY created_at DESC;

-- Migration to add supabase_auth_id field to users table
-- This field will store the Supabase Auth user ID to link with our local user records

ALTER TABLE public.users 
ADD COLUMN supabase_auth_id text UNIQUE;

-- Create an index for better performance
CREATE INDEX idx_users_supabase_auth_id ON public.users(supabase_auth_id);

-- Add a comment to explain the field
COMMENT ON COLUMN public.users.supabase_auth_id IS 'Supabase Auth user ID for linking with authentication system';

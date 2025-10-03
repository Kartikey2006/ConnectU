-- Migration for Profile Features
-- This adds the necessary tables for profile management features

-- Create achievements table
CREATE TABLE IF NOT EXISTS public.achievements (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  title text NOT NULL,
  description text,
  emoji text DEFAULT '🏆',
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT achievements_pkey PRIMARY KEY (id),
  CONSTRAINT achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Create notification preferences table
CREATE TABLE IF NOT EXISTS public.notification_preferences (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL UNIQUE,
  push_notifications boolean NOT NULL DEFAULT true,
  email_notifications boolean NOT NULL DEFAULT true,
  event_reminders boolean NOT NULL DEFAULT false,
  mentorship_updates boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT notification_preferences_pkey PRIMARY KEY (id),
  CONSTRAINT notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Create support messages table
CREATE TABLE IF NOT EXISTS public.support_messages (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  message text NOT NULL,
  category text NOT NULL DEFAULT 'general',
  status text NOT NULL DEFAULT 'pending' CHECK (status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'resolved'::text, 'closed'::text])),
  response text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT support_messages_pkey PRIMARY KEY (id),
  CONSTRAINT support_messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Create bug reports table
CREATE TABLE IF NOT EXISTS public.bug_reports (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  description text NOT NULL,
  steps_to_reproduce text NOT NULL,
  device_info text,
  status text NOT NULL DEFAULT 'pending' CHECK (status = ANY (ARRAY['pending'::text, 'investigating'::text, 'fixed'::text, 'wont_fix'::text, 'duplicate'::text])),
  priority text NOT NULL DEFAULT 'medium' CHECK (priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'critical'::text])),
  assigned_to text,
  resolution text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT bug_reports_pkey PRIMARY KEY (id),
  CONSTRAINT bug_reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Add missing columns to users table
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS phone_number text,
ADD COLUMN IF NOT EXISTS bio text,
ADD COLUMN IF NOT EXISTS address text,
ADD COLUMN IF NOT EXISTS profile_image_url text,
ADD COLUMN IF NOT EXISTS is_profile_completed boolean DEFAULT false;

-- Add missing columns to alumnidetails table
ALTER TABLE public.alumnidetails 
ADD COLUMN IF NOT EXISTS experience_years integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS skills text;

-- Add missing columns to studentdetails table (create if not exists)
CREATE TABLE IF NOT EXISTS public.studentdetails (
  user_id bigint NOT NULL,
  batch_year integer,
  current_company text,
  position text,
  experience_years integer DEFAULT 0,
  skills text,
  linkedin_url text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT studentdetails_pkey PRIMARY KEY (user_id),
  CONSTRAINT studentdetails_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_achievements_user_id ON public.achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_achievements_created_at ON public.achievements(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notification_preferences_user_id ON public.notification_preferences(user_id);
CREATE INDEX IF NOT EXISTS idx_support_messages_user_id ON public.support_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_support_messages_status ON public.support_messages(status);
CREATE INDEX IF NOT EXISTS idx_support_messages_created_at ON public.support_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_bug_reports_user_id ON public.bug_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_bug_reports_status ON public.bug_reports(status);
CREATE INDEX IF NOT EXISTS idx_bug_reports_priority ON public.bug_reports(priority);
CREATE INDEX IF NOT EXISTS idx_bug_reports_created_at ON public.bug_reports(created_at DESC);

-- Create storage bucket for profile images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('profile-images', 'profile-images', true)
ON CONFLICT (id) DO NOTHING;

-- Create RLS policies for profile images
CREATE POLICY "Profile images are publicly accessible" ON storage.objects
FOR SELECT USING (bucket_id = 'profile-images');

CREATE POLICY "Users can upload their own profile images" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'profile-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can update their own profile images" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'profile-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can delete their own profile images" ON storage.objects
FOR DELETE USING (
  bucket_id = 'profile-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Create RLS policies for achievements
CREATE POLICY "Users can view all achievements" ON public.achievements
FOR SELECT USING (true);

CREATE POLICY "Users can insert their own achievements" ON public.achievements
FOR INSERT WITH CHECK (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

CREATE POLICY "Users can update their own achievements" ON public.achievements
FOR UPDATE USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

CREATE POLICY "Users can delete their own achievements" ON public.achievements
FOR DELETE USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

-- Create RLS policies for notification preferences
CREATE POLICY "Users can view their own notification preferences" ON public.notification_preferences
FOR SELECT USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

CREATE POLICY "Users can insert their own notification preferences" ON public.notification_preferences
FOR INSERT WITH CHECK (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

CREATE POLICY "Users can update their own notification preferences" ON public.notification_preferences
FOR UPDATE USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

-- Create RLS policies for support messages
CREATE POLICY "Users can view their own support messages" ON public.support_messages
FOR SELECT USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

CREATE POLICY "Users can insert their own support messages" ON public.support_messages
FOR INSERT WITH CHECK (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

-- Create RLS policies for bug reports
CREATE POLICY "Users can view their own bug reports" ON public.bug_reports
FOR SELECT USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

CREATE POLICY "Users can insert their own bug reports" ON public.bug_reports
FOR INSERT WITH CHECK (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = user_id));

-- Enable RLS on all tables
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bug_reports ENABLE ROW LEVEL SECURITY;

-- Add comments to tables
COMMENT ON TABLE public.achievements IS 'User achievements and awards';
COMMENT ON TABLE public.notification_preferences IS 'User notification preferences';
COMMENT ON TABLE public.support_messages IS 'User support messages and tickets';
COMMENT ON TABLE public.bug_reports IS 'Bug reports submitted by users';

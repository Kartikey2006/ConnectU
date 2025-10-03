-- Admin Features Migration
-- This script creates tables and policies for admin functionality

-- Create admin_actions table for logging admin activities
CREATE TABLE IF NOT EXISTS public.admin_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create platform_settings table for system configuration
CREATE TABLE IF NOT EXISTS public.platform_settings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    key VARCHAR(100) UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create announcements table for system-wide announcements
CREATE TABLE IF NOT EXISTS public.announcements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'general', -- general, maintenance, security, etc.
    target_roles TEXT[] DEFAULT '{}', -- Array of roles this announcement targets
    is_active BOOLEAN DEFAULT TRUE,
    created_by uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create reports table for content moderation
CREATE TABLE IF NOT EXISTS public.reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    content_id uuid, -- Can reference posts, comments, etc.
    content_type VARCHAR(50) NOT NULL, -- post, comment, user, etc.
    reason VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- pending, reviewed, resolved, dismissed
    reviewed_by uuid REFERENCES public.users(supabase_auth_id) ON DELETE SET NULL,
    reviewed_at TIMESTAMP WITH TIME ZONE,
    resolution_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add moderation fields to existing posts table
ALTER TABLE public.posts ADD COLUMN IF NOT EXISTS is_approved BOOLEAN DEFAULT TRUE;
ALTER TABLE public.posts ADD COLUMN IF NOT EXISTS moderation_notes TEXT;
ALTER TABLE public.posts ADD COLUMN IF NOT EXISTS moderated_by uuid REFERENCES public.users(supabase_auth_id) ON DELETE SET NULL;
ALTER TABLE public.posts ADD COLUMN IF NOT EXISTS moderated_at TIMESTAMP WITH TIME ZONE;

-- Add suspension field to users table
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_suspended BOOLEAN DEFAULT FALSE;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS suspension_reason TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS suspended_by uuid REFERENCES public.users(supabase_auth_id) ON DELETE SET NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS suspended_at TIMESTAMP WITH TIME ZONE;

-- Add last_active field to users table
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Enable Row Level Security (RLS) for admin_actions table
ALTER TABLE public.admin_actions ENABLE ROW LEVEL SECURITY;

-- Policy to allow admins to view all admin actions
CREATE POLICY "Allow admins to view admin actions" ON public.admin_actions
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
);

-- Policy to allow admins to insert admin actions
CREATE POLICY "Allow admins to insert admin actions" ON public.admin_actions
FOR INSERT WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
);

-- Enable Row Level Security (RLS) for platform_settings table
ALTER TABLE public.platform_settings ENABLE ROW LEVEL SECURITY;

-- Policy to allow admins to manage platform settings
CREATE POLICY "Allow admins to manage platform settings" ON public.platform_settings
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
) WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
);

-- Enable Row Level Security (RLS) for announcements table
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

-- Policy to allow all authenticated users to view active announcements
CREATE POLICY "Allow authenticated users to view active announcements" ON public.announcements
FOR SELECT USING (
    is_active = TRUE AND (
        target_roles = '{}' OR 
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE users.supabase_auth_id = auth.uid() 
            AND users.role = ANY(target_roles)
        )
    )
);

-- Policy to allow admins to manage announcements
CREATE POLICY "Allow admins to manage announcements" ON public.announcements
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
) WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
);

-- Enable Row Level Security (RLS) for reports table
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to create reports
CREATE POLICY "Allow users to create reports" ON public.reports
FOR INSERT WITH CHECK (auth.uid() = reporter_id);

-- Policy to allow users to view their own reports
CREATE POLICY "Allow users to view their own reports" ON public.reports
FOR SELECT USING (auth.uid() = reporter_id);

-- Policy to allow admins to view and manage all reports
CREATE POLICY "Allow admins to manage all reports" ON public.reports
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
) WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    )
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_admin_actions_admin_id ON public.admin_actions(admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_actions_created_at ON public.admin_actions(created_at);
CREATE INDEX IF NOT EXISTS idx_admin_actions_action ON public.admin_actions(action);

CREATE INDEX IF NOT EXISTS idx_platform_settings_key ON public.platform_settings(key);

CREATE INDEX IF NOT EXISTS idx_announcements_is_active ON public.announcements(is_active);
CREATE INDEX IF NOT EXISTS idx_announcements_created_at ON public.announcements(created_at);
CREATE INDEX IF NOT EXISTS idx_announcements_target_roles ON public.announcements USING GIN(target_roles);

CREATE INDEX IF NOT EXISTS idx_reports_reporter_id ON public.reports(reporter_id);
CREATE INDEX IF NOT EXISTS idx_reports_content_id ON public.reports(content_id);
CREATE INDEX IF NOT EXISTS idx_reports_status ON public.reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_created_at ON public.reports(created_at);

CREATE INDEX IF NOT EXISTS idx_posts_is_approved ON public.posts(is_approved);
CREATE INDEX IF NOT EXISTS idx_posts_moderated_at ON public.posts(moderated_at);

CREATE INDEX IF NOT EXISTS idx_users_is_suspended ON public.users(is_suspended);
CREATE INDEX IF NOT EXISTS idx_users_last_active ON public.users(last_active);

-- Insert default platform settings
INSERT INTO public.platform_settings (key, value, description) VALUES
('site_name', '"ConnectU Alumni Platform"', 'The name of the platform'),
('site_description', '"Connecting alumni and students for mentorship and networking"', 'Platform description'),
('max_file_size', '10485760', 'Maximum file upload size in bytes (10MB)'),
('allowed_file_types', '["jpg", "jpeg", "png", "pdf", "doc", "docx"]', 'Allowed file types for uploads'),
('email_notifications', 'true', 'Enable email notifications'),
('maintenance_mode', 'false', 'Enable maintenance mode'),
('registration_enabled', 'true', 'Allow new user registrations'),
('max_posts_per_day', '10', 'Maximum posts a user can create per day'),
('content_moderation', 'true', 'Enable content moderation'),
('auto_approve_posts', 'false', 'Automatically approve posts without moderation')
ON CONFLICT (key) DO NOTHING;

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_platform_settings_updated_at 
    BEFORE UPDATE ON public.platform_settings 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_announcements_updated_at 
    BEFORE UPDATE ON public.announcements 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create function to log admin actions
CREATE OR REPLACE FUNCTION log_admin_action(
    action_name VARCHAR(100),
    action_description TEXT,
    action_metadata JSONB DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO public.admin_actions (admin_id, action, description, metadata)
    VALUES (auth.uid(), action_name, action_description, action_metadata);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users (will be restricted by RLS)
GRANT EXECUTE ON FUNCTION log_admin_action TO authenticated;

-- Create function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users 
        WHERE users.supabase_auth_id = auth.uid() 
        AND users.role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION is_admin TO authenticated;

-- Create function to update user last active timestamp
CREATE OR REPLACE FUNCTION update_user_last_active()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.users 
    SET last_active = NOW() 
    WHERE users.supabase_auth_id = auth.uid();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to update last_active on any user activity
-- This would be triggered by various user actions (posts, comments, etc.)
-- For now, we'll create a manual function that can be called

-- Create view for admin dashboard statistics
CREATE OR REPLACE VIEW admin_dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM public.users WHERE role = 'student') as total_students,
    (SELECT COUNT(*) FROM public.users WHERE role = 'alumni') as total_alumni,
    (SELECT COUNT(*) FROM public.users WHERE role = 'admin') as total_admins,
    (SELECT COUNT(*) FROM public.users WHERE created_at >= NOW() - INTERVAL '7 days') as new_users_week,
    (SELECT COUNT(*) FROM public.posts WHERE created_at >= NOW() - INTERVAL '7 days') as new_posts_week,
    (SELECT COUNT(*) FROM public.users WHERE last_active >= NOW() - INTERVAL '7 days') as active_users_week,
    (SELECT COUNT(*) FROM public.reports WHERE status = 'pending') as pending_reports,
    (SELECT COUNT(*) FROM public.users WHERE is_suspended = TRUE) as suspended_users;

-- Grant access to admin dashboard stats view
GRANT SELECT ON admin_dashboard_stats TO authenticated;

-- Create RLS policy for admin dashboard stats
CREATE POLICY "Allow admins to view dashboard stats" ON admin_dashboard_stats
FOR SELECT USING (is_admin());

-- Add comments for documentation
COMMENT ON TABLE public.admin_actions IS 'Logs all administrative actions for audit trail';
COMMENT ON TABLE public.platform_settings IS 'System-wide configuration settings';
COMMENT ON TABLE public.announcements IS 'System announcements and notifications';
COMMENT ON TABLE public.reports IS 'User reports for content moderation';

COMMENT ON COLUMN public.posts.is_approved IS 'Whether the post has been approved by moderators';
COMMENT ON COLUMN public.posts.moderation_notes IS 'Notes from moderators about the post';
COMMENT ON COLUMN public.users.is_suspended IS 'Whether the user account is suspended';
COMMENT ON COLUMN public.users.suspension_reason IS 'Reason for user suspension';
COMMENT ON COLUMN public.users.last_active IS 'Last time the user was active on the platform';

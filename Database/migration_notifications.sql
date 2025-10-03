-- Migration for enhanced notification system
-- Create comprehensive notifications table

CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- mentorship, webinar, referral, chat, system, payment, event, job, reminder, achievement, message, connection
    action_url TEXT, -- URL to navigate to when notification is clicked
    metadata JSONB, -- Additional data like event_id, session_id, etc.
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create notification preferences table
CREATE TABLE IF NOT EXISTS public.notification_preferences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    email_notifications BOOLEAN DEFAULT TRUE,
    push_notifications BOOLEAN DEFAULT TRUE,
    in_app_notifications BOOLEAN DEFAULT TRUE,
    mentorship_notifications BOOLEAN DEFAULT TRUE,
    event_notifications BOOLEAN DEFAULT TRUE,
    job_notifications BOOLEAN DEFAULT TRUE,
    system_notifications BOOLEAN DEFAULT TRUE,
    marketing_notifications BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Create notification templates table
CREATE TABLE IF NOT EXISTS public.notification_templates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL,
    title_template TEXT NOT NULL,
    message_template TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for notifications table
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view their own notifications
CREATE POLICY "Allow users to view their own notifications" ON public.notifications
FOR SELECT USING (auth.uid() = user_id);

-- Policy to allow users to update their own notifications
CREATE POLICY "Allow users to update their own notifications" ON public.notifications
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Policy to allow system to insert notifications
CREATE POLICY "Allow system to insert notifications" ON public.notifications
FOR INSERT WITH CHECK (true);

-- Enable Row Level Security (RLS) for notification_preferences table
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to manage their own notification preferences
CREATE POLICY "Allow users to manage their own notification preferences" ON public.notification_preferences
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Enable Row Level Security (RLS) for notification_templates table
ALTER TABLE public.notification_templates ENABLE ROW LEVEL SECURITY;

-- Policy to allow authenticated users to view notification templates
CREATE POLICY "Allow authenticated users to view notification templates" ON public.notification_templates
FOR SELECT USING (auth.role() = 'authenticated');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON public.notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id_created_at ON public.notifications(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_notification_preferences_user_id ON public.notification_preferences(user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_notification_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_notifications_updated_at 
    BEFORE UPDATE ON public.notifications 
    FOR EACH ROW EXECUTE FUNCTION update_notification_updated_at();

CREATE TRIGGER update_notification_preferences_updated_at 
    BEFORE UPDATE ON public.notification_preferences 
    FOR EACH ROW EXECUTE FUNCTION update_notification_updated_at();

CREATE TRIGGER update_notification_templates_updated_at 
    BEFORE UPDATE ON public.notification_templates 
    FOR EACH ROW EXECUTE FUNCTION update_notification_updated_at();

-- Insert default notification templates
INSERT INTO public.notification_templates (name, type, title_template, message_template) VALUES
('welcome_student', 'system', 'Welcome to ConnectU Alumni Platform!', 'Welcome! Explore mentorship opportunities and connect with alumni to advance your career.'),
('welcome_alumni', 'system', 'Welcome to ConnectU Alumni Platform!', 'Welcome! Start connecting with fellow alumni and sharing your expertise with the next generation.'),
('mentorship_request', 'mentorship', 'New Mentorship Request', '{{mentor_name}} has requested a mentorship session with you.'),
('mentorship_accepted', 'mentorship', 'Mentorship Request Accepted', '{{mentor_name}} has accepted your mentorship request.'),
('mentorship_reminder', 'reminder', 'Mentorship Session Reminder', 'Your mentorship session with {{mentor_name}} is scheduled for {{session_time}}.'),
('event_reminder', 'reminder', 'Event Reminder', 'Don''t forget about {{event_name}} starting at {{event_time}}.'),
('job_match', 'job', 'New Job Match', 'A new job matching your profile has been posted: {{job_title}} at {{company_name}}.'),
('connection_request', 'connection', 'New Connection Request', '{{user_name}} wants to connect with you.'),
('achievement_unlocked', 'achievement', 'Achievement Unlocked!', 'Congratulations! You''ve unlocked the "{{achievement_name}}" achievement.'),
('payment_success', 'payment', 'Payment Successful', 'Your payment of {{amount}} has been processed successfully.'),
('system_maintenance', 'system', 'System Maintenance Notice', 'The platform will be under maintenance from {{start_time}} to {{end_time}}.'),
('new_message', 'message', 'New Message', 'You have a new message from {{sender_name}}.')
ON CONFLICT (name) DO NOTHING;

-- Insert default notification preferences for existing users
INSERT INTO public.notification_preferences (user_id, email_notifications, push_notifications, in_app_notifications, mentorship_notifications, event_notifications, job_notifications, system_notifications, marketing_notifications)
SELECT 
    supabase_auth_id,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    FALSE
FROM public.users
WHERE NOT EXISTS (
    SELECT 1 FROM public.notification_preferences 
    WHERE notification_preferences.user_id = users.supabase_auth_id
);

-- Create function to send notification using template
CREATE OR REPLACE FUNCTION send_notification_from_template(
    p_user_id uuid,
    p_template_name varchar,
    p_variables jsonb DEFAULT '{}'::jsonb
)
RETURNS boolean AS $$
DECLARE
    template_record record;
    final_title text;
    final_message text;
BEGIN
    -- Get the template
    SELECT * INTO template_record 
    FROM public.notification_templates 
    WHERE name = p_template_name AND is_active = TRUE;
    
    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;
    
    -- Replace variables in title and message
    final_title := template_record.title_template;
    final_message := template_record.message_template;
    
    -- Simple variable replacement (you can enhance this with more sophisticated templating)
    FOR key, value IN SELECT * FROM jsonb_each_text(p_variables) LOOP
        final_title := replace(final_title, '{{' || key || '}}', value);
        final_message := replace(final_message, '{{' || key || '}}', value);
    END LOOP;
    
    -- Insert the notification
    INSERT INTO public.notifications (user_id, title, message, type, created_at)
    VALUES (p_user_id, final_title, final_message, template_record.type, NOW());
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Create function to clean up old notifications
CREATE OR REPLACE FUNCTION cleanup_old_notifications()
RETURNS void AS $$
BEGIN
    -- Delete notifications older than 90 days that are read
    DELETE FROM public.notifications 
    WHERE created_at < NOW() - INTERVAL '90 days' 
    AND is_read = TRUE;
    
    -- Delete notifications older than 30 days that are unread (user probably won't see them)
    DELETE FROM public.notifications 
    WHERE created_at < NOW() - INTERVAL '30 days' 
    AND is_read = FALSE;
END;
$$ LANGUAGE plpgsql;

-- Create a scheduled job to clean up old notifications (this would need to be set up in your cron or job scheduler)
-- For now, you can call cleanup_old_notifications() manually or set up a trigger

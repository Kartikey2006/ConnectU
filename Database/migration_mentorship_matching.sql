-- Migration for advanced mentorship matching system
-- Add fields to support AI-powered matching

-- Add mentorship-related fields to users table
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS is_mentor BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS mentorship_goals TEXT[],
ADD COLUMN IF NOT EXISTS communication_preferences JSONB DEFAULT '{"methods": ["video_call", "phone_call"], "availability": "flexible", "timezone": "UTC"}',
ADD COLUMN IF NOT EXISTS experience_years INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS industry VARCHAR(100),
ADD COLUMN IF NOT EXISTS skills TEXT[],
ADD COLUMN IF NOT EXISTS location VARCHAR(255);

-- Create mentorship_sessions table
CREATE TABLE IF NOT EXISTS public.mentorship_sessions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    mentee_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    mentor_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    topic VARCHAR(255) NOT NULL,
    description TEXT,
    duration INTEGER DEFAULT 60, -- in minutes
    format VARCHAR(50) DEFAULT 'video_call', -- video_call, phone_call, in_person, chat
    status VARCHAR(50) DEFAULT 'pending', -- pending, confirmed, completed, cancelled
    scheduled_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    suggested_agenda TEXT[],
    learning_objectives TEXT[],
    mentee_notes TEXT,
    mentor_notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    feedback TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create mentorship_matches table to store AI-generated matches
CREATE TABLE IF NOT EXISTS public.mentorship_matches (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    mentee_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    mentor_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    compatibility_score DECIMAL(3,2) NOT NULL CHECK (compatibility_score >= 0 AND compatibility_score <= 1),
    match_reasons TEXT[],
    industry_match_score DECIMAL(3,2),
    skills_match_score DECIMAL(3,2),
    experience_compatibility_score DECIMAL(3,2),
    goal_alignment_score DECIMAL(3,2),
    location_compatibility_score DECIMAL(3,2),
    communication_compatibility_score DECIMAL(3,2),
    is_viewed BOOLEAN DEFAULT FALSE,
    is_contacted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(mentee_id, mentor_id)
);

-- Create mentorship_feedback table for session feedback
CREATE TABLE IF NOT EXISTS public.mentorship_feedback (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id uuid NOT NULL REFERENCES public.mentorship_sessions(id) ON DELETE CASCADE,
    feedback_from_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    feedback_to_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    feedback_text TEXT,
    communication_rating INTEGER CHECK (communication_rating >= 1 AND communication_rating <= 5),
    expertise_rating INTEGER CHECK (expertise_rating >= 1 AND expertise_rating <= 5),
    helpfulness_rating INTEGER CHECK (helpfulness_rating >= 1 AND helpfulness_rating <= 5),
    would_recommend BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for mentorship_sessions table
ALTER TABLE public.mentorship_sessions ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view their own mentorship sessions
CREATE POLICY "Allow users to view their own mentorship sessions" ON public.mentorship_sessions
FOR SELECT USING (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
);

-- Policy to allow users to create mentorship sessions
CREATE POLICY "Allow users to create mentorship sessions" ON public.mentorship_sessions
FOR INSERT WITH CHECK (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
);

-- Policy to allow users to update their own mentorship sessions
CREATE POLICY "Allow users to update their own mentorship sessions" ON public.mentorship_sessions
FOR UPDATE USING (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
) WITH CHECK (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
);

-- Enable Row Level Security (RLS) for mentorship_matches table
ALTER TABLE public.mentorship_matches ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view their own matches
CREATE POLICY "Allow users to view their own matches" ON public.mentorship_matches
FOR SELECT USING (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
);

-- Policy to allow users to update their own matches
CREATE POLICY "Allow users to update their own matches" ON public.mentorship_matches
FOR UPDATE USING (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
) WITH CHECK (
    auth.uid() = mentee_id OR 
    auth.uid() = mentor_id
);

-- Enable Row Level Security (RLS) for mentorship_feedback table
ALTER TABLE public.mentorship_feedback ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view feedback for their sessions
CREATE POLICY "Allow users to view feedback for their sessions" ON public.mentorship_feedback
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.mentorship_sessions 
        WHERE mentorship_sessions.id = mentorship_feedback.session_id 
        AND (mentorship_sessions.mentee_id = auth.uid() OR mentorship_sessions.mentor_id = auth.uid())
    )
);

-- Policy to allow users to create feedback for their sessions
CREATE POLICY "Allow users to create feedback for their sessions" ON public.mentorship_feedback
FOR INSERT WITH CHECK (
    auth.uid() = feedback_from_id AND
    EXISTS (
        SELECT 1 FROM public.mentorship_sessions 
        WHERE mentorship_sessions.id = mentorship_feedback.session_id 
        AND (mentorship_sessions.mentee_id = auth.uid() OR mentorship_sessions.mentor_id = auth.uid())
    )
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_mentee_id ON public.mentorship_sessions(mentee_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_mentor_id ON public.mentorship_sessions(mentor_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_status ON public.mentorship_sessions(status);
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_scheduled_at ON public.mentorship_sessions(scheduled_at);

CREATE INDEX IF NOT EXISTS idx_mentorship_matches_mentee_id ON public.mentorship_matches(mentee_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_matches_mentor_id ON public.mentorship_matches(mentor_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_matches_compatibility_score ON public.mentorship_matches(compatibility_score DESC);

CREATE INDEX IF NOT EXISTS idx_mentorship_feedback_session_id ON public.mentorship_feedback(session_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_feedback_feedback_from_id ON public.mentorship_feedback(feedback_from_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_feedback_feedback_to_id ON public.mentorship_feedback(feedback_to_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_mentorship_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_mentorship_sessions_updated_at 
    BEFORE UPDATE ON public.mentorship_sessions 
    FOR EACH ROW EXECUTE FUNCTION update_mentorship_updated_at();

CREATE TRIGGER update_mentorship_matches_updated_at 
    BEFORE UPDATE ON public.mentorship_matches 
    FOR EACH ROW EXECUTE FUNCTION update_mentorship_updated_at();

-- Insert sample mentorship data
INSERT INTO public.users (supabase_auth_id, name, email, role, is_mentor, industry, skills, experience_years, location, mentorship_goals, communication_preferences)
VALUES 
    ('mentor_1', 'Sarah Johnson', 'sarah.johnson@example.com', 'alumni', true, 'Technology', ARRAY['Flutter', 'Dart', 'Mobile Development', 'UI/UX'], 8, 'San Francisco, CA', ARRAY['Help new developers', 'Share mobile development expertise'], '{"methods": ["video_call", "in_person"], "availability": "weekends", "timezone": "PST"}'),
    ('mentor_2', 'Michael Chen', 'michael.chen@example.com', 'alumni', true, 'Finance', ARRAY['Investment Banking', 'Financial Modeling', 'Risk Management'], 12, 'New York, NY', ARRAY['Guide finance careers', 'Share investment strategies'], '{"methods": ["video_call", "phone_call"], "availability": "evenings", "timezone": "EST"}'),
    ('mentor_3', 'Emily Rodriguez', 'emily.rodriguez@example.com', 'alumni', true, 'Marketing', ARRAY['Digital Marketing', 'Brand Strategy', 'Content Marketing'], 6, 'Los Angeles, CA', ARRAY['Mentor marketing professionals', 'Share brand building insights'], '{"methods": ["video_call"], "availability": "flexible", "timezone": "PST"}')
ON CONFLICT (supabase_auth_id) DO UPDATE SET
    is_mentor = EXCLUDED.is_mentor,
    industry = EXCLUDED.industry,
    skills = EXCLUDED.skills,
    experience_years = EXCLUDED.experience_years,
    location = EXCLUDED.location,
    mentorship_goals = EXCLUDED.mentorship_goals,
    communication_preferences = EXCLUDED.communication_preferences;

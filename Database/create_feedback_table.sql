-- Create feedback table for rating and reviews
CREATE TABLE IF NOT EXISTS public.feedback (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id uuid REFERENCES public.mentorship_sessions(id) ON DELETE CASCADE,
    mentor_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    mentee_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    feedback_type VARCHAR(20) DEFAULT 'mentorship', -- 'mentorship', 'event', 'general'
    is_anonymous BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, mentee_id) -- One feedback per session per mentee
);

-- Create feedback_categories table for structured feedback
CREATE TABLE IF NOT EXISTS public.feedback_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    feedback_type VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create feedback_responses table for detailed feedback
CREATE TABLE IF NOT EXISTS public.feedback_responses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    feedback_id uuid NOT NULL REFERENCES public.feedback(id) ON DELETE CASCADE,
    category_id uuid NOT NULL REFERENCES public.feedback_categories(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for feedback table
ALTER TABLE public.feedback ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view feedback they are involved in
CREATE POLICY "Users can view relevant feedback" ON public.feedback
FOR SELECT USING (
    auth.uid() = mentor_id OR auth.uid() = mentee_id
);

-- Policy to allow mentees to create feedback for their sessions
CREATE POLICY "Mentees can create feedback" ON public.feedback
FOR INSERT WITH CHECK (
    auth.uid() = mentee_id AND
    EXISTS (
        SELECT 1 FROM public.mentorship_sessions 
        WHERE mentorship_sessions.id = session_id 
        AND mentorship_sessions.mentee_id = auth.uid()
    )
);

-- Policy to allow users to update their own feedback
CREATE POLICY "Users can update their feedback" ON public.feedback
FOR UPDATE USING (auth.uid() = mentee_id) WITH CHECK (auth.uid() = mentee_id);

-- Policy to allow users to delete their own feedback
CREATE POLICY "Users can delete their feedback" ON public.feedback
FOR DELETE USING (auth.uid() = mentee_id);

-- Enable Row Level Security (RLS) for feedback_categories table
ALTER TABLE public.feedback_categories ENABLE ROW LEVEL SECURITY;

-- Policy to allow all authenticated users to view feedback categories
CREATE POLICY "All users can view feedback categories" ON public.feedback_categories
FOR SELECT USING (auth.role() = 'authenticated');

-- Enable Row Level Security (RLS) for feedback_responses table
ALTER TABLE public.feedback_responses ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to manage feedback responses for their feedback
CREATE POLICY "Users can manage their feedback responses" ON public.feedback_responses
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.feedback 
        WHERE feedback.id = feedback_id 
        AND feedback.mentee_id = auth.uid()
    )
) WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.feedback 
        WHERE feedback.id = feedback_id 
        AND feedback.mentee_id = auth.uid()
    )
);

-- Insert default feedback categories
INSERT INTO public.feedback_categories (name, description, feedback_type) VALUES
('Communication', 'How well did the mentor communicate?', 'mentorship'),
('Knowledge', 'How knowledgeable was the mentor?', 'mentorship'),
('Patience', 'How patient was the mentor?', 'mentorship'),
('Guidance', 'How helpful was the guidance provided?', 'mentorship'),
('Availability', 'How available was the mentor?', 'mentorship'),
('Overall Experience', 'Overall rating of the mentorship experience', 'mentorship'),
('Event Organization', 'How well was the event organized?', 'event'),
('Content Quality', 'Quality of the event content', 'event'),
('Speaker Performance', 'How well did the speakers perform?', 'event'),
('Venue & Logistics', 'Quality of venue and logistics', 'event'),
('Networking Opportunities', 'Opportunities for networking', 'event'),
('Value for Money', 'Was the event worth the cost?', 'event')
ON CONFLICT DO NOTHING;

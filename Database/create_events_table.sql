-- Create events table
CREATE TABLE IF NOT EXISTS public.events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- 'alumni_reunion', 'webinar', 'networking', 'workshop', 'conference'
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    location VARCHAR(255),
    virtual_link TEXT, -- For online events
    max_attendees INTEGER,
    registration_deadline TIMESTAMP WITH TIME ZONE,
    organizer_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    cover_image_url TEXT,
    is_virtual BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    registration_fee DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create event_registrations table
CREATE TABLE IF NOT EXISTS public.event_registrations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id uuid NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'registered', -- 'registered', 'attended', 'cancelled'
    payment_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'paid', 'refunded'
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(event_id, user_id) -- Ensure one registration per event per user
);

-- Create event_agenda table for event schedules
CREATE TABLE IF NOT EXISTS public.event_agenda (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id uuid NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    session_title VARCHAR(255) NOT NULL,
    session_description TEXT,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    speaker_name VARCHAR(255),
    speaker_title VARCHAR(255),
    session_type VARCHAR(50) DEFAULT 'presentation', -- 'presentation', 'panel', 'workshop', 'networking'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for events table
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- Policy to allow all authenticated users to view active events
CREATE POLICY "Allow authenticated users to view active events" ON public.events
FOR SELECT USING (auth.role() = 'authenticated' AND is_active = true);

-- Policy to allow organizers to manage their own events
CREATE POLICY "Allow organizers to manage their own events" ON public.events
FOR ALL USING (auth.uid() = organizer_id) WITH CHECK (auth.uid() = organizer_id);

-- Enable Row Level Security (RLS) for event_registrations table
ALTER TABLE public.event_registrations ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to manage their own registrations
CREATE POLICY "Allow users to manage their own registrations" ON public.event_registrations
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Policy to allow event organizers to view registrations for their events
CREATE POLICY "Allow organizers to view event registrations" ON public.event_registrations
FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.events WHERE events.id = event_id AND events.organizer_id = auth.uid())
);

-- Enable Row Level Security (RLS) for event_agenda table
ALTER TABLE public.event_agenda ENABLE ROW LEVEL SECURITY;

-- Policy to allow all authenticated users to view event agendas
CREATE POLICY "Allow authenticated users to view event agendas" ON public.event_agenda
FOR SELECT USING (auth.role() = 'authenticated');

-- Policy to allow event organizers to manage event agendas
CREATE POLICY "Allow organizers to manage event agendas" ON public.event_agenda
FOR ALL USING (
    EXISTS (SELECT 1 FROM public.events WHERE events.id = event_id AND events.organizer_id = auth.uid())
) WITH CHECK (
    EXISTS (SELECT 1 FROM public.events WHERE events.id = event_id AND events.organizer_id = auth.uid())
);

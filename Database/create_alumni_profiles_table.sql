-- Create alumni_profiles table
CREATE TABLE IF NOT EXISTS public.alumni_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    linkedin_profile VARCHAR(255),
    bio TEXT,
    university VARCHAR(255) NOT NULL,
    degree VARCHAR(100) NOT NULL,
    field_of_study VARCHAR(100),
    graduation_year VARCHAR(10) NOT NULL,
    gpa VARCHAR(10),
    achievements TEXT,
    current_company VARCHAR(255),
    current_position VARCHAR(255),
    experience_years VARCHAR(10),
    skills TEXT,
    interests TEXT,
    profile_image_path VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_alumni_profiles_user_id ON public.alumni_profiles(user_id);

-- Enable RLS (Row Level Security)
ALTER TABLE public.alumni_profiles ENABLE ROW LEVEL SECURITY;

-- Create RLS policy to allow users to manage their own profiles
CREATE POLICY "Users can manage their own alumni profiles" ON public.alumni_profiles
    FOR ALL USING (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = user_id));

-- Create RLS policy to allow users to view other alumni profiles (for networking)
CREATE POLICY "Users can view other alumni profiles" ON public.alumni_profiles
    FOR SELECT USING (true);

-- Add comment
COMMENT ON TABLE public.alumni_profiles IS 'Stores detailed profile information for alumni users';

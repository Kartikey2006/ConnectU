-- Create jobs table for job postings
CREATE TABLE IF NOT EXISTS public.jobs (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    title text NOT NULL,
    company text NOT NULL,
    location text NOT NULL,
    type text NOT NULL CHECK (type = ANY (ARRAY['Full-time'::text, 'Part-time'::text, 'Internship'::text, 'Contract'::text])),
    salary text,
    experience text,
    description text NOT NULL,
    skills text[], -- Array of skills
    category text NOT NULL,
    posted_by bigint NOT NULL, -- User ID who posted the job
    company_logo_url text,
    application_deadline timestamp with time zone,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT jobs_pkey PRIMARY KEY (id),
    CONSTRAINT jobs_posted_by_fkey FOREIGN KEY (posted_by) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Create job applications table
CREATE TABLE IF NOT EXISTS public.job_applications (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    job_id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    cover_letter text,
    resume_url text,
    status text NOT NULL DEFAULT 'pending' CHECK (status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'shortlisted'::text, 'rejected'::text, 'hired'::text])),
    applied_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT job_applications_pkey PRIMARY KEY (id),
    CONSTRAINT job_applications_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE,
    CONSTRAINT job_applications_applicant_id_fkey FOREIGN KEY (applicant_id) REFERENCES public.users(id) ON DELETE CASCADE,
    CONSTRAINT unique_job_application UNIQUE (job_id, applicant_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_jobs_category ON public.jobs(category);
CREATE INDEX IF NOT EXISTS idx_jobs_location ON public.jobs(location);
CREATE INDEX IF NOT EXISTS idx_jobs_type ON public.jobs(type);
CREATE INDEX IF NOT EXISTS idx_jobs_posted_by ON public.jobs(posted_by);
CREATE INDEX IF NOT EXISTS idx_jobs_is_active ON public.jobs(is_active);
CREATE INDEX IF NOT EXISTS idx_job_applications_job_id ON public.job_applications(job_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_applicant_id ON public.job_applications(applicant_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_status ON public.job_applications(status);

-- Enable RLS (Row Level Security)
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_applications ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for jobs table
CREATE POLICY "Anyone can view active jobs" ON public.jobs
    FOR SELECT USING (is_active = true);

CREATE POLICY "Users can create jobs" ON public.jobs
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = posted_by));

CREATE POLICY "Job posters can update their own jobs" ON public.jobs
    FOR UPDATE USING (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = posted_by));

CREATE POLICY "Job posters can delete their own jobs" ON public.jobs
    FOR DELETE USING (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = posted_by));

-- Create RLS policies for job_applications table
CREATE POLICY "Users can view their own applications" ON public.job_applications
    FOR SELECT USING (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = applicant_id));

CREATE POLICY "Job posters can view applications for their jobs" ON public.job_applications
    FOR SELECT USING (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = (SELECT posted_by FROM public.jobs WHERE id = job_id)));

CREATE POLICY "Users can create job applications" ON public.job_applications
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = applicant_id));

CREATE POLICY "Job posters can update application status" ON public.job_applications
    FOR UPDATE USING (auth.uid()::text = (SELECT supabase_auth_id FROM public.users WHERE id = (SELECT posted_by FROM public.jobs WHERE id = job_id)));

-- Add comments
COMMENT ON TABLE public.jobs IS 'Stores job postings from alumni and companies';
COMMENT ON TABLE public.job_applications IS 'Stores job applications from students and alumni';

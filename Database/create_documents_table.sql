-- Create documents table for file sharing
CREATE TABLE IF NOT EXISTS public.documents (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    file_size BIGINT,
    file_type VARCHAR(50) NOT NULL, -- 'resume', 'portfolio', 'certificate', 'other'
    mime_type VARCHAR(100),
    is_public BOOLEAN DEFAULT FALSE,
    download_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create document_shares table for sharing documents with specific users
CREATE TABLE IF NOT EXISTS public.document_shares (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id uuid NOT NULL REFERENCES public.documents(id) ON DELETE CASCADE,
    shared_with_user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    shared_by_user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    permission_type VARCHAR(20) DEFAULT 'view', -- 'view', 'download', 'edit'
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(document_id, shared_with_user_id)
);

-- Create document_categories table for organizing documents
CREATE TABLE IF NOT EXISTS public.document_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(7), -- Hex color code
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add category_id to documents table
ALTER TABLE public.documents 
ADD COLUMN IF NOT EXISTS category_id uuid REFERENCES public.document_categories(id);

-- Enable Row Level Security (RLS) for documents table
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view their own documents
CREATE POLICY "Users can view their own documents" ON public.documents
FOR SELECT USING (auth.uid() = user_id);

-- Policy to allow users to view public documents
CREATE POLICY "Users can view public documents" ON public.documents
FOR SELECT USING (is_public = true);

-- Policy to allow users to manage their own documents
CREATE POLICY "Users can manage their own documents" ON public.documents
FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Policy to allow users to view shared documents
CREATE POLICY "Users can view shared documents" ON public.documents
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.document_shares 
        WHERE document_shares.document_id = documents.id 
        AND document_shares.shared_with_user_id = auth.uid()
    )
);

-- Enable Row Level Security (RLS) for document_shares table
ALTER TABLE public.document_shares ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view shares they are involved in
CREATE POLICY "Users can view relevant document shares" ON public.document_shares
FOR SELECT USING (
    auth.uid() = shared_with_user_id OR auth.uid() = shared_by_user_id
);

-- Policy to allow users to create shares for their documents
CREATE POLICY "Users can share their documents" ON public.document_shares
FOR INSERT WITH CHECK (
    auth.uid() = shared_by_user_id AND
    EXISTS (
        SELECT 1 FROM public.documents 
        WHERE documents.id = document_id AND documents.user_id = auth.uid()
    )
);

-- Policy to allow users to update shares they created
CREATE POLICY "Users can update their document shares" ON public.document_shares
FOR UPDATE USING (auth.uid() = shared_by_user_id) WITH CHECK (auth.uid() = shared_by_user_id);

-- Policy to allow users to delete shares they created
CREATE POLICY "Users can delete their document shares" ON public.document_shares
FOR DELETE USING (auth.uid() = shared_by_user_id);

-- Enable Row Level Security (RLS) for document_categories table
ALTER TABLE public.document_categories ENABLE ROW LEVEL SECURITY;

-- Policy to allow all authenticated users to view document categories
CREATE POLICY "All users can view document categories" ON public.document_categories
FOR SELECT USING (auth.role() = 'authenticated');

-- Insert default document categories
INSERT INTO public.document_categories (name, description, icon, color) VALUES
('Resume', 'Professional resumes and CVs', 'description', '#3B82F6'),
('Portfolio', 'Work portfolios and project showcases', 'folder', '#10B981'),
('Certificates', 'Professional certificates and achievements', 'verified', '#F59E0B'),
('Projects', 'Project documentation and case studies', 'code', '#8B5CF6'),
('Research', 'Research papers and academic work', 'school', '#EF4444'),
('Other', 'Other documents and files', 'insert_drive_file', '#6B7280')
ON CONFLICT (name) DO NOTHING;

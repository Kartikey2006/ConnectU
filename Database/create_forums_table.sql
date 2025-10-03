-- Create forums table for discussion forums
CREATE TABLE IF NOT EXISTS public.forums (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL, -- 'general', 'career', 'alumni', 'events', 'mentorship'
    is_public BOOLEAN DEFAULT TRUE,
    created_by uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum_posts table for forum posts
CREATE TABLE IF NOT EXISTS public.forum_posts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    forum_id uuid NOT NULL REFERENCES public.forums(id) ON DELETE CASCADE,
    author_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_pinned BOOLEAN DEFAULT FALSE,
    is_locked BOOLEAN DEFAULT FALSE,
    view_count INTEGER DEFAULT 0,
    like_count INTEGER DEFAULT 0,
    reply_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum_replies table for forum post replies
CREATE TABLE IF NOT EXISTS public.forum_replies (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id uuid NOT NULL REFERENCES public.forum_posts(id) ON DELETE CASCADE,
    author_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    parent_reply_id uuid REFERENCES public.forum_replies(id) ON DELETE CASCADE, -- For nested replies
    like_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum_members table for forum membership
CREATE TABLE IF NOT EXISTS public.forum_members (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    forum_id uuid NOT NULL REFERENCES public.forums(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'member', -- 'member', 'moderator', 'admin'
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(forum_id, user_id)
);

-- Create forum_likes table for post and reply likes
CREATE TABLE IF NOT EXISTS public.forum_likes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    post_id uuid REFERENCES public.forum_posts(id) ON DELETE CASCADE,
    reply_id uuid REFERENCES public.forum_replies(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, post_id),
    UNIQUE(user_id, reply_id),
    CHECK (
        (post_id IS NOT NULL AND reply_id IS NULL) OR 
        (post_id IS NULL AND reply_id IS NOT NULL)
    )
);

-- Create group_chats table for group messaging
CREATE TABLE IF NOT EXISTS public.group_chats (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_by uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    is_public BOOLEAN DEFAULT FALSE,
    max_members INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create group_chat_members table for group chat membership
CREATE TABLE IF NOT EXISTS public.group_chat_members (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_id uuid NOT NULL REFERENCES public.group_chats(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'member', -- 'member', 'admin'
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_read_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(chat_id, user_id)
);

-- Create group_chat_messages table for group chat messages
CREATE TABLE IF NOT EXISTS public.group_chat_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_id uuid NOT NULL REFERENCES public.group_chats(id) ON DELETE CASCADE,
    sender_id uuid NOT NULL REFERENCES public.users(supabase_auth_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text', -- 'text', 'image', 'file', 'system'
    file_url TEXT,
    reply_to_message_id uuid REFERENCES public.group_chat_messages(id) ON DELETE SET NULL,
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for forums table
ALTER TABLE public.forums ENABLE ROW LEVEL SECURITY;

-- Policy to allow all authenticated users to view public forums
CREATE POLICY "All users can view public forums" ON public.forums
FOR SELECT USING (auth.role() = 'authenticated' AND is_public = true);

-- Policy to allow forum creators to manage their forums
CREATE POLICY "Forum creators can manage their forums" ON public.forums
FOR ALL USING (auth.uid() = created_by) WITH CHECK (auth.uid() = created_by);

-- Policy to allow forum members to view private forums
CREATE POLICY "Forum members can view private forums" ON public.forums
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.forum_members 
        WHERE forum_members.forum_id = forums.id 
        AND forum_members.user_id = auth.uid()
    )
);

-- Enable Row Level Security (RLS) for forum_posts table
ALTER TABLE public.forum_posts ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view posts in forums they have access to
CREATE POLICY "Users can view posts in accessible forums" ON public.forum_posts
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.forums 
        WHERE forums.id = forum_id 
        AND (
            forums.is_public = true OR
            EXISTS (
                SELECT 1 FROM public.forum_members 
                WHERE forum_members.forum_id = forums.id 
                AND forum_members.user_id = auth.uid()
            )
        )
    )
);

-- Policy to allow authenticated users to create posts
CREATE POLICY "Authenticated users can create posts" ON public.forum_posts
FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    auth.uid() = author_id AND
    EXISTS (
        SELECT 1 FROM public.forums 
        WHERE forums.id = forum_id 
        AND (
            forums.is_public = true OR
            EXISTS (
                SELECT 1 FROM public.forum_members 
                WHERE forum_members.forum_id = forums.id 
                AND forum_members.user_id = auth.uid()
            )
        )
    )
);

-- Policy to allow post authors to update their posts
CREATE POLICY "Post authors can update their posts" ON public.forum_posts
FOR UPDATE USING (auth.uid() = author_id) WITH CHECK (auth.uid() = author_id);

-- Policy to allow post authors to delete their posts
CREATE POLICY "Post authors can delete their posts" ON public.forum_posts
FOR DELETE USING (auth.uid() = author_id);

-- Enable Row Level Security (RLS) for forum_replies table
ALTER TABLE public.forum_replies ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view replies to posts they can access
CREATE POLICY "Users can view replies to accessible posts" ON public.forum_replies
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.forum_posts 
        JOIN public.forums ON forums.id = forum_posts.forum_id
        WHERE forum_posts.id = post_id 
        AND (
            forums.is_public = true OR
            EXISTS (
                SELECT 1 FROM public.forum_members 
                WHERE forum_members.forum_id = forums.id 
                AND forum_members.user_id = auth.uid()
            )
        )
    )
);

-- Policy to allow authenticated users to create replies
CREATE POLICY "Authenticated users can create replies" ON public.forum_replies
FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    auth.uid() = author_id AND
    EXISTS (
        SELECT 1 FROM public.forum_posts 
        JOIN public.forums ON forums.id = forum_posts.forum_id
        WHERE forum_posts.id = post_id 
        AND (
            forums.is_public = true OR
            EXISTS (
                SELECT 1 FROM public.forum_members 
                WHERE forum_members.forum_id = forums.id 
                AND forum_members.user_id = auth.uid()
            )
        )
    )
);

-- Policy to allow reply authors to update their replies
CREATE POLICY "Reply authors can update their replies" ON public.forum_replies
FOR UPDATE USING (auth.uid() = author_id) WITH CHECK (auth.uid() = author_id);

-- Policy to allow reply authors to delete their replies
CREATE POLICY "Reply authors can delete their replies" ON public.forum_replies
FOR DELETE USING (auth.uid() = author_id);

-- Enable Row Level Security (RLS) for forum_members table
ALTER TABLE public.forum_members ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view forum memberships
CREATE POLICY "Users can view forum memberships" ON public.forum_members
FOR SELECT USING (
    auth.uid() = user_id OR
    EXISTS (
        SELECT 1 FROM public.forums 
        WHERE forums.id = forum_id 
        AND forums.is_public = true
    )
);

-- Policy to allow users to join forums
CREATE POLICY "Users can join forums" ON public.forum_members
FOR INSERT WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
        SELECT 1 FROM public.forums 
        WHERE forums.id = forum_id 
        AND forums.is_public = true
    )
);

-- Policy to allow users to leave forums
CREATE POLICY "Users can leave forums" ON public.forum_members
FOR DELETE USING (auth.uid() = user_id);

-- Enable Row Level Security (RLS) for forum_likes table
ALTER TABLE public.forum_likes ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view likes
CREATE POLICY "Users can view likes" ON public.forum_likes
FOR SELECT USING (auth.role() = 'authenticated');

-- Policy to allow users to like posts and replies
CREATE POLICY "Users can like posts and replies" ON public.forum_likes
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy to allow users to unlike posts and replies
CREATE POLICY "Users can unlike posts and replies" ON public.forum_likes
FOR DELETE USING (auth.uid() = user_id);

-- Enable Row Level Security (RLS) for group_chats table
ALTER TABLE public.group_chats ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view group chats they are members of
CREATE POLICY "Users can view their group chats" ON public.group_chats
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.group_chat_members 
        WHERE group_chat_members.chat_id = group_chats.id 
        AND group_chat_members.user_id = auth.uid()
    )
);

-- Policy to allow users to view public group chats
CREATE POLICY "Users can view public group chats" ON public.group_chats
FOR SELECT USING (auth.role() = 'authenticated' AND is_public = true);

-- Policy to allow users to create group chats
CREATE POLICY "Users can create group chats" ON public.group_chats
FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Policy to allow group chat creators to update their chats
CREATE POLICY "Group chat creators can update their chats" ON public.group_chats
FOR UPDATE USING (auth.uid() = created_by) WITH CHECK (auth.uid() = created_by);

-- Policy to allow group chat creators to delete their chats
CREATE POLICY "Group chat creators can delete their chats" ON public.group_chats
FOR DELETE USING (auth.uid() = created_by);

-- Enable Row Level Security (RLS) for group_chat_members table
ALTER TABLE public.group_chat_members ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view group chat memberships
CREATE POLICY "Users can view group chat memberships" ON public.group_chat_members
FOR SELECT USING (
    auth.uid() = user_id OR
    EXISTS (
        SELECT 1 FROM public.group_chats 
        WHERE group_chats.id = chat_id 
        AND group_chats.is_public = true
    )
);

-- Policy to allow users to join group chats
CREATE POLICY "Users can join group chats" ON public.group_chat_members
FOR INSERT WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
        SELECT 1 FROM public.group_chats 
        WHERE group_chats.id = chat_id 
        AND (
            group_chats.is_public = true OR
            group_chats.created_by = auth.uid()
        )
    )
);

-- Policy to allow users to leave group chats
CREATE POLICY "Users can leave group chats" ON public.group_chat_members
FOR DELETE USING (auth.uid() = user_id);

-- Enable Row Level Security (RLS) for group_chat_messages table
ALTER TABLE public.group_chat_messages ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to view messages in chats they are members of
CREATE POLICY "Users can view messages in their chats" ON public.group_chat_messages
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.group_chat_members 
        WHERE group_chat_members.chat_id = group_chat_messages.chat_id 
        AND group_chat_members.user_id = auth.uid()
    )
);

-- Policy to allow users to send messages in chats they are members of
CREATE POLICY "Users can send messages in their chats" ON public.group_chat_messages
FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
        SELECT 1 FROM public.group_chat_members 
        WHERE group_chat_members.chat_id = group_chat_messages.chat_id 
        AND group_chat_members.user_id = auth.uid()
    )
);

-- Policy to allow message senders to update their messages
CREATE POLICY "Message senders can update their messages" ON public.group_chat_messages
FOR UPDATE USING (auth.uid() = sender_id) WITH CHECK (auth.uid() = sender_id);

-- Policy to allow message senders to delete their messages
CREATE POLICY "Message senders can delete their messages" ON public.group_chat_messages
FOR DELETE USING (auth.uid() = sender_id);

-- Insert default forums
INSERT INTO public.forums (name, description, category, is_public, created_by) VALUES
('General Discussion', 'General discussions and announcements', 'general', true, (SELECT supabase_auth_id FROM users LIMIT 1)),
('Career Advice', 'Career guidance and job search discussions', 'career', true, (SELECT supabase_auth_id FROM users LIMIT 1)),
('Alumni Stories', 'Share your success stories and experiences', 'alumni', true, (SELECT supabase_auth_id FROM users LIMIT 1)),
('Event Discussions', 'Discussions about upcoming and past events', 'events', true, (SELECT supabase_auth_id FROM users LIMIT 1)),
('Mentorship Forum', 'Mentorship-related discussions and tips', 'mentorship', true, (SELECT supabase_auth_id FROM users LIMIT 1))
ON CONFLICT DO NOTHING;

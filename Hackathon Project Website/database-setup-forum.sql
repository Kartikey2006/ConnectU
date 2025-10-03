-- Create forum categories table
CREATE TABLE IF NOT EXISTS forum_categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum posts table
CREATE TABLE IF NOT EXISTS forum_posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES forum_categories(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum comments table
CREATE TABLE IF NOT EXISTS forum_comments (
  id SERIAL PRIMARY KEY,
  post_id INTEGER REFERENCES forum_posts(id) ON DELETE CASCADE,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default categories
INSERT INTO forum_categories (name, description) VALUES
('General Discussion', 'General topics and discussions'),
('Academic Help', 'Ask questions about academic topics'),
('Career Advice', 'Career guidance and job search help'),
('Tech Talk', 'Technology discussions and trends'),
('Alumni Stories', 'Share your experiences and success stories')
ON CONFLICT DO NOTHING;

-- Enable Row Level Security
ALTER TABLE forum_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_comments ENABLE ROW LEVEL SECURITY;

-- Create policies for forum_categories (read-only for all authenticated users)
CREATE POLICY "Categories are viewable by authenticated users" 
ON forum_categories FOR SELECT 
USING (auth.role() = 'authenticated');

-- Create policies for forum_posts
CREATE POLICY "Posts are viewable by all authenticated users" 
ON forum_posts FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert posts" 
ON forum_posts FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update own posts" 
ON forum_posts FOR UPDATE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_posts.user_id));

CREATE POLICY "Users can delete own posts" 
ON forum_posts FOR DELETE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_posts.user_id));

-- Create policies for forum_comments
CREATE POLICY "Comments are viewable by all authenticated users" 
ON forum_comments FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert comments" 
ON forum_comments FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update own comments" 
ON forum_comments FOR UPDATE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_comments.user_id));

CREATE POLICY "Users can delete own comments" 
ON forum_comments FOR DELETE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_comments.user_id));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_forum_posts_category ON forum_posts(category_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_user ON forum_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_created_at ON forum_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_forum_comments_post ON forum_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_forum_comments_user ON forum_comments(user_id);

-- Create additional Flutter-compatible tables
CREATE TABLE IF NOT EXISTS forums (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100) DEFAULT 'General',
  is_public BOOLEAN DEFAULT true,
  created_by INTEGER REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum members table
CREATE TABLE IF NOT EXISTS forum_members (
  id SERIAL PRIMARY KEY,
  forum_id INTEGER REFERENCES forums(id) ON DELETE CASCADE,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(forum_id, user_id)
);

-- Create forum replies table
CREATE TABLE IF NOT EXISTS forum_replies (
  id SERIAL PRIMARY KEY,
  post_id INTEGER REFERENCES forum_posts(id) ON DELETE CASCADE,
  author_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  parent_reply_id INTEGER REFERENCES forum_replies(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create forum likes table
CREATE TABLE IF NOT EXISTS forum_likes (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  post_id INTEGER REFERENCES forum_posts(id) ON DELETE CASCADE,
  reply_id INTEGER REFERENCES forum_replies(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CHECK ((post_id IS NOT NULL) OR (reply_id IS NOT NULL)),
  UNIQUE(user_id, post_id),
  UNIQUE(user_id, reply_id)
);

-- Add columns to forum_posts for Flutter compatibility
ALTER TABLE forum_posts 
  ADD COLUMN IF NOT EXISTS forum_id INTEGER REFERENCES forums(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS author_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS replies_count INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS views_count INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT false;

-- Drop the old category_id constraint if it exists and add new forum_id constraint
-- DO $$ BEGIN
--   IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'forum_posts_category_id_fkey') THEN
--     ALTER TABLE forum_posts DROP CONSTRAINT forum_posts_category_id_fkey;
--   END IF;
-- END $$;

-- Insert default forums (equivalent to categories)
INSERT INTO forums (name, description, category, created_by, is_public) 
SELECT 
  fc.name, 
  fc.description, 
  CASE 
    WHEN fc.name = 'General Discussion' THEN 'General'
    WHEN fc.name = 'Academic Help' THEN 'Academic' 
    WHEN fc.name = 'Career Advice' THEN 'Career'
    WHEN fc.name = 'Tech Talk' THEN 'Tech'
    WHEN fc.name = 'Alumni Stories' THEN 'Alumni'
    ELSE 'General'
  END,
  1, -- Admin user ID
  true
FROM forum_categories fc
WHERE NOT EXISTS (SELECT 1 FROM forums WHERE name = fc.name)
ON CONFLICT DO NOTHING;

-- Create database functions for counters
CREATE OR REPLACE FUNCTION increment_reply_count(post_id_param INTEGER)
RETURNS VOID AS $$
BEGIN
  UPDATE forum_posts 
  SET replies_count = replies_count + 1 
  WHERE id = post_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION increment_like_count(post_id_param INTEGER)
RETURNS VOID AS $$
BEGIN
  UPDATE forum_posts 
  SET likes_count = likes_count + 1 
  WHERE id = post_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_like_count(post_id_param INTEGER)
RETURNS VOID AS $$
BEGIN
  UPDATE forum_posts 
  SET likes_count = GREATEST(likes_count - 1, 0) 
  WHERE id = post_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION increment_view_count(post_id_param INTEGER)
RETURNS VOID AS $$
BEGIN
  UPDATE forum_posts 
  SET views_count = views_count + 1 
  WHERE id = post_id_param;
END;
$$ LANGUAGE plpgsql;

-- Enable Row Level Security for new tables
ALTER TABLE forums ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_likes ENABLE ROW LEVEL SECURITY;

-- Create policies for forums
CREATE POLICY "Forums are viewable by authenticated users" 
ON forums FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can create forums" 
ON forums FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update own forums" 
ON forums FOR UPDATE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forums.created_by));

-- Create policies for forum_members
CREATE POLICY "Forum members are viewable by authenticated users" 
ON forum_members FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can join forums" 
ON forum_members FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can leave forums they joined" 
ON forum_members FOR DELETE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_members.user_id));

-- Create policies for forum_replies
CREATE POLICY "Replies are viewable by authenticated users" 
ON forum_replies FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can create replies" 
ON forum_replies FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update own replies" 
ON forum_replies FOR UPDATE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_replies.author_id));

CREATE POLICY "Users can delete own replies" 
ON forum_replies FOR DELETE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_replies.author_id));

-- Create policies for forum_likes
CREATE POLICY "Likes are viewable by authenticated users" 
ON forum_likes FOR SELECT 
USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can like/unlike" 
ON forum_likes FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can remove their own likes" 
ON forum_likes FOR DELETE 
USING (auth.uid()::text = (SELECT supabase_auth_id FROM users WHERE id = forum_likes.user_id));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_forums_category ON forums(category);
CREATE INDEX IF NOT EXISTS idx_forums_created_by ON forums(created_by);
CREATE INDEX IF NOT EXISTS idx_forum_members_forum ON forum_members(forum_id);
CREATE INDEX IF NOT EXISTS idx_forum_members_user ON forum_members(user_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_forum ON forum_posts(forum_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_author ON forum_posts(author_id);
CREATE INDEX IF NOT EXISTS idx_forum_replies_post ON forum_replies(post_id);
CREATE INDEX IF NOT EXISTS idx_forum_replies_author ON forum_replies(author_id);
CREATE INDEX IF NOT EXISTS idx_forum_likes_post ON forum_likes(post_id);
CREATE INDEX IF NOT EXISTS idx_forum_likes_reply ON forum_likes(reply_id);
CREATE INDEX IF NOT EXISTS idx_forum_likes_user ON forum_likes(user_id);

-- Enable realtime for all forum tables
ALTER PUBLICATION supabase_realtime ADD TABLE forums;
ALTER PUBLICATION supabase_realtime ADD TABLE forum_posts;
ALTER PUBLICATION supabase_realtime ADD TABLE forum_comments;
ALTER PUBLICATION supabase_realtime ADD TABLE forum_categories;
ALTER PUBLICATION supabase_realtime ADD TABLE forum_members;
ALTER PUBLICATION supabase_realtime ADD TABLE forum_replies;
ALTER PUBLICATION supabase_realtime ADD TABLE forum_likes;

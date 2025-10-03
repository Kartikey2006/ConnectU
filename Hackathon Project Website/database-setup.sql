-- Database setup for ConnectU Alumni Platform
-- Run this in your Supabase SQL editor

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255), -- Optional, Supabase handles auth
  role VARCHAR(20) CHECK (role IN ('student', 'alumni', 'admin')) NOT NULL DEFAULT 'student',
  supabase_auth_id VARCHAR(255) UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create student details table
CREATE TABLE IF NOT EXISTS studentdetails (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  current_year INTEGER CHECK (current_year >= 1 AND current_year <= 4),
  branch VARCHAR(100),
  skills TEXT[], -- Array of skills
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create alumni details table
CREATE TABLE IF NOT EXISTS alumnidetails (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  batch_year INTEGER,
  company VARCHAR(255),
  designation VARCHAR(255),
  linkedin_url VARCHAR(500),
  verification_status BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create role change log table for audit
CREATE TABLE IF NOT EXISTS role_change_log (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  old_role VARCHAR(20),
  new_role VARCHAR(20) NOT NULL,
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  changed_by VARCHAR(255) -- Admin who made the change
);

-- Create mentorship sessions table
CREATE TABLE IF NOT EXISTS mentorship_sessions (
  id SERIAL PRIMARY KEY,
  alumni_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  student_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  topic VARCHAR(255) NOT NULL,
  date_time TIMESTAMP WITH TIME ZONE NOT NULL,
  duration INTEGER NOT NULL, -- Duration in minutes
  price DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) CHECK (status IN ('pending', 'accepted', 'rejected', 'completed', 'cancelled')) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create webinars table
CREATE TABLE IF NOT EXISTS webinars (
  id SERIAL PRIMARY KEY,
  alumni_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  date_time TIMESTAMP WITH TIME ZONE NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  max_participants INTEGER DEFAULT 100,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create referrals table
CREATE TABLE IF NOT EXISTS referrals (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  alumni_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  message TEXT,
  status VARCHAR(20) CHECK (status IN ('pending', 'accepted', 'rejected')) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create transactions table
CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  payer_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  payee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  amount DECIMAL(10,2) NOT NULL,
  type VARCHAR(50) NOT NULL, -- 'mentorship', 'webinar', etc.
  reference_id INTEGER, -- ID of the session/webinar
  status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'failed', 'refunded')) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_supabase_auth_id ON users(supabase_auth_id);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_alumni_id ON mentorship_sessions(alumni_id);
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_student_id ON mentorship_sessions(student_id);
CREATE INDEX IF NOT EXISTS idx_webinars_alumni_id ON webinars(alumni_id);
CREATE INDEX IF NOT EXISTS idx_referrals_student_id ON referrals(student_id);
CREATE INDEX IF NOT EXISTS idx_referrals_alumni_id ON referrals(alumni_id);

-- Enable Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE studentdetails ENABLE ROW LEVEL SECURITY;
ALTER TABLE alumnidetails ENABLE ROW LEVEL SECURITY;
ALTER TABLE mentorship_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE webinars ENABLE ROW LEVEL SECURITY;
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can read their own data
CREATE POLICY "Users can read own data" ON users
  FOR SELECT USING (auth.uid()::text = supabase_auth_id);

-- Users can update their own data
CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid()::text = supabase_auth_id);

-- Allow signup to insert users
CREATE POLICY "Allow signup" ON users
  FOR INSERT WITH CHECK (true);

-- Admin can read all users
CREATE POLICY "Admin can read all users" ON users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE supabase_auth_id = auth.uid()::text 
      AND role = 'admin'
    )
  );

-- Admin can update all users
CREATE POLICY "Admin can update all users" ON users
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE supabase_auth_id = auth.uid()::text 
      AND role = 'admin'
    )
  );

-- Similar policies for other tables
CREATE POLICY "Users can read own student details" ON studentdetails
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = studentdetails.user_id 
      AND supabase_auth_id = auth.uid()::text
    )
  );

CREATE POLICY "Users can update own student details" ON studentdetails
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = studentdetails.user_id 
      AND supabase_auth_id = auth.uid()::text
    )
  );

CREATE POLICY "Allow insert student details" ON studentdetails
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = studentdetails.user_id 
      AND supabase_auth_id = auth.uid()::text
    )
  );

-- Similar policies for alumnidetails
CREATE POLICY "Users can read own alumni details" ON alumnidetails
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = alumnidetails.user_id 
      AND supabase_auth_id = auth.uid()::text
    )
  );

CREATE POLICY "Users can update own alumni details" ON alumnidetails
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = alumnidetails.user_id 
      AND supabase_auth_id = auth.uid()::text
    )
  );

CREATE POLICY "Allow insert alumni details" ON alumnidetails
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = alumnidetails.user_id 
      AND supabase_auth_id = auth.uid()::text
    )
  );

-- Create a function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_studentdetails_updated_at BEFORE UPDATE ON studentdetails
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_alumnidetails_updated_at BEFORE UPDATE ON alumnidetails
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mentorship_sessions_updated_at BEFORE UPDATE ON mentorship_sessions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_webinars_updated_at BEFORE UPDATE ON webinars
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_referrals_updated_at BEFORE UPDATE ON referrals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert a default admin user (you should change the email and create the user in Supabase Auth first)
-- This is just an example - replace with actual admin user data
-- INSERT INTO users (name, email, role, supabase_auth_id) 
-- VALUES ('Admin User', 'admin@connectu.com', 'admin', 'your-supabase-auth-id-here')
-- ON CONFLICT (email) DO NOTHING;

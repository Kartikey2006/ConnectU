-- Insert sample highly qualified alumni profiles for testing
-- This script adds 4 diverse alumni profiles with different backgrounds

-- First, let's ensure we have the alumni_profiles table structure
CREATE TABLE IF NOT EXISTS alumni_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    linkedin_profile VARCHAR(255),
    bio TEXT,
    university VARCHAR(255) NOT NULL,
    degree VARCHAR(100) NOT NULL,
    field_of_study VARCHAR(100) NOT NULL,
    graduation_year VARCHAR(10) NOT NULL,
    gpa VARCHAR(10),
    achievements TEXT,
    current_company VARCHAR(255),
    current_position VARCHAR(255),
    experience_years VARCHAR(10),
    skills TEXT,
    interests TEXT,
    profile_image_path VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert 4 highly qualified alumni profiles

-- 1. Tech Industry Leader - Software Engineering
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests,
    profile_image_path
) VALUES (
    1, 'Sarah', 'Chen', '+1-555-0101', '1985-03-15', '123 Tech Valley Drive', 'San Francisco', 'California', 'USA',
    'https://linkedin.com/in/sarahchen', 
    'Senior Software Engineer with 12+ years of experience in full-stack development. Passionate about building scalable applications and mentoring junior developers. Led multiple high-impact projects at major tech companies.',
    'Stanford University', 'Master of Science', 'Computer Science', '2007', '3.9',
    'Google Code Jam Winner 2006, IEEE Best Paper Award 2007, Built 3 successful startups',
    'Google', 'Senior Staff Software Engineer', '12',
    'Python, JavaScript, React, Node.js, AWS, Machine Learning, Leadership',
    'Technology, Mentoring, Photography, Hiking, Open Source',
    NULL
);

-- 2. Finance Executive - Investment Banking
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests,
    profile_image_path
) VALUES (
    2, 'Michael', 'Rodriguez', '+1-555-0102', '1982-07-22', '456 Wall Street', 'New York', 'New York', 'USA',
    'https://linkedin.com/in/michaelrodriguez',
    'Investment Banking Director with 15+ years of experience in M&A and capital markets. Expert in financial modeling, due diligence, and strategic advisory. Successfully closed over $50B in transactions.',
    'Harvard Business School', 'Master of Business Administration', 'Finance', '2005', '3.8',
    'CFA Charterholder, Forbes 30 Under 30 (2008), Led $10B acquisition deal',
    'Goldman Sachs', 'Managing Director', '15',
    'Financial Modeling, M&A, Capital Markets, Leadership, Strategic Planning',
    'Finance, Golf, Wine Tasting, Travel, Philanthropy',
    NULL
);

-- 3. Healthcare Innovation Leader - Medical Technology
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests,
    profile_image_path
) VALUES (
    3, 'Dr. Priya', 'Patel', '+1-555-0103', '1980-11-08', '789 Medical Center Blvd', 'Boston', 'Massachusetts', 'USA',
    'https://linkedin.com/in/drpriyapatel',
    'Chief Medical Officer and serial entrepreneur in healthcare technology. MD with specialization in cardiology and 10+ years in medical device innovation. Founded 2 successful healthtech startups.',
    'Johns Hopkins University', 'Doctor of Medicine', 'Cardiology', '2006', '3.95',
    'Nobel Prize Nominee 2020, FDA Approval for 3 medical devices, TEDx Speaker',
    'MedTech Innovations Inc.', 'Chief Medical Officer & Co-Founder', '10',
    'Medical Research, Product Development, Regulatory Affairs, Leadership, Public Speaking',
    'Healthcare Innovation, Yoga, Classical Music, Medical Research, Mentoring',
    NULL
);

-- 4. Marketing & Brand Strategy Expert - Consumer Goods
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests,
    profile_image_path
) VALUES (
    4, 'James', 'Thompson', '+1-555-0104', '1983-05-14', '321 Brand Avenue', 'Chicago', 'Illinois', 'USA',
    'https://linkedin.com/in/jamesthompson',
    'Global Marketing Director with 13+ years of experience in brand strategy and digital marketing. Expert in consumer insights, campaign development, and market expansion. Led marketing for 5 major product launches.',
    'Northwestern University', 'Master of Science', 'Integrated Marketing Communications', '2006', '3.7',
    'Cannes Lions Winner 2019, AdAge 40 Under 40 (2018), Increased brand awareness by 300%',
    'Procter & Gamble', 'Global Marketing Director', '13',
    'Brand Strategy, Digital Marketing, Consumer Insights, Campaign Management, Leadership',
    'Marketing, Travel, Photography, Sports, Wine Tasting',
    NULL
);

-- Also insert corresponding user records for these alumni
-- (Assuming these user IDs don't exist yet)

-- User 1 - Sarah Chen
INSERT INTO users (id, name, email, role, created_at, updated_at) 
VALUES (1, 'Sarah Chen', 'sarah.chen@alumni.stanford.edu', 'alumni', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

-- User 2 - Michael Rodriguez  
INSERT INTO users (id, name, email, role, created_at, updated_at)
VALUES (2, 'Michael Rodriguez', 'michael.rodriguez@alumni.harvard.edu', 'alumni', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

-- User 3 - Dr. Priya Patel
INSERT INTO users (id, name, email, role, created_at, updated_at)
VALUES (3, 'Dr. Priya Patel', 'priya.patel@alumni.jhu.edu', 'alumni', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

-- User 4 - James Thompson
INSERT INTO users (id, name, email, role, created_at, updated_at)
VALUES (4, 'James Thompson', 'james.thompson@alumni.northwestern.edu', 'alumni', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_alumni_profiles_user_id ON alumni_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_alumni_profiles_company ON alumni_profiles(current_company);
CREATE INDEX IF NOT EXISTS idx_alumni_profiles_university ON alumni_profiles(university);
CREATE INDEX IF NOT EXISTS idx_alumni_profiles_skills ON alumni_profiles(skills);

-- Enable Row Level Security (RLS) for alumni_profiles table
ALTER TABLE alumni_profiles ENABLE ROW LEVEL SECURITY;

-- Create RLS policy to allow authenticated users to read alumni profiles
CREATE POLICY "Allow authenticated users to read alumni profiles" ON alumni_profiles
    FOR SELECT USING (auth.role() = 'authenticated');

-- Create RLS policy to allow alumni to update their own profiles
CREATE POLICY "Allow alumni to update own profile" ON alumni_profiles
    FOR UPDATE USING (auth.uid()::text = user_id::text);

-- Create RLS policy to allow alumni to insert their own profiles
CREATE POLICY "Allow alumni to insert own profile" ON alumni_profiles
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- Display the inserted data
SELECT 
    id,
    first_name || ' ' || last_name as full_name,
    current_company,
    current_position,
    university,
    degree,
    experience_years || ' years experience' as experience,
    skills
FROM alumni_profiles 
ORDER BY id;

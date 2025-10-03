-- Simple insert script for Supabase Dashboard
-- Copy and paste this into your Supabase SQL Editor

-- Insert sample alumni profiles (simplified version)

-- 1. Tech Leader - Sarah Chen
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests
) VALUES (
    1, 'Sarah', 'Chen', '+1-555-0101', '1985-03-15', '123 Tech Valley Drive', 'San Francisco', 'California', 'USA',
    'https://linkedin.com/in/sarahchen', 
    'Senior Software Engineer with 12+ years of experience in full-stack development. Passionate about building scalable applications and mentoring junior developers.',
    'Stanford University', 'Master of Science', 'Computer Science', '2007', '3.9',
    'Google Code Jam Winner 2006, IEEE Best Paper Award 2007, Built 3 successful startups',
    'Google', 'Senior Staff Software Engineer', '12',
    'Python, JavaScript, React, Node.js, AWS, Machine Learning, Leadership',
    'Technology, Mentoring, Photography, Hiking, Open Source'
);

-- 2. Finance Executive - Michael Rodriguez
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests
) VALUES (
    2, 'Michael', 'Rodriguez', '+1-555-0102', '1982-07-22', '456 Wall Street', 'New York', 'New York', 'USA',
    'https://linkedin.com/in/michaelrodriguez',
    'Investment Banking Director with 15+ years of experience in M&A and capital markets. Expert in financial modeling and strategic advisory.',
    'Harvard Business School', 'Master of Business Administration', 'Finance', '2005', '3.8',
    'CFA Charterholder, Forbes 30 Under 30 (2008), Led $10B acquisition deal',
    'Goldman Sachs', 'Managing Director', '15',
    'Financial Modeling, M&A, Capital Markets, Leadership, Strategic Planning',
    'Finance, Golf, Wine Tasting, Travel, Philanthropy'
);

-- 3. Healthcare Leader - Dr. Priya Patel
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests
) VALUES (
    3, 'Dr. Priya', 'Patel', '+1-555-0103', '1980-11-08', '789 Medical Center Blvd', 'Boston', 'Massachusetts', 'USA',
    'https://linkedin.com/in/drpriyapatel',
    'Chief Medical Officer and serial entrepreneur in healthcare technology. MD with specialization in cardiology and 10+ years in medical device innovation.',
    'Johns Hopkins University', 'Doctor of Medicine', 'Cardiology', '2006', '3.95',
    'Nobel Prize Nominee 2020, FDA Approval for 3 medical devices, TEDx Speaker',
    'MedTech Innovations Inc.', 'Chief Medical Officer & Co-Founder', '10',
    'Medical Research, Product Development, Regulatory Affairs, Leadership, Public Speaking',
    'Healthcare Innovation, Yoga, Classical Music, Medical Research, Mentoring'
);

-- 4. Marketing Expert - James Thompson
INSERT INTO alumni_profiles (
    user_id, first_name, last_name, phone, date_of_birth, address, city, state, country,
    linkedin_profile, bio, university, degree, field_of_study, graduation_year, gpa,
    achievements, current_company, current_position, experience_years, skills, interests
) VALUES (
    4, 'James', 'Thompson', '+1-555-0104', '1983-05-14', '321 Brand Avenue', 'Chicago', 'Illinois', 'USA',
    'https://linkedin.com/in/jamesthompson',
    'Global Marketing Director with 13+ years of experience in brand strategy and digital marketing. Expert in consumer insights and campaign development.',
    'Northwestern University', 'Master of Science', 'Integrated Marketing Communications', '2006', '3.7',
    'Cannes Lions Winner 2019, AdAge 40 Under 40 (2018), Increased brand awareness by 300%',
    'Procter & Gamble', 'Global Marketing Director', '13',
    'Brand Strategy, Digital Marketing, Consumer Insights, Campaign Management, Leadership',
    'Marketing, Travel, Photography, Sports, Wine Tasting'
);

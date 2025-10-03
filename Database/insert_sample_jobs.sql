-- Insert sample job data
-- Note: Replace the posted_by values with actual user IDs from your users table

INSERT INTO public.jobs (
    title, 
    company, 
    location, 
    type, 
    salary, 
    experience, 
    description, 
    skills, 
    category, 
    posted_by
) VALUES 
(
    'Senior Software Engineer',
    'Google',
    'Bangalore',
    'Full-time',
    '₹15-25 LPA',
    '3-5 years',
    'We are looking for a Senior Software Engineer to join our team. You will be responsible for developing and maintaining our core products. This role involves working with cutting-edge technologies and collaborating with cross-functional teams.',
    ARRAY['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
    'Technology',
    1 -- Replace with actual user ID
),
(
    'Product Manager',
    'Microsoft',
    'Mumbai',
    'Full-time',
    '₹12-20 LPA',
    '2-4 years',
    'Join our product team to drive innovation and deliver exceptional user experiences. You will work closely with engineering, design, and business teams to define product strategy and roadmap.',
    ARRAY['Product Management', 'Agile', 'Analytics', 'User Research'],
    'Technology',
    1 -- Replace with actual user ID
),
(
    'Data Science Intern',
    'Amazon',
    'Pune',
    'Internship',
    '₹30k/month',
    '0-1 years',
    'Great opportunity for students to learn and work on real-world data science projects. You will work with large datasets, build machine learning models, and gain hands-on experience in the field.',
    ARRAY['Python', 'Machine Learning', 'SQL', 'Statistics'],
    'Technology',
    1 -- Replace with actual user ID
),
(
    'Investment Banking Analyst',
    'Goldman Sachs',
    'Delhi',
    'Full-time',
    '₹18-30 LPA',
    '1-3 years',
    'Join our investment banking team to work on high-profile deals and transactions. You will analyze financial data, prepare presentations, and work with senior bankers on client projects.',
    ARRAY['Finance', 'Excel', 'Financial Modeling', 'Analytics'],
    'Finance',
    1 -- Replace with actual user ID
),
(
    'Marketing Manager',
    'Unilever',
    'Mumbai',
    'Full-time',
    '₹10-18 LPA',
    '2-4 years',
    'Lead marketing campaigns for our consumer products. You will develop marketing strategies, manage brand positioning, and work with creative teams to deliver impactful campaigns.',
    ARRAY['Digital Marketing', 'Brand Management', 'Analytics', 'Campaign Management'],
    'Marketing',
    1 -- Replace with actual user ID
),
(
    'UX Designer',
    'Adobe',
    'Bangalore',
    'Full-time',
    '₹8-15 LPA',
    '1-3 years',
    'Design intuitive and beautiful user experiences for our creative software. You will conduct user research, create wireframes and prototypes, and collaborate with product and engineering teams.',
    ARRAY['Figma', 'User Research', 'Prototyping', 'Design Systems'],
    'Design',
    1 -- Replace with actual user ID
),
(
    'DevOps Engineer',
    'Netflix',
    'Mumbai',
    'Full-time',
    '₹12-22 LPA',
    '2-5 years',
    'Build and maintain our cloud infrastructure. You will work with AWS, implement CI/CD pipelines, and ensure high availability and scalability of our streaming platform.',
    ARRAY['AWS', 'Docker', 'Kubernetes', 'Terraform', 'Python'],
    'Technology',
    1 -- Replace with actual user ID
),
(
    'Business Analyst',
    'McKinsey & Company',
    'Delhi',
    'Full-time',
    '₹14-25 LPA',
    '1-3 years',
    'Work on strategic consulting projects for Fortune 500 companies. You will analyze business problems, develop solutions, and present recommendations to senior executives.',
    ARRAY['Business Analysis', 'Excel', 'PowerPoint', 'Problem Solving'],
    'Consulting',
    1 -- Replace with actual user ID
);

-- Update the timestamps to show recent postings
UPDATE public.jobs SET created_at = NOW() - INTERVAL '2 days' WHERE title = 'Senior Software Engineer';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '1 week' WHERE title = 'Product Manager';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '3 days' WHERE title = 'Data Science Intern';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '5 days' WHERE title = 'Investment Banking Analyst';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '1 day' WHERE title = 'Marketing Manager';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '4 days' WHERE title = 'UX Designer';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '6 days' WHERE title = 'DevOps Engineer';
UPDATE public.jobs SET created_at = NOW() - INTERVAL '2 days' WHERE title = 'Business Analyst';

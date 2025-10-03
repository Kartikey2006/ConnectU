-- Insert sample events data
INSERT INTO public.events (organizer_id, title, description, event_type, start_date, end_date, location, virtual_link, max_attendees, registration_deadline, cover_image_url, is_virtual, registration_fee, is_active)
VALUES
('YOUR_USER_ID_1', 'Annual Alumni Reunion 2024', 'Join us for our biggest alumni reunion of the year! Connect with old friends, meet new alumni, and celebrate our shared journey. The event will feature keynote speeches, networking sessions, and a gala dinner.', 'alumni_reunion', '2024-03-15 18:00:00+00', '2024-03-15 23:00:00+00', 'Grand Ballroom, Hotel Taj Palace, Mumbai', null, 500, '2024-03-10 23:59:59+00', 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800', false, 2500.00, true),

('YOUR_USER_ID_2', 'Tech Innovation Webinar Series', 'A series of webinars featuring industry leaders discussing the latest trends in technology, AI, and digital transformation. Perfect for alumni working in tech or looking to transition into tech roles.', 'webinar', '2024-02-20 19:00:00+00', '2024-02-20 21:00:00+00', null, 'https://zoom.us/j/123456789', 200, '2024-02-19 18:00:00+00', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800', true, 0.00, true),

('YOUR_USER_ID_3', 'Networking Mixer - Finance & Banking', 'An exclusive networking event for alumni working in finance, banking, and fintech. Connect with industry professionals, share insights, and explore collaboration opportunities.', 'networking', '2024-02-25 18:30:00+00', '2024-02-25 21:30:00+00', 'The Oberoi, New Delhi', null, 100, '2024-02-23 17:00:00+00', 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800', false, 1500.00, true),

('YOUR_USER_ID_1', 'Startup Workshop: From Idea to IPO', 'Learn from successful alumni entrepreneurs about building and scaling startups. This intensive workshop covers everything from ideation to fundraising and exit strategies.', 'workshop', '2024-03-02 09:00:00+00', '2024-03-02 17:00:00+00', 'Innovation Hub, Bangalore', null, 50, '2024-02-28 23:59:59+00', 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800', false, 5000.00, true),

('YOUR_USER_ID_2', 'Global Alumni Conference 2024', 'Our flagship annual conference bringing together alumni from around the world. Features panel discussions, keynote speakers, and breakout sessions on various topics.', 'conference', '2024-04-10 08:00:00+00', '2024-04-12 18:00:00+00', 'Convention Centre, Hyderabad', null, 1000, '2024-04-05 23:59:59+00', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800', false, 8000.00, true),

('YOUR_USER_ID_3', 'Women in Leadership Summit', 'A special event celebrating and empowering women alumni in leadership roles. Features inspiring talks, panel discussions, and networking opportunities.', 'webinar', '2024-03-08 10:00:00+00', '2024-03-08 16:00:00+00', null, 'https://zoom.us/j/987654321', 300, '2024-03-06 23:59:59+00', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800', true, 0.00, true),

('YOUR_USER_ID_1', 'Alumni Sports Day', 'Get ready for some friendly competition! Join us for our annual sports day featuring cricket, football, badminton, and more. Open to all alumni and their families.', 'alumni_reunion', '2024-03-30 08:00:00+00', '2024-03-30 18:00:00+00', 'University Sports Complex, Pune', null, 200, '2024-03-25 23:59:59+00', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800', false, 500.00, true),

('YOUR_USER_ID_2', 'Digital Marketing Masterclass', 'Learn the latest digital marketing strategies from industry experts. Perfect for alumni looking to upskill or transition into marketing roles.', 'workshop', '2024-02-28 14:00:00+00', '2024-02-28 18:00:00+00', 'Digital Academy, Chennai', null, 75, '2024-02-26 23:59:59+00', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800', false, 2000.00, true);

-- Insert sample event agenda items
INSERT INTO public.event_agenda (event_id, session_title, session_description, start_time, end_time, speaker_name, speaker_title, session_type)
VALUES
-- Agenda for Annual Alumni Reunion 2024
((SELECT id FROM events WHERE title = 'Annual Alumni Reunion 2024'), 'Welcome & Registration', 'Welcome drinks and registration for all attendees', '2024-03-15 18:00:00+00', '2024-03-15 19:00:00+00', 'Event Team', 'Organizing Committee', 'networking'),
((SELECT id FROM events WHERE title = 'Annual Alumni Reunion 2024'), 'Keynote Address', 'The Future of Education and Alumni Networks', '2024-03-15 19:00:00+00', '2024-03-15 19:45:00+00', 'Dr. Rajesh Kumar', 'Vice Chancellor', 'presentation'),
((SELECT id FROM events WHERE title = 'Annual Alumni Reunion 2024'), 'Alumni Achievement Awards', 'Recognizing outstanding contributions by our alumni', '2024-03-15 19:45:00+00', '2024-03-15 20:30:00+00', 'Awards Committee', 'Selection Panel', 'presentation'),
((SELECT id FROM events WHERE title = 'Annual Alumni Reunion 2024'), 'Networking Dinner', 'Gala dinner with live music and networking opportunities', '2024-03-15 20:30:00+00', '2024-03-15 23:00:00+00', 'Live Band', 'Entertainment', 'networking'),

-- Agenda for Tech Innovation Webinar Series
((SELECT id FROM events WHERE title = 'Tech Innovation Webinar Series'), 'AI and Machine Learning Trends', 'Exploring the latest developments in AI and ML', '2024-02-20 19:00:00+00', '2024-02-20 19:45:00+00', 'Dr. Priya Sharma', 'AI Research Lead at Google', 'presentation'),
((SELECT id FROM events WHERE title = 'Tech Innovation Webinar Series'), 'Q&A Session', 'Interactive Q&A with the speaker', '2024-02-20 19:45:00+00', '2024-02-20 21:00:00+00', 'Dr. Priya Sharma', 'AI Research Lead at Google', 'panel'),

-- Agenda for Startup Workshop
((SELECT id FROM events WHERE title = 'Startup Workshop: From Idea to IPO'), 'Welcome & Introduction', 'Workshop overview and participant introductions', '2024-03-02 09:00:00+00', '2024-03-02 09:30:00+00', 'Workshop Facilitators', 'Startup Mentors', 'presentation'),
((SELECT id FROM events WHERE title = 'Startup Workshop: From Idea to IPO'), 'Ideation & Validation', 'How to identify and validate business ideas', '2024-03-02 09:30:00+00', '2024-03-02 11:00:00+00', 'Rahul Mehta', 'Founder of TechStart Inc.', 'workshop'),
((SELECT id FROM events WHERE title = 'Startup Workshop: From Idea to IPO'), 'Building Your MVP', 'Creating a Minimum Viable Product', '2024-03-02 11:15:00+00', '2024-03-02 12:45:00+00', 'Sneha Patel', 'Product Manager at StartupX', 'workshop'),
((SELECT id FROM events WHERE title = 'Startup Workshop: From Idea to IPO'), 'Lunch Break', 'Networking lunch with fellow participants', '2024-03-02 12:45:00+00', '2024-03-02 13:45:00+00', null, null, 'networking'),
((SELECT id FROM events WHERE title = 'Startup Workshop: From Idea to IPO'), 'Fundraising Strategies', 'How to raise capital for your startup', '2024-03-02 13:45:00+00', '2024-03-02 15:15:00+00', 'Amit Kumar', 'Venture Partner at Growth Capital', 'presentation'),
((SELECT id FROM events WHERE title = 'Startup Workshop: From Idea to IPO'), 'Scaling & Exit Strategies', 'Growing your business and planning exits', '2024-03-02 15:30:00+00', '2024-03-02 17:00:00+00', 'Deepak Singh', 'CEO of ExitReady Corp', 'presentation');

# Database Setup Guide for ConnectU Alumni Platform

## Overview
This guide will help you set up the complete database schema for the ConnectU Alumni Platform, including all tables for jobs, alumni profiles, mentorship, and other features.

## Prerequisites
- Supabase account and project
- Access to Supabase SQL Editor

## Step 1: Run Core Database Schema

First, run the main database schema:

```sql
-- Run this in your Supabase SQL Editor
-- This creates the core tables for users, alumni, students, etc.
```

Copy and paste the contents of `Database/Database_Schema.sql` into your Supabase SQL Editor and execute it.

## Step 2: Create Jobs Tables

Run the jobs table creation script:

```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/create_jobs_table.sql` into your Supabase SQL Editor and execute it.

## Step 3: Create Alumni Profiles Table

Run the alumni profiles table creation script:

```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/create_alumni_profiles_table.sql` into your Supabase SQL Editor and execute it.

## Step 4: Run Profile Features Migration

Run the profile features migration:

```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/migration_profile_features.sql` into your Supabase SQL Editor and execute it.

## Step 5: Create Events Tables

Run the events table creation script:

```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/create_events_table.sql` into your Supabase SQL Editor and execute it.

## Step 6: Create Documents Tables

Run the documents table creation script:

```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/create_documents_table.sql` into your Supabase SQL Editor and execute it.

## Step 7: Create Feedback Tables

Run the feedback table creation script:

```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/create_feedback_table.sql` into your Supabase SQL Editor and execute it.

## Step 8: Insert Sample Data

### Insert Sample Jobs
```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/insert_sample_jobs.sql` into your Supabase SQL Editor and execute it.

**Important**: Before running this script, you need to:
1. Get the actual user ID from your `users` table
2. Replace the `posted_by` values (currently set to `1`) with actual user IDs

To get user IDs:
```sql
SELECT id, name, email FROM users;
```

### Insert Sample Alumni Data
```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/insert_sample_alumni.sql` into your Supabase SQL Editor and execute it.

### Insert Sample Events
```sql
-- Run this in your Supabase SQL Editor
```

Copy and paste the contents of `Database/insert_sample_events.sql` into your Supabase SQL Editor and execute it.

## Step 9: Verify Database Setup

Run these queries to verify your database is set up correctly:

```sql
-- Check if all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check jobs table
SELECT COUNT(*) as job_count FROM jobs;

-- Check alumni profiles
SELECT COUNT(*) as alumni_count FROM alumni_profiles;

-- Check users
SELECT COUNT(*) as user_count FROM users;
```

## Step 7: Configure Row Level Security (RLS)

The scripts should have already set up RLS policies, but you can verify them:

```sql
-- Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
```

## Step 8: Test the Application

1. Run the Flutter app
2. Navigate to the Jobs page
3. Verify that jobs are loading from the database
4. Test job filtering and search functionality
5. Test job application functionality

## Troubleshooting

### Common Issues

1. **Jobs not loading**: Check if the `jobs` table exists and has data
2. **Permission errors**: Verify RLS policies are correctly set up
3. **Foreign key errors**: Ensure user IDs in sample data match actual user IDs
4. **Connection errors**: Check your Supabase connection string in the app

### Debug Queries

```sql
-- Check if jobs table has data
SELECT * FROM jobs LIMIT 5;

-- Check if users table has data
SELECT * FROM users LIMIT 5;

-- Check job applications
SELECT * FROM job_applications LIMIT 5;

-- Check alumni profiles
SELECT * FROM alumni_profiles LIMIT 5;
```

## Database Schema Overview

### Core Tables
- `users` - User accounts and authentication
- `alumnidetails` - Alumni-specific information
- `studentdetails` - Student-specific information
- `alumni_profiles` - Detailed alumni profiles

### Job-Related Tables
- `jobs` - Job postings
- `job_applications` - Job applications

### Other Tables
- `mentorship_sessions` - Mentorship sessions
- `mentorship_bookings` - Mentorship bookings
- `webinars` - Webinar information
- `webinar_registrations` - Webinar registrations
- `chat_messages` - Chat messages
- `achievements` - User achievements
- `notification_preferences` - User notification preferences
- `support_messages` - Support messages
- `bug_reports` - Bug reports

## Next Steps

After setting up the database:

1. Test all functionality in the app
2. Add more sample data as needed
3. Configure additional RLS policies if required
4. Set up database backups
5. Monitor database performance

## Support

If you encounter any issues:
1. Check the Supabase logs
2. Verify your database connection
3. Check the Flutter app logs
4. Ensure all migrations have been run successfully

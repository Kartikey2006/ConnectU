-- Add is_profile_completed column to users table
-- This column tracks whether alumni have completed their profile setup

-- Add the column with default value false
ALTER TABLE users 
ADD COLUMN is_profile_completed BOOLEAN DEFAULT FALSE;

-- Update existing users to have profile completed as false
UPDATE users 
SET is_profile_completed = FALSE 
WHERE is_profile_completed IS NULL;

-- Add an index for better query performance
CREATE INDEX idx_users_profile_completed ON users(is_profile_completed);

-- Add a comment to document the column
COMMENT ON COLUMN users.is_profile_completed IS 'Tracks whether alumni have completed their detailed profile setup';

import { createClient } from '@supabase/supabase-js'

// Hardcoded values to ensure the client always works
const supabaseUrl = 'https://cudwwhohzfxmflquizhk.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMTU3ODIsImV4cCI6MjA3MTg5MTc4Mn0.dqjSaeIwtVvc3-D8Aa9_w5PTK47SbI-M-aXlxu3H_Yw'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Export createClient for server-side usage
export { createClient }

// Database types based on the schema
export interface User {
  id: number
  name: string
  email: string
  password_hash: string
  role: 'student' | 'alumni' | 'admin'
  supabase_auth_id?: string
  created_at: string
}

export interface StudentDetails {
  user_id: number
  current_year: number
  branch: string
  skills: string[]
}

export interface AlumniDetails {
  user_id: number
  batch_year: number
  company?: string
  designation?: string
  linkedin_url?: string
  verification_status: boolean
}

export interface MentorshipSession {
  id: number
  alumni_id: number
  student_id: number
  topic: string
  date_time: string
  duration: number
  price: number
  status: 'pending' | 'accepted' | 'completed' | 'cancelled'
  created_at: string
}

export interface Webinar {
  id: number
  alumni_id: number
  title: string
  description: string
  date_time: string
  price: number
  created_at: string
}

export interface Referral {
  id: number
  student_id: number
  alumni_id: number
  status: 'pending' | 'accepted' | 'rejected'
  created_at: string
}

export interface Notification {
  id: number
  user_id: number
  message: string
  type: 'system' | 'referral_update' | 'webinar_update' | 'mentorship_update'
  is_read: boolean
  created_at: string
}

export interface ChatMessage {
  id: number
  sender_id: number
  receiver_id: number
  message: string
  created_at: string
}

export interface ForumCategory {
  id: number
  name: string
  description: string
  created_at: string
}

export interface ForumPost {
  id: number
  user_id: number
  category_id: number
  title: string
  content: string
  created_at: string
  updated_at: string
  user?: User
  category?: ForumCategory
  comments?: ForumComment[]
}

export interface ForumComment {
  id: number
  post_id: number
  user_id: number
  content: string
  created_at: string
  updated_at: string
  user?: User
}

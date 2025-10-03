// Test user creation script for different roles
// Run this with: node create-test-users.js

const { createClient } = require('@supabase/supabase-js')

const supabaseUrl = 'https://cudwwhohzfxmflquizhk.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMTU3ODIsImV4cCI6MjA3MTg5MTc4Mn0.dqjSaeIwtVvc3-D8Aa9_w5PTK47SbI-M-aXlxu3H_Yw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

const testUsers = [
  {
    email: 'student@test.com',
    password: 'password123',
    role: 'student',
    name: 'Test Student'
  },
  {
    email: 'alumni@test.com', 
    password: 'password123',
    role: 'alumni',
    name: 'Test Alumni'
  },
  {
    email: 'kartikeyupadhyay450@gmail.com',
    password: 'admin123',
    role: 'admin',
    name: 'Admin User'
  }
]

async function createTestUsers() {
  console.log('Creating test users...')
  
  for (const user of testUsers) {
    try {
      console.log(`Creating user: ${user.email}`)
      
      // Create auth user
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: user.email,
        password: user.password,
        options: {
          data: {
            role: user.role,
            name: user.name
          }
        }
      })
      
      if (authError) {
        console.error(`Error creating auth user ${user.email}:`, authError.message)
        continue
      }
      
      console.log(`✅ Created user: ${user.email} (${user.role})`)
      
    } catch (error) {
      console.error(`Error creating user ${user.email}:`, error.message)
    }
  }
  
  console.log('\nTest users created! You can now login with:')
  console.log('Student: student@test.com / password123')
  console.log('Alumni: alumni@test.com / password123') 
  console.log('Admin: kartikeyupadhyay450@gmail.com / admin123')
}

createTestUsers()

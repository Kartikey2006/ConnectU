// Script to create admin user in Supabase
// Run this in your browser console on the Supabase dashboard or use the Supabase client

const { createClient } = require('@supabase/supabase-js')

const supabaseUrl = 'https://cudwwhohzfxmflquizhk.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMTU3ODIsImV4cCI6MjA3MTg5MTc4Mn0.dqjSaeIwtVvc3-D8Aa9_w5PTK47SbI-M-aXlxu3H_Yw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function createAdminUser() {
  try {
    // First, create the user in Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: 'kartikeyupadhyay450@gmail.com',
      password: 'admin123', // You can change this password
      options: {
        data: {
          name: 'Kartikey Upadhyay',
          role: 'admin'
        }
      }
    })

    if (authError) {
      console.error('Auth error:', authError)
      return
    }

    console.log('Auth user created:', authData)

    // Then create the user record in the users table
    const { data: userData, error: userError } = await supabase
      .from('users')
      .insert({
        name: 'Kartikey Upadhyay',
        email: 'kartikeyupadhyay450@gmail.com',
        password_hash: '', // Supabase handles password
        role: 'admin',
        supabase_auth_id: authData.user.id,
      })

    if (userError) {
      console.error('User table error:', userError)
    } else {
      console.log('User record created:', userData)
    }

  } catch (error) {
    console.error('Error:', error)
  }
}

// Uncomment the line below to run the script
// createAdminUser()

console.log('Script loaded. Uncomment the last line to create admin user.')

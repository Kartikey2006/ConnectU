const { createClient } = require('@supabase/supabase-js')
const fs = require('fs')
const path = require('path')

// Supabase client
const supabase = createClient(
  'https://cudwwhohzfxmflquizhk.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMTU3ODIsImV4cCI6MjA3MTg5MTc4Mn0.dqjSaeIwtVvc3-D8Aa9_w5PTK47SbI-M-aXlxu3H_Yw'
)

async function setupForumDatabase() {
  console.log('🚀 Setting up forum database...')

  try {
    // Create forum categories
    console.log('📂 Creating forum categories...')
    const { data: existingCategories, error: checkError } = await supabase
      .from('forum_categories')
      .select('*')
      .limit(1)

    if (checkError && !checkError.message.includes('relation "forum_categories" does not exist')) {
      console.error('Error checking categories:', checkError)
      return
    }

    if (checkError && checkError.message.includes('relation "forum_categories" does not exist')) {
      console.log('⚠️  Forum tables do not exist. You need to run the SQL schema first.')
      console.log('📝 Please run the following SQL in your Supabase SQL editor:')
      
      const sqlContent = fs.readFileSync(
        path.join(__dirname, 'database-setup-forum.sql'), 
        'utf8'
      )
      console.log('\n' + '='.repeat(50))
      console.log(sqlContent)
      console.log('='.repeat(50) + '\n')
      return
    }

    if (!existingCategories || existingCategories.length === 0) {
      const categories = [
        {
          name: 'General Discussion',
          description: 'General topics and discussions'
        },
        {
          name: 'Academic Help',
          description: 'Ask questions about academic topics'
        },
        {
          name: 'Career Advice',
          description: 'Career guidance and job search help'
        },
        {
          name: 'Tech Talk',
          description: 'Technology discussions and trends'
        },
        {
          name: 'Alumni Stories',
          description: 'Share your experiences and success stories'
        }
      ]

      const { error: insertError } = await supabase
        .from('forum_categories')
        .insert(categories)

      if (insertError) {
        console.error('Error inserting categories:', insertError)
        return
      }

      console.log('✅ Forum categories created successfully!')
    } else {
      console.log('✅ Forum categories already exist!')
    }

    // Test forum posts table
    console.log('📋 Testing forum posts table...')
    const { error: postsError } = await supabase
      .from('forum_posts')
      .select('*')
      .limit(1)

    if (postsError) {
      console.error('Error accessing forum posts:', postsError)
      return
    }

    console.log('✅ Forum posts table is accessible!')

    // Test forum comments table
    console.log('💬 Testing forum comments table...')
    const { error: commentsError } = await supabase
      .from('forum_comments')
      .select('*')
      .limit(1)

    if (commentsError) {
      console.error('Error accessing forum comments:', commentsError)
      return
    }

    console.log('✅ Forum comments table is accessible!')

    console.log('\n🎉 Forum database setup completed successfully!')
    console.log('🔗 You can now use the forums at http://localhost:3000/forums')

  } catch (error) {
    console.error('❌ Error setting up forum database:', error)
  }
}

setupForumDatabase()
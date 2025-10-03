'use client'

import React, { useState } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { useForumCategories, useForumPosts } from '@/hooks/useRealtimeData'
import { supabase, ForumCategory, ForumPost } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { MessageSquare, Plus, Users, Clock } from 'lucide-react'

interface NewPostModalProps {
  isOpen: boolean
  onClose: () => void
  onSubmit: (title: string, content: string, categoryId: number) => void
  categories: ForumCategory[]
}

function NewPostModal({ isOpen, onClose, onSubmit, categories }: NewPostModalProps) {
  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')
  const [categoryId, setCategoryId] = useState(categories[0]?.id || 1)

  if (!isOpen) return null

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (title.trim() && content.trim()) {
      onSubmit(title, content, categoryId)
      setTitle('')
      setContent('')
      onClose()
    }
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg p-6 w-full max-w-2xl">
        <h2 className="text-2xl font-bold mb-4 text-gray-900">Create New Post</h2>
        <form onSubmit={handleSubmit}>
          <div className="mb-4">
            <label htmlFor="category" className="block text-sm font-medium mb-2 text-gray-900">
              Category
            </label>
            <select
              id="category"
              value={categoryId}
              onChange={(e) => setCategoryId(Number(e.target.value))}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
            >
              {categories.map((category) => (
                <option key={category.id} value={category.id} className="text-gray-900">
                  {category.name}
                </option>
              ))}
            </select>
          </div>
          <div className="mb-4">
            <label htmlFor="title" className="block text-sm font-medium mb-2 text-gray-900">
              Title
            </label>
            <input
              type="text"
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
              placeholder="Enter post title..."
              required
            />
          </div>
          <div className="mb-6">
            <label htmlFor="content" className="block text-sm font-medium mb-2 text-gray-900">
              Content
            </label>
            <textarea
              id="content"
              value={content}
              onChange={(e) => setContent(e.target.value)}
              rows={6}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
              placeholder="Write your post content..."
              required
            />
          </div>
          <div className="flex gap-3 justify-end">
            <Button type="button" variant="secondary" onClick={onClose} className="text-gray-900">
              Cancel
            </Button>
            <Button type="submit" className="text-white">Create Post</Button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default function ForumsPage() {
  const [selectedCategory, setSelectedCategory] = useState<number | null>(null)
  const [showNewPostModal, setShowNewPostModal] = useState(false)
  const [localPosts, setLocalPosts] = useState<ForumPost[]>([])

  const { data: categories, loading: categoriesLoading, error: catError } = useForumCategories()
  // Get all posts initially, then filter on client side to avoid re-rendering issues
  const { data: allPosts, loading: postsLoading, error: postsError } = useForumPosts()
  
  // Use mock data when database tables don't exist or have errors
  const typedCategories = catError || categories.length === 0 ? [
    { id: 1, name: 'General Discussion', description: 'General conversations and introductions', created_at: new Date().toISOString() },
    { id: 2, name: 'Career Advice', description: 'Share career tips and advice', created_at: new Date().toISOString() },
    { id: 3, name: 'Job Opportunities', description: 'Post and discuss job opportunities', created_at: new Date().toISOString() },
    { id: 4, name: 'Study Help', description: 'Ask questions and get help with studies', created_at: new Date().toISOString() },
    { id: 5, name: 'Alumni Spotlight', description: 'Featured alumni success stories', created_at: new Date().toISOString() }
  ] : categories as ForumCategory[]

  const defaultPosts: ForumPost[] = [
    {
      id: 1,
      user_id: 1,
      category_id: 2,
      title: 'What are the best job search strategies in tech?',
      content: 'I am currently finishing my computer science degree and wondering what strategies work best for landing tech jobs. Any advice from those who successfully made the transition?',
      created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
      updated_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
      user: { id: 1, name: 'Arjun Sharma', email: 'arjun@example.com', role: 'student', password_hash: '', created_at: new Date().toISOString() },
      category: { id: 2, name: 'Career Advice', description: 'Share career tips and advice', created_at: new Date().toISOString() },
      comments: []
    },
    {
      id: 2,
      user_id: 2,
      category_id: 3,
      title: 'Software Engineer Position at TechCorp',
      content: 'We are hiring! Looking for a fresh graduate with strong programming skills and a passion for innovation. Benefits include health insurance, 401k, and remote work options.',
      created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      updated_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      user: { id: 2, name: 'Priya Patel', email: 'priya@example.com', role: 'alumni', password_hash: '', created_at: new Date().toISOString() },
      category: { id: 3, name: 'Job Opportunities', description: 'Post and discuss job opportunities', created_at: new Date().toISOString() },
      comments: []
    },
    {
      id: 3,
      user_id: 3,
      category_id: 1,
      title: 'Welcome to ConnectU Forums!',
      content: 'Welcome to our community! Feel free to introduce yourself and let us know what you\'re studying or working on. Looking forward to seeing great discussions here.',
      created_at: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      updated_at: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      user: { id: 3, name: 'Rajesh Kumar', email: 'rajesh@example.com', role: 'admin', password_hash: '', created_at: new Date().toISOString() },
      category: { id: 1, name: 'General Discussion', description: 'General conversations and introductions', created_at: new Date().toISOString() },
      comments: []
    }
  ]

  const typedAllPosts: ForumPost[] = postsError || allPosts?.length === 0 ? [...defaultPosts, ...localPosts] : (allPosts as ForumPost[] || [])
  
  // Filter posts on the client side for smooth category switching
  const filteredPosts = selectedCategory 
    ? typedAllPosts.filter(post => post.category_id === selectedCategory)
    : typedAllPosts

  const handleCreatePost = async (title: string, content: string, categoryId: number) => {
    try {
      // Get current user
      const { data: { user } } = await supabase.auth.getUser()
      const currentUser = user || { id: 'demo-user', email: 'demo@example.com' }
      
      // Find the category name
      const category = typedCategories.find(cat => cat.id === categoryId)
      const categoryName = category ? category.name : 'General Discussion'

      // Create the new post
      const newPost: ForumPost = {
        id: Date.now(), // Generate unique ID
        user_id: 999, // Mock user ID
        category_id: categoryId,
        title,
        content,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
        user: {
          id: 999,
          name: currentUser.email ? currentUser.email.split('@')[0] : 'Anonymous User',
          email: currentUser.email || 'anonymous@example.com',
          role: 'student',
          password_hash: '',
          created_at: new Date().toISOString()
        },
        category: {
          id: categoryId,
          name: categoryName,
          description: category ? category.description : 'General discussions',
          created_at: new Date().toISOString()
        },
        comments: []
      }

      // Add the post to local state
      setLocalPosts(prevPosts => [newPost, ...prevPosts])
      
      alert('Post created successfully!')

    } catch (err) {
      console.error('Error creating post:', err)
      alert('Failed to create post. Please try again.')
    }
  }

  const formatTimeAgo = (dateString: string) => {
    const date = new Date(dateString)
    const now = new Date()
    const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60))
    
    if (diffInHours < 1) return 'Just now'
    if (diffInHours < 24) return `${diffInHours}h ago`
    return `${Math.floor(diffInHours / 24)}d ago`
  }

  if (categoriesLoading || postsLoading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div className="lg:col-span-1">
              <div className="h-64 bg-gray-200 rounded"></div>
            </div>
            <div className="lg:col-span-3">
              <div className="space-y-4">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="h-24 bg-gray-200 rounded"></div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Community Forums</h1>
            <p className="mt-1 text-sm text-gray-500">Connect with fellow students and alumni</p>
          </div>
          <Button
            onClick={() => setShowNewPostModal(true)}
            className="flex items-center gap-2"
          >
            <Plus size={20} />
            New Post
          </Button>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Categories Sidebar */}
          <div className="lg:col-span-1">
            <Card className="p-6 h-fit">
              <h2 className="text-lg font-semibold mb-4 text-gray-900 border-b pb-3 border-gray-200">Categories</h2>
              <div className="space-y-1">
                <button
                  onClick={() => setSelectedCategory(null)}
                  className={`w-full text-left p-3 rounded-lg transition-all duration-200 ${
                    selectedCategory === null
                      ? 'bg-blue-100 text-blue-700 shadow-sm'
                      : 'hover:bg-gray-50 text-gray-700'
                  }`}
                >
                  <div className="font-medium">All Categories</div>
                  <div className="text-xs text-gray-500 mt-1">Show all discussions</div>
                </button>
                {typedCategories?.map((category) => (
                  <button
                    key={category.id}
                    onClick={() => setSelectedCategory(category.id)}
                    className={`w-full text-left p-3 rounded-lg transition-all duration-200 ${
                      selectedCategory === category.id
                        ? 'bg-blue-100 text-blue-700 shadow-sm'
                        : 'hover:bg-gray-50 text-gray-700'
                    }`}
                  >
                    <div className="font-medium">{category.name}</div>
                    <div className="text-xs text-gray-500 truncate mt-1">
                      {category.description}
                    </div>
                  </button>
                ))}
              </div>
            </Card>
          </div>

          {/* Posts List */}
          <div className="lg:col-span-3">
            <div className="space-y-4">
              {postsLoading ? (
                <div className="space-y-4">
                  {[1, 2, 3, 4, 5].map((i) => (
                    <Card key={i} className="p-6">
                      <div className="animate-pulse">
                        <div className="h-5 bg-gray-200 rounded w-3/4 mb-2"></div>
                        <div className="h-4 bg-gray-200 rounded w-full mb-2"></div>
                        <div className="h-4 bg-gray-200 rounded w-2/3"></div>
                      </div>
                    </Card>
                  ))}
                </div>
              ) : filteredPosts.length === 0 ? (
                <Card className="p-8 text-center">
                  <MessageSquare size={48} className="mx-auto text-gray-400 mb-4" />
                  <h3 className="text-xl font-semibold text-gray-700 mb-2">
                    No posts yet
                  </h3>
                  <p className="text-gray-500 mb-4">
                    Be the first to start a discussion in this category!
                  </p>
                  <Button onClick={() => setShowNewPostModal(true)}>
                    Create First Post
                  </Button>
                </Card>
              ) : (
                filteredPosts.map((post) => (
                  <Card key={post.id} className="p-6 hover:shadow-lg transition-shadow cursor-pointer border border-gray-200">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-3">
                          <span className="text-sm font-medium text-blue-600 bg-blue-50 px-2 py-1 rounded-full">
                            {post.category?.name}
                          </span>
                          <span className="text-gray-400">•</span>
                          <span className="text-sm text-gray-500">
                            by {post.user?.name || 'Anonymous'}
                          </span>
                          <span className="text-gray-400">•</span>
                          <span className="text-sm text-gray-500 flex items-center gap-1">
                            <Clock size={12} />
                            {formatTimeAgo(post.created_at)}
                          </span>
                        </div>
                        <h3 className="text-lg font-semibold text-gray-900 mb-2">
                          {post.title}
                        </h3>
                        <p className="text-gray-600 line-clamp-2 mb-3">
                          {post.content}
                        </p>
                        <div className="flex items-center gap-4 text-sm text-gray-500">
                          <div className="flex items-center gap-1">
                            <MessageSquare size={16} />
                            <span>{post.comments?.length || 0} comments</span>
                          </div>
                          <div className="flex items-center gap-1">
                            <Users size={16} />
                            <span>Discussion</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </Card>
                ))
              )}
            </div>
          </div>
        </div>

        {/* New Post Modal */}
        <NewPostModal
          isOpen={showNewPostModal}
          onClose={() => setShowNewPostModal(false)}
          onSubmit={handleCreatePost}
          categories={typedCategories || []}
        />
      </div>
    </DashboardLayout>
  )
}
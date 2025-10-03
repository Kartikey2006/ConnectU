'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Calendar, Clock, DollarSign, User, Video, Users } from 'lucide-react'
import toast from 'react-hot-toast'

interface Webinar {
  id: number
  alumni_id: number
  title: string
  description: string
  date_time: string
  price: number
  created_at: string
  alumni?: {
    name: string
    email: string
  }
}

export default function WebinarsPage() {
  const [webinars, setWebinars] = useState<Webinar[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('upcoming')
  const [userRole, setUserRole] = useState<string>('')

  useEffect(() => {
    fetchWebinars()
    getUserRole()
  }, [])

  const getUserRole = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        setUserRole(user.user_metadata?.role || 'student')
      }
    } catch (error) {
      console.error('Error getting user role:', error)
    }
  }

  const fetchWebinars = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockWebinars: Webinar[] = [
        {
          id: 1,
          alumni_id: 1,
          title: 'Career in Tech: From College to Industry',
          description: 'Learn about transitioning from college to a career in technology. We\'ll cover resume building, interview preparation, and industry insights.',
          date_time: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(), // 7 days from now
          price: 25,
          created_at: new Date().toISOString(),
          alumni: { name: 'Arjun Sharma', email: 'arjun@example.com' }
        },
        {
          id: 2,
          alumni_id: 2,
          title: 'Data Science Fundamentals',
          description: 'Introduction to data science concepts, tools, and career paths. Perfect for beginners looking to enter the field.',
          date_time: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString(), // 14 days from now
          price: 30,
          created_at: new Date().toISOString(),
          alumni: { name: 'Priya Patel', email: 'priya@example.com' }
        },
        {
          id: 3,
          alumni_id: 3,
          title: 'Product Management Workshop',
          description: 'Deep dive into product management roles, responsibilities, and how to break into PM careers.',
          date_time: new Date(Date.now() + 21 * 24 * 60 * 60 * 1000).toISOString(), // 21 days from now
          price: 40,
          created_at: new Date().toISOString(),
          alumni: { name: 'Rajesh Kumar', email: 'rajesh@example.com' }
        }
      ]

      setWebinars(mockWebinars)
      
      /* Uncomment when database tables are ready:
      const { data, error } = await supabase
        .from('webinars')
        .select(`
          *,
          alumni:alumni_id (name, email)
        `)
        .order('date_time', { ascending: true })

      if (error) {
        toast.error('Failed to fetch webinars')
        return
      }

      setWebinars(data || [])
      */
    } catch (error) {
      console.error('Error fetching webinars:', error)
      toast.error('An error occurred')
      // Set empty array on error
      setWebinars([])
    } finally {
      setLoading(false)
    }
  }

  const handleJoinWebinar = async (webinarId: number) => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      // Check if already registered
      const { data: existing } = await supabase
        .from('webinar_registrations')
        .select('*')
        .eq('webinar_id', webinarId)
        .eq('student_id', user.id)
        .single()

      if (existing) {
        toast.success('You are already registered for this webinar!')
        return
      }

      // Register for webinar
      const { error } = await supabase
        .from('webinar_registrations')
        .insert({
          webinar_id: webinarId,
          student_id: user.id,
          payment_status: 'free' // Assuming free for now
        })

      if (error) {
        toast.error('Failed to register for webinar')
        return
      }

      toast.success('Successfully registered for webinar!')
    } catch (error) {
      toast.error('An error occurred')
    }
  }

  const handleCreateWebinar = async (formData: any) => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { error } = await supabase
        .from('webinars')
        .insert({
          alumni_id: user.id,
          title: formData.title,
          description: formData.description,
          date_time: formData.date_time,
          price: parseFloat(formData.price)
        })

      if (error) {
        toast.error('Failed to create webinar')
        return
      }

      toast.success('Webinar created successfully!')
      fetchWebinars()
    } catch (error) {
      toast.error('An error occurred')
    }
  }

  const upcomingWebinars = webinars.filter(w => new Date(w.date_time) > new Date())
  const pastWebinars = webinars.filter(w => new Date(w.date_time) <= new Date())

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="space-y-4">
            {[...Array(3)].map((_, i) => (
              <div key={i} className="bg-white p-6 rounded-lg shadow">
                <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
                <div className="h-4 bg-gray-200 rounded w-1/4"></div>
              </div>
            ))}
          </div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Webinars</h1>
            <p className="mt-1 text-sm text-gray-500">
              Join educational webinars by industry experts and alumni.
            </p>
          </div>
          {userRole === 'alumni' && (
            <button
              onClick={() => setActiveTab('create')}
              className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
            >
              Create Webinar
            </button>
          )}
        </div>

        {/* Tabs */}
        <div className="border-b border-gray-200">
          <nav className="-mb-px flex space-x-8">
            <button
              onClick={() => setActiveTab('upcoming')}
              className={`${
                activeTab === 'upcoming'
                  ? 'border-primary-500 text-primary-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              } whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm`}
            >
              Upcoming ({upcomingWebinars.length})
            </button>
            <button
              onClick={() => setActiveTab('past')}
              className={`${
                activeTab === 'past'
                  ? 'border-primary-500 text-primary-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              } whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm`}
            >
              Past ({pastWebinars.length})
            </button>
            {userRole === 'alumni' && (
              <button
                onClick={() => setActiveTab('my-webinars')}
                className={`${
                  activeTab === 'my-webinars'
                    ? 'border-primary-500 text-primary-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                } whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm`}
              >
                My Webinars
              </button>
            )}
          </nav>
        </div>

        {/* Create Webinar Form */}
        {activeTab === 'create' && userRole === 'alumni' && (
          <div className="bg-white rounded-lg shadow-md p-6">
            <h2 className="text-lg font-medium text-gray-900 mb-4">Create New Webinar</h2>
            <form onSubmit={(e) => {
              e.preventDefault()
              const formData = new FormData(e.currentTarget)
              handleCreateWebinar(Object.fromEntries(formData))
            }}>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Title
                  </label>
                  <input
                    type="text"
                    name="title"
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                    placeholder="Webinar title"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Price ($)
                  </label>
                  <input
                    type="number"
                    name="price"
                    required
                    min="0"
                    step="0.01"
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                    placeholder="0.00"
                  />
                </div>
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Description
                  </label>
                  <textarea
                    name="description"
                    required
                    rows={3}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                    placeholder="Describe what students will learn"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Date & Time
                  </label>
                  <input
                    type="datetime-local"
                    name="date_time"
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>
              </div>
              <div className="mt-4 flex space-x-2">
                <button
                  type="submit"
                  className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
                >
                  Create Webinar
                </button>
                <button
                  type="button"
                  onClick={() => setActiveTab('upcoming')}
                  className="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 transition-colors"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Webinar List */}
        {(activeTab === 'upcoming' || activeTab === 'past' || activeTab === 'my-webinars') && (
          <div className="space-y-4">
            {(() => {
              let displayWebinars = webinars
              if (activeTab === 'upcoming') displayWebinars = upcomingWebinars
              if (activeTab === 'past') displayWebinars = pastWebinars
              if (activeTab === 'my-webinars') {
                displayWebinars = webinars.filter(w => w.alumni_id === Number(userRole))
              }

              if (displayWebinars.length === 0) {
                return (
                  <div className="text-center py-12">
                    <Video className="mx-auto h-12 w-12 text-gray-400" />
                    <h3 className="mt-2 text-sm font-medium text-gray-900">No webinars</h3>
                    <p className="mt-1 text-sm text-gray-500">
                      {activeTab === 'upcoming' ? 'No upcoming webinars scheduled.' :
                       activeTab === 'past' ? 'No past webinars found.' :
                       'You haven\'t created any webinars yet.'}
                    </p>
                  </div>
                )
              }

              return displayWebinars.map((webinar) => (
                <div key={webinar.id} className="bg-white rounded-lg shadow-md p-6">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center">
                        <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                          <User className="h-5 w-5 text-primary-600" />
                        </div>
                        <div className="ml-4">
                          <h3 className="text-lg font-medium text-gray-900">{webinar.title}</h3>
                          <p className="text-sm text-gray-500">by {webinar.alumni?.name}</p>
                        </div>
                      </div>
                      
                      <p className="mt-2 text-sm text-gray-600">{webinar.description}</p>
                      
                      <div className="mt-4 flex items-center space-x-4 text-sm text-gray-500">
                        <div className="flex items-center">
                          <Calendar className="h-4 w-4 mr-1" />
                          {new Date(webinar.date_time).toLocaleDateString()}
                        </div>
                        <div className="flex items-center">
                          <Clock className="h-4 w-4 mr-1" />
                          {new Date(webinar.date_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                        </div>
                        <div className="flex items-center">
                          <DollarSign className="h-4 w-4 mr-1" />
                          ${webinar.price}
                        </div>
                      </div>
                    </div>
                    
                    <div className="ml-4 flex flex-col items-end space-y-2">
                      <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                        new Date(webinar.date_time) > new Date() ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                      }`}>
                        {new Date(webinar.date_time) > new Date() ? 'Upcoming' : 'Past'}
                      </span>
                      
                      {userRole === 'student' && new Date(webinar.date_time) > new Date() && (
                        <button
                          onClick={() => handleJoinWebinar(webinar.id)}
                          className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
                        >
                          Join Webinar
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              ))
            })()}
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}

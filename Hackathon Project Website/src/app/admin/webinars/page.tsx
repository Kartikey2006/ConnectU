'use client'

import { useState, useEffect } from 'react'
import AdminLayout from '@/components/layout/AdminLayout'
import { BookOpen, Video, Users, DollarSign, Calendar, Search, Plus } from 'lucide-react'

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

export default function AdminWebinarsPage() {
  const [webinars, setWebinars] = useState<Webinar[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    // Set mock data immediately for faster loading
    const mockWebinars: Webinar[] = [
      {
        id: 1,
        alumni_id: 1,
        title: 'Career in Tech: From College to Industry',
        description: 'Learn about transitioning from college to a career in technology. We\'ll cover resume building, interview preparation, and industry insights.',
        date_time: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
        price: 25,
        created_at: new Date().toISOString(),
        alumni: { name: 'Arjun Sharma', email: 'arjun@example.com' }
      },
      {
        id: 2,
        alumni_id: 2,
        title: 'Data Science Fundamentals',
        description: 'Introduction to data science concepts, tools, and career paths. Perfect for beginners looking to enter the field.',
        date_time: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString(),
        price: 30,
        created_at: new Date().toISOString(),
        alumni: { name: 'Priya Patel', email: 'priya@example.com' }
      },
      {
        id: 3,
        alumni_id: 3,
        title: 'Product Management Workshop',
        description: 'Deep dive into product management roles, responsibilities, and how to break into PM careers.',
        date_time: new Date(Date.now() + 21 * 24 * 60 * 60 * 1000).toISOString(),
        price: 40,
        created_at: new Date().toISOString(),
        alumni: { name: 'Rajesh Kumar', email: 'rajesh@example.com' }
      }
    ]
    
    setWebinars(mockWebinars)
    setLoading(false)
  }, [])

  const filteredWebinars = webinars.filter(webinar => 
    !searchTerm || 
    webinar.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
    webinar.alumni?.name.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const upcomingWebinars = filteredWebinars.filter(w => new Date(w.date_time) > new Date())
  const pastWebinars = filteredWebinars.filter(w => new Date(w.date_time) <= new Date())

  if (loading) {
    return (
      <AdminLayout>
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
      </AdminLayout>
    )
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Webinar Management</h1>
            <p className="mt-1 text-sm text-gray-500">
              Monitor and manage all webinars across the platform.
            </p>
          </div>
          <button className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
            <Plus className="h-4 w-4 mr-2" />
            Create Webinar
          </button>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <BookOpen className="h-8 w-8 text-blue-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">{webinars.length}</div>
                <div className="text-sm text-gray-500">Total Webinars</div>
              </div>
            </div>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <Calendar className="h-8 w-8 text-green-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">{upcomingWebinars.length}</div>
                <div className="text-sm text-gray-500">Upcoming</div>
              </div>
            </div>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <Video className="h-8 w-8 text-purple-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">{pastWebinars.length}</div>
                <div className="text-sm text-gray-500">Completed</div>
              </div>
            </div>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <DollarSign className="h-8 w-8 text-yellow-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">
                  ${webinars.reduce((sum, w) => sum + w.price, 0)}
                </div>
                <div className="text-sm text-gray-500">Total Revenue</div>
              </div>
            </div>
          </div>
        </div>

        {/* Search */}
        <div className="bg-white p-4 rounded-lg shadow">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search webinars..."
              className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 text-gray-900 focus:outline-none focus:ring-2 focus:ring-red-500"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        {/* Upcoming Webinars */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
              Upcoming Webinars ({upcomingWebinars.length})
            </h3>
            <div className="space-y-4">
              {upcomingWebinars.map((webinar) => (
                <div key={webinar.id} className="border border-gray-200 rounded-lg p-4 hover:bg-gray-50">
                  <div className="flex justify-between items-start">
                    <div className="flex-1">
                      <h4 className="text-lg font-medium text-gray-900">{webinar.title}</h4>
                      <p className="text-sm text-gray-600 mt-1 line-clamp-2">{webinar.description}</p>
                      <div className="flex items-center mt-2 space-x-4 text-sm text-gray-500">
                        <div className="flex items-center">
                          <Calendar className="h-4 w-4 mr-1" />
                          {new Date(webinar.date_time).toLocaleDateString()}
                        </div>
                        <div className="flex items-center">
                          <DollarSign className="h-4 w-4 mr-1" />
                          ${webinar.price}
                        </div>
                        <div className="flex items-center">
                          <Users className="h-4 w-4 mr-1" />
                          {webinar.alumni?.name}
                        </div>
                      </div>
                    </div>
                    <div className="flex space-x-2 ml-4">
                      <button className="px-3 py-1 text-sm bg-blue-100 text-blue-800 rounded-md hover:bg-blue-200">
                        Edit
                      </button>
                      <button className="px-3 py-1 text-sm bg-red-100 text-red-800 rounded-md hover:bg-red-200">
                        Delete
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Past Webinars */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
              Past Webinars ({pastWebinars.length})
            </h3>
            <div className="space-y-4">
              {pastWebinars.map((webinar) => (
                <div key={webinar.id} className="border border-gray-200 rounded-lg p-4 bg-gray-50">
                  <div className="flex justify-between items-start">
                    <div className="flex-1">
                      <h4 className="text-lg font-medium text-gray-900">{webinar.title}</h4>
                      <p className="text-sm text-gray-600 mt-1 line-clamp-2">{webinar.description}</p>
                      <div className="flex items-center mt-2 space-x-4 text-sm text-gray-500">
                        <div className="flex items-center">
                          <Calendar className="h-4 w-4 mr-1" />
                          {new Date(webinar.date_time).toLocaleDateString()}
                        </div>
                        <div className="flex items-center">
                          <DollarSign className="h-4 w-4 mr-1" />
                          ${webinar.price}
                        </div>
                        <div className="flex items-center">
                          <Users className="h-4 w-4 mr-1" />
                          {webinar.alumni?.name}
                        </div>
                      </div>
                    </div>
                    <div className="flex space-x-2 ml-4">
                      <button className="px-3 py-1 text-sm bg-gray-100 text-gray-800 rounded-md">
                        View Details
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  )
}

'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  BookOpen, 
  Calendar, 
  Clock, 
  Users, 
  Plus,
  Edit,
  Trash2,
  Eye,
  Play,
  DollarSign,
  Star
} from 'lucide-react'

interface Webinar {
  id: number
  title: string
  description: string
  date: string
  time: string
  duration: number
  price: number
  maxParticipants: number
  currentParticipants: number
  status: 'upcoming' | 'live' | 'completed' | 'cancelled'
  category: string
  createdAt: string
}

export default function AlumniWebinarsPage() {
  const [webinars, setWebinars] = useState<Webinar[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState<'upcoming' | 'completed'>('upcoming')

  useEffect(() => {
    // Mock data for now
    setWebinars([
      {
        id: 1,
        title: 'Introduction to Machine Learning',
        description: 'Learn the fundamentals of machine learning, including supervised and unsupervised learning algorithms.',
        date: '2024-01-25',
        time: '6:00 PM',
        duration: 90,
        price: 299,
        maxParticipants: 50,
        currentParticipants: 32,
        status: 'upcoming',
        category: 'Technology',
        createdAt: '2024-01-10'
      },
      {
        id: 2,
        title: 'Career Transition to Product Management',
        description: 'A comprehensive guide on transitioning from technical roles to product management.',
        date: '2024-01-22',
        time: '7:00 PM',
        duration: 60,
        price: 199,
        maxParticipants: 30,
        currentParticipants: 28,
        status: 'upcoming',
        category: 'Career Development',
        createdAt: '2024-01-08'
      },
      {
        id: 3,
        title: 'Data Science Interview Preparation',
        description: 'Master data science interviews with practical examples and coding challenges.',
        date: '2024-01-18',
        time: '5:00 PM',
        duration: 120,
        price: 399,
        maxParticipants: 40,
        currentParticipants: 40,
        status: 'completed',
        category: 'Interview Prep',
        createdAt: '2024-01-05'
      },
      {
        id: 4,
        title: 'Building Scalable Web Applications',
        description: 'Learn how to design and build web applications that can handle millions of users.',
        date: '2024-01-15',
        time: '6:30 PM',
        duration: 90,
        price: 249,
        maxParticipants: 35,
        currentParticipants: 35,
        status: 'completed',
        category: 'Web Development',
        createdAt: '2024-01-03'
      }
    ])
    setLoading(false)
  }, [])

  const handleCreateWebinar = () => {
    // In a real app, this would open a create webinar modal
    console.log('Create new webinar')
  }

  const handleEditWebinar = (webinarId: number) => {
    console.log('Edit webinar:', webinarId)
  }

  const handleDeleteWebinar = (webinarId: number) => {
    setWebinars(prev => prev.filter(w => w.id !== webinarId))
  }

  const handleStartWebinar = (webinarId: number) => {
    console.log('Start webinar:', webinarId)
  }

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'upcoming':
        return <Badge variant="info" size="sm">Upcoming</Badge>
      case 'live':
        return <Badge variant="success" size="sm">Live</Badge>
      case 'completed':
        return <Badge variant="info" size="sm">Completed</Badge>
      case 'cancelled':
        return <Badge variant="danger" size="sm">Cancelled</Badge>
      default:
        return <Badge variant="info" size="sm">{status}</Badge>
    }
  }

  const upcomingWebinars = webinars.filter(w => w.status === 'upcoming')
  const completedWebinars = webinars.filter(w => w.status === 'completed')

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="space-y-4">
            {[...Array(3)].map((_, i) => (
              <div key={i} className="bg-white p-6 rounded-lg shadow">
                <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
                <div className="h-4 bg-gray-200 rounded w-3/4"></div>
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
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">My Webinars</h1>
            <p className="mt-1 text-sm text-gray-500">
              Create and manage your educational webinars for students.
            </p>
          </div>
          <Button onClick={handleCreateWebinar} className="flex items-center">
            <Plus className="w-4 h-4 mr-2" />
            Create Webinar
          </Button>
        </div>

        {/* Tab Navigation */}
        <div className="border-b border-gray-200">
          <nav className="-mb-px flex space-x-8">
            <button
              onClick={() => setActiveTab('upcoming')}
              className={`py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'upcoming'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Upcoming ({upcomingWebinars.length})
            </button>
            <button
              onClick={() => setActiveTab('completed')}
              className={`py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'completed'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Completed ({completedWebinars.length})
            </button>
          </nav>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-4">
            {(activeTab === 'upcoming' ? upcomingWebinars : completedWebinars).map((webinar) => (
              <Card key={webinar.id}>
                <CardHeader>
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <h3 className="text-lg font-semibold text-gray-900 mb-2">
                        {webinar.title}
                      </h3>
                      <p className="text-sm text-gray-600 mb-3">{webinar.description}</p>
                      <div className="flex items-center space-x-4 text-sm text-gray-500">
                        <div className="flex items-center">
                          <Calendar className="w-4 h-4 mr-1" />
                          {new Date(webinar.date).toLocaleDateString()}
                        </div>
                        <div className="flex items-center">
                          <Clock className="w-4 h-4 mr-1" />
                          {webinar.time} ({webinar.duration} min)
                        </div>
                        <div className="flex items-center">
                          <Users className="w-4 h-4 mr-1" />
                          {webinar.currentParticipants}/{webinar.maxParticipants}
                        </div>
                        <div className="flex items-center">
                          <DollarSign className="w-4 h-4 mr-1" />
                          ₹{webinar.price}
                        </div>
                      </div>
                    </div>
                    <div className="flex flex-col items-end space-y-2">
                      {getStatusBadge(webinar.status)}
                      <Badge variant="info" size="sm">{webinar.category}</Badge>
                    </div>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="flex items-center justify-between">
                    <div className="flex space-x-3">
                      {webinar.status === 'upcoming' && (
                        <>
                          <Button 
                            size="sm" 
                            onClick={() => handleStartWebinar(webinar.id)}
                            className="flex items-center"
                          >
                            <Play className="w-4 h-4 mr-1" />
                            Start Webinar
                          </Button>
                          <Button 
                            size="sm" 
                            variant="outline"
                            onClick={() => handleEditWebinar(webinar.id)}
                            className="flex items-center"
                          >
                            <Edit className="w-4 h-4 mr-1" />
                            Edit
                          </Button>
                        </>
                      )}
                      {webinar.status === 'completed' && (
                        <Button 
                          size="sm" 
                          variant="outline"
                          className="flex items-center"
                        >
                          <Eye className="w-4 h-4 mr-1" />
                          View Recording
                        </Button>
                      )}
                      <Button 
                        size="sm" 
                        variant="outline"
                        onClick={() => handleDeleteWebinar(webinar.id)}
                        className="flex items-center text-red-600 hover:text-red-700"
                      >
                        <Trash2 className="w-4 h-4 mr-1" />
                        Delete
                      </Button>
                    </div>
                    <div className="text-right">
                      <p className="text-sm text-gray-600">
                        Created: {new Date(webinar.createdAt).toLocaleDateString()}
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          <div className="space-y-6">
            <Card>
              <CardHeader>
                <h3 className="text-lg font-semibold text-gray-900">Webinar Stats</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Total Webinars</span>
                    <span className="font-semibold">{webinars.length}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Upcoming</span>
                    <span className="font-semibold text-blue-600">
                      {upcomingWebinars.length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Completed</span>
                    <span className="font-semibold text-green-600">
                      {completedWebinars.length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Total Participants</span>
                    <span className="font-semibold text-purple-600">
                      {webinars.reduce((acc, w) => acc + w.currentParticipants, 0)}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Total Revenue</span>
                    <span className="font-semibold text-green-600">
                      ₹{webinars.reduce((acc, w) => acc + (w.price * w.currentParticipants), 0)}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Average Rating</span>
                    <span className="font-semibold text-yellow-600">4.7/5</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <h3 className="text-lg font-semibold text-gray-900">Webinar Tips</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-3 text-sm text-gray-600">
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Prepare interactive content and Q&A sessions</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Test your equipment and internet connection</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Share resources and follow-up materials</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Record sessions for students who miss them</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

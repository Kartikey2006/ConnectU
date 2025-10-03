'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  MessageSquare, 
  Calendar, 
  Clock, 
  CheckCircle, 
  Play,
  Users,
  Star,
  Video,
  Phone,
  MapPin
} from 'lucide-react'

interface MentorshipSession {
  id: number
  studentName: string
  studentEmail: string
  topic: string
  date: string
  time: string
  duration: number
  status: 'upcoming' | 'completed' | 'cancelled'
  meetingLink?: string
  notes?: string
  rating?: number
  avatar: string
}

export default function MentorshipSessionsPage() {
  const [sessions, setSessions] = useState<MentorshipSession[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState<'upcoming' | 'completed'>('upcoming')

  useEffect(() => {
    // Mock data for now
    setSessions([
      {
        id: 1,
        studentName: 'Priya Sharma',
        studentEmail: 'priya@example.com',
        topic: 'Career Guidance in Software Engineering',
        date: '2024-01-20',
        time: '2:00 PM',
        duration: 60,
        status: 'upcoming',
        meetingLink: 'https://meet.google.com/abc-defg-hij',
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 2,
        studentName: 'Rahul Kumar',
        studentEmail: 'rahul@example.com',
        topic: 'Product Management Career Path',
        date: '2024-01-18',
        time: '10:00 AM',
        duration: 45,
        status: 'upcoming',
        meetingLink: 'https://meet.google.com/xyz-1234-567',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 3,
        studentName: 'Sneha Patel',
        studentEmail: 'sneha@example.com',
        topic: 'Data Science and Machine Learning',
        date: '2024-01-15',
        time: '4:00 PM',
        duration: 60,
        status: 'completed',
        notes: 'Great session! Discussed ML fundamentals and career opportunities. Student showed strong interest in deep learning.',
        rating: 5,
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 4,
        studentName: 'Amit Singh',
        studentEmail: 'amit@example.com',
        topic: 'Interview Preparation for Tech Companies',
        date: '2024-01-12',
        time: '3:00 PM',
        duration: 90,
        status: 'completed',
        notes: 'Focused on system design and coding interview strategies. Provided practice problems and resources.',
        rating: 4,
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      }
    ])
    setLoading(false)
  }, [])

  const handleStartSession = (sessionId: number) => {
    // In a real app, this would open the meeting link
    console.log('Starting session:', sessionId)
  }

  const handleCompleteSession = (sessionId: number) => {
    setSessions(prev => prev.map(session => 
      session.id === sessionId ? { ...session, status: 'completed' as const } : session
    ))
  }

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'upcoming':
        return <Badge variant="info" size="sm">Upcoming</Badge>
      case 'completed':
        return <Badge variant="success" size="sm">Completed</Badge>
      case 'cancelled':
        return <Badge variant="danger" size="sm">Cancelled</Badge>
      default:
        return <Badge variant="info" size="sm">{status}</Badge>
    }
  }

  const upcomingSessions = sessions.filter(s => s.status === 'upcoming')
  const completedSessions = sessions.filter(s => s.status === 'completed')

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
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Mentorship Sessions</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage your mentorship sessions with students.
          </p>
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
              Upcoming ({upcomingSessions.length})
            </button>
            <button
              onClick={() => setActiveTab('completed')}
              className={`py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'completed'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Completed ({completedSessions.length})
            </button>
          </nav>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-4">
            {(activeTab === 'upcoming' ? upcomingSessions : completedSessions).map((session) => (
              <Card key={session.id}>
                <CardHeader>
                  <div className="flex items-start justify-between">
                    <div className="flex items-center space-x-4">
                      <img 
                        src={session.avatar} 
                        alt={session.studentName}
                        className="w-12 h-12 rounded-full object-cover"
                      />
                      <div>
                        <h3 className="text-lg font-semibold text-gray-900">
                          {session.studentName}
                        </h3>
                        <p className="text-sm text-gray-600">{session.studentEmail}</p>
                        <div className="flex items-center space-x-2 mt-1">
                          <Badge variant="info" size="sm">
                            <Clock className="w-3 h-3 mr-1" />
                            {session.duration} min
                          </Badge>
                        </div>
                      </div>
                    </div>
                    {getStatusBadge(session.status)}
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-medium text-gray-900 mb-2">{session.topic}</h4>
                      <div className="flex items-center space-x-4 text-sm text-gray-500">
                        <div className="flex items-center">
                          <Calendar className="w-4 h-4 mr-1" />
                          {new Date(session.date).toLocaleDateString()}
                        </div>
                        <div className="flex items-center">
                          <Clock className="w-4 h-4 mr-1" />
                          {session.time}
                        </div>
                      </div>
                    </div>

                    {session.status === 'upcoming' && (
                      <div className="pt-4 border-t">
                        <div className="flex space-x-3">
                          <Button 
                            size="sm" 
                            onClick={() => handleStartSession(session.id)}
                            className="flex items-center"
                          >
                            <Play className="w-4 h-4 mr-1" />
                            Join Session
                          </Button>
                          <Button 
                            size="sm" 
                            variant="outline"
                            className="flex items-center"
                          >
                            <Video className="w-4 h-4 mr-1" />
                            Test Audio/Video
                          </Button>
                          <Button 
                            size="sm" 
                            variant="outline"
                            onClick={() => handleCompleteSession(session.id)}
                            className="flex items-center"
                          >
                            <CheckCircle className="w-4 h-4 mr-1" />
                            Mark Complete
                          </Button>
                        </div>
                        {session.meetingLink && (
                          <div className="mt-3 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                            <p className="text-sm text-blue-800">
                              <strong>Meeting Link:</strong>{' '}
                              <a 
                                href={session.meetingLink} 
                                target="_blank" 
                                rel="noopener noreferrer"
                                className="underline hover:no-underline"
                              >
                                {session.meetingLink}
                              </a>
                            </p>
                          </div>
                        )}
                      </div>
                    )}

                    {session.status === 'completed' && (
                      <div className="pt-4 border-t">
                        {session.notes && (
                          <div className="mb-3">
                            <h5 className="font-medium text-gray-900 mb-1">Session Notes:</h5>
                            <p className="text-sm text-gray-600">{session.notes}</p>
                          </div>
                        )}
                        {session.rating && (
                          <div className="flex items-center space-x-1">
                            <span className="text-sm text-gray-600">Student Rating:</span>
                            {[...Array(5)].map((_, i) => (
                              <Star 
                                key={i} 
                                className={`w-4 h-4 ${
                                  i < session.rating! ? 'text-yellow-400 fill-current' : 'text-gray-300'
                                }`} 
                              />
                            ))}
                            <span className="text-sm text-gray-600 ml-1">({session.rating}/5)</span>
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          <div className="space-y-6">
            <Card>
              <CardHeader>
                <h3 className="text-lg font-semibold text-gray-900">Session Stats</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Total Sessions</span>
                    <span className="font-semibold">{sessions.length}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Upcoming</span>
                    <span className="font-semibold text-blue-600">
                      {upcomingSessions.length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Completed</span>
                    <span className="font-semibold text-green-600">
                      {completedSessions.length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Average Rating</span>
                    <span className="font-semibold text-yellow-600">4.5/5</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Total Hours</span>
                    <span className="font-semibold text-purple-600">
                      {sessions.reduce((acc, s) => acc + s.duration, 0) / 60}h
                    </span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <h3 className="text-lg font-semibold text-gray-900">Session Tips</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-3 text-sm text-gray-600">
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Test your audio/video before the session</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Prepare an agenda and share it beforehand</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Take notes during the session</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Follow up with resources and next steps</span>
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

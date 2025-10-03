'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  UserPlus, 
  MessageSquare, 
  Calendar, 
  Clock, 
  CheckCircle, 
  XCircle,
  Star,
  MapPin,
  Building2
} from 'lucide-react'

interface StudentRequest {
  id: number
  studentName: string
  studentEmail: string
  studentYear: string
  studentBranch: string
  topic: string
  message: string
  preferredTime: string
  status: 'pending' | 'accepted' | 'rejected'
  createdAt: string
  avatar: string
}

export default function StudentRequestsPage() {
  const [requests, setRequests] = useState<StudentRequest[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Mock data for now
    setRequests([
      {
        id: 1,
        studentName: 'Priya Sharma',
        studentEmail: 'priya@example.com',
        studentYear: '3rd Year',
        studentBranch: 'Computer Science',
        topic: 'Career Guidance in Software Engineering',
        message: 'I would love to get guidance on how to prepare for software engineering roles and what skills I should focus on.',
        preferredTime: 'Weekends, 2-4 PM',
        status: 'pending',
        createdAt: '2024-01-15',
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 2,
        studentName: 'Rahul Kumar',
        studentEmail: 'rahul@example.com',
        studentYear: '2nd Year',
        studentBranch: 'Information Technology',
        topic: 'Product Management Career Path',
        message: 'I am interested in learning about product management roles and how to transition from technical to PM roles.',
        preferredTime: 'Evenings, 6-8 PM',
        status: 'pending',
        createdAt: '2024-01-14',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 3,
        studentName: 'Sneha Patel',
        studentEmail: 'sneha@example.com',
        studentYear: '4th Year',
        studentBranch: 'Electronics & Communication',
        topic: 'Data Science and Machine Learning',
        message: 'I want to understand the data science field and how to build a career in ML/AI.',
        preferredTime: 'Weekdays, 4-6 PM',
        status: 'accepted',
        createdAt: '2024-01-13',
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      }
    ])
    setLoading(false)
  }, [])

  const handleAccept = (requestId: number) => {
    setRequests(prev => prev.map(req => 
      req.id === requestId ? { ...req, status: 'accepted' as const } : req
    ))
  }

  const handleReject = (requestId: number) => {
    setRequests(prev => prev.map(req => 
      req.id === requestId ? { ...req, status: 'rejected' as const } : req
    ))
  }

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'pending':
        return <Badge variant="warning" size="sm">Pending</Badge>
      case 'accepted':
        return <Badge variant="success" size="sm">Accepted</Badge>
      case 'rejected':
        return <Badge variant="danger" size="sm">Rejected</Badge>
      default:
        return <Badge variant="info" size="sm">{status}</Badge>
    }
  }

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
          <h1 className="text-2xl font-bold text-gray-900">Student Requests</h1>
          <p className="mt-1 text-sm text-gray-500">
            Review and respond to mentorship requests from students.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-4">
            {requests.map((request) => (
              <Card key={request.id}>
                <CardHeader>
                  <div className="flex items-start justify-between">
                    <div className="flex items-center space-x-4">
                      <img 
                        src={request.avatar} 
                        alt={request.studentName}
                        className="w-12 h-12 rounded-full object-cover"
                      />
                      <div>
                        <h3 className="text-lg font-semibold text-gray-900">
                          {request.studentName}
                        </h3>
                        <p className="text-sm text-gray-600">{request.studentEmail}</p>
                        <div className="flex items-center space-x-2 mt-1">
                          <Badge variant="info" size="sm">
                            <Building2 className="w-3 h-3 mr-1" />
                            {request.studentYear} • {request.studentBranch}
                          </Badge>
                        </div>
                      </div>
                    </div>
                    {getStatusBadge(request.status)}
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-medium text-gray-900 mb-2">Topic: {request.topic}</h4>
                      <p className="text-gray-600 text-sm">{request.message}</p>
                    </div>
                    
                    <div className="flex items-center space-x-4 text-sm text-gray-500">
                      <div className="flex items-center">
                        <Clock className="w-4 h-4 mr-1" />
                        {request.preferredTime}
                      </div>
                      <div className="flex items-center">
                        <Calendar className="w-4 h-4 mr-1" />
                        {new Date(request.createdAt).toLocaleDateString()}
                      </div>
                    </div>

                    {request.status === 'pending' && (
                      <div className="flex space-x-3 pt-4 border-t">
                        <Button 
                          size="sm" 
                          onClick={() => handleAccept(request.id)}
                          className="flex items-center"
                        >
                          <CheckCircle className="w-4 h-4 mr-1" />
                          Accept
                        </Button>
                        <Button 
                          size="sm" 
                          variant="outline"
                          onClick={() => handleReject(request.id)}
                          className="flex items-center"
                        >
                          <XCircle className="w-4 h-4 mr-1" />
                          Decline
                        </Button>
                        <Button 
                          size="sm" 
                          variant="outline"
                          className="flex items-center"
                        >
                          <MessageSquare className="w-4 h-4 mr-1" />
                          Message
                        </Button>
                      </div>
                    )}

                    {request.status === 'accepted' && (
                      <div className="pt-4 border-t">
                        <Button 
                          size="sm" 
                          className="flex items-center"
                        >
                          <MessageSquare className="w-4 h-4 mr-1" />
                          Start Session
                        </Button>
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
                <h3 className="text-lg font-semibold text-gray-900">Quick Stats</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Total Requests</span>
                    <span className="font-semibold">{requests.length}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Pending</span>
                    <span className="font-semibold text-orange-600">
                      {requests.filter(r => r.status === 'pending').length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Accepted</span>
                    <span className="font-semibold text-green-600">
                      {requests.filter(r => r.status === 'accepted').length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Response Rate</span>
                    <span className="font-semibold text-blue-600">85%</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <h3 className="text-lg font-semibold text-gray-900">Tips for Mentoring</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-3 text-sm text-gray-600">
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Be specific about your availability and expertise</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Ask clarifying questions to understand their goals</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Provide actionable advice and resources</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                    <span>Follow up after sessions to track progress</span>
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

'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  Users, 
  MessageSquare, 
  Calendar, 
  Clock, 
  CheckCircle, 
  XCircle,
  FileText,
  Building2,
  MapPin,
  ExternalLink
} from 'lucide-react'

interface ReferralRequest {
  id: number
  studentName: string
  studentEmail: string
  studentYear: string
  studentBranch: string
  company: string
  position: string
  jobDescription: string
  studentResume: string
  message: string
  status: 'pending' | 'accepted' | 'rejected' | 'submitted'
  createdAt: string
  avatar: string
}

export default function ReferralRequestsPage() {
  const [requests, setRequests] = useState<ReferralRequest[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Mock data for now
    setRequests([
      {
        id: 1,
        studentName: 'Amit Singh',
        studentEmail: 'amit@example.com',
        studentYear: '4th Year',
        studentBranch: 'Computer Science',
        company: 'Google',
        position: 'Software Engineer Intern',
        jobDescription: 'Looking for a software engineering internship at Google. Strong background in algorithms and data structures.',
        studentResume: 'amit_singh_resume.pdf',
        message: 'I have been preparing for Google interviews and would really appreciate a referral. I have completed several projects in web development and have good problem-solving skills.',
        status: 'pending',
        createdAt: '2024-01-15',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 2,
        studentName: 'Kavya Reddy',
        studentEmail: 'kavya@example.com',
        studentYear: '3rd Year',
        studentBranch: 'Information Technology',
        company: 'Microsoft',
        position: 'Product Manager Intern',
        jobDescription: 'Seeking a product management internship to gain experience in product strategy and user research.',
        studentResume: 'kavya_reddy_resume.pdf',
        message: 'I am passionate about product management and have been working on several product case studies. Would love to get a referral for the PM internship.',
        status: 'accepted',
        createdAt: '2024-01-14',
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 3,
        studentName: 'Rohit Sharma',
        studentEmail: 'rohit@example.com',
        studentYear: '4th Year',
        studentBranch: 'Electronics & Communication',
        company: 'Amazon',
        position: 'Data Scientist Intern',
        jobDescription: 'Looking for a data science internship with focus on machine learning and analytics.',
        studentResume: 'rohit_sharma_resume.pdf',
        message: 'I have strong background in machine learning and have worked on several data science projects. Would appreciate a referral for the data science role.',
        status: 'submitted',
        createdAt: '2024-01-13',
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      }
    ])
    setLoading(false)
  }, [])

  const handleInfo = (requestId: number) => {
    // Show detailed information about the referral request
    const request = requests.find(req => req.id === requestId)
    if (request) {
      alert(`Student: ${request.studentName}\nCompany: ${request.company}\nPosition: ${request.position}\nMessage: ${request.message}`)
    }
  }

  const handleReject = (requestId: number) => {
    setRequests(prev => prev.map(req => 
      req.id === requestId ? { ...req, status: 'rejected' as const } : req
    ))
  }

  const handleSubmit = (requestId: number) => {
    setRequests(prev => prev.map(req => 
      req.id === requestId ? { ...req, status: 'submitted' as const } : req
    ))
  }

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'pending':
        return <Badge variant="warning" size="sm">Pending</Badge>
      case 'accepted':
        return <Badge variant="info" size="sm">Accepted</Badge>
      case 'submitted':
        return <Badge variant="success" size="sm">Submitted</Badge>
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
              <h1 className="text-2xl font-bold text-gray-900">Referral Help</h1>
              <p className="mt-1 text-sm text-gray-500">
                Help students with job referrals and career guidance.
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
                      <h4 className="font-medium text-gray-900 mb-2">
                        {request.position} at {request.company}
                      </h4>
                      <p className="text-gray-600 text-sm mb-3">{request.jobDescription}</p>
                      <p className="text-gray-600 text-sm">{request.message}</p>
                    </div>
                    
                    <div className="flex items-center space-x-4 text-sm text-gray-500">
                      <div className="flex items-center">
                        <Calendar className="w-4 h-4 mr-1" />
                        {new Date(request.createdAt).toLocaleDateString()}
                      </div>
                      <div className="flex items-center">
                        <FileText className="w-4 h-4 mr-1" />
                        <a href="#" className="text-blue-600 hover:underline">
                          {request.studentResume}
                        </a>
                      </div>
                    </div>

                    {request.status === 'pending' && (
                      <div className="flex space-x-3 pt-4 border-t">
                        <Button 
                          size="sm" 
                          onClick={() => handleInfo(request.id)}
                          className="flex items-center"
                        >
                          <FileText className="w-4 h-4 mr-1" />
                          Info
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
                        <div className="flex space-x-3">
                          <Button 
                            size="sm" 
                            onClick={() => handleSubmit(request.id)}
                            className="flex items-center"
                          >
                            <ExternalLink className="w-4 h-4 mr-1" />
                            Submit Referral
                          </Button>
                          <Button 
                            size="sm" 
                            variant="outline"
                            className="flex items-center"
                          >
                            <MessageSquare className="w-4 h-4 mr-1" />
                            Message Student
                          </Button>
                        </div>
                      </div>
                    )}

                    {request.status === 'submitted' && (
                      <div className="pt-4 border-t">
                        <div className="bg-green-50 border border-green-200 rounded-lg p-3">
                          <p className="text-sm text-green-800">
                            ✅ Referral submitted successfully! The student will be notified.
                          </p>
                        </div>
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
                <h3 className="text-lg font-semibold text-gray-900">Referral Stats</h3>
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
                    <span className="font-semibold text-blue-600">
                      {requests.filter(r => r.status === 'accepted').length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Submitted</span>
                    <span className="font-semibold text-green-600">
                      {requests.filter(r => r.status === 'submitted').length}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-600">Success Rate</span>
                    <span className="font-semibold text-green-600">78%</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <h3 className="text-lg font-semibold text-gray-900">Referral Guidelines</h3>
              </CardHeader>
              <CardContent>
                <div className="space-y-3 text-sm text-gray-600">
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Only refer candidates you genuinely believe are qualified</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Review their resume and portfolio thoroughly</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Provide specific feedback if declining</span>
                  </div>
                  <div className="flex items-start space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500 mt-0.5" />
                    <span>Follow up on referral status when possible</span>
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

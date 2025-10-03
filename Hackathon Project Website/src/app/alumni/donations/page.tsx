'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  Heart, 
  DollarSign, 
  Users, 
  Calendar, 
  TrendingUp,
  Gift,
  Target,
  CheckCircle,
  XCircle,
  Star
} from 'lucide-react'

interface Donation {
  id: number
  amount: number
  studentName: string
  studentEmail: string
  purpose: string
  message: string
  status: 'pending' | 'completed' | 'cancelled'
  createdAt: string
  avatar: string
}

interface DonationGoal {
  id: number
  title: string
  description: string
  targetAmount: number
  currentAmount: number
  deadline: string
  status: 'active' | 'completed' | 'expired'
}

export default function DonationsPage() {
  const [donations, setDonations] = useState<Donation[]>([])
  const [goals, setGoals] = useState<DonationGoal[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState<'donations' | 'goals'>('donations')

  useEffect(() => {
    // Mock data for now
    setDonations([
      {
        id: 1,
        amount: 5000,
        studentName: 'Priya Sharma',
        studentEmail: 'priya@example.com',
        purpose: 'Laptop for Online Learning',
        message: 'I need a laptop to continue my studies online. Any help would be greatly appreciated.',
        status: 'completed',
        createdAt: '2024-01-15',
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 2,
        amount: 3000,
        studentName: 'Rahul Kumar',
        studentEmail: 'rahul@example.com',
        purpose: 'Course Materials',
        message: 'I need financial assistance to purchase course materials and books for my final year.',
        status: 'pending',
        createdAt: '2024-01-14',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      },
      {
        id: 3,
        amount: 8000,
        studentName: 'Sneha Patel',
        studentEmail: 'sneha@example.com',
        purpose: 'Internship Travel Expenses',
        message: 'I have an internship opportunity in another city but need help with travel and accommodation expenses.',
        status: 'completed',
        createdAt: '2024-01-13',
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
      }
    ])

    setGoals([
      {
        id: 1,
        title: 'Student Emergency Fund',
        description: 'Help students facing financial emergencies during their studies',
        targetAmount: 100000,
        currentAmount: 75000,
        deadline: '2024-03-31',
        status: 'active'
      },
      {
        id: 2,
        title: 'Laptop Donation Drive',
        description: 'Provide laptops to students who cannot afford them for online learning',
        targetAmount: 500000,
        currentAmount: 320000,
        deadline: '2024-02-28',
        status: 'active'
      },
      {
        id: 3,
        title: 'Scholarship Program',
        description: 'Support meritorious students with financial constraints',
        targetAmount: 200000,
        currentAmount: 200000,
        deadline: '2024-01-31',
        status: 'completed'
      }
    ])

    setLoading(false)
  }, [])

  const handleApproveDonation = (donationId: number) => {
    setDonations(prev => prev.map(donation => 
      donation.id === donationId ? { ...donation, status: 'completed' as const } : donation
    ))
  }

  const handleRejectDonation = (donationId: number) => {
    setDonations(prev => prev.map(donation => 
      donation.id === donationId ? { ...donation, status: 'cancelled' as const } : donation
    ))
  }

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'pending':
        return <Badge variant="warning" size="sm">Pending</Badge>
      case 'completed':
        return <Badge variant="success" size="sm">Completed</Badge>
      case 'cancelled':
        return <Badge variant="danger" size="sm">Cancelled</Badge>
      default:
        return <Badge variant="info" size="sm">{status}</Badge>
    }
  }

  const getGoalStatusBadge = (status: string) => {
    switch (status) {
      case 'active':
        return <Badge variant="info" size="sm">Active</Badge>
      case 'completed':
        return <Badge variant="success" size="sm">Completed</Badge>
      case 'expired':
        return <Badge variant="danger" size="sm">Expired</Badge>
      default:
        return <Badge variant="info" size="sm">{status}</Badge>
    }
  }

  const totalDonated = donations
    .filter(d => d.status === 'completed')
    .reduce((acc, d) => acc + d.amount, 0)

  const pendingDonations = donations.filter(d => d.status === 'pending')
  const completedDonations = donations.filter(d => d.status === 'completed')

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
          <h1 className="text-2xl font-bold text-gray-900">Donations</h1>
          <p className="mt-1 text-sm text-gray-500">
            Support students in need and track your donation impact.
          </p>
        </div>

        {/* Tab Navigation */}
        <div className="border-b border-gray-200">
          <nav className="-mb-px flex space-x-8">
            <button
              onClick={() => setActiveTab('donations')}
              className={`py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'donations'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Donation Requests ({donations.length})
            </button>
            <button
              onClick={() => setActiveTab('goals')}
              className={`py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'goals'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              Donation Goals ({goals.length})
            </button>
          </nav>
        </div>

        {activeTab === 'donations' && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2 space-y-4">
              {donations.map((donation) => (
                <Card key={donation.id}>
                  <CardHeader>
                    <div className="flex items-start justify-between">
                      <div className="flex items-center space-x-4">
                        <img 
                          src={donation.avatar} 
                          alt={donation.studentName}
                          className="w-12 h-12 rounded-full object-cover"
                        />
                        <div>
                          <h3 className="text-lg font-semibold text-gray-900">
                            {donation.studentName}
                          </h3>
                          <p className="text-sm text-gray-600">{donation.studentEmail}</p>
                          <div className="flex items-center space-x-2 mt-1">
                            <Badge variant="info" size="sm">
                              <DollarSign className="w-3 h-3 mr-1" />
                              ₹{donation.amount.toLocaleString()}
                            </Badge>
                          </div>
                        </div>
                      </div>
                      {getStatusBadge(donation.status)}
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-4">
                      <div>
                        <h4 className="font-medium text-gray-900 mb-2">{donation.purpose}</h4>
                        <p className="text-gray-600 text-sm">{donation.message}</p>
                      </div>
                      
                      <div className="flex items-center space-x-4 text-sm text-gray-500">
                        <div className="flex items-center">
                          <Calendar className="w-4 h-4 mr-1" />
                          {new Date(donation.createdAt).toLocaleDateString()}
                        </div>
                      </div>

                      {donation.status === 'pending' && (
                        <div className="flex space-x-3 pt-4 border-t">
                          <Button 
                            size="sm" 
                            onClick={() => handleApproveDonation(donation.id)}
                            className="flex items-center"
                          >
                            <CheckCircle className="w-4 h-4 mr-1" />
                            Approve
                          </Button>
                          <Button 
                            size="sm" 
                            variant="outline"
                            onClick={() => handleRejectDonation(donation.id)}
                            className="flex items-center"
                          >
                            <XCircle className="w-4 h-4 mr-1" />
                            Decline
                          </Button>
                        </div>
                      )}

                      {donation.status === 'completed' && (
                        <div className="pt-4 border-t">
                          <div className="bg-green-50 border border-green-200 rounded-lg p-3">
                            <p className="text-sm text-green-800">
                              ✅ Donation completed successfully! Student has been notified.
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
                  <h3 className="text-lg font-semibold text-gray-900">Donation Stats</h3>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Total Donated</span>
                      <span className="font-semibold text-green-600">
                        ₹{totalDonated.toLocaleString()}
                      </span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Students Helped</span>
                      <span className="font-semibold text-blue-600">
                        {completedDonations.length}
                      </span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Pending Requests</span>
                      <span className="font-semibold text-orange-600">
                        {pendingDonations.length}
                      </span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Average Donation</span>
                      <span className="font-semibold text-purple-600">
                        ₹{completedDonations.length > 0 ? Math.round(totalDonated / completedDonations.length).toLocaleString() : 0}
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <h3 className="text-lg font-semibold text-gray-900">Impact Stories</h3>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3 text-sm text-gray-600">
                    <div className="flex items-start space-x-2">
                      <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                      <span>Helped 3 students purchase laptops for online learning</span>
                    </div>
                    <div className="flex items-start space-x-2">
                      <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                      <span>Supported 5 students with course materials</span>
                    </div>
                    <div className="flex items-start space-x-2">
                      <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                      <span>Enabled 2 students to attend internships</span>
                    </div>
                    <div className="flex items-start space-x-2">
                      <Star className="w-4 h-4 text-yellow-500 mt-0.5" />
                      <span>Provided emergency financial assistance</span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )}

        {activeTab === 'goals' && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2 space-y-4">
              {goals.map((goal) => (
                <Card key={goal.id}>
                  <CardHeader>
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <h3 className="text-lg font-semibold text-gray-900 mb-2">
                          {goal.title}
                        </h3>
                        <p className="text-sm text-gray-600 mb-3">{goal.description}</p>
                        <div className="flex items-center space-x-4 text-sm text-gray-500">
                          <div className="flex items-center">
                            <Target className="w-4 h-4 mr-1" />
                            Target: ₹{goal.targetAmount.toLocaleString()}
                          </div>
                          <div className="flex items-center">
                            <Calendar className="w-4 h-4 mr-1" />
                            Deadline: {new Date(goal.deadline).toLocaleDateString()}
                          </div>
                        </div>
                      </div>
                      {getGoalStatusBadge(goal.status)}
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-4">
                      <div>
                        <div className="flex items-center justify-between text-sm mb-2">
                          <span className="text-gray-600">Progress</span>
                          <span className="font-medium">
                            ₹{goal.currentAmount.toLocaleString()} / ₹{goal.targetAmount.toLocaleString()}
                          </span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                          <div 
                            className="bg-blue-600 h-2 rounded-full" 
                            style={{ width: `${Math.min((goal.currentAmount / goal.targetAmount) * 100, 100)}%` }}
                          ></div>
                        </div>
                        <p className="text-sm text-gray-500 mt-1">
                          {Math.round((goal.currentAmount / goal.targetAmount) * 100)}% complete
                        </p>
                      </div>

                      <div className="flex space-x-3 pt-4 border-t">
                        <Button 
                          size="sm" 
                          className="flex items-center"
                        >
                          <Heart className="w-4 h-4 mr-1" />
                          Donate Now
                        </Button>
                        <Button 
                          size="sm" 
                          variant="outline"
                          className="flex items-center"
                        >
                          <Users className="w-4 h-4 mr-1" />
                          Share
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>

            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <h3 className="text-lg font-semibold text-gray-900">Goal Stats</h3>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Active Goals</span>
                      <span className="font-semibold text-blue-600">
                        {goals.filter(g => g.status === 'active').length}
                      </span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Completed Goals</span>
                      <span className="font-semibold text-green-600">
                        {goals.filter(g => g.status === 'completed').length}
                      </span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Total Raised</span>
                      <span className="font-semibold text-purple-600">
                        ₹{goals.reduce((acc, g) => acc + g.currentAmount, 0).toLocaleString()}
                      </span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600">Total Target</span>
                      <span className="font-semibold text-orange-600">
                        ₹{goals.reduce((acc, g) => acc + g.targetAmount, 0).toLocaleString()}
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <h3 className="text-lg font-semibold text-gray-900">How to Help</h3>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3 text-sm text-gray-600">
                    <div className="flex items-start space-x-2">
                      <Gift className="w-4 h-4 text-green-500 mt-0.5" />
                      <span>Make one-time or recurring donations</span>
                    </div>
                    <div className="flex items-start space-x-2">
                      <Gift className="w-4 h-4 text-green-500 mt-0.5" />
                      <span>Share donation goals with your network</span>
                    </div>
                    <div className="flex items-start space-x-2">
                      <Gift className="w-4 h-4 text-green-500 mt-0.5" />
                      <span>Sponsor specific students or causes</span>
                    </div>
                    <div className="flex items-start space-x-2">
                      <Gift className="w-4 h-4 text-green-500 mt-0.5" />
                      <span>Volunteer your time and expertise</span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}

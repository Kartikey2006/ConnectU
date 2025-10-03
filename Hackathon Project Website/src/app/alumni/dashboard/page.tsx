'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Calendar, MessageSquare, Users, BookOpen, TrendingUp, DollarSign, Clock, CheckCircle } from 'lucide-react'

interface AlumniDashboardStats {
  totalStudents: number
  activeMentorshipSessions: number
  upcomingWebinars: number
  totalEarnings: number
  pendingRequests: number
  completedSessions: number
}

export default function AlumniDashboard() {
  const [stats, setStats] = useState<AlumniDashboardStats>({
    totalStudents: 0,
    activeMentorshipSessions: 0,
    upcomingWebinars: 0,
    totalEarnings: 0,
    pendingRequests: 0,
    completedSessions: 0,
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      setStats({
        totalStudents: 8,
        activeMentorshipSessions: 3,
        upcomingWebinars: 2,
        totalEarnings: 450.00,
        pendingRequests: 2,
        completedSessions: 12,
      })
      
      /* Uncomment when database tables are ready:
      // Fetch mentorship sessions
      const { data: sessions } = await supabase
        .from('mentorship_sessions')
        .select('*')
        .eq('alumni_id', user.id)

      // Fetch webinars
      const { data: webinars } = await supabase
        .from('webinars')
        .select('*')
        .eq('alumni_id', user.id)

      // Fetch earnings from transactions
      const { data: transactions } = await supabase
        .from('transactions')
        .select('amount')
        .eq('payee_id', user.id)

      // Count unique students mentored
      const { data: students } = await supabase
        .from('mentorship_sessions')
        .select('student_id')
        .eq('alumni_id', user.id)

      const uniqueStudents = new Set(students?.map(s => s.student_id)).size

      setStats({
        totalStudents: uniqueStudents,
        activeMentorshipSessions: sessions?.filter(s => s.status === 'accepted').length || 0,
        upcomingWebinars: webinars?.filter(w => new Date(w.date_time) > new Date()).length || 0,
        totalEarnings: transactions?.reduce((sum, t) => sum + parseFloat(t.amount), 0) || 0,
        pendingRequests: sessions?.filter(s => s.status === 'pending').length || 0,
        completedSessions: sessions?.filter(s => s.status === 'completed').length || 0,
      })
      */
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
      // Set mock data on error
      setStats({
        totalStudents: 8,
        activeMentorshipSessions: 3,
        upcomingWebinars: 2,
        totalEarnings: 450.00,
        pendingRequests: 2,
        completedSessions: 12,
      })
    } finally {
      setLoading(false)
    }
  }

  const statCards = [
    {
      name: 'Students Mentored',
      value: stats.totalStudents,
      icon: Users,
      color: 'bg-blue-500',
      href: '/alumni/students'
    },
    {
      name: 'Active Sessions',
      value: stats.activeMentorshipSessions,
      icon: MessageSquare,
      color: 'bg-green-500',
      href: '/mentorship'
    },
    {
      name: 'Upcoming Webinars',
      value: stats.upcomingWebinars,
      icon: BookOpen,
      color: 'bg-purple-500',
      href: '/webinars'
    },
    {
      name: 'Total Earnings',
      value: `$${stats.totalEarnings.toFixed(2)}`,
      icon: DollarSign,
      color: 'bg-yellow-500',
      href: '/alumni/earnings'
    },
    {
      name: 'Pending Requests',
      value: stats.pendingRequests,
      icon: Clock,
      color: 'bg-orange-500',
      href: '/alumni/requests'
    },
    {
      name: 'Completed Sessions',
      value: stats.completedSessions,
      icon: CheckCircle,
      color: 'bg-green-600',
      href: '/alumni/history'
    },
  ]

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
              <div key={i} className="bg-white p-6 rounded-lg shadow">
                <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
                <div className="h-8 bg-gray-200 rounded w-1/4"></div>
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
          <h1 className="text-2xl font-bold text-gray-900">Alumni Dashboard</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage your mentorship sessions, webinars, and help students grow.
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {statCards.map((card) => (
            <div key={card.name} className="bg-white overflow-hidden shadow rounded-lg">
              <div className="p-5">
                <div className="flex items-center">
                  <div className="flex-shrink-0">
                    <div className={`p-3 rounded-md ${card.color}`}>
                      <card.icon className="h-6 w-6 text-white" />
                    </div>
                  </div>
                  <div className="ml-5 w-0 flex-1">
                    <dl>
                      <dt className="text-sm font-medium text-gray-500 truncate">
                        {card.name}
                      </dt>
                      <dd className="text-lg font-medium text-gray-900">
                        {card.value}
                      </dd>
                    </dl>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Quick Actions */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">
              Quick Actions
            </h3>
            <div className="mt-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <button className="relative group bg-white p-6 focus-within:ring-2 focus-within:ring-inset focus-within:ring-primary-500 rounded-lg border border-gray-200 hover:border-gray-300">
                <div>
                  <span className="rounded-lg inline-flex p-3 bg-blue-50 text-blue-700 ring-4 ring-white">
                    <MessageSquare className="h-6 w-6" />
                  </span>
                </div>
                <div className="mt-8">
                  <h3 className="text-lg font-medium">
                    <span className="absolute inset-0" aria-hidden="true" />
                    View Requests
                  </h3>
                  <p className="mt-2 text-sm text-gray-500">
                    Review and respond to mentorship requests
                  </p>
                </div>
              </button>

              <button className="relative group bg-white p-6 focus-within:ring-2 focus-within:ring-inset focus-within:ring-primary-500 rounded-lg border border-gray-200 hover:border-gray-300">
                <div>
                  <span className="rounded-lg inline-flex p-3 bg-purple-50 text-purple-700 ring-4 ring-white">
                    <BookOpen className="h-6 w-6" />
                  </span>
                </div>
                <div className="mt-8">
                  <h3 className="text-lg font-medium">
                    <span className="absolute inset-0" aria-hidden="true" />
                    Create Webinar
                  </h3>
                  <p className="mt-2 text-sm text-gray-500">
                    Host educational webinars for students
                  </p>
                </div>
              </button>

              <button className="relative group bg-white p-6 focus-within:ring-2 focus-within:ring-inset focus-within:ring-primary-500 rounded-lg border border-gray-200 hover:border-gray-300">
                <div>
                  <span className="rounded-lg inline-flex p-3 bg-green-50 text-green-700 ring-4 ring-white">
                    <TrendingUp className="h-6 w-6" />
                  </span>
                </div>
                <div className="mt-8">
                  <h3 className="text-lg font-medium">
                    <span className="absolute inset-0" aria-hidden="true" />
                    View Analytics
                  </h3>
                  <p className="mt-2 text-sm text-gray-500">
                    Track your impact and earnings
                  </p>
                </div>
              </button>
            </div>
          </div>
        </div>

        {/* Recent Activity */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">
              Recent Activity
            </h3>
            <div className="mt-5">
              <div className="flow-root">
                <ul className="-mb-8">
                  <li>
                    <div className="relative pb-8">
                      <span className="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200" aria-hidden="true" />
                      <div className="relative flex space-x-3">
                        <div>
                          <span className="h-8 w-8 rounded-full bg-blue-500 flex items-center justify-center ring-8 ring-white">
                            <MessageSquare className="h-4 w-4 text-white" />
                          </span>
                        </div>
                        <div className="min-w-0 flex-1 pt-1.5 flex justify-between space-x-4">
                          <div>
                            <p className="text-sm text-gray-500">
                              New mentorship request from <span className="font-medium text-gray-900">Jane Smith</span>
                            </p>
                          </div>
                          <div className="text-right text-sm whitespace-nowrap text-gray-500">
                            <time>1 hour ago</time>
                          </div>
                        </div>
                      </div>
                    </div>
                  </li>
                  <li>
                    <div className="relative">
                      <div className="relative flex space-x-3">
                        <div>
                          <span className="h-8 w-8 rounded-full bg-green-500 flex items-center justify-center ring-8 ring-white">
                            <CheckCircle className="h-4 w-4 text-white" />
                          </span>
                        </div>
                        <div className="min-w-0 flex-1 pt-1.5 flex justify-between space-x-4">
                          <div>
                            <p className="text-sm text-gray-500">
                              Completed mentorship session with <span className="font-medium text-gray-900">Mike Johnson</span>
                            </p>
                          </div>
                          <div className="text-right text-sm whitespace-nowrap text-gray-500">
                            <time>3 hours ago</time>
                          </div>
                        </div>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

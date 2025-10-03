'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { StatCard } from '@/components/ui/StatCard'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  Users, 
  MessageSquare, 
  BookOpen, 
  TrendingUp,
  Calendar,
  Clock,
  Star,
  ArrowRight,
  Play,
  UserCheck,
  Bell,
  Target
} from 'lucide-react'

interface DashboardStats {
  upcomingSessions: number
  totalMentors: number
  registeredWebinars: number
  pendingReferrals: number
}

export default function StudentDashboard() {
  const [stats, setStats] = useState<DashboardStats>({
    upcomingSessions: 0,
    totalMentors: 0,
    registeredWebinars: 0,
    pendingReferrals: 0,
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Set mock data immediately for faster loading
    setStats({
      upcomingSessions: 2,
      totalMentors: 15,
      registeredWebinars: 3,
      pendingReferrals: 1,
    })
    setLoading(false)
    
    // Fetch real data in background (when database is ready)
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      setStats({
        upcomingSessions: 2,
        totalMentors: 15,
        registeredWebinars: 3,
        pendingReferrals: 1,
      })

      /* Uncomment when database tables are ready:
      // Fetch mentorship sessions
      const { data: sessions } = await supabase
        .from('mentorship_sessions')
        .select('*')
        .eq('student_id', user.id)
        .eq('status', 'accepted')

      // Fetch webinars
      const { data: webinars } = await supabase
        .from('webinar_registrations')
        .select('*')
        .eq('student_id', user.id)

      // Fetch referrals
      const { data: referrals } = await supabase
        .from('referrals')
        .select('*')
        .eq('student_id', user.id)
        .eq('status', 'pending')

      // Count alumni
      const { count: alumniCount } = await supabase
        .from('alumnidetails')
        .select('*', { count: 'exact', head: true })
        .eq('verification_status', true)

      setStats({
        upcomingSessions: sessions?.length || 0,
        totalMentors: alumniCount || 0,
        registeredWebinars: webinars?.length || 0,
        pendingReferrals: referrals?.length || 0,
      })
      */
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
      // Set mock data on error
      setStats({
        upcomingSessions: 2,
        totalMentors: 15,
        registeredWebinars: 3,
        pendingReferrals: 1,
      })
    } finally {
      // setLoading(false) // Removed as mock data sets loading to false immediately
    }
  }

  const upcomingSessions = [
    {
      id: 1,
      mentor: 'Priya Patel',
      company: 'Google',
      topic: 'Career Guidance in Software Engineering',
      date: '2024-01-15',
      time: '2:00 PM',
      avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
    },
    {
      id: 2,
      mentor: 'Arvind Singh',
      company: 'Microsoft',
      topic: 'Product Management Fundamentals',
      date: '2024-01-18',
      time: '10:00 AM',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'
    }
  ]

  const recentActivities = [
    {
      id: 1,
      type: 'session',
      title: 'Mentorship session completed',
      description: 'Career guidance session with Priya Patel',
      time: '2 hours ago',
      icon: MessageSquare,
      color: 'green'
    },
    {
      id: 2,
      type: 'webinar',
      title: 'Webinar registration',
      description: 'Registered for "Data Science Trends 2024"',
      time: '1 day ago',
      icon: BookOpen,
      color: 'blue'
    },
    {
      id: 3,
      type: 'referral',
      title: 'Referral request sent',
      description: 'Requested referral from Arvind Singh',
      time: '3 days ago',
      icon: Users,
      color: 'purple'
    }
  ]

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[...Array(4)].map((_, i) => (
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
      <div className="space-y-8">
        {/* Welcome Section */}
        <div className="bg-gradient-to-r from-blue-600 to-purple-700 rounded-2xl p-8 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold mb-2">Welcome back!</h1>
              <p className="text-blue-100 text-lg">
                Ready to continue your learning journey? Let's connect with mentors and grow together.
              </p>
            </div>
            <div className="hidden md:block">
              <div className="w-24 h-24 bg-white/20 rounded-full flex items-center justify-center">
                <TrendingUp className="w-12 h-12 text-white" />
              </div>
            </div>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <StatCard
            title="Upcoming Sessions"
            value={stats.upcomingSessions}
            icon={<Calendar className="w-6 h-6" />}
            color="blue"
            change="+2 this week"
            changeType="increase"
            href="/mentorship"
          />
          <StatCard
            title="Available Mentors"
            value={stats.totalMentors}
            icon={<Users className="w-6 h-6" />}
            color="green"
            change="+5 new mentors"
            changeType="increase"
            href="/mentorship"
          />
          <StatCard
            title="Registered Webinars"
            value={stats.registeredWebinars}
            icon={<BookOpen className="w-6 h-6" />}
            color="purple"
            change="+1 this month"
            changeType="increase"
            href="/webinars"
          />
          <StatCard
            title="Pending Referrals"
            value={stats.pendingReferrals}
            icon={<UserCheck className="w-6 h-6" />}
            color="orange"
            change="2 in progress"
            changeType="neutral"
            href="/referrals"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Upcoming Sessions */}
          <div className="lg:col-span-2">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-bold text-gray-900">Upcoming Sessions</h2>
                  <Button variant="outline" size="sm" href="/mentorship">
                    View All
                    <ArrowRight className="w-4 h-4 ml-1" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {upcomingSessions.map((session) => (
                    <div key={session.id} className="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                      <img 
                        src={session.avatar} 
                        alt={session.mentor}
                        className="w-12 h-12 rounded-full object-cover"
                      />
                      <div className="flex-1">
                        <h3 className="font-semibold text-gray-900">{session.mentor}</h3>
                        <p className="text-sm text-gray-600">{session.company} • {session.topic}</p>
                        <div className="flex items-center mt-2 space-x-4">
                          <Badge variant="info" size="sm">
                            <Calendar className="w-3 h-3 mr-1" />
                            {session.date}
                          </Badge>
                          <Badge variant="warning" size="sm">
                            <Clock className="w-3 h-3 mr-1" />
                            {session.time}
                          </Badge>
                        </div>
                      </div>
                      <Button size="sm" variant="outline">
                        Join
                      </Button>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Recent Activity */}
          <div>
            <Card>
              <CardHeader>
                <h2 className="text-xl font-bold text-gray-900">Recent Activity</h2>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {recentActivities.map((activity) => (
                    <div key={activity.id} className="flex items-start space-x-3">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                        activity.color === 'green' ? 'bg-green-100 text-green-600' :
                        activity.color === 'blue' ? 'bg-blue-100 text-blue-600' :
                        'bg-purple-100 text-purple-600'
                      }`}>
                        <activity.icon className="w-4 h-4" />
                      </div>
                      <div className="flex-1">
                        <p className="text-sm font-medium text-gray-900">{activity.title}</p>
                        <p className="text-xs text-gray-600">{activity.description}</p>
                        <p className="text-xs text-gray-500 mt-1">{activity.time}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

        {/* Quick Actions */}
        <Card>
          <CardHeader>
            <h2 className="text-xl font-bold text-gray-900">Quick Actions</h2>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/mentorship"
              >
                <MessageSquare className="w-6 h-6" />
                <span>Find a Mentor</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/webinars"
              >
                <BookOpen className="w-6 h-6" />
                <span>Browse Webinars</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/referrals"
              >
                <Users className="w-6 h-6" />
                <span>Request Referral</span>
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Progress Section */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <Card>
            <CardHeader>
              <h2 className="text-xl font-bold text-gray-900">Learning Progress</h2>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">Mentorship Sessions</span>
                  <span className="text-sm text-gray-600">8/12 completed</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-blue-600 h-2 rounded-full" style={{ width: '67%' }}></div>
                </div>
                
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">Webinar Attendance</span>
                  <span className="text-sm text-gray-600">5/8 attended</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-green-600 h-2 rounded-full" style={{ width: '63%' }}></div>
                </div>
                
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">Skill Development</span>
                  <span className="text-sm text-gray-600">3/5 skills acquired</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-purple-600 h-2 rounded-full" style={{ width: '60%' }}></div>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <h2 className="text-xl font-bold text-gray-900">Achievements</h2>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center">
                    <Star className="w-5 h-5 text-yellow-600" />
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">First Mentor Session</p>
                    <p className="text-sm text-gray-600">Completed your first mentorship session</p>
                  </div>
                </div>
                
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                    <Target className="w-5 h-5 text-green-600" />
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">Goal Setter</p>
                    <p className="text-sm text-gray-600">Set your first career goal</p>
                  </div>
                </div>
                
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                    <BookOpen className="w-5 h-5 text-blue-600" />
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">Knowledge Seeker</p>
                    <p className="text-sm text-gray-600">Attended 5 webinars</p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  )
}
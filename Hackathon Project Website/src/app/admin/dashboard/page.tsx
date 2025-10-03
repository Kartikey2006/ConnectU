'use client'

import { useState, useEffect } from 'react'
import AdminLayout from '@/components/layout/AdminLayout'
import { supabase } from '@/lib/supabase'
import { StatCard } from '@/components/ui/StatCard'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  Users, 
  MessageSquare, 
  BookOpen, 
  DollarSign, 
  TrendingUp, 
  AlertCircle, 
  CheckCircle, 
  Clock,
  Shield,
  Activity,
  UserCheck,
  BarChart3,
  ArrowRight,
  Eye,
  Settings
} from 'lucide-react'

interface AdminDashboardStats {
  totalUsers: number
  totalStudents: number
  totalAlumni: number
  totalSessions: number
  totalWebinars: number
  totalRevenue: number
  pendingVerifications: number
  activeUsers: number
}

export default function AdminDashboard() {
  const [stats, setStats] = useState<AdminDashboardStats>({
    totalUsers: 0,
    totalStudents: 0,
    totalAlumni: 0,
    totalSessions: 0,
    totalWebinars: 0,
    totalRevenue: 0,
    pendingVerifications: 0,
    activeUsers: 0,
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Set mock data immediately for faster loading
    setStats({
      totalUsers: 156,
      totalStudents: 89,
      totalAlumni: 45,
      totalSessions: 234,
      totalWebinars: 67,
      totalRevenue: 12580.50,
      pendingVerifications: 8,
      activeUsers: 142,
    })
    setLoading(false)

    // Fetch real data in background (when database is ready)
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      setStats({
        totalUsers: 156,
        totalStudents: 89,
        totalAlumni: 45,
        totalSessions: 234,
        totalWebinars: 67,
        totalRevenue: 12580.50,
        pendingVerifications: 8,
        activeUsers: 142,
      })

      /* Uncomment when database tables are ready:
      // Fetch total users
      const { count: totalUsers } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true })

      // Fetch users by role
      const { count: totalStudents } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true })
        .eq('role', 'student')

      const { count: totalAlumni } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true })
        .eq('role', 'alumni')

      // Fetch sessions
      const { count: totalSessions } = await supabase
        .from('mentorship_sessions')
        .select('*', { count: 'exact', head: true })

      // Fetch webinars
      const { count: totalWebinars } = await supabase
        .from('webinars')
        .select('*', { count: 'exact', head: true })

      // Fetch total revenue
      const { data: transactions } = await supabase
        .from('transactions')
        .select('amount')

      // Fetch pending verifications
      const { count: pendingVerifications } = await supabase
        .from('alumnidetails')
        .select('*', { count: 'exact', head: true })
        .eq('verification_status', false)

      // Calculate active users (users who have had activity in last 30 days)
      const thirtyDaysAgo = new Date()
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

      const { count: activeUsers } = await supabase
        .from('mentorship_sessions')
        .select('*', { count: 'exact', head: true })
        .gte('created_at', thirtyDaysAgo.toISOString())

      setStats({
        totalUsers: totalUsers || 0,
        totalStudents: totalStudents || 0,
        totalAlumni: totalAlumni || 0,
        totalSessions: totalSessions || 0,
        totalWebinars: totalWebinars || 0,
        totalRevenue: transactions?.reduce((sum, t) => sum + parseFloat(t.amount), 0) || 0,
        pendingVerifications: pendingVerifications || 0,
        activeUsers: activeUsers || 0,
      })
      */
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
      // Set mock data on error
      setStats({
        totalUsers: 156,
        totalStudents: 89,
        totalAlumni: 45,
        totalSessions: 234,
        totalWebinars: 67,
        totalRevenue: 12580.50,
        pendingVerifications: 8,
        activeUsers: 142,
      })
    } finally {
      // setLoading(false) // Removed as mock data sets loading to false immediately
    }
  }

  const recentActivities = [
    {
      id: 1,
      type: 'user',
      title: 'New user registration',
      description: 'John Doe joined as a student',
      time: '5 minutes ago',
      icon: Users,
      color: 'blue'
    },
    {
      id: 2,
      type: 'verification',
      title: 'Alumni verification completed',
      description: 'Sarah Chen verified as Google employee',
      time: '1 hour ago',
      icon: UserCheck,
      color: 'green'
    },
    {
      id: 3,
      type: 'session',
      title: 'Mentorship session completed',
      description: 'Session between Alice and Bob completed',
      time: '2 hours ago',
      icon: MessageSquare,
      color: 'purple'
    },
    {
      id: 4,
      type: 'webinar',
      title: 'New webinar created',
      description: 'Data Science Trends 2024 webinar scheduled',
      time: '3 hours ago',
      icon: BookOpen,
      color: 'orange'
    }
  ]

  const pendingActions = [
    {
      id: 1,
      title: 'Alumni Verification Requests',
      count: stats.pendingVerifications,
      description: 'New alumni profiles need verification',
      href: '/admin/verifications',
      icon: AlertCircle,
      color: 'orange'
    },
    {
      id: 2,
      title: 'Reported Users',
      count: 3,
      description: 'Users reported for policy violations',
      href: '/admin/reports',
      icon: Shield,
      color: 'red'
    },
    {
      id: 3,
      title: 'Pending Refunds',
      count: 2,
      description: 'Refund requests need processing',
      href: '/admin/refunds',
      icon: DollarSign,
      color: 'yellow'
    }
  ]

  if (loading) {
    return (
      <AdminLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[...Array(8)].map((_, i) => (
              <div key={i} className="bg-white p-6 rounded-lg shadow">
                <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
                <div className="h-8 bg-gray-200 rounded w-1/4"></div>
              </div>
            ))}
          </div>
        </div>
      </AdminLayout>
    )
  }

  return (
    <AdminLayout>
      <div className="space-y-8">
        {/* Welcome Section */}
        <div className="bg-gradient-to-r from-red-600 to-red-800 rounded-2xl p-8 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold mb-2">Admin Dashboard</h1>
              <p className="text-red-100 text-lg">
                Monitor platform activity, manage users, and oversee the ConnectU community.
              </p>
            </div>
            <div className="hidden md:block">
              <div className="w-24 h-24 bg-white/20 rounded-full flex items-center justify-center">
                <Shield className="w-12 h-12 text-white" />
              </div>
            </div>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <StatCard
            title="Total Users"
            value={stats.totalUsers}
            icon={<Users className="w-6 h-6" />}
            color="blue"
            change="+12 this week"
            changeType="increase"
            href="/admin/users"
          />
          <StatCard
            title="Students"
            value={stats.totalStudents}
            icon={<Users className="w-6 h-6" />}
            color="green"
            change="+8 this week"
            changeType="increase"
            href="/admin/users?role=student"
          />
          <StatCard
            title="Alumni"
            value={stats.totalAlumni}
            icon={<Users className="w-6 h-6" />}
            color="purple"
            change="+4 this week"
            changeType="increase"
            href="/admin/users?role=alumni"
          />
          <StatCard
            title="Active Users"
            value={stats.activeUsers}
            icon={<Activity className="w-6 h-6" />}
            color="orange"
            change="+15 this week"
            changeType="increase"
            href="/admin/analytics"
          />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <StatCard
            title="Mentorship Sessions"
            value={stats.totalSessions}
            icon={<MessageSquare className="w-6 h-6" />}
            color="indigo"
            change="+23 this week"
            changeType="increase"
            href="/admin/sessions"
          />
          <StatCard
            title="Webinars"
            value={stats.totalWebinars}
            icon={<BookOpen className="w-6 h-6" />}
            color="yellow"
            change="+5 this week"
            changeType="increase"
            href="/admin/webinars"
          />
          <StatCard
            title="Total Revenue"
            value={`$${stats.totalRevenue.toFixed(2)}`}
            icon={<DollarSign className="w-6 h-6" />}
            color="green"
            change="+$1,250 this week"
            changeType="increase"
            href="/admin/revenue"
          />
          <StatCard
            title="Pending Verifications"
            value={stats.pendingVerifications}
            icon={<AlertCircle className="w-6 h-6" />}
            color="red"
            change="3 urgent"
            changeType="neutral"
            href="/admin/verifications"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Recent Activity */}
          <div className="lg:col-span-2">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-bold text-gray-900">Recent Activity</h2>
                  <Button variant="outline" size="sm" href="/admin/activity">
                    View All
                    <ArrowRight className="w-4 h-4 ml-1" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {recentActivities.map((activity) => (
                    <div key={activity.id} className="flex items-start space-x-3 p-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                        activity.color === 'blue' ? 'bg-blue-100 text-blue-600' :
                        activity.color === 'green' ? 'bg-green-100 text-green-600' :
                        activity.color === 'purple' ? 'bg-purple-100 text-purple-600' :
                        'bg-orange-100 text-orange-600'
                      }`}>
                        <activity.icon className="w-4 h-4" />
                      </div>
                      <div className="flex-1">
                        <p className="font-medium text-gray-900">{activity.title}</p>
                        <p className="text-sm text-gray-600">{activity.description}</p>
                        <p className="text-xs text-gray-500 mt-1">{activity.time}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Pending Actions */}
          <div>
            <Card>
              <CardHeader>
                <h2 className="text-xl font-bold text-gray-900">Pending Actions</h2>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {pendingActions.map((action) => (
                    <div key={action.id} className="p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                      <div className="flex items-center justify-between mb-2">
                        <h3 className="font-medium text-gray-900">{action.title}</h3>
                        <Badge 
                          variant={action.color === 'red' ? 'danger' : action.color === 'orange' ? 'warning' : 'default'}
                          size="sm"
                        >
                          {action.count}
                        </Badge>
                      </div>
                      <p className="text-sm text-gray-600 mb-3">{action.description}</p>
                      <Button size="sm" variant="outline" href={action.href}>
                        <Eye className="w-4 h-4 mr-1" />
                        Review
                      </Button>
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
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/admin/users"
              >
                <Users className="w-6 h-6" />
                <span>Manage Users</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/admin/verifications"
              >
                <CheckCircle className="w-6 h-6" />
                <span>Verify Alumni</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/admin/analytics"
              >
                <BarChart3 className="w-6 h-6" />
                <span>View Analytics</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-20 flex-col space-y-2"
                href="/admin/settings"
              >
                <Settings className="w-6 h-6" />
                <span>Settings</span>
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* System Status */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <Card>
            <CardHeader>
              <h2 className="text-xl font-bold text-gray-900">System Status</h2>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                    <span className="text-sm font-medium text-gray-900">Database</span>
                  </div>
                  <Badge variant="success" size="sm">Online</Badge>
                </div>
                
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                    <span className="text-sm font-medium text-gray-900">Authentication</span>
                  </div>
                  <Badge variant="success" size="sm">Online</Badge>
                </div>
                
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                    <span className="text-sm font-medium text-gray-900">Email Service</span>
                  </div>
                  <Badge variant="success" size="sm">Online</Badge>
                </div>
                
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                    <span className="text-sm font-medium text-gray-900">File Storage</span>
                  </div>
                  <Badge variant="warning" size="sm">Maintenance</Badge>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <h2 className="text-xl font-bold text-gray-900">Performance Metrics</h2>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">Response Time</span>
                  <span className="text-sm text-gray-600">125ms</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-green-600 h-2 rounded-full" style={{ width: '85%' }}></div>
                </div>
                
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">Uptime</span>
                  <span className="text-sm text-gray-600">99.9%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-blue-600 h-2 rounded-full" style={{ width: '99%' }}></div>
                </div>
                
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">Server Load</span>
                  <span className="text-sm text-gray-600">45%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div className="bg-yellow-600 h-2 rounded-full" style={{ width: '45%' }}></div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </AdminLayout>
  )
}
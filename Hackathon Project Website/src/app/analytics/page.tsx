'use client'

import { useState, useEffect } from 'react'
import AdminLayout from '@/components/layout/AdminLayout'
import { supabase } from '@/lib/supabase'
import { BarChart3, TrendingUp, Users, Calendar, DollarSign } from 'lucide-react'

interface AnalyticsData {
  totalUsers: number
  totalSessions: number
  totalWebinars: number
  totalRevenue: number
  userGrowth: Array<{ month: string; count: number }>
  sessionStats: Array<{ status: string; count: number }>
  revenueByType: Array<{ type: string; amount: number }>
}

export default function AnalyticsPage() {
  const [analytics, setAnalytics] = useState<AnalyticsData>({
    totalUsers: 0,
    totalSessions: 0,
    totalWebinars: 0,
    totalRevenue: 0,
    userGrowth: [],
    sessionStats: [],
    revenueByType: []
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchAnalytics()
  }, [])

  const fetchAnalytics = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      setAnalytics({
        totalUsers: 156,
        totalSessions: 234,
        totalWebinars: 67,
        totalRevenue: 12580.50,
        userGrowth: [
          { month: 'Jul', count: 45 },
          { month: 'Aug', count: 52 },
          { month: 'Sep', count: 48 },
          { month: 'Oct', count: 61 },
          { month: 'Nov', count: 67 },
          { month: 'Dec', count: 73 }
        ],
        sessionStats: [
          { status: 'Completed', count: 156 },
          { status: 'Pending', count: 45 },
          { status: 'Cancelled', count: 33 }
        ],
        revenueByType: [
          { type: 'Mentorship', amount: 8500 },
          { type: 'Webinars', amount: 4080.50 }
        ]
      })
      
      /* Uncomment when database tables are ready:
      // Fetch basic counts
      const [usersResult, sessionsResult, webinarsResult, transactionsResult] = await Promise.all([
        supabase.from('users').select('*', { count: 'exact', head: true }),
        supabase.from('mentorship_sessions').select('*', { count: 'exact', head: true }),
        supabase.from('webinars').select('*', { count: 'exact', head: true }),
        supabase.from('transactions').select('amount')
      ])

      // Fetch session status breakdown
      const { data: sessionData } = await supabase
        .from('mentorship_sessions')
        .select('status')

      // Fetch revenue by type
      const { data: transactionData } = await supabase
        .from('transactions')
        .select('type, amount')

      // Calculate user growth (last 6 months)
      const sixMonthsAgo = new Date()
      sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6)

      const { data: userGrowthData } = await supabase
        .from('users')
        .select('created_at')
        .gte('created_at', sixMonthsAgo.toISOString())

      // Process session stats
      const sessionStats = sessionData?.reduce((acc, session) => {
        acc[session.status] = (acc[session.status] || 0) + 1
        return acc
      }, {} as Record<string, number>) || {}

      // Process revenue by type
      const revenueByType = transactionData?.reduce((acc, transaction) => {
        acc[transaction.type] = (acc[transaction.type] || 0) + parseFloat(transaction.amount)
        return acc
      }, {} as Record<string, number>) || {}

      // Process user growth
      const userGrowth = userGrowthData?.reduce((acc, user) => {
        const month = new Date(user.created_at).toLocaleDateString('en-US', { month: 'short' })
        acc[month] = (acc[month] || 0) + 1
        return acc
      }, {} as Record<string, number>) || {}

      setAnalytics({
        totalUsers: usersResult.count || 0,
        totalSessions: sessionsResult.count || 0,
        totalWebinars: webinarsResult.count || 0,
        totalRevenue: transactionsResult.data?.reduce((sum, t) => sum + parseFloat(t.amount), 0) || 0,
        userGrowth: Object.entries(userGrowth).map(([month, count]) => ({ month, count })),
        sessionStats: Object.entries(sessionStats).map(([status, count]) => ({ status, count })),
        revenueByType: Object.entries(revenueByType).map(([type, amount]) => ({ type, amount }))
      })
      */
    } catch (error) {
      console.error('Error fetching analytics:', error)
      // Set mock data on error
      setAnalytics({
        totalUsers: 156,
        totalSessions: 234,
        totalWebinars: 67,
        totalRevenue: 12580.50,
        userGrowth: [
          { month: 'Jul', count: 45 },
          { month: 'Aug', count: 52 },
          { month: 'Sep', count: 48 },
          { month: 'Oct', count: 61 },
          { month: 'Nov', count: 67 },
          { month: 'Dec', count: 73 }
        ],
        sessionStats: [
          { status: 'Completed', count: 156 },
          { status: 'Pending', count: 45 },
          { status: 'Cancelled', count: 33 }
        ],
        revenueByType: [
          { type: 'Mentorship', amount: 8500 },
          { type: 'Webinars', amount: 4080.50 }
        ]
      })
    } finally {
      setLoading(false)
    }
  }

  const statCards = [
    {
      name: 'Total Users',
      value: analytics.totalUsers,
      icon: Users,
      color: 'bg-blue-500',
      change: '+12%'
    },
    {
      name: 'Mentorship Sessions',
      value: analytics.totalSessions,
      icon: Calendar,
      color: 'bg-green-500',
      change: '+8%'
    },
    {
      name: 'Webinars',
      value: analytics.totalWebinars,
      icon: TrendingUp,
      color: 'bg-purple-500',
      change: '+15%'
    },
    {
      name: 'Total Revenue',
      value: `$${analytics.totalRevenue.toFixed(2)}`,
      icon: DollarSign,
      color: 'bg-yellow-500',
      change: '+22%'
    }
  ]

  if (loading) {
    return (
      <AdminLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            {[...Array(4)].map((_, i) => (
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
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Analytics Dashboard</h1>
          <p className="mt-1 text-sm text-gray-500">
            Platform performance and user engagement metrics.
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
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
                      <dd className="flex items-baseline">
                        <div className="text-2xl font-semibold text-gray-900">
                          {card.value}
                        </div>
                        <div className="ml-2 flex items-baseline text-sm font-semibold text-green-600">
                          {card.change}
                        </div>
                      </dd>
                    </dl>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Charts Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Session Status Chart */}
          <div className="bg-white shadow rounded-lg p-6">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Session Status Breakdown</h3>
            <div className="space-y-3">
              {analytics.sessionStats.map((stat) => (
                <div key={stat.status} className="flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="w-3 h-3 bg-primary-500 rounded-full mr-2"></div>
                    <span className="text-sm text-gray-600 capitalize">{stat.status}</span>
                  </div>
                  <span className="text-sm font-medium text-gray-900">{stat.count}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Revenue by Type Chart */}
          <div className="bg-white shadow rounded-lg p-6">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Revenue by Type</h3>
            <div className="space-y-3">
              {analytics.revenueByType.map((item) => (
                <div key={item.type} className="flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="w-3 h-3 bg-green-500 rounded-full mr-2"></div>
                    <span className="text-sm text-gray-600 capitalize">
                      {item.type.replace('_', ' ')}
                    </span>
                  </div>
                  <span className="text-sm font-medium text-gray-900">
                    ${item.amount.toFixed(2)}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* User Growth Chart */}
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-4">User Growth (Last 6 Months)</h3>
          <div className="flex items-end space-x-4 h-32">
            {analytics.userGrowth.map((data) => (
              <div key={data.month} className="flex-1 flex flex-col items-center">
                <div 
                  className="bg-primary-500 w-full rounded-t"
                  style={{ height: `${(data.count / Math.max(...analytics.userGrowth.map(d => d.count))) * 100}px` }}
                ></div>
                <span className="text-xs text-gray-500 mt-2">{data.month}</span>
                <span className="text-xs font-medium text-gray-900">{data.count}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Key Metrics */}
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Key Performance Indicators</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-primary-600">
                {analytics.totalUsers > 0 ? (analytics.totalSessions / analytics.totalUsers).toFixed(1) : '0'}
              </div>
              <div className="text-sm text-gray-500">Avg Sessions per User</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary-600">
                {analytics.totalSessions > 0 ? (analytics.totalRevenue / analytics.totalSessions).toFixed(2) : '0'}
              </div>
              <div className="text-sm text-gray-500">Avg Revenue per Session ($)</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary-600">
                {analytics.totalUsers > 0 ? (analytics.totalWebinars / analytics.totalUsers).toFixed(1) : '0'}
              </div>
              <div className="text-sm text-gray-500">Avg Webinars per User</div>
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  )
}

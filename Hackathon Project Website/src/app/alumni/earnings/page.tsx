'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { DollarSign, TrendingUp, Calendar, CreditCard, Download, Filter, Eye } from 'lucide-react'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'

interface Earning {
  id: number
  date: string
  source: string
  description: string
  amount: number
  status: 'pending' | 'completed' | 'failed'
  type: 'mentorship' | 'webinar' | 'referral' | 'other'
}

interface EarningsStats {
  totalEarnings: number
  thisMonth: number
  lastMonth: number
  pendingAmount: number
  completedSessions: number
}

export default function AlumniEarningsPage() {
  const [earnings, setEarnings] = useState<Earning[]>([])
  const [stats, setStats] = useState<EarningsStats>({
    totalEarnings: 0,
    thisMonth: 0,
    lastMonth: 0,
    pendingAmount: 0,
    completedSessions: 0
  })
  const [loading, setLoading] = useState(true)
  const [filterStatus, setFilterStatus] = useState('all')
  const [filterType, setFilterType] = useState('all')

  useEffect(() => {
    fetchEarnings()
  }, [])

  const fetchEarnings = async () => {
    try {
      // Mock data - replace with actual Supabase queries
      const mockEarnings: Earning[] = [
        {
          id: 1,
          date: '2024-01-15',
          source: 'Mentorship Session',
          description: '1-on-1 session with Arjun Sharma',
          amount: 500,
          status: 'completed',
          type: 'mentorship'
        },
        {
          id: 2,
          date: '2024-01-20',
          source: 'Webinar Hosting',
          description: 'React Best Practices Webinar',
          amount: 1000,
          status: 'completed',
          type: 'webinar'
        },
        {
          id: 3,
          date: '2024-01-25',
          source: 'Job Referral',
          description: 'Successfully referred Priya Patel to Google',
          amount: 2000,
          status: 'completed',
          type: 'referral'
        },
        {
          id: 4,
          date: '2024-01-28',
          source: 'Mentorship Session',
          description: 'Career guidance with Raj Kumar',
          amount: 500,
          status: 'pending',
          type: 'mentorship'
        },
        {
          id: 5,
          date: '2024-01-30',
          source: 'Workshop Session',
          description: 'Advanced JavaScript Workshop',
          amount: 750,
          status: 'completed',
          type: 'webinar'
        }
      ]

      setEarnings(mockEarnings)

      // Calculate stats
      const totalEarnings = mockEarnings
        .filter(e => e.status === 'completed')
        .reduce((sum, earning) => sum + earning.amount, 0)

      const thisMonth = mockEarnings
        .filter(e => e.status === 'completed' && new Date(e.date).getMonth() === new Date().getMonth())
        .reduce((sum, earning) => sum + earning.amount, 0)

      const pendingAmount = mockEarnings
        .filter(e => e.status === 'pending')
        .reduce((sum, earning) => sum + earning.amount, 0)

      const completedSessions = mockEarnings
        .filter(e => e.status === 'completed').length

      setStats({
        totalEarnings,
        thisMonth,
        lastMonth: 12500, // Mock previous month
        pendingAmount,
        completedSessions
      })
    } catch (error) {
      console.error('Error fetching earnings:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed':
        return 'bg-green-100 text-green-800'
      case 'pending':
        return 'bg-yellow-100 text-yellow-800'
      case 'failed':
        return 'bg-red-100 text-red-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'mentorship':
        return 'bg-blue-100 text-blue-800'
      case 'webinar':
        return 'bg-purple-100 text-purple-800'
      case 'referral':
        return 'bg-green-100 text-green-800'
      case 'other':
        return 'bg-gray-100 text-gray-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR'
    }).format(amount)
  }

  const filteredEarnings = earnings.filter(earning => {
    const statusMatch = filterStatus === 'all' || earning.status === filterStatus
    const typeMatch = filterType === 'all' || earning.type === filterType
    return statusMatch && typeMatch
  })

  const statCards = [
    {
      title: 'Total Earnings',
      value: formatCurrency(stats.totalEarnings),
      icon: DollarSign,
      color: 'bg-green-500'
    },
    {
      title: 'This Month',
      value: formatCurrency(stats.thisMonth),
      icon: TrendingUp,
      color: 'bg-blue-500'
    },
    {
      title: 'Pending',
      value: formatCurrency(stats.pendingAmount),
      icon: Calendar,
      color: 'bg-yellow-500'
    },
    {
      title: 'Completed Sessions',
      value: stats.completedSessions.toString(),
      icon: TrendingUp,
      color: 'bg-purple-500'
    }
  ]

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
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
        {/* Header */}
        <div className="bg-gradient-to-r from-green-600 to-blue-700 rounded-xl px-8 py-10 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold mb-2">Earnings Overview</h1>
              <p className="text-blue-100">
                Track your mentorship earnings and payments
              </p>
            </div>
            <CreditCard className="w-16 h-16 opacity-20" />
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {statCards.map((stat, index) => (
            <Card key={index} className="p-6">
              <div className="flex items-center">
                <div className={`p-3 rounded-full ${stat.color} text-white mr-4`}>
                  <stat.icon className="w-6 h-6" />
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-600">{stat.title}</p>
                  <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
                </div>
              </div>
            </Card>
          ))}
        </div>

        {/* Filters */}
        <Card className="p-6">
          <div className="flex flex-wrap gap-4">
            <div className="flex items-center space-x-2">
              <Filter className="w-5 h-5 text-gray-500" />
              <span className="text-sm font-medium text-gray-700">Filters:</span>
            </div>
            
            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="all">All Status</option>
              <option value="completed">Completed</option>
              <option value="pending">Pending</option>
              <option value="failed">Failed</option>
            </select>

            <select
              value={filterType}
              onChange={(e) => setFilterType(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="all">All Types</option>
              <option value="mentorship">Mentorship</option>
              <option value="webinar">Webinar</option>
              <option value="referral">Referral</option>
              <option value="other">Other</option>
            </select>

            <Button className="ml-auto" variant="outline">
              <Download className="w-4 h-4 mr-2" />
              Export
            </Button>
          </div>
        </Card>

        {/* Earnings Table */}
        <Card className="overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900">Recent Earnings</h2>
          </div>
          
          {filteredEarnings.length === 0 ? (
            <div className="p-12 text-center">
              <DollarSign className="w-16 h-16 mx-auto text-gray-400 mb-4" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">
                No earnings found
              </h3>
              <p className="text-gray-500">
                Complete mentorship sessions to start earning
              </p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Date & Source
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Description
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Type
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Amount
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {filteredEarnings.map((earning) => (
                    <tr key={earning.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div>
                          <p className="text-sm font-medium text-gray-900">
                            {new Date(earning.date).toLocaleDateString()}
                          </p>
                          <p className="text-sm text-gray-500">{earning.source}</p>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <p className="text-sm text-gray-900 max-w-xs truncate">
                          {earning.description}
                        </p>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <Badge className={getTypeColor(earning.type)}>
                          {earning.type.charAt(0).toUpperCase() + earning.type.slice(1)}
                        </Badge>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <Badge className={getStatusColor(earning.status)}>
                          {earning.status.charAt(0).toUpperCase() + earning.status.slice(1)}
                        </Badge>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-gray-900">
                        {formatCurrency(earning.amount)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <Button size="sm" variant="outline">
                          <Eye className="w-4 h-4" />
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      </div>
    </DashboardLayout>
  )
}

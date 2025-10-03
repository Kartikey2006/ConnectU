'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Briefcase, User, Calendar, CheckCircle, XCircle, Clock } from 'lucide-react'
import toast from 'react-hot-toast'

interface Referral {
  id: number
  student_id: number
  alumni_id: number
  status: 'pending' | 'accepted' | 'rejected'
  created_at: string
  student?: {
    name: string
    email: string
  }
  alumni?: {
    name: string
    email: string
  }
}

export default function ReferralsPage() {
  const [referrals, setReferrals] = useState<Referral[]>([])
  const [loading, setLoading] = useState(true)
  const [userRole, setUserRole] = useState<string>('')
  const [showCreateForm, setShowCreateForm] = useState(false)
  const [formData, setFormData] = useState({
    alumni_id: '',
    message: ''
  })

  useEffect(() => {
    fetchReferrals()
    getUserRole()
  }, [])

  const getUserRole = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        setUserRole(user.user_metadata?.role || 'student')
      }
    } catch (error) {
      console.error('Error getting user role:', error)
    }
  }

  const fetchReferrals = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const userRole = user.user_metadata?.role || 'student'

      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockReferrals: Referral[] = userRole === 'student' ? [
        {
          id: 1,
          student_id: Number(user.id),
          alumni_id: 1,
          status: 'pending',
          created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(), // 2 days ago
          alumni: { name: 'Arjun Sharma', email: 'arjun@example.com' }
        },
        {
          id: 2,
          student_id: Number(user.id),
          alumni_id: 2,
          status: 'accepted',
          created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(), // 5 days ago
          alumni: { name: 'Priya Patel', email: 'priya@example.com' }
        }
      ] : [
        {
          id: 3,
          student_id: 1,
          alumni_id: Number(user.id),
          status: 'pending',
          created_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(), // 1 day ago
          student: { name: 'Akash Verma', email: 'akash@example.com' }
        },
        {
          id: 4,
          student_id: 2,
          alumni_id: Number(user.id),
          status: 'accepted',
          created_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(), // 3 days ago
          student: { name: 'Neha Gupta', email: 'neha@example.com' }
        }
      ]

      setReferrals(mockReferrals)
      
      /* Uncomment when database tables are ready:
      let query = supabase
        .from('referrals')
        .select(`
          *,
          student:student_id (name, email),
          alumni:alumni_id (name, email)
        `)

      if (userRole === 'student') {
        query = query.eq('student_id', user.id)
      } else if (userRole === 'alumni') {
        query = query.eq('alumni_id', user.id)
      }

      const { data, error } = await query.order('created_at', { ascending: false })

      if (error) {
        toast.error('Failed to fetch referrals')
        return
      }

      setReferrals(data || [])
      */
    } catch (error) {
      console.error('Error fetching referrals:', error)
      toast.error('An error occurred')
      // Set empty array on error
      setReferrals([])
    } finally {
      setLoading(false)
    }
  }

  const handleCreateReferral = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { error } = await supabase
        .from('referrals')
        .insert({
          student_id: Number(user.id),
          alumni_id: parseInt(formData.alumni_id),
          status: 'pending'
        })

      if (error) {
        toast.error('Failed to create referral request')
        return
      }

      toast.success('Referral request sent!')
      setShowCreateForm(false)
      setFormData({ alumni_id: '', message: '' })
      fetchReferrals()
    } catch (error) {
      toast.error('An error occurred')
    }
  }

  const handleUpdateReferralStatus = async (referralId: number, status: 'accepted' | 'rejected') => {
    try {
      const { error } = await supabase
        .from('referrals')
        .update({ status })
        .eq('id', referralId)

      if (error) {
        toast.error('Failed to update referral status')
        return
      }

      toast.success(`Referral ${status}!`)
      fetchReferrals()
    } catch (error) {
      toast.error('An error occurred')
    }
  }

  const getAvailableAlumni = async () => {
    try {
      // For now, return mock alumni data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockAlumni = [
        {
          id: 1,
          name: 'Arjun Sharma',
          email: 'arjun@example.com',
          alumnidetails: {
            company: 'Google',
            designation: 'Senior Software Engineer',
            verification_status: true
          }
        },
        {
          id: 2,
          name: 'Priya Patel',
          email: 'priya@example.com',
          alumnidetails: {
            company: 'Microsoft',
            designation: 'Product Manager',
            verification_status: true
          }
        },
        {
          id: 3,
          name: 'Rajesh Kumar',
          email: 'rajesh@example.com',
          alumnidetails: {
            company: 'Amazon',
            designation: 'Data Scientist',
            verification_status: true
          }
        }
      ]

      return mockAlumni
      
      /* Uncomment when database tables are ready:
      const { data, error } = await supabase
        .from('users')
        .select(`
          id,
          name,
          email,
          alumnidetails (company, designation, verification_status)
        `)
        .eq('role', 'alumni')
        .eq('alumnidetails.verification_status', true)

      if (error) {
        toast.error('Failed to fetch alumni')
        return
      }

      return data || []
      */
    } catch (error) {
      console.error('Error fetching alumni:', error)
      return []
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'accepted':
        return <CheckCircle className="h-4 w-4 text-green-500" />
      case 'rejected':
        return <XCircle className="h-4 w-4 text-red-500" />
      default:
        return <Clock className="h-4 w-4 text-yellow-500" />
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'accepted':
        return 'bg-green-100 text-green-800'
      case 'rejected':
        return 'bg-red-100 text-red-800'
      default:
        return 'bg-yellow-100 text-yellow-800'
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
                <div className="h-4 bg-gray-200 rounded w-1/4"></div>
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
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Job Referrals</h1>
            <p className="mt-1 text-sm text-gray-500">
              Request job referrals from alumni or manage referral requests.
            </p>
          </div>
          {userRole === 'student' && (
            <button
              onClick={() => setShowCreateForm(true)}
              className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
            >
              Request Referral
            </button>
          )}
        </div>

        {/* Create Referral Form */}
        {showCreateForm && (
          <div className="bg-white rounded-lg shadow-md p-6">
            <h2 className="text-lg font-medium text-gray-900 mb-4">Request Job Referral</h2>
            <form onSubmit={handleCreateReferral}>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Select Alumni
                  </label>
                  <select
                    value={formData.alumni_id}
                    onChange={(e) => setFormData({ ...formData, alumni_id: e.target.value })}
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                  >
                    <option value="">Choose an alumni...</option>
                    {/* This would be populated with available alumni */}
                    <option value="1">John Doe - Google</option>
                    <option value="2">Jane Smith - Microsoft</option>
                    <option value="3">Mike Johnson - Amazon</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Message (Optional)
                  </label>
                  <textarea
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    rows={3}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                    placeholder="Briefly describe your background and the type of role you're looking for..."
                  />
                </div>
              </div>
              <div className="mt-4 flex space-x-2">
                <button
                  type="submit"
                  className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
                >
                  Send Request
                </button>
                <button
                  type="button"
                  onClick={() => setShowCreateForm(false)}
                  className="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 transition-colors"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Referrals List */}
        <div className="space-y-4">
          {referrals.length === 0 ? (
            <div className="text-center py-12">
              <Briefcase className="mx-auto h-12 w-12 text-gray-400" />
              <h3 className="mt-2 text-sm font-medium text-gray-900">No referrals</h3>
              <p className="mt-1 text-sm text-gray-500">
                {userRole === 'student' 
                  ? 'Start by requesting a job referral from alumni.' 
                  : 'No referral requests at the moment.'}
              </p>
            </div>
          ) : (
            referrals.map((referral) => (
              <div key={referral.id} className="bg-white rounded-lg shadow-md p-6">
                <div className="flex items-start justify-between">
                  <div className="flex items-start">
                    <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                      <User className="h-5 w-5 text-primary-600" />
                    </div>
                    <div className="ml-4">
                      <h3 className="text-lg font-medium text-gray-900">
                        {userRole === 'student' 
                          ? `Referral request to ${referral.alumni?.name}`
                          : `Referral request from ${referral.student?.name}`}
                      </h3>
                      <p className="text-sm text-gray-500">
                        {userRole === 'student' 
                          ? referral.alumni?.email 
                          : referral.student?.email}
                      </p>
                      <div className="mt-2 flex items-center">
                        <Calendar className="h-4 w-4 mr-1 text-gray-400" />
                        <span className="text-sm text-gray-500">
                          {new Date(referral.created_at).toLocaleDateString()}
                        </span>
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex items-center space-x-3">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusColor(referral.status)}`}>
                      {getStatusIcon(referral.status)}
                      <span className="ml-1 capitalize">{referral.status}</span>
                    </span>
                    
                    {userRole === 'alumni' && referral.status === 'pending' && (
                      <div className="flex space-x-2">
                        <button
                          onClick={() => handleUpdateReferralStatus(referral.id, 'accepted')}
                          className="bg-green-600 text-white px-3 py-1 rounded-md hover:bg-green-700 transition-colors text-sm"
                        >
                          Accept
                        </button>
                        <button
                          onClick={() => handleUpdateReferralStatus(referral.id, 'rejected')}
                          className="bg-red-600 text-white px-3 py-1 rounded-md hover:bg-red-700 transition-colors text-sm"
                        >
                          Reject
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </DashboardLayout>
  )
}

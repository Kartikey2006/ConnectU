'use client'

import { useState, useEffect } from 'react'
import AdminLayout from '@/components/layout/AdminLayout'
import { UserCheck, UserX, Clock, Search, CheckCircle, XCircle, Eye } from 'lucide-react'

interface VerificationRequest {
  id: number
  user_id: number
  name: string
  email: string
  company: string
  designation: string
  linkedin_url: string
  verification_status: boolean
  submitted_at: string
  documents?: string[]
}

export default function AdminVerificationsPage() {
  const [verifications, setVerifications] = useState<VerificationRequest[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState('')

  useEffect(() => {
    // Set mock data immediately for faster loading
    const mockVerifications: VerificationRequest[] = [
      {
        id: 1,
        user_id: 1,
        name: 'Arjun Sharma',
        email: 'arjun@example.com',
        company: 'Google',
        designation: 'Senior Software Engineer',
        linkedin_url: 'https://linkedin.com/in/arjunsharma',
        verification_status: false,
        submitted_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
        documents: ['employment_letter.pdf', 'linkedin_profile.pdf']
      },
      {
        id: 2,
        user_id: 2,
        name: 'Priya Patel',
        email: 'priya@example.com',
        company: 'Microsoft',
        designation: 'Product Manager',
        linkedin_url: 'https://linkedin.com/in/priyapatel',
        verification_status: true,
        submitted_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
        documents: ['employment_letter.pdf', 'linkedin_profile.pdf']
      },
      {
        id: 3,
        user_id: 3,
        name: 'Rajesh Kumar',
        email: 'rajesh@example.com',
        company: 'Amazon',
        designation: 'Data Scientist',
        linkedin_url: 'https://linkedin.com/in/rajeshkumar',
        verification_status: false,
        submitted_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
        documents: ['employment_letter.pdf', 'linkedin_profile.pdf']
      }
    ]
    
    setVerifications(mockVerifications)
    setLoading(false)
  }, [])

  const filteredVerifications = verifications.filter(verification => {
    const matchesSearch = !searchTerm || 
      verification.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      verification.company.toLowerCase().includes(searchTerm.toLowerCase()) ||
      verification.email.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesStatus = !statusFilter || 
      (statusFilter === 'pending' && !verification.verification_status) ||
      (statusFilter === 'verified' && verification.verification_status)
    
    return matchesSearch && matchesStatus
  })

  const handleVerify = async (id: number, status: boolean) => {
    // Update verification status
    setVerifications(prev => 
      prev.map(v => v.id === id ? { ...v, verification_status: status } : v)
    )
    // Show success message
  }

  const getStatusBadge = (status: boolean) => {
    return status 
      ? 'bg-green-100 text-green-800'
      : 'bg-yellow-100 text-yellow-800'
  }

  const getStatusIcon = (status: boolean) => {
    return status ? <CheckCircle className="h-4 w-4" /> : <Clock className="h-4 w-4" />
  }

  if (loading) {
    return (
      <AdminLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="space-y-4">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="bg-white p-6 rounded-lg shadow">
                <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
                <div className="h-4 bg-gray-200 rounded w-1/4"></div>
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
          <h1 className="text-2xl font-bold text-gray-900">Verification Management</h1>
          <p className="mt-1 text-sm text-gray-500">
            Review and approve alumni verification requests.
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <UserCheck className="h-8 w-8 text-blue-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">{verifications.length}</div>
                <div className="text-sm text-gray-500">Total Requests</div>
              </div>
            </div>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <Clock className="h-8 w-8 text-yellow-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">
                  {verifications.filter(v => !v.verification_status).length}
                </div>
                <div className="text-sm text-gray-500">Pending</div>
              </div>
            </div>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex items-center">
              <CheckCircle className="h-8 w-8 text-green-500" />
              <div className="ml-4">
                <div className="text-2xl font-bold text-gray-900">
                  {verifications.filter(v => v.verification_status).length}
                </div>
                <div className="text-sm text-gray-500">Verified</div>
              </div>
            </div>
          </div>
        </div>

        {/* Filters */}
        <div className="bg-white p-4 rounded-lg shadow">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="Search verifications..."
                  className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 text-gray-900 focus:outline-none focus:ring-2 focus:ring-red-500"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
            </div>
            <div className="sm:w-48">
              <select
                className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-500"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="">All Status</option>
                <option value="pending">Pending</option>
                <option value="verified">Verified</option>
              </select>
            </div>
          </div>
        </div>

        {/* Verification Requests */}
        <div className="bg-white shadow rounded-lg overflow-hidden">
          <div className="px-4 py-5 sm:p-6">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      User Details
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Company Info
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Documents
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Submitted
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {filteredVerifications.map((verification) => (
                    <tr key={verification.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div>
                          <div className="text-sm font-medium text-gray-900">{verification.name}</div>
                          <div className="text-sm text-gray-500">{verification.email}</div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div>
                          <div className="text-sm font-medium text-gray-900">{verification.company}</div>
                          <div className="text-sm text-gray-500">{verification.designation}</div>
                          {verification.linkedin_url && (
                            <a 
                              href={verification.linkedin_url} 
                              target="_blank" 
                              rel="noopener noreferrer"
                              className="text-xs text-blue-600 hover:text-blue-800"
                            >
                              LinkedIn Profile
                            </a>
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">
                          {verification.documents?.length || 0} documents
                        </div>
                        <button className="text-xs text-blue-600 hover:text-blue-800">
                          <Eye className="h-3 w-3 inline mr-1" />
                          View
                        </button>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusBadge(verification.verification_status)}`}>
                          {getStatusIcon(verification.verification_status)}
                          <span className="ml-1">
                            {verification.verification_status ? 'Verified' : 'Pending'}
                          </span>
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(verification.submitted_at).toLocaleDateString()}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        {!verification.verification_status ? (
                          <div className="flex space-x-2">
                            <button
                              onClick={() => handleVerify(verification.id, true)}
                              className="text-green-600 hover:text-green-900 flex items-center"
                            >
                              <CheckCircle className="h-4 w-4 mr-1" />
                              Approve
                            </button>
                            <button
                              onClick={() => handleVerify(verification.id, false)}
                              className="text-red-600 hover:text-red-900 flex items-center"
                            >
                              <XCircle className="h-4 w-4 mr-1" />
                              Reject
                            </button>
                          </div>
                        ) : (
                          <span className="text-green-600">Verified</span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  )
}

'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { FileText, Download, Upload, Trash2, Eye, Search, Filter, FolderOpen, Clock, CheckCircle } from 'lucide-react'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'

interface Document {
  id: number
  name: string
  type: 'certificate' | 'resume' | 'portfolio' | 'certification' | 'achievement' | 'other'
  description: string
  fileSize: string
  uploadDate: string
  status: 'verified' | 'pending' | 'rejected'
  downloadUrl?: string
  thumbnailUrl?: string
}

interface DocumentStats {
  totalDocuments: number
  verifiedDocuments: number
  pendingDocuments: number
  storageUsed: string
}

export default function AlumniDocumentsPage() {
  const [documents, setDocuments] = useState<Document[]>([])
  const [filteredDocuments, setFilteredDocuments] = useState<Document[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [filterType, setFilterType] = useState('all')
  const [filterStatus, setFilterStatus] = useState('all')

  useEffect(() => {
    fetchDocuments()
  }, [])

  useEffect(() => {
    filterDocuments()
  }, [documents, searchTerm, filterType, filterStatus])

  const fetchDocuments = async () => {
    try {
      // Mock data - replace with actual Supabase queries
      const mockDocuments: Document[] = [
        {
          id: 1,
          name: 'BTech Certificate.pdf',
          type: 'certificate',
          description: 'B.Tech Computer Science Degree Certificate',
          fileSize: '2.3 MB',
          uploadDate: '2024-01-15',
          status: 'verified'
        },
        {
          id: 2,
          name: 'Resume_Updated_2024.pdf',
          type: 'resume',
          description: 'Latest resume with recent experience',
          fileSize: '1.8 MB',
          uploadDate: '2024-01-20',
          status: 'verified'
        },
        {
          id: 3,
          name: 'Portfolio_Projects.zip',
          type: 'portfolio',
          description: 'Collection of personal and professional projects',
          fileSize: '15.2 MB',
          uploadDate: '2024-01-25',
          status: 'verified'
        },
        {
          id: 4,
          name: 'AWS_Certification.pdf',
          type: 'certification',
          description: 'AWS Solutions Architect Associate Certification',
          fileSize: '3.1 MB',
          uploadDate: '2024-01-28',
          status: 'pending'
        },
        {
          id: 5,
          name: 'Job_Achievement_Letter.pdf',
          type: 'achievement',
          description: 'Employee of the Year 2023',
          fileSize: '456 KB',
          uploadDate: '2024-01-30',
          status: 'verified'
        },
        {
          id: 6,
          name: 'Cover_Letter_Template.pdf',
          type: 'other',
          description: 'Professional cover letter template',
          fileSize: '234 KB',
          uploadDate: '2024-02-01',
          status: 'rejected'
        }
      ]

      setDocuments(mockDocuments)

      // Calculate stats
      const verifiedDocuments = mockDocuments.filter(doc => doc.status === 'verified').length
      const pendingDocuments = mockDocuments.filter(doc => doc.status === 'pending').length
      const totalSize = mockDocuments.reduce((total, doc) => {
        const sizeInMB = parseFloat(doc.fileSize.replace(' MB', '').replace(' KB', ''))
        return total + (doc.fileSize.includes(' MB') ? sizeInMB : sizeInMB / 1024)
      }, 0)

      setStats({
        totalDocuments: mockDocuments.length,
        verifiedDocuments,
        pendingDocuments,
        storageUsed: `${totalSize.toFixed(1)} MB`
      })
    } catch (error) {
      console.error('Error fetching documents:', error)
    } finally {
      setLoading(false)
    }
  }

  const [stats, setStats] = useState<DocumentStats>({
    totalDocuments: 0,
    verifiedDocuments: 0,
    pendingDocuments: 0,
    storageUsed: '0 MB'
  })

  const filterDocuments = () => {
    let filtered = [...documents]

    // Search filter
    if (searchTerm) {
      filtered = filtered.filter(doc =>
        doc.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        doc.description.toLowerCase().includes(searchTerm.toLowerCase())
      )
    }

    // Type filter
    if (filterType !== 'all') {
      filtered = filtered.filter(doc => doc.type === filterType)
    }

    // Status filter
    if (filterStatus !== 'all') {
      filtered = filtered.filter(doc => doc.status === filterStatus)
    }

    setFilteredDocuments(filtered)
  }

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'certificate':
        return '🎓'
      case 'resume':
        return '📋'
      case 'portfolio':
        return '💼'
      case 'certification':
        return '🏆'
      case 'achievement':
        return '⭐'
      default:
        return '📄'
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'verified':
        return 'bg-green-100 text-green-800'
      case 'pending':
        return 'bg-yellow-100 text-yellow-800'
      case 'rejected':
        return 'bg-red-100 text-red-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'verified':
        return <CheckCircle className="w-4 h-4" />
      case 'pending':
        return <Clock className="w-4 h-4" />
      case 'rejected':
        return <Trash2 className="w-4 h-4" />
      default:
        return <FileText className="w-4 h-4" />
    }
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-IN', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }

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

  const statCards = [
    {
      title: 'Total Documents',
      value: stats.totalDocuments,
      icon: FileText,
      color: 'bg-blue-500'
    },
    {
      title: 'Verified',
      value: stats.verifiedDocuments,
      icon: CheckCircle,
      color: 'bg-green-500'
    },
    {
      title: 'Pending',
      value: stats.pendingDocuments,
      icon: Clock,
      color: 'bg-yellow-500'
    },
    {
      title: 'Storage Used',
      value: stats.storageUsed,
      icon: FolderOpen,
      color: 'bg-purple-500'
    }
  ]

  return (
    <DashboardLayout>
      <div className="space-y-8">
        {/* Header */}
        <div className="bg-gradient-to-r from-purple-600 to-indigo-700 rounded-xl px-8 py-10 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold mb-2">Documents Management</h1>
              <p className="text-purple-100">
                Organize and manage your academic and professional documents
              </p>
            </div>
            <FileText className="w-16 h-16 opacity-20" />
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

        {/* Search & Filters */}
        <Card className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-center">
            <div className="relative">
              <Search className="absolute left-3 top-3 text-gray-400 w-5 h-5" />
              <input
                type="text"
                placeholder="Search documents..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            
            <select
              value={filterType}
              onChange={(e) => setFilterType(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="all">All Types</option>
              <option value="certificate">Certificate</option>
              <option value="resume">Resume</option>
              <option value="portfolio">Portfolio</option>
              <option value="certification">Certification</option>
              <option value="achievement">Achievement</option>
              <option value="other">Other</option>
            </select>

            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="all">All Status</option>
              <option value="verified">Verified</option>
              <option value="pending">Pending</option>
              <option value="rejected">Rejected</option>
            </select>

            <Button className="w-full">
              <Upload className="w-4 h-4 mr-2" />
              Upload New
            </Button>
          </div>
        </Card>

        {/* Documents Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredDocuments.map((document) => (
            <Card key={document.id} className="p-6 hover:shadow-lg transition-shadow">
              <div className="flex items-start space-x-4">
                <div className="text-3xl">
                  {getTypeIcon(document.type)}
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 mb-1 truncate">
                    {document.name}
                  </h3>
                  <p className="text-sm text-gray-600 mb-2 line-clamp-2">
                    {document.description}
                  </p>
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-xs text-gray-500">
                      {document.fileSize}
                    </span>
                    <span className="text-xs text-gray-500">
                      {formatDate(document.uploadDate)}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <Badge className={`${getStatusColor(document.status)} text-xs flex items-center gap-1`}>
                      {getStatusIcon(document.status)}
                      {document.status.charAt(0).toUpperCase() + document.status.slice(1)}
                    </Badge>
                    <div className="flex space-x-2">
                      <Button size="sm" variant="outline">
                        <Eye className="w-4 h-4" />
                      </Button>
                      <Button size="sm" variant="outline">
                        <Download className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </div>
              </div>
            </Card>
          ))}
        </div>

        {filteredDocuments.length === 0 && (
          <Card className="p-12 text-center">
            <FileText className="w-16 h-16 mx-auto text-gray-400 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">
              No documents found
            </h3>
            <p className="text-gray-500 mb-4">
              Upload documents to build your professional portfolio
            </p>
            <Button>
              <Upload className="w-4 h-4 mr-2" />
              Upload Your First Document
            </Button>
          </Card>
        )}
      </div>
    </DashboardLayout>
  )
}

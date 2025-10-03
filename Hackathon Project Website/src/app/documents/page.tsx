'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Card, CardContent } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { 
  FileText, 
  Upload, 
  Download, 
  Eye, 
  Trash2, 
  Edit, 
  Cloud,
  User,
  Calendar,
  File,
  Image
} from 'lucide-react'
import toast from 'react-hot-toast'

interface Document {
  id: number
  title: string
  file_name: string
  file_size: number
  file_type: string
  file_url: string
  document_type: 'resume' | 'portfolio' | 'certificate' | 'cover_letter' | 'other'
  created_at: string
  updated_at: string
  is_public: boolean
}

export default function DocumentsPage() {
  const [documents, setDocuments] = useState<Document[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')
  const [showUploadModal, setShowUploadModal] = useState(false)
  const [uploading, setUploading] = useState(false)
  const [selectedFile, setSelectedFile] = useState<File | null>(null)

  useEffect(() => {
    fetchDocuments()
  }, [])

  const fetchDocuments = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockDocuments: Document[] = [
        {
          id: 1,
          title: 'Resume - Software Engineer',
          file_name: 'resume_arjun_sharma.pdf',
          file_size: 245760,
          file_type: 'pdf',
          file_url: '#',
          document_type: 'resume',
          created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
          updated_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
          is_public: true
        },
        {
          id: 2,
          title: 'Portfolio Project Descriptions',
          file_name: 'portfolio_projects.docx',
          file_size: 128000,
          file_type: 'docx',
          file_url: '#',
          document_type: 'portfolio',
          created_at: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString(),
          updated_at: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
          is_public: false
        },
        {
          id: 3,
          title: 'AWS Certification',
          file_name: 'aws_cloud_practitioner.pdf',
          file_size: 512000,
          file_type: 'pdf',
          file_url: '#',
          document_type: 'certificate',
          created_at: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
          updated_at: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
          is_public: true
        }
      ]

      setDocuments(mockDocuments)
      
      /* Uncomment when database tables are ready:
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { data, error } = await supabase
        .from('user_documents')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('Error fetching documents:', error)
        toast.error('Error loading documents')
        return
      }

      setDocuments(data || [])
      */
    } catch (error) {
      console.error('Error fetching documents:', error)
      toast.error('Error loading documents')
      setDocuments([])
    } finally {
      setLoading(false)
    }
  }

  const handleFileUpload = async (file: File, documentType: string) => {
    setUploading(true)
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) {
        toast.error('Please log in to upload documents')
        return
      }

      const fileExt = file.name.split('.').pop()
      const fileName = `${user.id}_${Date.now()}.${fileExt}`
      const filePath = `documents/${user.id}/${fileName}`

      const { error: uploadError } = await supabase.storage
        .from('documents')
        .upload(filePath, file)

      if (uploadError) {
        console.error('Upload error:', uploadError)
        toast.error('Error uploading file')
        return
      }

      const { data: urlData } = supabase.storage
        .from('documents')
        .getPublicUrl(filePath)

      const { error: insertError } = await supabase
        .from('user_documents')
        .insert({
          title: file.name,
          file_name: fileName,
          file_size: file.size,
          file_type: fileExt || '',
          file_url: urlData.publicUrl,
          document_type: documentType,
          user_id: user.id
        })

      if (insertError) {
        console.error('Database error:', insertError)
        toast.error('Error saving document information')
        return
      }

      toast.success('Document uploaded successfully')
      await fetchDocuments()
      setShowUploadModal(false)
      setSelectedFile(null)
    } catch (error) {
      console.error('Upload error:', error)
      toast.error('Error uploading document')
    } finally {
      setUploading(false)
    }
  }

  const deleteDocument = async (documentId: number) => {
    try {
      const { error } = await supabase
        .from('user_documents')
        .delete()
        .eq('id', documentId)

      if (error) {
        console.error('Delete error:', error)
        toast.error('Error deleting document')
        return
      }

      toast.success('Document deleted successfully')
      await fetchDocuments()
    } catch (error) {
      console.error('Delete error:', error)
      toast.error('Error deleting document')
    }
  }

  const togglePublic = async (documentId: number, isPublic: boolean) => {
    try {
      const { error } = await supabase
        .from('user_documents')
        .update({ is_public: !isPublic })
        .eq('id', documentId)

      if (error) {
        console.error('Update error:', error)
        toast.error('Error updating document visibility')
        return
      }

      toast.success(`Document updated - ${!isPublic ? 'now visible' : 'now private'} to others`)
      await fetchDocuments()
    } catch (error) {
      console.error('Update error:', error)
      toast.error('Error updating document')
    }
  }

  const filteredDocuments = documents.filter(doc => {
    return filter === 'all' || doc.document_type === filter
  })

  const formatFileSize = (bytes: number) => {
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    if (bytes === 0) return '0 Bytes'
    const i = Math.floor(Math.log(bytes) / Math.log(1024))
    return Math.round(bytes / Math.pow(1024, i)) + ' ' + sizes[i]
  }

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }

  const getDocumentIcon = (type: string) => {
    switch (type) {
      case 'image':
        return <Image size={20} />
      default:
        return <File size={20} />
    }
  }

  const getDocumentTypeColor = (type: string) => {
    const colors = {
      resume: 'blue',
      portfolio: 'green',
      certificate: 'purple',
      cover_letter: 'orange',
      other: 'gray'
    }
    return colors[type as keyof typeof colors] || 'gray'
  }

  const handleUploadClick = () => {
    const input = document.createElement('input')
    input.type = 'file'
    input.accept = '.pdf,.doc,.docx,.jpg,.jpeg,.png'
    input.onchange = (e) => {
      const file = (e.target as HTMLInputElement).files?.[0]
      if (file) {
        setSelectedFile(file)
        setShowUploadModal(true)
      }
    }
    input.click()
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="h-48 bg-gray-200 rounded"></div>
            ))}
          </div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Resume & Documents</h1>
            <p className="mt-1 text-sm text-gray-500">
              Manage your resume, portfolio, certificates, and other important documents
            </p>
          </div>
          <Button
            onClick={handleUploadClick}
            className="flex items-center gap-2"
          >
            <Upload size={20} />
            Upload Document
          </Button>
        </div>

        {/* Filters */}
        <div className="flex gap-2">
          {['all', 'resume', 'portfolio', 'certificate', 'cover_letter', 'other'].map((type) => (
            <Button
              key={type}
              variant={filter === type ? 'primary' : 'outline'}
              size="sm"
              onClick={() => setFilter(type)}
              className="capitalize"
            >
              {type === 'all' ? 'All Types' : type.replace('_', ' ')}
            </Button>
          ))}
        </div>

        {/* Documents Grid */}
        {filteredDocuments.length === 0 ? (
          <Card className="p-8 text-center">
            <FileText size={48} className="mx-auto text-gray-400 mb-4" />
            <h3 className="text-xl font-semibold text-gray-700 mb-2">
              No documents found
            </h3>
            <p className="text-gray-500 mb-4">
              {filter !== 'all' 
                ? 'No documents match your current filter.' 
                : 'Upload your first document to get started.'}
            </p>
            <Button onClick={handleUploadClick}>
              Upload Your First Document
            </Button>
          </Card>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
            {filteredDocuments.map((doc) => (
              <Card key={doc.id} className="hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-blue-50 rounded-lg">
                        {getDocumentIcon(doc.file_type)}
                      </div>
                      <div>
                        <h3 className="font-medium text-gray-900">
                          {doc.title}
                        </h3>
                        <Badge 
                          variant="info" 
                          className={`bg-${getDocumentTypeColor(doc.document_type)}-100 text-${getDocumentTypeColor(doc.document_type)}-800`}
                        >
                          {doc.document_type}
                        </Badge>
                      </div>
                    </div>
                    <div className="flex gap-1">
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => togglePublic(doc.id, doc.is_public)}
                        className="text-xs"
                      >
                        {doc.is_public ? 'Public' : 'Private'}
                      </Button>
                    </div>
                  </div>
                  
                  <div className="space-y-2 text-sm text-gray-500 mb-4">
                    <div className="flex items-center gap-2">
                      <Calendar size={14} />
                      <span>Uploaded {formatDate(doc.created_at)}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <FileText size={14} />
                      <span>{formatFileSize(doc.file_size)}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Cloud size={14} />
                      <span className={doc.is_public ? 'text-green-600' : 'text-gray-500'}>
                        {doc.is_public ? 'Visible to others' : 'Private'}
                      </span>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <div className="flex gap-2">
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => window.open(doc.file_url, '_blank')}
                        className="flex items-center gap-1"
                      >
                        <Eye size={14} />
                        View
                      </Button>
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => window.open(doc.file_url, '_blank')}
                        className="flex items-center gap-1"
                      >
                        <Download size={14} />
                        Download
                      </Button>
                    </div>
                    <Button
                      size="sm"
                      variant="danger"
                      onClick={() => deleteDocument(doc.id)}
                      className="flex items-center gap-1"
                    >
                      <Trash2 size={14} />
                      Delete
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* Upload Modal */}
        {showUploadModal && selectedFile && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <Card className="w-96">
              <CardContent className="p-6">
                <h3 className="text-lg font-semibold mb-4">Upload Document</h3>
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      File: {selectedFile.name}
                    </label>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Document Type
                    </label>
                    <select
                      className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      onChange={(e) => {
                        if (e.target.value && selectedFile) {
                          handleFileUpload(selectedFile, e.target.value)
                        }
                      }}
                    >
                      <option value="">Select document type...</option>
                      <option value="resume">Resume</option>
                      <option value="portfolio">Portfolio</option>
                      <option value="certificate">Certificate</option>
                      <option value="cover_letter">Cover Letter</option>
                      <option value="other">Other</option>
                    </select>
                  </div>
                  <div className="flex gap-2">
                    <Button
                      variant="outline"
                      onClick={() => {
                        setShowUploadModal(false)
                        setSelectedFile(null)
                      }}
                      className="flex-1"
                    >
                      Cancel
                    </Button>
                    <Button
                      disabled={uploading}
                      className="flex-1 flex items-center gap-2"
                    >
                      {uploading ? (
                        <>
                          <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                          Uploading...
                        </>
                      ) : (
                        'Upload'
                      )}
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}

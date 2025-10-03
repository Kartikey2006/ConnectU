'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Card, CardContent } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Building2, MapPin, DollarSign, Clock, Users, Filter, ExternalLink, Bookmark } from 'lucide-react'
import toast from 'react-hot-toast'

interface Job {
  id: number
  title: string
  company: string
  location: string
  salary_range: string
  job_type: 'full_time' | 'part_time' | 'contract' | 'internship'
  description: string
  requirements: string[]
  posted_by: number
  created_at: string
  application_deadline: string
  author?: {
    name: string
    email: string
  }
}

export default function JobsPage() {
  const [jobs, setJobs] = useState<Job[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')
  const [searchTerm, setSearchTerm] = useState('')
  const [savedJobs, setSavedJobs] = useState<number[]>([])
  const [appliedJobs, setAppliedJobs] = useState<number[]>([])

  useEffect(() => {
    fetchJobs()
    fetchSavedJobs()
    
    // Subscribe to real-time updates
    const subscription = supabase
      .channel('jobs')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: 'job_opportunities' },
        () => fetchJobs()
      )
      .subscribe()

    return () => {
      subscription.unsubscribe()
    }
  }, [])

  const fetchJobs = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockJobs: Job[] = [
        {
          id: 1,
          title: 'Frontend Developer',
          company: 'TechCorp Inc.',
          location: 'San Francisco, CA',
          salary_range: '$70,000 - $90,000',
          job_type: 'full_time',
          description: 'We are looking for a skilled frontend developer to join our growing team. Experience with React, TypeScript, and modern web development tools required.',
          requirements: ['React', 'TypeScript', 'CSS', 'Git'],
          posted_by: 1,
          created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
          application_deadline: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
          author: { name: 'Arjun Sharma', email: 'arjun@example.com' }
        },
        {
          id: 2,
          title: 'Data Scientist',
          company: 'DataCorp',
          location: 'New York, NY',
          salary_range: '$85,000 - $120,000',
          job_type: 'full_time',
          description: 'Join our data science team to work on cutting-edge machine learning projects. PhD or equivalent experience preferred.',
          requirements: ['Python', 'Machine Learning', 'Statistics', 'SQL'],
          posted_by: 2,
          created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
          application_deadline: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString(),
          author: { name: 'Priya Patel', email: 'priya@example.com' }
        },
        {
          id: 3,
          title: 'Product Manager Intern',
          company: 'StartupXYZ',
          location: 'Austin, TX',
          salary_range: '$20 - $25/hr',
          job_type: 'internship',
          description: 'Great opportunity for students to gain hands-on experience in product management at a fast-growing startup.',
          requirements: ['Communication', 'Analytics', 'Agile'],
          posted_by: 3,
          created_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
          application_deadline: new Date(Date.now() + 21 * 24 * 60 * 60 * 1000).toISOString(),
          author: { name: 'Rajesh Kumar', email: 'rajesh@example.com' }
        }
      ]

      setJobs(mockJobs)
      
      /* Uncomment when database tables are ready:
      const { data, error } = await supabase
        .from('job_opportunities')
        .select(`
          *,
          author:users(name, email)
        `)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('Error fetching jobs:', error)
        toast.error('Error loading job opportunities')
        return
      }

      setJobs(data?.filter((job: any) => job.author) || [])
      */
    } catch (error) {
      console.error('Error fetching jobs:', error)
      toast.error('Error loading job opportunities')
      setJobs([])
    } finally {
      setLoading(false)
    }
  }

  const fetchSavedJobs = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { data } = await supabase
        .from('saved_jobs')
        .select('job_id')
        .eq('user_id', user.id)

      if (data) {
        setSavedJobs(data.map(item => item.job_id))
      }
    } catch (error) {
      console.error('Error fetching saved jobs:', error)
    }
  }

  const toggleSaveJob = async (jobId: number) => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) {
        toast.error('Please log in to save jobs')
        return
      }

      const isSaved = savedJobs.includes(jobId)
      
      if (isSaved) {
        await supabase
          .from('saved_jobs')
          .delete()
          .eq('job_id', jobId)
          .eq('user_id', user.id)
        setSavedJobs(prev => prev.filter(id => id !== jobId))
        toast.success('Job removed from saved list')
      } else {
        await supabase
          .from('saved_jobs')
          .insert({ job_id: jobId, user_id: user.id })
        setSavedJobs(prev => [...prev, jobId])
        toast.success('Job saved successfully')
      }
    } catch (error) {
      console.error('Error saving job:', error)
      toast.error('Error saving job')
    }
  }

  const filteredJobs = jobs.filter(job => {
    const matchesFilter = filter === 'all' || job.job_type === filter
    const matchesSearch = searchTerm === '' || 
      job.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      job.company.toLowerCase().includes(searchTerm.toLowerCase()) ||
      job.location.toLowerCase().includes(searchTerm.toLowerCase())
    
    return matchesFilter && matchesSearch
  })

  const getJobTypeColor = (type: string) => {
    const colors = {
      full_time: 'blue',
      part_time: 'green',
      contract: 'purple',
      internship: 'orange'
    }
    return colors[type as keyof typeof colors] || 'blue'
  }

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  }

  const formatTimeAgo = (dateString: string) => {
    const date = new Date(dateString)
    const now = new Date()
    const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60))
    
    if (diffInHours < 1) return 'Just now'
    if (diffInHours < 24) return `${diffInHours} hour(s) ago`
    const diffInDays = Math.floor(diffInHours / 24)
    return `${diffInDays} day(s) ago`
  }

  const applyToJob = (jobId: number) => {
    if (appliedJobs.includes(jobId)) {
      toast.error('You have already applied to this job')
      return
    }
    
    setAppliedJobs(prev => [...prev, jobId])
    toast.success('Application sent!')
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="h-64 bg-gray-200 rounded"></div>
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
            <h1 className="text-2xl font-bold text-gray-900">Job Opportunities</h1>
            <p className="mt-1 text-sm text-gray-500">
              Discover career opportunities posted by alumni and partners
            </p>
          </div>
          <Button
            onClick={() => {
              // Todo: implement post job functionality
              toast.success('Post job feature coming soon!')
            }}
            className="flex items-center gap-2"
          >
            <Building2 size={20} />
            Post Job
          </Button>
        </div>

        {/* Filters */}
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex gap-2">
            {['all', 'full_time', 'part_time', 'contract', 'internship'].map((type) => (
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
          
          <div className="flex-1 max-w-md">
            <div className="relative">
              <input
                type="text"
                placeholder="Search jobs..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
              <Filter className="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
            </div>
          </div>
        </div>

        {/* Jobs List */}
        {filteredJobs.length === 0 ? (
          <Card className="p-8 text-center">
            <Building2 size={48} className="mx-auto text-gray-400 mb-4" />
            <h3 className="text-xl font-semibold text-gray-700 mb-2">
              No job opportunities found
            </h3>
            <p className="text-gray-500 mb-4">
              {searchTerm || filter !== 'all' 
                ? 'No jobs match your current filters.' 
                : 'No job opportunities have been posted yet.'}
            </p>
            <Button onClick={fetchJobs}>
              Refresh Jobs
            </Button>
          </Card>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {filteredJobs.map((job) => (
              <Card key={job.id} className="hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <Badge 
                          variant="info" 
                          className={`bg-${getJobTypeColor(job.job_type)}-100 text-${getJobTypeColor(job.job_type)}-800`}
                        >
                          {job.job_type.replace('_', ' ')}
                        </Badge>
                        <span className="text-sm text-gray-500">
                          {formatTimeAgo(job.created_at)}
                        </span>
                      </div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-2">
                        {job.title}
                      </h3>
                      <div className="flex items-center gap-4 text-sm text-gray-500 mb-3">
                        <div className="flex items-center gap-1">
                          <Building2 size={16} />
                          <span>{job.company}</span>
                        </div>
                        <div className="flex items-center gap-1">
                          <MapPin size={16} />
                          <span>{job.location}</span>
                        </div>
                        {job.salary_range && (
                          <div className="flex items-center gap-1">
                            <DollarSign size={16} />
                            <span>{job.salary_range}</span>
                          </div>
                        )}
                      </div>
                    </div>
                    <button
                      onClick={() => toggleSaveJob(job.id)}
                      className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                    >
                      <Bookmark 
                        size={20} 
                        className={savedJobs.includes(job.id) ? 'text-blue-600 fill-current' : 'text-gray-400'} 
                      />
                    </button>
                  </div>
                  
                  <p className="text-gray-600 text-sm line-clamp-3 mb-4">
                    {job.description}
                  </p>

                  {job.requirements && job.requirements.length > 0 && (
                    <div className="mb-4">
                      <h4 className="text-sm font-medium text-gray-700 mb-2">Requirements:</h4>
                      <div className="flex flex-wrap gap-1">
                        {job.requirements.slice(0, 3).map((req, index) => (
                          <Badge key={index} variant="default" className="text-xs">
                            {req}
                          </Badge>
                        ))}
                        {job.requirements.length > 3 && (
                          <Badge variant="default" className="text-xs">
                            +{job.requirements.length - 3} more
                          </Badge>
                        )}
                      </div>
                    </div>
                  )}

                  {job.application_deadline && (
                    <div className="flex items-center gap-2 text-sm text-gray-500 mb-4">
                      <Clock size={16} />
                      <span>
                        Apply before {formatDate(job.application_deadline)}
                      </span>
                    </div>
                  )}

                  <div className="flex items-center justify-between">
                    <div className="text-sm text-gray-500">
                      Posted by {job.author?.name || 'Unknown'}
                    </div>
                    <div className="flex gap-2">
                      <Button
                        size="sm"
                        variant={appliedJobs.includes(job.id) ? "secondary" : "outline"}
                        onClick={() => applyToJob(job.id)}
                        className={`flex items-center gap-1 ${
                          appliedJobs.includes(job.id) ? 'cursor-not-allowed' : ''
                        }`}
                        disabled={appliedJobs.includes(job.id)}
                      >
                        {appliedJobs.includes(job.id) ? 'Applied' : 'Apply Now'}
                        <ExternalLink size={14} />
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}

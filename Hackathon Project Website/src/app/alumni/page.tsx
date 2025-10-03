'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { User, Building, MapPin, Linkedin, MessageSquare, Search, Star, TrendingUp, Users, Filter, SortAsc } from 'lucide-react'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'

interface Alumni {
  id: number
  name: string
  email: string
  alumnidetails?: {
    batch_year: number
    company?: string
    designation?: string
    linkedin_url?: string
    verification_status: boolean
  }[]
}

export default function AlumniDirectoryPage() {
  const [alumni, setAlumni] = useState<Alumni[]>([])
  const [filteredAlumni, setFilteredAlumni] = useState<Alumni[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedCompany, setSelectedCompany] = useState('')
  const [selectedBatch, setSelectedBatch] = useState('')
  const [sortBy, setSortBy] = useState('name')
  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid')

  useEffect(() => {
    fetchAlumni()
  }, [])

  useEffect(() => {
    filterAlumni()
  }, [alumni, searchTerm, selectedCompany, selectedBatch, sortBy])

  const fetchAlumni = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockAlumni: Alumni[] = [
        {
          id: 1,
          name: 'Rajesh Kumar',
          email: 'rajesh@example.com',
          alumnidetails: [{
            batch_year: 2020,
            company: 'Google',
            designation: 'Senior Software Engineer',
            linkedin_url: 'https://linkedin.com/in/rajeshkumar',
            verification_status: true
          }]
        },
        {
          id: 2,
          name: 'Priya Patel',
          email: 'priya@example.com',
          alumnidetails: [{
            batch_year: 2019,
            company: 'Microsoft',
            designation: 'Product Manager',
            linkedin_url: 'https://linkedin.com/in/priyapatel',
            verification_status: true
          }]
        },
        {
          id: 3,
          name: 'Arvind Singh',
          email: 'arvind@example.com',
          alumnidetails: [{
            batch_year: 2021,
            company: 'Amazon',
            designation: 'Data Scientist',
            linkedin_url: 'https://linkedin.com/in/arvindsingh',
            verification_status: true
          }]
        },
        {
          id: 4,
          name: 'Sakshi Agarwal',
          email: 'sakshi@example.com',
          alumnidetails: [{
            batch_year: 2018,
            company: 'Meta',
            designation: 'Engineering Manager',
            linkedin_url: 'https://linkedin.com/in/sakshigarwal',
            verification_status: true
          }]
        },
        {
          id: 5,
          name: 'Akash Sharma',
          email: 'akash@example.com',
          alumnidetails: [{
            batch_year: 2022,
            company: 'Netflix',
            designation: 'Frontend Developer',
            linkedin_url: 'https://linkedin.com/in/akashsharma',
            verification_status: true
          }]
        },
        {
          id: 6,
          name: 'Neha Gupta',
          email: 'neha@example.com',
          alumnidetails: [{
            batch_year: 2017,
            company: 'Apple',
            designation: 'iOS Developer',
            linkedin_url: 'https://linkedin.com/in/nehagupta',
            verification_status: true
          }]
        },
        {
          id: 7,
          name: 'Vikram Reddy',
          email: 'vikram@example.com',
          alumnidetails: [{
            batch_year: 2019,
            company: 'Tesla',
            designation: 'Software Engineer',
            linkedin_url: 'https://linkedin.com/in/vikramreddy',
            verification_status: true
          }]
        },
        {
          id: 8,
          name: 'Ananya Jain',
          email: 'ananya@example.com',
          alumnidetails: [{
            batch_year: 2020,
            company: 'Twitter',
            designation: 'UX Designer',
            linkedin_url: 'https://linkedin.com/in/ananyajain',
            verification_status: true
          }]
        },
        {
          id: 9,
          name: 'Deepak Verma',
          email: 'deepak@example.com',
          alumnidetails: [{
            batch_year: 2021,
            company: 'Uber',
            designation: 'Backend Developer',
            linkedin_url: 'https://linkedin.com/in/deepakverma',
            verification_status: true
          }]
        }
      ]

      setAlumni(mockAlumni)
      
      /* Uncomment when database tables are ready:
      const { data, error } = await supabase
        .from('users')
        .select(`
          id,
          name,
          email,
          alumnidetails (*)
        `)
        .eq('role', 'alumni')
        .eq('alumnidetails.verification_status', true)
        .order('name')

      if (error) {
        console.error('Error fetching alumni:', error)
        return
      }

      setAlumni(data || [])
      */
    } catch (error) {
      console.error('Error fetching alumni:', error)
    } finally {
      setLoading(false)
    }
  }

  const filterAlumni = () => {
    let filtered = alumni

    if (searchTerm) {
      filtered = filtered.filter(alumni =>
        alumni.name.toLowerCase().includes(searchTerm.toLowerCase()) ||  
        alumni.alumnidetails?.[0]?.company?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        alumni.alumnidetails?.[0]?.designation?.toLowerCase().includes(searchTerm.toLowerCase())
      )
    }

    if (selectedCompany) {
      filtered = filtered.filter(alumni => 
        alumni.alumnidetails?.[0]?.company === selectedCompany
      )
    }

    if (selectedBatch) {
      filtered = filtered.filter(alumni => 
        alumni.alumnidetails?.[0]?.batch_year.toString() === selectedBatch
      )
    }

    // Apply sorting
    filtered.sort((a, b) => {
      switch (sortBy) {
        case 'name':
          return a.name.localeCompare(b.name)
        case 'company':
          return (a.alumnidetails?.[0]?.company || '').localeCompare(b.alumnidetails?.[0]?.company || '')
        case 'batch':
          return (b.alumnidetails?.[0]?.batch_year || 0) - (a.alumnidetails?.[0]?.batch_year || 0)
        case 'designation':
          return (a.alumnidetails?.[0]?.designation || '').localeCompare(b.alumnidetails?.[0]?.designation || '')
        default:
          return 0
      }
    })

    setFilteredAlumni(filtered)
  }

  const getUniqueCompanies = () => {
    const companies = alumni
      .map(alumni => alumni.alumnidetails?.[0]?.company)
      .filter((company, index, self) => company && self.indexOf(company) === index)
    return companies.sort()
  }

  const getUniqueBatches = () => {
    const batches = alumni
      .map(alumni => alumni.alumnidetails?.[0]?.batch_year)
      .filter((batch, index, self) => batch && self.indexOf(batch) === index)
    return batches.sort((a, b) => (b || 0) - (a || 0))
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
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
      <div className="space-y-8">
        {/* Enhanced Header */}
        <div className="bg-gradient-to-r from-blue-600 to-purple-700 rounded-xl px-8 py-10 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold mb-2">Alumni Directory</h1>
              <p className="text-blue-100">
                Connect with verified alumni from your institution
              </p>
              <div className="flex items-center mt-4 space-x-6">
                <div className="flex items-center">
                  <Users className="h-5 w-5 mr-2" />
                  <span className="text-lg font-semibold">{alumni.length} Alumni</span>
                </div>
                <div className="flex items-center">
                  <TrendingUp className="h-5 w-5 mr-2" />
                  <span className="text-lg font-semibold">{getUniqueCompanies().length} Companies</span>
                </div>
              </div>
            </div>
            <div className="hidden lg:block">
              <div className="bg-white/20 backdrop-blur-sm rounded-lg px-6 py-4">
                <div className="text-yellow-300 font-bold text-4xl">{alumni.length}</div>
                <div className="text-white/90 text-sm">Active Alumni</div>
              </div>
            </div>
          </div>
        </div>

        {/* Search and Filters */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Search Alumni
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md text-gray-900 focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                  placeholder="Search by name, company, or role..."
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Company
              </label>
              <select
                value={selectedCompany}
                onChange={(e) => setSelectedCompany(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
              >
                <option value="">All Companies</option>
                {getUniqueCompanies().map(company => (
                  <option key={company} value={company}>{company}</option>
                ))}
              </select>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Batch Year
              </label>
              <select
                value={selectedBatch}
                onChange={(e) => setSelectedBatch(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
              >
                <option value="">All Batches</option>
                {getUniqueBatches().map(batch => (
                  <option key={batch} value={batch}>{batch}</option>
                ))}
              </select>
            </div>
          </div>
        </div>

        {/* Enhanced Search and Controls */}
        <div className="flex justify-between items-center mb-6">
          <div className="flex items-center space-x-4">
            <div className="flex bg-gray-100 rounded-lg p-1">
              <button
                onClick={() => setViewMode('grid')}
                className={`px-3 py-1 rounded-md transition-colors ${
                  viewMode === 'grid' ? 'bg-white shadow' : 'text-gray-600'
                }`}
              >
                Grid
              </button>
              <button
                onClick={() => setViewMode('list')}
                className={`px-3 py-1 rounded-md transition-colors ${
                  viewMode === 'list' ? 'bg-white shadow' : 'text-gray-600'
                }`}
              >
                List
              </button>
            </div>
          </div>
          
          <div className="flex items-center space-x-3">
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="name">Sort by Name</option>
              <option value="company">Sort by Company</option>
              <option value="batch">Sort by Batch Year</option>
              <option value="designation">Sort by Designation</option>
            </select>
          </div>
        </div>

        {/* Alumni Cards */}
        <div className={viewMode === 'grid' 
          ? "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" 
          : "space-y-4"
        }>
          {filteredAlumni.length === 0 ? (
            <div className="col-span-full text-center py-12">
              <Users className="mx-auto h-16 w-16 text-gray-400" />
              <h3 className="mt-4 text-lg font-medium text-gray-900">No alumni found</h3>
              <p className="mt-2 text-gray-500">
                Try adjusting your search criteria or filters.
              </p>
            </div>
          ) : (
            filteredAlumni.map((alumni) => (
              <Card key={alumni.id} className={`group hover:shadow-xl transition-all duration-300 ${viewMode === 'list' ? 'flex' : ''}`}>
                <div className={`${viewMode === 'list' ? 'flex-1 flex items-center' : ''}`}>
                  {viewMode === 'grid' ? (
                    <div className="p-6">
                      {/* Header with Avatar and Info */}
                      <div className="flex items-start justify-between mb-4">
                        <div className="flex items-center">
                          <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-xl">
                            {alumni.name.split(' ').map(n => n[0]).join('').slice(0, 2)}
                          </div>
                          <div className="ml-4">
                            <h3 className="text-xl font-semibold text-gray-900 group-hover:text-blue-600 transition-colors">
                              {alumni.name}
                            </h3>
                            <p className="text-lg font-medium text-gray-600">{alumni.alumnidetails?.[0]?.designation}</p>
                            <div className="flex items-center mt-1">
                              <Star className="h-4 w-4 text-yellow-400 fill-current" />
                              <span className="text-sm text-gray-500 ml-1">Verified Alumni</span>
                            </div>
                          </div>
                        </div>
                        <Button variant="ghost" size="sm" className="opacity-0 group-hover:opacity-100 transition-opacity">
                          <Linkedin className="h-4 w-4" />
                        </Button>
                      </div>

                      {/* Company Info */}
                      <div className="space-y-3 mb-6">
                        <div className="flex items-center text-gray-700">
                          <Building className="h-5 w-5 mr-3 text-blue-500" />
                          <span className="font-medium">{alumni.alumnidetails?.[0]?.company}</span>
                        </div>
                        
                        <div className="flex items-center text-gray-700">
                          <MapPin className="h-5 w-5 mr-3 text-green-500" />
                          <span>Batch {alumni.alumnidetails?.[0]?.batch_year}</span>
                        </div>
                      </div>

                      {/* Action Buttons */}
                      <div className="space-y-3">
                        <Button className="w-full" size="lg">
                          <MessageSquare className="h-4 w-4 mr-2" />
                          Send Message
                        </Button>
                        {alumni.alumnidetails?.[0]?.linkedin_url && (
                          <Button variant="outline" className="w-full">
                            <a 
                              href={alumni.alumnidetails[0].linkedin_url} 
                              target="_blank" 
                              rel="noopener noreferrer"
                              className="flex items-center justify-center w-full"
                            >
                              <Linkedin className="h-4 w-4 mr-2" />
                              LinkedIn Profile
                            </a>
                          </Button>
                        )}
                      </div>
                    </div>
                  ) : (
                    // List View
                    <div className="p-6 w-full">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                          <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold">
                            {alumni.name.split(' ').map(n => n[0]).join('').slice(0, 2)}
                          </div>
                          <div>
                            <h3 className="text-lg font-semibold text-gray-900">{alumni.name}</h3>
                            <p className="text-gray-600">{alumni.alumnidetails?.[0]?.designation} at {alumni.alumnidetails?.[0]?.company}</p>
                            <div className="flex items-center text-sm text-gray-500">
                              <MapPin className="h-4 w-4 mr-1" />
                              Batch {alumni.alumnidetails?.[0]?.batch_year}
                            </div>
                          </div>
                        </div>
                        <div className="flex space-x-2">
                          <Button size="sm">
                            <MessageSquare className="h-4 w-4 mr-1" />
                            Connect
                          </Button>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </Card>
            ))
          )}
        </div>

        {/* Enhanced Stats */}
        <div className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-xl p-8">
          <h3 className="text-2xl font-bold text-gray-900 mb-6">Directory Statistics</h3>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="bg-white rounded-lg p-6 shadow-sm border">
              <div className="flex items-center">
                <div className="p-3 bg-blue-100 rounded-full">
                  <Users className="h-6 w-6 text-blue-600" />
                </div>
                <div className="ml-4">
                  <div className="text-3xl font-bold text-gray-900">{alumni.length}</div>
                  <div className="text-gray-500">Total Alumni</div>
                </div>
              </div>
            </div>
            
            <div className="bg-white rounded-lg p-6 shadow-sm border">
              <div className="flex items-center">
                <div className="p-3 bg-green-100 rounded-full">
                  <Building className="h-6 w-6 text-green-600" />
                </div>
                <div className="ml-4">
                  <div className="text-3xl font-bold text-gray-900">{getUniqueCompanies().length}</div>
                  <div className="text-gray-500">Companies</div>
                </div>
              </div>
            </div>
            
            <div className="bg-white rounded-lg p-6 shadow-sm border">
              <div className="flex items-center">
                <div className="p-3 bg-purple-100 rounded-full">
                  <TrendingUp className="h-6 w-6 text-purple-600" />
                </div>
                <div className="ml-4">
                  <div className="text-3xl font-bold text-gray-900">{getUniqueBatches().length}</div>
                  <div className="text-gray-500">Batch Years</div>
                </div>
              </div>
            </div>
            
            <div className="bg-white rounded-lg p-6 shadow-sm border">
              <div className="flex items-center">
                <div className="p-3 bg-yellow-100 rounded-full">
                  <Star className="h-6 w-6 text-yellow-600" />
                </div>
                <div className="ml-4">
                  <div className="text-3xl font-bold text-gray-900">100%</div>
                  <div className="text-gray-500">Verified Rate</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

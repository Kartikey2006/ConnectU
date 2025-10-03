'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { UserPlus, Search, Filter, Mail, MessageSquare, Calendar, Star, BookOpen, MapPin, GraduationCap } from 'lucide-react'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'

interface Student {
  id: number
  name: string
  email: string
  current_year?: number
  branch?: string
  skills?: string[]
  linkedin_url?: string
  studentdetails?: {
    current_year: number
    branch: string
    skills: string[]
  }[]
}

export default function AlumniStudentsPage() {
  const [students, setStudents] = useState<Student[]>([])
  const [filteredStudents, setFilteredStudents] = useState<Student[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedYear, setSelectedYear] = useState('')
  const [selectedBranch, setSelectedBranch] = useState('')
  const [sortBy, setSortBy] = useState('name')

  useEffect(() => {
    fetchStudents()
  }, [])

  useEffect(() => {
    filterStudents()
  }, [students, searchTerm, selectedYear, selectedBranch, sortBy])

  const fetchStudents = async () => {
    try {
      // Mock data for demonstration - replace with actual Supabase queries
      const mockStudents: Student[] = [
        {
          id: 1,
          name: 'Arjun Sharma',
          email: 'arjun@example.com',
          studentdetails: [{
            current_year: 3,
            branch: 'Computer Science',
            skills: ['React', 'Node.js', 'Python']
          }]
        },
        {
          id: 2,
          name: 'Priya Patel',
          email: 'priya@example.com',
          studentdetails: [{
            current_year: 2,
            branch: 'Information Technology',
            skills: ['Vue.js', 'Java', 'SQL']
          }]
        },
        {
          id: 3,
          name: 'Raj Kumar',
          email: 'raj@example.com',
          studentdetails: [{
            current_year: 4,
            branch: 'Computer Science',
            skills: ['Machine Learning', 'Python', 'TensorFlow']
          }]
        },
        {
          id: 4,
          name: 'Sneha Singh',
          email: 'sneha@example.com',
          studentdetails: [{
            current_year: 1,
            branch: 'Electronics & Communication',
            skills: ['C++', 'Arduino', 'Circuit Design']
          }]
        },
        {
          id: 5,
          name: 'Vikram Mittal',
          email: 'vikram@example.com',
          studentdetails: [{
            current_year: 3,
            branch: 'Mechanical Engineering',
            skills: ['AutoCAD', 'SolidWorks', 'MATLAB']
          }]
        }
      ]

      setStudents(mockStudents)
    } catch (error) {
      console.error('Error fetching students:', error)
    } finally {
      setLoading(false)
    }
  }

  const filterStudents = () => {
    let filtered = [...students]

    // Search filter
    if (searchTerm) {
      filtered = filtered.filter(student =>
        student.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        student.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        student.studentdetails?.[0]?.branch?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        student.studentdetails?.[0]?.skills?.some(skill =>
          skill.toLowerCase().includes(searchTerm.toLowerCase())
        )
      )
    }

    // Year filter
    if (selectedYear) {
      filtered = filtered.filter(student =>
        student.studentdetails?.[0]?.current_year?.toString() === selectedYear
      )
    }

    // Branch filter
    if (selectedBranch) {
      filtered = filtered.filter(student =>
        student.studentdetails?.[0]?.branch === selectedBranch
      )
    }

    // Sort
    filtered.sort((a, b) => {
      const aName = a.name.toLowerCase()
      const bName = b.name.toLowerCase()
      return sortBy === 'name' ? aName.localeCompare(bName) : bName.localeCompare(aName)
    })

    setFilteredStudents(filtered)
  }

  const getUniqueYears = () => {
    const years = students
      .map(student => student.studentdetails?.[0]?.current_year)
      .filter(year => year !== undefined)
    return Array.from(new Set(years)).sort()
  }

  const getUniqueBranches = () => {
    const branches = students
      .map(student => student.studentdetails?.[0]?.branch)
      .filter(branch => branch !== undefined)
    return Array.from(new Set(branches)).sort()
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
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-purple-700 rounded-xl px-8 py-10 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold mb-2">Connect with Students</h1>
              <p className="text-blue-100">
                Browse and connect with students seeking mentorship guidance
              </p>
            </div>
            <GraduationCap className="w-16 h-16 opacity-20" />
          </div>
        </div>

        {/* Filters & Search */}
        <Card className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="relative">
              <Search className="absolute left-3 top-3 text-gray-400 w-5 h-5" />
              <input
                type="text"
                placeholder="Search students..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            
            <select
              value={selectedYear}
              onChange={(e) => setSelectedYear(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">All Years</option>
              {getUniqueYears().map(year => (
                <option key={year} value={year}>
                  Year {year}
                </option>
              ))}
            </select>

            <select
              value={selectedBranch}
              onChange={(e) => setSelectedBranch(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">All Branches</option>
              {getUniqueBranches().map(branch => (
                <option key={branch} value={branch}>
                  {branch}
                </option>
              ))}
            </select>

            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="name">Sort by Name</option>
              <option value="year">Sort by Year</option>
            </select>
          </div>
        </Card>

        {/* Students Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredStudents.map((student) => (
            <Card key={student.id} className="p-6 hover:shadow-lg transition-shadow">
              <div className="flex items-center space-x-4 mb-4">
                <div className="w-12 h-12 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold text-lg">
                  {student.name.charAt(0)}
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900">{student.name}</h3>
                  <p className="text-sm text-gray-500">{student.email}</p>
                </div>
              </div>

              {student.studentdetails?.[0] && (
                <div className="space-y-2 mb-4">
                  <div className="flex items-center text-sm text-gray-600">
                    <GraduationCap className="w-4 h-4 mr-2" />
                    Year {student.studentdetails[0].current_year}
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <MapPin className="w-4 h-4 mr-2" />
                    {student.studentdetails[0].branch}
                  </div>
                </div>
              )}

              {student.studentdetails?.[0]?.skills && (
                <div className="mb-4">
                  <div className="flex flex-wrap gap-1">
                    {student.studentdetails[0].skills.slice(0, 3).map((skill, index) => (
                      <Badge key={index} className="text-xs">
                        {skill}
                      </Badge>
                    ))}
                    {student.studentdetails[0].skills.length > 3 && (
                      <Badge className="text-xs bg-gray-100">
                        +{student.studentdetails[0].skills.length - 3} more
                      </Badge>
                    )}
                  </div>
                </div>
              )}

              <div className="flex space-x-2">
                <Button size="sm" className="flex-1">
                  <MessageSquare className="w-4 h-4 mr-2" />
                  Message
                </Button>
                <Button size="sm" variant="secondary" className="flex-1">
                  <UserPlus className="w-4 h-4 mr-2" />
                  Mentor
                </Button>
              </div>
            </Card>
          ))}
        </div>

        {filteredStudents.length === 0 && (
          <Card className="p-12 text-center">
            <GraduationCap className="w-16 h-16 mx-auto text-gray-400 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">
              No students found
            </h3>
            <p className="text-gray-500">
              Try adjusting your search criteria or filters
            </p>
          </Card>
        )}
      </div>
    </DashboardLayout>
  )
}

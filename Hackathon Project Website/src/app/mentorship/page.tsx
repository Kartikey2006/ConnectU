'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { 
  Users, 
  MessageSquare, 
  Star, 
  MapPin, 
  Clock,
  Calendar,
  Filter,
  Search,
  ArrowRight,
  User,
  Building,
  Award,
  Globe
} from 'lucide-react'

interface Mentor {
  id: number
  name: string
  email: string
  company: string
  designation: string
  experience: number
  rating: number
  totalSessions: number
  specialties: string[]
  linkedin_url: string
  avatar: string
  location: string
  availability: string[]
  price_per_hour: number
}

export default function MentorshipPage() {
  const [mentors, setMentors] = useState<Mentor[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedSpecialty, setSelectedSpecialty] = useState('')
  const [priceRange, setPriceRange] = useState('')

  const specialties = [
    'Software Engineering',
    'Product Management',
    'Data Science',
    'Machine Learning',
    'UI/UX Design',
    'Marketing',
    'Finance',
    'Consulting',
    'Entrepreneurship',
    'Leadership'
  ]

  useEffect(() => {
    fetchMentors()
  }, [])

  const fetchMentors = async () => {
    try {
      // Mock data for now
      const mockMentors: Mentor[] = [
        {
          id: 1,
          name: 'Priya Patel',
          email: 'priya@example.com',
          company: 'Google',
          designation: 'Senior Software Engineer',
          experience: 8,
          rating: 4.9,
          totalSessions: 156,
          specialties: ['Software Engineering', 'Machine Learning', 'Leadership'],
          linkedin_url: 'https://linkedin.com/in/priyapatel',
          avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
          location: 'San Francisco, CA',
          availability: ['Mon', 'Wed', 'Fri'],
          price_per_hour: 75
        },
        {
          id: 2,
          name: 'Arvind Singh',
          email: 'arvind@example.com',
          company: 'Microsoft',
          designation: 'Product Manager',
          experience: 6,
          rating: 4.8,
          totalSessions: 89,
          specialties: ['Product Management', 'Strategy', 'UI/UX Design'],
          linkedin_url: 'https://linkedin.com/in/arvindsingh',
          avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
          location: 'Seattle, WA',
          availability: ['Tue', 'Thu', 'Sat'],
          price_per_hour: 85
        },
        {
          id: 3,
          name: 'Sakshi Agarwal',
          email: 'sakshi@example.com',
          company: 'Amazon',
          designation: 'Data Scientist',
          experience: 5,
          rating: 4.7,
          totalSessions: 67,
          specialties: ['Data Science', 'Machine Learning', 'Python'],
          linkedin_url: 'https://linkedin.com/in/sakshigarwal',
          avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
          location: 'New York, NY',
          availability: ['Mon', 'Tue', 'Wed'],
          price_per_hour: 65
        },
        {
          id: 4,
          name: 'Ravindra Reddy',
          email: 'ravindra@example.com',
          company: 'Meta',
          designation: 'Engineering Manager',
          experience: 10,
          rating: 4.9,
          totalSessions: 203,
          specialties: ['Software Engineering', 'Leadership', 'System Design'],
          linkedin_url: 'https://linkedin.com/in/ravindrareddy',
          avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
          location: 'Menlo Park, CA',
          availability: ['Thu', 'Fri', 'Sun'],
          price_per_hour: 95
        }
      ]

      setMentors(mockMentors)
      setLoading(false)
    } catch (error) {
      console.error('Error fetching mentors:', error)
      setLoading(false)
    }
  }

  const filteredMentors = mentors.filter(mentor => {
    const matchesSearch = mentor.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         mentor.company.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         mentor.specialties.some(s => s.toLowerCase().includes(searchTerm.toLowerCase()))
    
    const matchesSpecialty = !selectedSpecialty || mentor.specialties.includes(selectedSpecialty)
    
    const matchesPrice = !priceRange || 
      (priceRange === 'low' && mentor.price_per_hour < 70) ||
      (priceRange === 'medium' && mentor.price_per_hour >= 70 && mentor.price_per_hour < 90) ||
      (priceRange === 'high' && mentor.price_per_hour >= 90)
    
    return matchesSearch && matchesSpecialty && matchesPrice
  })

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse space-y-6">
          <div className="h-8 bg-gray-200 rounded w-1/4"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
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
        <div className="bg-gradient-to-r from-blue-600 to-purple-700 rounded-2xl p-8 text-white">
          <h1 className="text-3xl font-bold mb-4">Find Your Perfect Mentor</h1>
          <p className="text-blue-100 text-lg">
            Connect with industry experts and accelerate your career growth through personalized mentorship.
          </p>
        </div>

        {/* Search and Filters */}
        <Card>
          <CardContent className="p-6">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                <input
                  type="text"
                  placeholder="Search mentors, companies, skills..."
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl text-gray-900 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              
              <select
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                value={selectedSpecialty}
                onChange={(e) => setSelectedSpecialty(e.target.value)}
              >
                <option value="">All Specialties</option>
                {specialties.map(specialty => (
                  <option key={specialty} value={specialty}>{specialty}</option>
                ))}
              </select>
              
              <select
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                value={priceRange}
                onChange={(e) => setPriceRange(e.target.value)}
              >
                <option value="">All Price Ranges</option>
                <option value="low">Under $70/hour</option>
                <option value="medium">$70 - $90/hour</option>
                <option value="high">$90+/hour</option>
              </select>
              
              <Button className="flex items-center justify-center">
                <Filter className="w-4 h-4 mr-2" />
                Filter Results
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Results Count */}
        <div className="flex items-center justify-between">
          <p className="text-gray-600">
            Showing {filteredMentors.length} of {mentors.length} mentors
          </p>
        </div>

        {/* Mentors Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredMentors.map((mentor) => (
            <Card key={mentor.id} className="group hover:shadow-2xl transition-all duration-300">
              <CardContent className="p-6">
                <div className="flex items-start space-x-4 mb-4">
                  <img 
                    src={mentor.avatar} 
                    alt={mentor.name}
                    className="w-16 h-16 rounded-full object-cover"
                  />
                  <div className="flex-1">
                    <h3 className="text-lg font-bold text-gray-900 group-hover:text-blue-600 transition-colors">
                      {mentor.name}
                    </h3>
                    <p className="text-sm text-gray-600">{mentor.designation}</p>
                    <div className="flex items-center mt-1">
                      <Building className="w-4 h-4 text-gray-400 mr-1" />
                      <span className="text-sm text-gray-500">{mentor.company}</span>
                    </div>
                  </div>
                </div>

                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center">
                      <Star className="w-4 h-4 text-yellow-400 fill-current mr-1" />
                      <span className="text-sm font-medium">{mentor.rating}</span>
                      <span className="text-sm text-gray-500 ml-1">({mentor.totalSessions} sessions)</span>
                    </div>
                    <Badge variant="info" size="sm">
                      ${mentor.price_per_hour}/hr
                    </Badge>
                  </div>

                  <div className="flex items-center text-sm text-gray-600">
                    <MapPin className="w-4 h-4 mr-1" />
                    <span>{mentor.location}</span>
                  </div>

                  <div className="flex items-center text-sm text-gray-600">
                    <Clock className="w-4 h-4 mr-1" />
                    <span>Available: {mentor.availability.join(', ')}</span>
                  </div>

                  <div className="flex flex-wrap gap-2">
                    {mentor.specialties.slice(0, 3).map((specialty) => (
                      <Badge key={specialty} variant="default" size="sm">
                        {specialty}
                      </Badge>
                    ))}
                    {mentor.specialties.length > 3 && (
                      <Badge variant="default" size="sm">
                        +{mentor.specialties.length - 3} more
                      </Badge>
                    )}
                  </div>

                  <div className="flex space-x-2 pt-4">
                    <Button 
                      className="flex-1" 
                      size="sm"
                      onClick={() => {/* Handle book session */}}
                    >
                      <Calendar className="w-4 h-4 mr-1" />
                      Book Session
                    </Button>
                    <Button 
                      variant="outline" 
                      size="sm"
                      onClick={() => {/* Handle view profile */}}
                    >
                      <User className="w-4 h-4 mr-1" />
                      Profile
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* No Results */}
        {filteredMentors.length === 0 && (
          <Card>
            <CardContent className="p-12 text-center">
              <Users className="w-16 h-16 text-gray-400 mx-auto mb-4" />
              <h3 className="text-lg font-medium text-gray-900 mb-2">No mentors found</h3>
              <p className="text-gray-600 mb-4">
                Try adjusting your search criteria or browse all available mentors.
              </p>
              <Button onClick={() => {
                setSearchTerm('')
                setSelectedSpecialty('')
                setPriceRange('')
              }}>
                Clear Filters
              </Button>
            </CardContent>
          </Card>
        )}

        {/* CTA Section */}
        <Card className="bg-gradient-to-r from-green-50 to-blue-50 border-green-200">
          <CardContent className="p-8 text-center">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Can't find what you're looking for?
            </h2>
            <p className="text-gray-600 mb-6">
              We're constantly adding new mentors. Join our waitlist to be notified when mentors in your field become available.
            </p>
            <Button size="lg" className="mr-4">
              Join Waitlist
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
            <Button variant="outline" size="lg">
              Suggest a Mentor
            </Button>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}
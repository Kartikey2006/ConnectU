'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { User, Mail, Calendar, Building, MapPin, Linkedin, Save } from 'lucide-react'
import toast from 'react-hot-toast'

interface UserProfile {
  id: number
  name: string
  email: string
  role: string
  created_at: string
  studentdetails?: {
    current_year: number
    branch: string
    skills: string[]
  }
  alumnidetails?: {
    batch_year: number
    company?: string
    designation?: string
    linkedin_url?: string
    verification_status: boolean
  }
}

export default function ProfilePage() {
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [formData, setFormData] = useState({
    name: '',
    current_year: '',
    branch: '',
    skills: '',
    batch_year: '',
    company: '',
    designation: '',
    linkedin_url: ''
  })

  useEffect(() => {
    fetchProfile()
  }, [])

  const fetchProfile = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const userRole = user.user_metadata?.role || 'student'
      
      const mockProfile: UserProfile = userRole === 'student' ? {
        id: 1,
        name: user.user_metadata?.name || 'John Doe',
        email: user.email || 'john@example.com',
        role: 'student',
        created_at: new Date().toISOString(),
        studentdetails: {
          current_year: 3,
          branch: 'Computer Science',
          skills: ['JavaScript', 'React', 'Node.js', 'Python']
        }
      } : {
        id: 2,
        name: user.user_metadata?.name || 'Jane Smith',
        email: user.email || 'jane@example.com',
        role: 'alumni',
        created_at: new Date().toISOString(),
        alumnidetails: {
          batch_year: 2020,
          company: 'Google',
          designation: 'Senior Software Engineer',
          linkedin_url: 'https://linkedin.com/in/janesmith',
          verification_status: true
        }
      }

      setProfile(mockProfile)
      
      // Populate form data
      setFormData({
        name: mockProfile.name || '',
        current_year: mockProfile.studentdetails?.current_year?.toString() || '',
        branch: mockProfile.studentdetails?.branch || '',
        skills: mockProfile.studentdetails?.skills?.join(', ') || '',
        batch_year: mockProfile.alumnidetails?.batch_year?.toString() || '',
        company: mockProfile.alumnidetails?.company || '',
        designation: mockProfile.alumnidetails?.designation || '',
        linkedin_url: mockProfile.alumnidetails?.linkedin_url || ''
      })
      
      /* Uncomment when database tables are ready:
      // Fetch user profile
      const { data: userData, error: userError } = await supabase
        .from('users')
        .select(`
          *,
          studentdetails (*),
          alumnidetails (*)
        `)
        .eq('supabase_auth_id', user.id)
        .single()

      if (userError) {
        toast.error('Failed to fetch profile')
        return
      }

      setProfile(userData)
      
      // Populate form data
      setFormData({
        name: userData.name || '',
        current_year: userData.studentdetails?.current_year?.toString() || '',
        branch: userData.studentdetails?.branch || '',
        skills: userData.studentdetails?.skills?.join(', ') || '',
        batch_year: userData.alumnidetails?.batch_year?.toString() || '',
        company: userData.alumnidetails?.company || '',
        designation: userData.alumnidetails?.designation || '',
        linkedin_url: userData.alumnidetails?.linkedin_url || ''
      })
      */
    } catch (error) {
      console.error('Error fetching profile:', error)
      toast.error('An error occurred')
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async () => {
    setSaving(true)
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user || !profile) return

      // Update user basic info
      const { error: userError } = await supabase
        .from('users')
        .update({ name: formData.name })
        .eq('supabase_auth_id', user.id)

      if (userError) {
        toast.error('Failed to update profile')
        return
      }

      // Update role-specific details
      if (profile.role === 'student') {
        const { error: studentError } = await supabase
          .from('studentdetails')
          .upsert({
            user_id: profile.id,
            current_year: parseInt(formData.current_year),
            branch: formData.branch,
            skills: formData.skills.split(',').map(s => s.trim()).filter(s => s)
          })

        if (studentError) {
          toast.error('Failed to update student details')
          return
        }
      } else if (profile.role === 'alumni') {
        const { error: alumniError } = await supabase
          .from('alumnidetails')
          .upsert({
            user_id: profile.id,
            batch_year: parseInt(formData.batch_year),
            company: formData.company,
            designation: formData.designation,
            linkedin_url: formData.linkedin_url
          })

        if (alumniError) {
          toast.error('Failed to update alumni details')
          return
        }
      }

      toast.success('Profile updated successfully!')
      setEditMode(false)
      fetchProfile()
    } catch (error) {
      console.error('Error updating profile:', error)
      toast.error('An error occurred')
    } finally {
      setSaving(false)
    }
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="bg-white p-6 rounded-lg shadow">
            <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
            <div className="h-4 bg-gray-200 rounded w-1/4"></div>
          </div>
        </div>
      </DashboardLayout>
    )
  }

  if (!profile) {
    return (
      <DashboardLayout>
        <div className="text-center py-12">
          <User className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-medium text-gray-900">Profile not found</h3>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Profile Settings</h1>
            <p className="mt-1 text-sm text-gray-500">
              Manage your account information and preferences.
            </p>
          </div>
          <div className="flex space-x-2">
            {editMode ? (
              <>
                <button
                  onClick={handleSave}
                  disabled={saving}
                  className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors disabled:opacity-50 flex items-center"
                >
                  <Save className="h-4 w-4 mr-2" />
                  {saving ? 'Saving...' : 'Save Changes'}
                </button>
                <button
                  onClick={() => {
                    setEditMode(false)
                    fetchProfile() // Reset form data
                  }}
                  className="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 transition-colors"
                >
                  Cancel
                </button>
              </>
            ) : (
              <button
                onClick={() => setEditMode(true)}
                className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
              >
                Edit Profile
              </button>
            )}
          </div>
        </div>

        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Basic Information */}
              <div className="space-y-4">
                <h3 className="text-lg font-medium text-gray-900">Basic Information</h3>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Full Name
                  </label>
                  {editMode ? (
                    <input
                      type="text"
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                    />
                  ) : (
                    <div className="flex items-center">
                      <User className="h-4 w-4 mr-2 text-gray-400" />
                      <span className="text-sm text-gray-900">{profile.name}</span>
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Email
                  </label>
                  <div className="flex items-center">
                    <Mail className="h-4 w-4 mr-2 text-gray-400" />
                    <span className="text-sm text-gray-900">{profile.email}</span>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Role
                  </label>
                  <div className="flex items-center">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                      profile.role === 'admin' ? 'bg-red-100 text-red-800' :
                      profile.role === 'alumni' ? 'bg-blue-100 text-blue-800' :
                      'bg-green-100 text-green-800'
                    }`}>
                      {profile.role.charAt(0).toUpperCase() + profile.role.slice(1)}
                    </span>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Member Since
                  </label>
                  <div className="flex items-center">
                    <Calendar className="h-4 w-4 mr-2 text-gray-400" />
                    <span className="text-sm text-gray-900">
                      {new Date(profile.created_at).toLocaleDateString()}
                    </span>
                  </div>
                </div>
              </div>

              {/* Role-specific Information */}
              <div className="space-y-4">
                <h3 className="text-lg font-medium text-gray-900">
                  {profile.role === 'student' ? 'Student Information' : 
                   profile.role === 'alumni' ? 'Alumni Information' : 
                   'Admin Information'}
                </h3>

                {profile.role === 'student' && (
                  <>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Current Year
                      </label>
                      {editMode ? (
                        <input
                          type="number"
                          value={formData.current_year}
                          onChange={(e) => setFormData({ ...formData, current_year: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          min="1"
                          max="4"
                        />
                      ) : (
                        <span className="text-sm text-gray-900">
                          {profile.studentdetails?.current_year || 'Not specified'}
                        </span>
                      )}
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Branch
                      </label>
                      {editMode ? (
                        <input
                          type="text"
                          value={formData.branch}
                          onChange={(e) => setFormData({ ...formData, branch: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          placeholder="e.g., Computer Science"
                        />
                      ) : (
                        <span className="text-sm text-gray-900">
                          {profile.studentdetails?.branch || 'Not specified'}
                        </span>
                      )}
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Skills
                      </label>
                      {editMode ? (
                        <input
                          type="text"
                          value={formData.skills}
                          onChange={(e) => setFormData({ ...formData, skills: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          placeholder="e.g., JavaScript, Python, React"
                        />
                      ) : (
                        <div className="flex flex-wrap gap-2">
                          {profile.studentdetails?.skills?.map((skill, index) => (
                            <span key={index} className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800">
                              {skill}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                  </>
                )}

                {profile.role === 'alumni' && (
                  <>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Batch Year
                      </label>
                      {editMode ? (
                        <input
                          type="number"
                          value={formData.batch_year}
                          onChange={(e) => setFormData({ ...formData, batch_year: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          placeholder="e.g., 2020"
                        />
                      ) : (
                        <span className="text-sm text-gray-900">
                          {profile.alumnidetails?.batch_year || 'Not specified'}
                        </span>
                      )}
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Company
                      </label>
                      {editMode ? (
                        <input
                          type="text"
                          value={formData.company}
                          onChange={(e) => setFormData({ ...formData, company: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          placeholder="e.g., Google"
                        />
                      ) : (
                        <div className="flex items-center">
                          <Building className="h-4 w-4 mr-2 text-gray-400" />
                          <span className="text-sm text-gray-900">
                            {profile.alumnidetails?.company || 'Not specified'}
                          </span>
                        </div>
                      )}
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Designation
                      </label>
                      {editMode ? (
                        <input
                          type="text"
                          value={formData.designation}
                          onChange={(e) => setFormData({ ...formData, designation: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          placeholder="e.g., Senior Software Engineer"
                        />
                      ) : (
                        <span className="text-sm text-gray-900">
                          {profile.alumnidetails?.designation || 'Not specified'}
                        </span>
                      )}
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        LinkedIn URL
                      </label>
                      {editMode ? (
                        <input
                          type="url"
                          value={formData.linkedin_url}
                          onChange={(e) => setFormData({ ...formData, linkedin_url: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                          placeholder="https://linkedin.com/in/yourprofile"
                        />
                      ) : (
                        <div className="flex items-center">
                          <Linkedin className="h-4 w-4 mr-2 text-gray-400" />
                          <a 
                            href={profile.alumnidetails?.linkedin_url} 
                            target="_blank" 
                            rel="noopener noreferrer"
                            className="text-sm text-primary-600 hover:text-primary-800"
                          >
                            {profile.alumnidetails?.linkedin_url || 'Not specified'}
                          </a>
                        </div>
                      )}
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Verification Status
                      </label>
                      <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                        profile.alumnidetails?.verification_status 
                          ? 'bg-green-100 text-green-800' 
                          : 'bg-yellow-100 text-yellow-800'
                      }`}>
                        {profile.alumnidetails?.verification_status ? 'Verified' : 'Pending Verification'}
                      </span>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

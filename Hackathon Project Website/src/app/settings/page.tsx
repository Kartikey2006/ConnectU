'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { useAuth } from '@/components/providers/AuthProvider'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { Settings, Save, User, Bell, Shield, Globe, Mail, Lock, Phone } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { userManagement } from '@/lib/userManagement'
import toast from 'react-hot-toast'

export default function SettingsPage() {
  const { user, refreshUserProfile } = useAuth()
  const [saving, setSaving] = useState(false)
  const [userSettings, setUserSettings] = useState({
    // Profile Settings
    name: user?.email?.split('@')[0] || '',
    email: user?.email || '',
    phone: '',
    bio: '',
    
    // Notification Settings
    emailNotifications: true,
    webNotifications: true,
    marketingEmails: false,
    jobAlerts: true,
    mentorshipUpdates: true,
    
    // Privacy Settings
    profileVisibility: 'public',
    showEmail: false,
    showPhone: false,
    allowMessages: true,
    
    // Account Settings
    twoFactorAuth: false,
    loginNotifications: true
  })

  // Load saved settings when component mounts
  useEffect(() => {
    // Load saved notification settings from localStorage
    const savedNotifications = localStorage.getItem('userNotificationSettings')
    if (savedNotifications) {
      try {
        const notificationSettings = JSON.parse(savedNotifications)
        setUserSettings(prev => ({
          ...prev,
          ...notificationSettings
        }))
      } catch (error) {
        console.error('Error loading notification settings:', error)
      }
    }

    // Load saved privacy settings from localStorage
    const savedPrivacy = localStorage.getItem('userPrivacySettings')
    if (savedPrivacy) {
      try {
        const privacySettings = JSON.parse(savedPrivacy)
        setUserSettings(prev => ({
          ...prev,
          ...privacySettings
        }))
      } catch (error) {
        console.error('Error loading privacy settings:', error)
      }
    }
  }, [])

  const handleInputChange = (field: string, value: any) => {
    setUserSettings(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleSave = async () => {
    setSaving(true)
    try {
      if (!user) {
        toast.error('Please log in to save settings')
        return
      }

      // Update user name in Supabase Auth and custom user management
      const authUpdateData: any = {}
      const profileUpdateData: any = {}

      // Get the current user to extract user ID from auth
      const { data: { user: authUser } } = await supabase.auth.getUser()
      if (!authUser) {
        toast.error('Unable to get current user')
        setSaving(false)
        return
      }

      // If name has changed, update it
      if (userSettings.name !== user?.email?.split('@')[0]) {
        authUpdateData.display_name = userSettings.name
        profileUpdateData.name = userSettings.name
      }

      // Update Supabase Auth metadata/profile
      if (Object.keys(authUpdateData).length > 0) {
        const { error: authError } = await supabase.auth.updateUser({
          data: authUpdateData
        })
        if (authError) {
          console.error('Auth update error:', authError)
          toast.error('Failed to update auth profile')
        }
      }

      // Update the users table profile information
      const userProfileUpdates = {
        name: userSettings.name,
        ...profileUpdateData
      }

      if (Object.keys(userProfileUpdates).length > 0) {
        const updateSuccess = await userManagement.updateUserProfile(authUser.id, userProfileUpdates)
        if (!updateSuccess) {
          console.log('Profile update may have failed, but continuing...')
        }
      }

      // For now, save notification settings to localStorage for demo
      // In production, these could be stored in a user_preferences table
      const notificationSettings = {
        emailNotifications: userSettings.emailNotifications,
        webNotifications: userSettings.webNotifications,
        marketingEmails: userSettings.marketingEmails,
        jobAlerts: userSettings.jobAlerts,
        mentorshipUpdates: userSettings.mentorshipUpdates
      }
      
      const privacySettings = {
        profileVisibility: userSettings.profileVisibility,
        showEmail: userSettings.showEmail,
        showPhone: userSettings.showPhone,
        allowMessages: userSettings.allowMessages
      }

      localStorage.setItem('userNotificationSettings', JSON.stringify(notificationSettings))
      localStorage.setItem('userPrivacySettings', JSON.stringify(privacySettings))

      // Refresh user profile to reflect changes in header/dashboard
      await refreshUserProfile()

      toast.success('Settings saved successfully!')
    } catch (error) {
      console.error('Error saving settings:', error)
      toast.error('Failed to save settings. Please try again.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 flex items-center">
            <Settings className="h-6 w-6 mr-2 text-blue-600" />
            Account Settings
          </h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage your profile, privacy, and notification preferences.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Profile Settings */}
          <Card className="p-6">
            <div className="flex items-center mb-4">
              <User className="h-5 w-5 text-blue-500 mr-2" />
              <h3 className="text-lg font-medium text-gray-900">Profile Settings</h3>
            </div>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">Full Name</label>
                <input
                  type="text"
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
                  value={userSettings.name}
                  onChange={(e) => handleInputChange('name', e.target.value)}
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Email</label>
                <input
                  type="email"
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 bg-gray-100 text-gray-600"
                  value={userSettings.email}
                  disabled
                />
                <p className="text-xs text-gray-500 mt-1">Contact support to change email</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Phone</label>
                <input
                  type="tel"
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
                  value={userSettings.phone}
                  onChange={(e) => handleInputChange('phone', e.target.value)}
                  placeholder="+1 (555) 123-4567"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Bio</label>
                <textarea
                  rows={3}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
                  value={userSettings.bio}
                  onChange={(e) => handleInputChange('bio', e.target.value)}
                  placeholder="Tell us about yourself..."
                />
              </div>
            </div>
          </Card>

          {/* Notification Settings */}
          <Card className="p-6">
            <div className="flex items-center mb-4">
              <Bell className="h-5 w-5 text-green-500 mr-2" />
              <h3 className="text-lg font-medium text-gray-900">Notification Settings</h3>
            </div>
            <div className="space-y-4">
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="emailNotifications"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.emailNotifications}
                  onChange={(e) => handleInputChange('emailNotifications', e.target.checked)}
                />
                <label htmlFor="emailNotifications" className="ml-2 block text-sm text-gray-700">
                  Email notifications
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="webNotifications"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.webNotifications}
                  onChange={(e) => handleInputChange('webNotifications', e.target.checked)}
                />
                <label htmlFor="webNotifications" className="ml-2 block text-sm text-gray-700">
                  Browser notifications
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="jobAlerts"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.jobAlerts}
                  onChange={(e) => handleInputChange('jobAlerts', e.target.checked)}
                />
                <label htmlFor="jobAlerts" className="ml-2 block text-sm text-gray-700">
                  Job alerts and opportunities
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="mentorshipUpdates"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.mentorshipUpdates}
                  onChange={(e) => handleInputChange('mentorshipUpdates', e.target.checked)}
                />
                <label htmlFor="mentorshipUpdates" className="ml-2 block text-sm text-gray-700">
                  Mentorship updates
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="marketingEmails"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.marketingEmails}
                  onChange={(e) => handleInputChange('marketingEmails', e.target.checked)}
                />
                <label htmlFor="marketingEmails" className="ml-2 block text-sm text-gray-700">
                  Marketing emails
                </label>
              </div>
            </div>
          </Card>

          {/* Privacy Settings */}
          <Card className="p-6">
            <div className="flex items-center mb-4">
              <Shield className="h-5 w-5 text-purple-500 mr-2" />
              <h3 className="text-lg font-medium text-gray-900">Privacy Settings</h3>
            </div>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">Profile Visibility</label>
                <select
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
                  value={userSettings.profileVisibility}
                  onChange={(e) => handleInputChange('profileVisibility', e.target.value)}
                >
                  <option value="public">Public</option>
                  <option value="connections">Connections only</option>
                  <option value="private">Private</option>
                </select>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="showEmail"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.showEmail}
                  onChange={(e) => handleInputChange('showEmail', e.target.checked)}
                />
                <label htmlFor="showEmail" className="ml-2 block text-sm text-gray-700">
                  Show email on profile
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="showPhone"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.showPhone}
                  onChange={(e) => handleInputChange('showPhone', e.target.checked)}
                />
                <label htmlFor="showPhone" className="ml-2 block text-sm text-gray-700">
                  Show phone on profile
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="allowMessages"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.allowMessages}
                  onChange={(e) => handleInputChange('allowMessages', e.target.checked)}
                />
                <label htmlFor="allowMessages" className="ml-2 block text-sm text-gray-700">
                  Allow direct messages
                </label>
              </div>
            </div>
          </Card>

          {/* Security Settings */}
          <Card className="p-6">
            <div className="flex items-center mb-4">
              <Lock className="h-5 w-5 text-red-500 mr-2" />
              <h3 className="text-lg font-medium text-gray-900">Security Settings</h3>
            </div>
            <div className="space-y-4">
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="twoFactorAuth"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.twoFactorAuth}
                  onChange={(e) => handleInputChange('twoFactorAuth', e.target.checked)}
                />
                <label htmlFor="twoFactorAuth" className="ml-2 block text-sm text-gray-700">
                  Enable two-factor authentication
                </label>
              </div>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="loginNotifications"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  checked={userSettings.loginNotifications}
                  onChange={(e) => handleInputChange('loginNotifications', e.target.checked)}
                />
                <label htmlFor="loginNotifications" className="ml-2 block text-sm text-gray-700">
                  Login notifications
                </label>
              </div>
              <div className="pt-4 border-t border-gray-200">
                <Button variant="outline" size="sm">
                  Change Password
                </Button>
              </div>
            </div>
          </Card>
        </div>

        {/* Save Button */}
        <div className="flex justify-end">
          <Button
            onClick={handleSave}
            disabled={saving}
            className="px-6"
          >
            {saving ? (
              <>
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                Saving...
              </>
            ) : (
              <>
                <Save className="h-4 w-4 mr-2" />
                Save Settings
              </>
            )}
          </Button>
        </div>
      </div>
    </DashboardLayout>
  )
}

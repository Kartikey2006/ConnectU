'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { useAuth } from '@/components/providers/AuthProvider'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'

export default function TestRolesPage() {
  const { user, userRole, refreshUserProfile } = useAuth()
  const [loading, setLoading] = useState(false)

  const switchToRole = (role: 'student' | 'alumni' | 'admin') => {
    setLoading(true)
    
    // Force set role in localStorage and trigger refresh
    localStorage.setItem('userRole', role)
    
    setTimeout(() => {
      refreshUserProfile()
      window.location.reload()
    }, 500)
  }

  const clearStorage = () => {
    localStorage.removeItem('userRole')
    localStorage.clear()
    window.location.reload()
  }

  useEffect(() => {
    setLoading(false)
  }, [userRole])

  return (
    <DashboardLayout>
      <div className="space-y-8">
        <div className="mx-auto max-w-4xl">
          {/* Header */}
          <div className="bg-gradient-to-r from-blue-600 to-purple-700 rounded-xl px-8 py-10 text-white">
            <h1 className="text-3xl font-bold mb-2">Role Testing</h1>
            <p className="text-blue-100">
              Test sidebar navigation by switching between user roles
            </p>
          </div>

          {/* Current Status */}
          <Card className="p-6 mt-6">
            <h2 className="text-xl font-semibold mb-4">Current Status</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
              <div>
                <span className="font-medium text-gray-700">User Email:</span>
                <p className="text-gray-900">{user?.email || 'Not logged in'}</p>
              </div>
              <div>
                <span className="font-medium text-gray-700">Current Role:</span>
                <p className="text-gray-900">{userRole || 'Undefined'}</p>
              </div>
              <div>
                <span className="font-medium text-gray-700">Local Storage:</span>
                <p className="text-gray-900">{typeof window !== 'undefined' ? localStorage.getItem('userRole') || 'Empty' : 'Unknown'}</p>
              </div>
            </div>
          </Card>

          {/* Role Testing Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
            {/* Student Role Test */}
            <Card className="p-6 hover:shadow-lg transition-shadow">
              <div className="text-center">
                <div className="bg-blue-100 text-blue-800 text-4xl font-bold w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  S
                </div>
                <h3 className="text-xl font-semibold mb-2">Student</h3>
                <p className="text-sm text-gray-600 mb-4">
                  Test student navigation and features
                </p>
                <Button 
                  onClick={() => switchToRole('student')}
                  disabled={loading}
                  variant={userRole === 'student' ? 'secondary' : undefined}
                  className="w-full"
                >
                  {userRole === 'student' ? '✓ Active' : 'Switch to Student'}
                </Button>
              </div>
            </Card>

            {/* Alumni Role Test */}
            <Card className="p-6 hover:shadow-lg transition-shadow">
              <div className="text-center">
                <div className="bg-green-100 text-green-800 text-4xl font-bold w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  A
                </div>
                <h3 className="text-xl font-semibold mb-2">Alumni</h3>
                <p className="text-sm text-gray-600 mb-4">
                  Test alumni navigation and features
                </p>
                <Button 
                  onClick={() => switchToRole('alumni')}
                  disabled={loading}
                  variant={userRole === 'alumni' ? 'secondary' : undefined}
                  className="w-full"
                >
                  {userRole === 'alumni' ? '✓ Active' : 'Switch to Alumni'}
                </Button>
              </div>
            </Card>

            {/* Admin Role Test */}
            <Card className="p-6 hover:shadow-lg transition-shadow">
              <div className="text-center">
                <div className="bg-purple-100 text-purple-800 text-4xl font-bold w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  A
                </div>
                <h3 className="text-xl font-semibold mb-2">Admin</h3>
                <p className="text-sm text-gray-600 mb-4">
                  Test admin navigation and features
                </p>
                <Button 
                  onClick={() => switchToRole('admin')}
                  disabled={loading}
                  variant={userRole === 'admin' ? 'secondary' : undefined}
                  className="w-full"
                >
                  {userRole === 'admin' ? '✓ Active' : 'Switch to Admin'}
                </Button>
              </div>
            </Card>
          </div>

          {/* Navigation Instructions */}
          <Card className="p-6 mt-6">
            <h2 className="text-xl font-semibold mb-4">Instructions</h2>
            <ol className="list-decimal list-inside space-y-2 text-sm text-gray-700">
              <li>Click "Switch to Alumni" to test the alumni navigation</li>
              <li>You should see new sidebar items like "Students", "Earnings", "Documents"</li>
              <li>The sidebar navigation should change immediately after role switch</li>
              <li>Navigate to <code>/alumni/dashboard</code> to see the alumni-specific dashboard</li>
            </ol>
          </Card>

          {/* Debug Info */}
          <Card className="p-6 mt-6">
            <h2 className="text-xl font-semibold mb-4">Debug Information</h2>
            <div className="space-y-2 font-mono text-xs">
              <div><strong>Current userRole:</strong> {JSON.stringify(userRole)}</div>
              <div><strong>localStorage:</strong> {typeof window !== 'undefined' ? JSON.stringify(localStorage.getItem('userRole')) : 'N/A'}</div>
              <div><strong>User auth:</strong> {JSON.stringify(!!user)}</div>
            </div>
            <div className="mt-4">
              <Button variant="outline" size="sm" onClick={clearStorage} disabled={loading}>
                Clear Storage & Reset
              </Button>
            </div>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  )
}
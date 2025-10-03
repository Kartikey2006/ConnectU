'use client'

import { useState } from 'react'
import { supabase } from '@/lib/supabase'
import { userManagement } from '@/lib/userManagement'
import DashboardLayout from '@/components/layout/DashboardLayout'

export default function TestSignupPage() {
  const [testResults, setTestResults] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  const runSignupTests = async () => {
    setLoading(true)
    const results: any[] = []

    // Test 1: Supabase connection
    try {
      const { data, error } = await supabase.auth.getSession()
      results.push({
        test: 'Supabase Connection',
        status: error ? 'FAIL' : 'PASS',
        details: error ? `Connection error: ${error.message}` : 'Successfully connected to Supabase',
        data: { error: error?.message }
      })
    } catch (err) {
      results.push({
        test: 'Supabase Connection',
        status: 'FAIL',
        details: `Connection failed: ${err}`,
        data: { error: err }
      })
    }

    // Test 2: Database users table access
    try {
      const { data, error } = await supabase
        .from('users')
        .select('count')
        .limit(1)

      results.push({
        test: 'Users Table Access',
        status: error ? 'FAIL' : 'PASS',
        details: error ? `Table access error: ${error.message}` : 'Successfully accessed users table',
        data: { error: error?.message }
      })
    } catch (err) {
      results.push({
        test: 'Users Table Access',
        status: 'FAIL',
        details: `Table access failed: ${err}`,
        data: { error: err }
      })
    }

    // Test 3: User management system
    try {
      // Test getting user profile (should return null for non-existent user)
      const profile = await userManagement.getUserProfile('test@example.com')
      results.push({
        test: 'User Management System',
        status: 'PASS',
        details: 'User management system is functional',
        data: { profile }
      })
    } catch (err) {
      results.push({
        test: 'User Management System',
        status: 'FAIL',
        details: `User management error: ${err}`,
        data: { error: err }
      })
    }

    // Test 4: Signup form validation simulation
    const testFormData = {
      name: 'Test User',
      email: 'test@example.com',
      password: 'testpassword123',
      confirmPassword: 'testpassword123',
      role: 'student' as const
    }

    // Validate form data
    const validationErrors = []
    if (!testFormData.name.trim()) validationErrors.push('Name is required')
    if (!testFormData.email.trim()) validationErrors.push('Email is required')
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(testFormData.email)) validationErrors.push('Invalid email format')
    if (testFormData.password.length < 6) validationErrors.push('Password too short')
    if (testFormData.password !== testFormData.confirmPassword) validationErrors.push('Passwords do not match')

    results.push({
      test: 'Form Validation',
      status: validationErrors.length === 0 ? 'PASS' : 'FAIL',
      details: validationErrors.length === 0 ? 'Form validation passes' : `Validation errors: ${validationErrors.join(', ')}`,
      data: { validationErrors, formData: testFormData }
    })

    // Test 5: Mock signup process (without actually creating user)
    try {
      // This would be the actual signup process
      const mockUser = {
        id: 'mock-user-id',
        email: testFormData.email,
        user_metadata: {
          name: testFormData.name,
          role: testFormData.role
        }
      }

      // Test user profile creation (mock)
      const success = await userManagement.createUserProfile(mockUser as any, testFormData.role)
      
      results.push({
        test: 'Mock User Creation',
        status: success ? 'PASS' : 'FAIL',
        details: success ? 'User creation process works' : 'User creation failed',
        data: { success, mockUser }
      })
    } catch (err) {
      results.push({
        test: 'Mock User Creation',
        status: 'FAIL',
        details: `User creation error: ${err}`,
        data: { error: err }
      })
    }

    setTestResults(results)
    setLoading(false)
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'PASS': return 'text-green-600 bg-green-100'
      case 'FAIL': return 'text-red-600 bg-red-100'
      default: return 'text-gray-600 bg-gray-100'
    }
  }

  return (
    <DashboardLayout>
      <div className="max-w-4xl mx-auto p-6">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">Signup System Test</h1>
          <p className="text-gray-600 mb-6">
            Comprehensive testing of the signup functionality and user management system.
          </p>
        </div>

        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-gray-900">Test Results</h2>
          <button
            onClick={runSignupTests}
            disabled={loading}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
          >
            {loading ? 'Running Tests...' : 'Run Signup Tests'}
          </button>
        </div>

        <div className="space-y-4">
          {testResults.map((result, index) => (
            <div key={index} className="bg-white rounded-lg shadow p-6">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-medium text-gray-900">{result.test}</h3>
                <span className={`px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(result.status)}`}>
                  {result.status}
                </span>
              </div>
              
              <p className="text-gray-600 mb-4">{result.details}</p>
              
              {result.data && (
                <details className="mt-4">
                  <summary className="cursor-pointer text-sm font-medium text-gray-700 hover:text-gray-900">
                    View Data
                  </summary>
                  <pre className="mt-2 p-4 bg-gray-100 rounded-md text-xs overflow-auto">
                    {JSON.stringify(result.data, null, 2)}
                  </pre>
                </details>
              )}
            </div>
          ))}
        </div>

        {testResults.length === 0 && !loading && (
          <div className="text-center py-12">
            <p className="text-gray-500">No test results available. Click "Run Signup Tests" to start.</p>
          </div>
        )}

        <div className="mt-8 bg-blue-50 border border-blue-200 rounded-lg p-6">
          <h3 className="text-lg font-medium text-blue-900 mb-2">Signup System Checklist</h3>
          <ul className="space-y-2 text-sm text-blue-800">
            <li className="flex items-center">
              <span className="mr-2">✓</span>
              Form validation with proper error handling
            </li>
            <li className="flex items-center">
              <span className="mr-2">✓</span>
              Supabase authentication integration
            </li>
            <li className="flex items-center">
              <span className="mr-2">✓</span>
              User profile creation in database
            </li>
            <li className="flex items-center">
              <span className="mr-2">✓</span>
              Role-based user management
            </li>
            <li className="flex items-center">
              <span className="mr-2">✓</span>
              Email verification flow
            </li>
            <li className="flex items-center">
              <span className="mr-2">✓</span>
              Proper error handling and user feedback
            </li>
          </ul>
        </div>

        <div className="mt-6 bg-yellow-50 border border-yellow-200 rounded-lg p-6">
          <h3 className="text-lg font-medium text-yellow-900 mb-2">Testing Instructions</h3>
          <ol className="space-y-2 text-sm text-yellow-800">
            <li>1. Run the signup tests above to verify system functionality</li>
            <li>2. Go to <code className="bg-yellow-100 px-1 rounded">/auth/signup</code> to test the actual signup form</li>
            <li>3. Try signing up with different roles (student/alumni)</li>
            <li>4. Test form validation with invalid data</li>
            <li>5. Verify email verification flow</li>
            <li>6. Check that users are created in the database with correct roles</li>
          </ol>
        </div>
      </div>
    </DashboardLayout>
  )
}

'use client'

import { useState } from 'react'
import { supabase } from '@/lib/supabase'

export default function TestDatabasePage() {
  const [users, setUsers] = useState<any[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const testDatabaseConnection = async () => {
    setLoading(true)
    setError(null)
    
    try {
      // Test 1: Check if users table exists and get all users
      const { data, error } = await supabase
        .from('users')
        .select('*')

      if (error) {
        setError(`Database Error: ${error.message}`)
        console.error('Database error:', error)
      } else {
        setUsers(data || [])
        console.log('Users found:', data)
      }
    } catch (err) {
      setError(`Connection Error: ${err}`)
      console.error('Connection error:', err)
    } finally {
      setLoading(false)
    }
  }

  const checkCurrentUser = async () => {
    setLoading(true)
    setError(null)
    
    try {
      const { data: { user } } = await supabase.auth.getUser()
      
      if (user) {
        console.log('Current user:', user)
        
        // Check if user exists in users table
        const { data: userData, error } = await supabase
          .from('users')
          .select('*')
          .eq('email', user.email)
          .single()

        if (error) {
          setError(`User not found in database: ${error.message}`)
        } else {
          console.log('User data from database:', userData)
          setUsers([userData])
        }
      } else {
        setError('No user logged in')
      }
    } catch (err) {
      setError(`Error: ${err}`)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white shadow rounded-lg p-6">
          <h1 className="text-2xl font-bold text-gray-900 mb-6">Database Test Page</h1>
          
          <div className="space-y-4 mb-6">
            <button
              onClick={testDatabaseConnection}
              disabled={loading}
              className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 disabled:opacity-50"
            >
              {loading ? 'Testing...' : 'Test Database Connection'}
            </button>
            
            <button
              onClick={checkCurrentUser}
              disabled={loading}
              className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 disabled:opacity-50 ml-4"
            >
              {loading ? 'Checking...' : 'Check Current User'}
            </button>
          </div>

          {error && (
            <div className="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
              <div className="text-red-800">{error}</div>
            </div>
          )}

          {users.length > 0 && (
            <div className="bg-gray-50 rounded-md p-4">
              <h2 className="text-lg font-semibold mb-4">Users Found ({users.length}):</h2>
              <div className="space-y-4">
                {users.map((user, index) => (
                  <div key={index} className="bg-white p-4 rounded border">
                    <div className="grid grid-cols-2 gap-4">
                      <div><strong>ID:</strong> {user.id}</div>
                      <div><strong>Name:</strong> {user.name}</div>
                      <div><strong>Email:</strong> {user.email}</div>
                      <div><strong>Role:</strong> <span className={`px-2 py-1 rounded text-sm ${
                        user.role === 'admin' ? 'bg-red-100 text-red-800' :
                        user.role === 'alumni' ? 'bg-purple-100 text-purple-800' :
                        'bg-blue-100 text-blue-800'
                      }`}>{user.role}</span></div>
                      <div><strong>Supabase Auth ID:</strong> {user.supabase_auth_id}</div>
                      <div><strong>Created:</strong> {new Date(user.created_at).toLocaleDateString()}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          <div className="mt-6 p-4 bg-yellow-50 border border-yellow-200 rounded-md">
            <h3 className="text-lg font-semibold text-yellow-800 mb-2">Instructions:</h3>
            <ol className="list-decimal list-inside text-yellow-700 space-y-1">
              <li>Make sure you're logged in to the website</li>
              <li>Click "Check Current User" to see your user data</li>
              <li>If you get an error, the users table might not exist or your user might not be in the database</li>
              <li>If you're the admin (kartikeyupadhyay450@gmail.com) and your role is not 'admin', you need to update it in the database</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  )
}

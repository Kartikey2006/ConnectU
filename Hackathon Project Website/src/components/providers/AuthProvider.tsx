'use client'

import { createContext, useContext, useEffect, useState } from 'react'
import { User } from '@supabase/supabase-js'
import { supabase } from '@/lib/supabase'
import { userManagement, UserProfile } from '@/lib/userManagement'

interface AuthContextType {
  user: User | null
  userRole: string | null
  userProfile: UserProfile | null
  loading: boolean
  signOut: () => Promise<void>
  refreshUserProfile: () => Promise<void>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [userRole, setUserRole] = useState<string | null>(() => {
    // Initialize from localStorage if available
    if (typeof window !== 'undefined') {
      return localStorage.getItem('userRole') || null
    }
    return null
  })
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)

  const fetchUserProfile = async (userEmail: string) => {
    // Ensure we only run this on client-side to avoid SSR/auth errors
    if (typeof window === 'undefined') {
      return
    }

    try {
      // Fast email-based role assignment for admin
      if (userEmail === 'kartikeyupadhyay450@gmail.com') {
        const role = 'admin'
        setUserRole(role)
        localStorage.setItem('userRole', role)
        setUserProfile({
          id: 1,
          name: 'Admin User',
          email: userEmail,
          role: 'admin',
          created_at: new Date().toISOString()
        })
        return
      }

      // Check localStorage first (this handles fresh signup scenarios)
      const localRole = localStorage.getItem('userRole')
      if (localRole && (localRole === 'alumni' || localRole === 'student' || localRole === 'admin')) {
        console.log('Using role from localStorage:', localRole)
        setUserRole(localRole)
        return
      }

      // For other users, check if we already have a role set in state
      // This prevents unnecessary re-fetching
      if (userRole && userRole !== 'student') {
        return // Don't override existing role
      }

      // Fetch full user profile from database
      const profile = await userManagement.getUserProfile(userEmail)
      
      if (profile) {
        setUserProfile(profile)
        setUserRole(profile.role)
        localStorage.setItem('userRole', profile.role)
      } else {
        // Default to student if no profile found
        const role = 'student'
        setUserRole(role)
        localStorage.setItem('userRole', role)
        setUserProfile(null)
      }
    } catch (error) {
      console.error('Error in fetchUserProfile:', error)
      // Only set default if we don't have a role already
      if (!userRole) {
        // Try localStorage as fallback
        const localRole = localStorage.getItem('userRole')
        if (localRole && (localRole === 'alumni' || localRole === 'student' || localRole === 'admin')) {
          setUserRole(localRole)
        } else {
          const role = 'student'
          setUserRole(role)
          localStorage.setItem('userRole', role)
          setUserProfile(null)
        }
      }
    }
  }

  const refreshUserProfile = async () => {
    if (user?.email) {
      await fetchUserProfile(user.email)
    }
  }

  useEffect(() => {
    // Only run authentication checks on client-side to avoid SSR issues
    if (typeof window === 'undefined') {
      setLoading(false)
      return
    }

    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
      if (session?.user?.email) {
        fetchUserProfile(session.user.email)
      }
      setLoading(false)
    }).catch((error) => {
      console.log('Auth check failed during build (this is normal for static generation)')
      setLoading(false)
    })

    // Listen for auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
      if (session?.user?.email) {
        fetchUserProfile(session.user.email)
      } else {
        setUserRole(null)
        setUserProfile(null)
      }
      setLoading(false)
    })

    // Subscribe to role changes for real-time updates
    const roleChangeSubscription = userManagement.subscribeToRoleChanges((event) => {
      // Get current user from state instead of dependency
      supabase.auth.getUser().then(({ data: { user: currentUser } }) => {
        if (currentUser?.id === event.user_id) {
          setUserRole(event.new_role)
          // Refresh profile to get updated data
          refreshUserProfile()
        }
      })
    })

    return () => {
      subscription.unsubscribe()
      roleChangeSubscription.unsubscribe()
    }
  }, []) // Remove user dependency to prevent re-runs

  const signOut = async () => {
    setUserRole(null)
    setUserProfile(null)
    localStorage.removeItem('userRole')
    await supabase.auth.signOut()
  }

  const value = {
    user,
    userRole,
    userProfile,
    loading,
    signOut,
    refreshUserProfile,
  }

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}

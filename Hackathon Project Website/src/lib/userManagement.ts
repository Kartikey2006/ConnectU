import { supabase } from './supabase'
import { User } from '@supabase/supabase-js'

export interface UserProfile {
  id: number
  name: string
  email: string
  role: 'student' | 'alumni' | 'admin'
  supabase_auth_id?: string
  created_at: string
  studentdetails?: {
    current_year: number
    branch: string
    skills: string[]
  }
  alumnidetails?: {
    batch_year: number
    company: string
    designation: string
    linkedin_url: string
    verification_status: boolean
  }
}

export interface RoleUpdateEvent {
  user_id: string
  old_role: string
  new_role: string
  timestamp: string
}

class UserManagementSystem {
  private listeners: Map<string, Function[]> = new Map()

  // Subscribe to user data changes
  subscribeToUserChanges(userId: string, callback: (user: UserProfile) => void) {
    if (!this.listeners.has(userId)) {
      this.listeners.set(userId, [])
    }
    this.listeners.get(userId)!.push(callback)

    // Return unsubscribe function
    return () => {
      const callbacks = this.listeners.get(userId)
      if (callbacks) {
        const index = callbacks.indexOf(callback)
        if (index > -1) {
          callbacks.splice(index, 1)
        }
      }
    }
  }

  // Subscribe to role changes across all users
  subscribeToRoleChanges(callback: (event: RoleUpdateEvent) => void) {
    return supabase
      .channel('role_changes')
      .on('postgres_changes', {
        event: 'UPDATE',
        schema: 'public',
        table: 'users',
        filter: 'role=neq.old.role'
      }, (payload) => {
        const event: RoleUpdateEvent = {
          user_id: payload.new.supabase_auth_id,
          old_role: payload.old.role,
          new_role: payload.new.role,
          timestamp: new Date().toISOString()
        }
        callback(event)
      })
      .subscribe()
  }

  // Get user profile with role
  async getUserProfile(email: string): Promise<UserProfile | null> {
    try {
      const { data, error } = await supabase
        .from('users')
        .select(`
          *,
          studentdetails (*),
          alumnidetails (*)
        `)
        .eq('email', email)
        .single()

      if (error) {
        console.error('Error fetching user profile:', error)
        return null
      }

      return data
    } catch (error) {
      console.error('Error in getUserProfile:', error)
      return null
    }
  }

  // Update user role (admin function)
  async updateUserRole(userId: string, newRole: 'student' | 'alumni' | 'admin'): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('users')
        .update({ role: newRole })
        .eq('supabase_auth_id', userId)

      if (error) {
        console.error('Error updating user role:', error)
        return false
      }

      // Log role change
      await this.logRoleChange(userId, newRole)
      return true
    } catch (error) {
      console.error('Error in updateUserRole:', error)
      return false
    }
  }

  // Create user profile after signup
  async createUserProfile(user: User, role: 'student' | 'alumni' = 'student'): Promise<boolean> {
    try {
      console.log('Creating profile for user:', user.email, 'with role:', role)
      
      const { data, error } = await supabase
        .from('users')
        .insert({
          name: user.user_metadata?.name || user.email?.split('@')[0] || 'User',
          email: user.email || '',
          role: role,
          supabase_auth_id: user.id
        })
        .select()

      if (error) {
        console.error('Error creating user profile:', error)
        console.error('Error details:', JSON.stringify(error, null, 2))
        return false
      }

      console.log('Profile created successfully:', data)
      return true
    } catch (error) {
      console.error('Error in createUserProfile:', error)
      console.error('Exception details:', JSON.stringify(error, null, 2))
      return false
    }
  }

  // Update user profile
  async updateUserProfile(userId: string, updates: Partial<UserProfile>): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('users')
        .update(updates)
        .eq('supabase_auth_id', userId)

      if (error) {
        console.error('Error updating user profile:', error)
        return false
      }

      return true
    } catch (error) {
      console.error('Error in updateUserProfile:', error)
      return false
    }
  }

  // Get all users (admin function)
  async getAllUsers(): Promise<UserProfile[]> {
    try {
      const { data, error } = await supabase
        .from('users')
        .select(`
          *,
          studentdetails (*),
          alumnidetails (*)
        `)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('Error fetching all users:', error)
        return []
      }

      return data || []
    } catch (error) {
      console.error('Error in getAllUsers:', error)
      return []
    }
  }

  // Log role changes for audit
  private async logRoleChange(userId: string, newRole: string): Promise<void> {
    try {
      await supabase
        .from('role_change_log')
        .insert({
          user_id: userId,
          new_role: newRole,
          changed_at: new Date().toISOString()
        })
    } catch (error) {
      console.error('Error logging role change:', error)
    }
  }

  // Validate role-based access
  validateRoleAccess(userRole: string, requiredRole: string): boolean {
    const roleHierarchy = {
      'student': 1,
      'alumni': 2,
      'admin': 3
    }

    const userLevel = roleHierarchy[userRole as keyof typeof roleHierarchy] || 0
    const requiredLevel = roleHierarchy[requiredRole as keyof typeof roleHierarchy] || 0

    return userLevel >= requiredLevel
  }

  // Get dashboard data based on role
  async getDashboardData(userRole: string, userId: string): Promise<any> {
    switch (userRole) {
      case 'student':
        return this.getStudentDashboardData(userId)
      case 'alumni':
        return this.getAlumniDashboardData(userId)
      case 'admin':
        return this.getAdminDashboardData()
      default:
        return null
    }
  }

  private async getStudentDashboardData(userId: string) {
    // Implementation for student dashboard data
    return {
      upcomingSessions: 2,
      totalMentors: 15,
      registeredWebinars: 3,
      pendingReferrals: 1,
      recentActivity: []
    }
  }

  private async getAlumniDashboardData(userId: string) {
    // Implementation for alumni dashboard data
    return {
      totalStudents: 8,
      activeMentorshipSessions: 3,
      upcomingWebinars: 2,
      totalEarnings: 450.00,
      pendingRequests: 2,
      completedSessions: 12
    }
  }

  private async getAdminDashboardData() {
    // Implementation for admin dashboard data
    return {
      totalUsers: 156,
      totalStudents: 89,
      totalAlumni: 45,
      totalSessions: 234,
      totalWebinars: 67,
      totalRevenue: 12580.50,
      pendingVerifications: 8,
      activeUsers: 142
    }
  }
}

// Export singleton instance
export const userManagement = new UserManagementSystem()

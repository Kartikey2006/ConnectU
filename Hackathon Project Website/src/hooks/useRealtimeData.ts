import { useEffect, useState, useCallback } from 'react'
import { supabase } from '@/lib/supabase'
import { RealtimeChannel } from '@supabase/supabase-js'

interface RealtimeSubscription {
  channel: RealtimeChannel
  unsubscribe: () => void
}

export function useRealtimeData<T>(
  table: string,
  selectQuery: string = '*',
  filter?: { column: string; value: any }
) {
  const [data, setData] = useState<T[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchData = useCallback(async () => {
    try {
      setLoading(true)
      let query = supabase.from(table).select(selectQuery)

      if (filter) {
        query = query.eq(filter.column, filter.value)
      }

      const { data: result, error: fetchError } = await query

      if (fetchError) {
        setError(fetchError.message)
        return
      }

      setData((result as T[]) || [])
      setError(null)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred')
    } finally {
      setLoading(false)
    }
  }, [table, selectQuery, filter])

  useEffect(() => {
    // Initial data fetch
    fetchData()

    // Set up real-time subscription
    const channel = supabase
      .channel(`${table}_changes`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: table,
          filter: filter ? `${filter.column}=eq.${filter.value}` : undefined
        },
        (payload) => {
          console.log('Real-time update received:', payload)

          setData(prevData => {
            switch (payload.eventType) {
              case 'INSERT':
                return [...prevData, payload.new as T]
              case 'UPDATE':
                return prevData.map(item => 
                  (item as any).id === payload.new.id ? payload.new as T : item
                )
              case 'DELETE':
                return prevData.filter(item => (item as any).id !== payload.old.id)
              default:
                return prevData
            }
          })
        }
      )
      .subscribe()

    return () => {
      channel.unsubscribe()
    }
  }, [fetchData, table, filter])

  const refresh = useCallback(() => {
    fetchData()
  }, [fetchData])

  return {
    data,
    loading,
    error,
    refresh
  }
}

// Specialized hooks for different data types
export function useUsers() {
  return useRealtimeData('users', `
    *,
    studentdetails (*),
    alumnidetails (*)
  `)
}

export function useMentorshipSessions(userId?: string) {
  const filter = userId ? { column: 'student_id', value: userId } : undefined
  return useRealtimeData('mentorship_sessions', `
    *,
    alumni:alumni_id (name, email),
    student:student_id (name, email)
  `, filter)
}

export function useWebinars() {
  return useRealtimeData('webinars', `
    *,
    alumni:alumni_id (name, email)
  `)
}

export function useReferrals(userId?: string) {
  const filter = userId ? { column: 'student_id', value: userId } : undefined
  return useRealtimeData('referrals', `
    *,
    student:student_id (name, email),
    alumni:alumni_id (name, email)
  `, filter)
}

// Role change subscription hook
export function useRoleChanges(callback: (event: any) => void) {
  useEffect(() => {
    const channel = supabase
      .channel('role_changes')
      .on('postgres_changes', {
        event: 'UPDATE',
        schema: 'public',
        table: 'users',
        filter: 'role=neq.old.role'
      }, callback)
      .subscribe()

    return () => {
      channel.unsubscribe()
    }
  }, [callback])
}

// User profile subscription hook
export function useUserProfile(userEmail: string) {
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (!userEmail) return

    const fetchProfile = async () => {
      try {
        const { data, error } = await supabase
          .from('users')
          .select(`
            *,
            studentdetails (*),
            alumnidetails (*)
          `)
          .eq('email', userEmail)
          .single()

        if (error) {
          console.error('Error fetching profile:', error)
          return
        }

        setProfile(data)
      } catch (err) {
        console.error('Error in fetchProfile:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchProfile()

    // Subscribe to profile changes
    const channel = supabase
      .channel(`user_profile_${userEmail}`)
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'users',
        filter: `email=eq.${userEmail}`
      }, (payload) => {
        console.log('Profile update received:', payload)
        if (payload.eventType === 'UPDATE') {
          setProfile(payload.new as any)
        }
      })
      .subscribe()

    return () => {
      channel.unsubscribe()
    }
  }, [userEmail])

  return { profile, loading }
}

// Forum-specific hooks
export function useForumCategories() {
  return useRealtimeData('forum_categories', '*')
}

export function useForumPosts(categoryId?: number) {
  const filter = categoryId ? { column: 'category_id', value: categoryId } : undefined
  return useRealtimeData('forum_posts', `
    *,
    user:user_id (id, name, email, role),
    category:category_id (id, name, description)
  `, filter)
}

export function useForumComments(postId: number) {
  return useRealtimeData('forum_comments', `
    *,
    user:user_id (id, name, email, role)
  `, { column: 'post_id', value: postId })
}

export function useForumPost(postId: number) {
  return useRealtimeData('forum_posts', `
    *,
    user:user_id (id, name, email, role),
    category:category_id (id, name, description)
  `, { column: 'id', value: postId })
}

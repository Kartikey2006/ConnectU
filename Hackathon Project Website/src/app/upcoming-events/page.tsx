'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Card, CardContent } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { 
  Calendar, 
  Clock, 
  Users, 
  MapPin, 
  Star, 
  Bell,
  Filter,
  Search,
  CheckCircle
} from 'lucide-react'
import toast from 'react-hot-toast'

interface UpcomingEvent {
  id: number
  title: string
  description: string
  date_time: string
  location: string
  max_attendees: number
  registered_attendees: number
  event_type: 'career' | 'networking' | 'education' | 'social'
  created_by: number
  created_at: string
  author?: {
    name: string
    email: string
  }
  is_registered?: boolean
}

export default function UpcomingEventsPage() {
  const [events, setEvents] = useState<UpcomingEvent[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')
  const [searchTerm, setSearchTerm] = useState('')
  const [registeredEvents, setRegisteredEvents] = useState<number[]>([])

  useEffect(() => {
    fetchUpcomingEvents()
    fetchRegisteredEvents()
    
    // Subscribe to real-time updates
    const subscription = supabase
      .channel('upcoming_events')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: 'events' },
        () => fetchUpcomingEvents()
      )
      .subscribe()

    return () => {
      subscription.unsubscribe()
    }
  }, [])

  const fetchUpcomingEvents = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockEvents: UpcomingEvent[] = [
        {
          id: 1,
          title: 'Career Workshop: Resume Building',
          description: 'Learn how to craft a compelling resume that gets noticed by employers.',
          date_time: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(),
          location: 'Online',
          max_attendees: 50,
          registered_attendees: 23,
          event_type: 'career',
          created_by: 1,
          created_at: new Date().toISOString(),
          author: { name: 'Arjun Sharma', email: 'arjun@example.com' },
          is_registered: false
        },
        {
          id: 2,
          title: 'Alumni Networking Dinner',
          description: 'Join fellow alumni for an evening of networking and career discussions.',
          date_time: new Date(Date.now() + 12 * 24 * 60 * 60 * 1000).toISOString(),
          location: 'Alumni Hall, University',
          max_attendees: 80,
          registered_attendees: 45,
          event_type: 'networking',
          created_by: 2,
          created_at: new Date().toISOString(),
          author: { name: 'Priya Patel', email: 'priya@example.com' },
          is_registered: true
        },
        {
          id: 3,
          title: 'Introduction to Data Science',
          description: 'Free workshop covering the fundamentals of data science and machine learning.',
          date_time: new Date(Date.now() + 19 * 24 * 60 * 60 * 1000).toISOString(),
          location: 'Computer Lab, Bldg 5',
          max_attendees: 30,
          registered_attendees: 12,
          event_type: 'education',
          created_by: 3,
          created_at: new Date().toISOString(),
          author: { name: 'Rajesh Kumar', email: 'rajesh@example.com' },
          is_registered: false
        }
      ]

      const eventsWithStatus = mockEvents.map(event => ({
        ...event,
        is_registered: registeredEvents.includes(event.id)
      }))

      setEvents(eventsWithStatus)
      
      /* Uncomment when database tables are ready:
      const now = new Date()
      const next30Days = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000)

      const { data, error } = await supabase
        .from('events')
        .select(`
          *,
          author:users(name, email),
          attendees:event_registrations(user_id)
        `)
        .gte('date_time', now.toISOString())
        .lte('date_time', next30Days.toISOString())
        .order('date_time', { ascending: true })

      if (error) {
        console.error('Error fetching upcoming events:', error)
        toast.error('Error loading upcoming events')
        return
      }

      // Add registration status
      const eventsWithStatus = data?.map(event => ({
        ...event,
        registered_attendees: event.attendees?.length || 0,
        is_registered: registeredEvents.includes(event.id)
      })) || []

      setEvents(eventsWithStatus.filter((event: any) => event.author))
      */
    } catch (error) {
      console.error('Error fetching upcoming events:', error)
      toast.error('Error loading upcoming events')
      setEvents([])
    } finally {
      setLoading(false)
    }
  }

  const fetchRegisteredEvents = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { data } = await supabase
        .from('event_registrations')
        .select('event_id')
        .eq('user_id', user.id)

      if (data) {
        setRegisteredEvents(data.map(item => item.event_id))
      }
    } catch (error) {
      console.error('Error fetching registered events:', error)
    }
  }

  const registerToEvent = async (eventId: number) => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) {
        toast.error('Please log in to register for events')
        return
      }

      const { error } = await supabase
        .from('event_registrations')
        .insert({
          event_id: eventId,
          user_id: user.id,
          registered_at: new Date().toISOString()
        })

      if (error) {
        console.error('Registration error:', error)
        toast.error('Error registering for event')
        return
      }

      toast.success('Successfully registered for event!')
      setRegisteredEvents(prev => [...prev, eventId])
      
      // Add to events state
      setEvents(prev => prev.map(event => 
        event.id === eventId 
          ? { ...event, is_registered: true, registered_attendees: event.registered_attendees + 1 }
          : event
      ))

    } catch (error) {
      console.error('Registration error:', error)
      toast.error('Error registering for event')
    }
  }

  const unregisterFromEvent = async (eventId: number) => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { error } = await supabase
        .from('event_registrations')
        .delete()
        .eq('event_id', eventId)
        .eq('user_id', user.id)

      if (error) {
        console.error('Unregistration error:', error)
        toast.error('Error unregistering from event')
        return
      }

      toast.success('Successfully unregistered from event')
      setRegisteredEvents(prev => prev.filter(id => id !== eventId))
      
      // Update events state
      setEvents(prev => prev.map(event => 
        event.id === eventId 
          ? { ...event, is_registered: false, registered_attendees: event.registered_attendees - 1 }
          : event
      ))

    } catch (error) {
      console.error('Unregistration error:', error)
      toast.error('Error unregistering from event')
    }
  }

  const toggleEventNotification = (eventId: number) => {
    // Todo: Implement notification toggle
    toast.success('Notification preference updated!')
  }

  const filteredEvents = events.filter(event => {
    const matchesFilter = filter === 'all' || event.event_type === filter
    const matchesSearch = searchTerm === '' || 
      event.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      event.description.toLowerCase().includes(searchTerm.toLowerCase())
    
    return matchesFilter && matchesSearch
  })

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  const formatTimeRemaining = (dateString: string) => {
    const eventDate = new Date(dateString)
    const now = new Date()
    const diffTime = eventDate.getTime() - now.getTime()
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
    
    if (diffDays < 0) return 'Event has passed'
    if (diffDays === 0) return 'Today!'
    if (diffDays === 1) return 'Tomorrow'
    return `${diffDays} days until event`
  }

  const getEventTypeColor = (type: string) => {
    const colors = {
      career: 'blue',
      networking: 'green',
      education: 'purple',
      social: 'orange'
    }
    return colors[type as keyof typeof colors] || 'blue'
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="h-64 bg-gray-200 rounded"></div>
            ))}
          </div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Upcoming Events</h1>
            <p className="mt-1 text-sm text-gray-500">
              Discover and register for upcoming networking, career, and educational events
            </p>
          </div>
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              onClick={() => toast.success('Calendar export feature coming soon!')}
              className="flex items-center gap-2"
            >
              <Calendar size={20} />
              Export Calendar
            </Button>
          </div>
        </div>

        {/* Filters and Search */}
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex gap-2">
            {['all', 'career', 'networking', 'education', 'social'].map((type) => (
              <Button
                key={type}
                variant={filter === type ? 'primary' : 'outline'}
                size="sm"
                onClick={() => setFilter(type)}
                className="capitalize"
              >
                {type === 'all' ? 'All Events' : type}
              </Button>
            ))}
          </div>
          
          <div className="flex-1 max-w-md">
            <div className="relative">
              <input
                type="text"
                placeholder="Search events..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
              <Search className="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
            </div>
          </div>
        </div>

        {/* Events List */}
        {filteredEvents.length === 0 ? (
          <Card className="p-8 text-center">
            <Calendar size={48} className="mx-auto text-gray-400 mb-4" />
            <h3 className="text-xl font-semibold text-gray-700 mb-2">
              No upcoming events found
            </h3>
            <p className="text-gray-500 mb-4">
              {searchTerm || filter !== 'all' 
                ? 'No events match your current filters.' 
                : 'No events are scheduled for the next 30 days.'}
            </p>
            <Button onClick={fetchUpcomingEvents}>
              Refresh Events
            </Button>
          </Card>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {filteredEvents.map((event) => (
              <Card key={event.id} className="hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <Badge 
                          variant="info" 
                          className={`bg-${getEventTypeColor(event.event_type)}-100 text-${getEventTypeColor(event.event_type)}-800`}
                        >
                          {event.event_type}
                        </Badge>
                        {event.is_registered && (
                          <Badge variant="success" className="bg-green-100 text-green-800">
                            <CheckCircle size={14} className="mr-1" />
                            Registered
                          </Badge>
                        )}
                      </div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-2">
                        {event.title}
                      </h3>
                      <p className="text-gray-600 text-sm line-clamp-2 mb-4">
                        {event.description}
                      </p>
                    </div>
                    {!event.is_registered && (
                      <button
                        onClick={() => toggleEventNotification(event.id)}
                        className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                      >
                        <Bell size={20} className="text-gray-400" />
                      </button>
                    )}
                  </div>
                  
                  <div className="space-y-3 mb-4">
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Calendar size={16} />
                      <span>{formatDate(event.date_time)}</span>
                      <Badge variant="info" className="ml-auto">
                        {formatTimeRemaining(event.date_time)}
                      </Badge>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <MapPin size={16} />
                      <span>{event.location || 'Online Event'}</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Users size={16} />
                      <span>
                        {event.registered_attendees} / {event.max_attendees} registered
                      </span>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <div className="text-sm text-gray-500">
                      by {event.author?.name || 'Unknown'}
                    </div>
                    <div className="flex gap-2">
                      {event.is_registered ? (
                        <Button
                          variant="danger"
                          size="sm"
                          onClick={() => unregisterFromEvent(event.id)}
                        >
                          Unregister
                        </Button>
                      ) : (
                        <Button
                          size="sm"
                          onClick={() => registerToEvent(event.id)}
                          disabled={event.registered_attendees >= event.max_attendees}
                          className="flex items-center gap-1"
                        >
                          <Calendar size={14} />
                          Register
                        </Button>
                      )}
                      {event.registered_attendees >= event.max_attendees && !event.is_registered && (
                        <Badge variant="danger" className="ml-2">
                          Full
                        </Badge>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}

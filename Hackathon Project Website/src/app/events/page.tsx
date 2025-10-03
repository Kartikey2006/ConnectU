'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Card, CardContent } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Calendar, Clock, Users, MapPin, ArrowRight, Filter } from 'lucide-react'
import toast from 'react-hot-toast'

interface Event {
  id: number
  title: string
  description: string
  date_time: string
  location: string
  max_attendees: number
  created_by: number
  created_at: string
  status: 'upcoming' | 'ongoing' | 'completed'
  type: 'career' | 'networking' | 'education' | 'social'
  author?: {
    name: string
    email: string
  }
}

export default function EventsPage() {
  const [events, setEvents] = useState<Event[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')
  const [searchTerm, setSearchTerm] = useState('')

  useEffect(() => {
    fetchEvents()
    
    // Subscribe to real-time updates
    const subscription = supabase
      .channel('events')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: 'events' },
        () => fetchEvents()
      )
      .subscribe()

    return () => {
      subscription.unsubscribe()
    }
  }, [])

  const fetchEvents = async () => {
    try {
      // For now, show mock data since tables might not exist yet
      // TODO: Replace with actual database queries once tables are created
      const mockEvents: Event[] = [
        {
          id: 1,
          title: 'Tech Conference 2024',
          description: 'Join us for the biggest tech conference of the year featuring industry leaders and innovative sessions.',
          date_time: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(),
          location: 'Convention Center, Downtown',
          max_attendees: 500,
          created_by: 1,
          created_at: new Date().toISOString(),
          status: 'upcoming',
          type: 'career',
          author: { name: 'Arjun Sharma', email: 'arjun@example.com' }
        },
        {
          id: 2,
          title: 'Alumni Networking Mixer',
          description: 'Connect with fellow alumni from various industries and build meaningful professional relationships.',
          date_time: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
          location: 'Alumni Hall, University',
          max_attendees: 100,
          created_by: 2,
          created_at: new Date().toISOString(),
          status: 'upcoming',
          type: 'networking',
          author: { name: 'Priya Patel', email: 'priya@example.com' }
        },
        {
          id: 3,
          title: 'AI & Machine Learning Workshop',
          description: 'Learn about the latest trends in AI and machine learning from industry experts.',
          date_time: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString(),
          location: 'Online',
          max_attendees: 200,
          created_by: 3,
          created_at: new Date().toISOString(),
          status: 'upcoming',
          type: 'education',
          author: { name: 'Rajesh Kumar', email: 'rajesh@example.com' }
        }
      ]

      setEvents(mockEvents)
      
      /* Uncomment when database tables are ready:
      const { data, error } = await supabase
        .from('events')
        .select(`
          *,
          author:users(name, email)
        `)
        .order('date_time', { ascending: true })

      if (error) {
        console.error('Error fetching events:', error)
        toast.error('Error loading events')
        return
      }

      setEvents(data?.filter((event: any) => event.author) || [])
      */
    } catch (error) {
      console.error('Error fetching events:', error)
      toast.error('Error loading events')
      setEvents([])
    } finally {
      setLoading(false)
    }
  }

  const filteredEvents = events.filter(event => {
    const matchesFilter = filter === 'all' || event.type === filter
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

  const formatTimeAgo = (dateString: string) => {
    const date = new Date(dateString)
    const now = new Date()
    const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60))
    
    if (diffInHours < 1) return 'Just now'
    if (diffInHours < 24) return `${diffInHours} hour(s) ago`
    const diffInDays = Math.floor(diffInHours / 24)
    return `${diffInDays} day(s) ago`
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

  const getEventStatus = (eventDate: string) => {
    const date = new Date(eventDate)
    const now = new Date()
    
    if (date < now) return 'completed'
    if (Math.abs(date.getTime() - now.getTime()) < 24 * 60 * 60 * 1000) {
      return 'ongoing'
    }
    return 'upcoming'
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {[1, 2, 3, 4, 5, 6].map((i) => (
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
            <h1 className="text-2xl font-bold text-gray-900">Events</h1>
            <p className="mt-1 text-sm text-gray-500">
              Discover and join exciting events for networking and learning
            </p>
          </div>
          <Button
            onClick={() => {
              // Todo: implement create event functionality
              toast.success('Create event feature coming soon!')
            }}
            className="flex items-center gap-2"
          >
            <Calendar size={20} />
            Create Event
          </Button>
        </div>

        {/* Filters */}
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
                {type === 'all' ? 'All Types' : type}
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
              <Filter className="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
            </div>
          </div>
        </div>

        {/* Events List */}
        {filteredEvents.length === 0 ? (
          <Card className="p-8 text-center">
            <Calendar size={48} className="mx-auto text-gray-400 mb-4" />
            <h3 className="text-xl font-semibold text-gray-700 mb-2">
              No events found
            </h3>
            <p className="text-gray-500 mb-4">
              {searchTerm || filter !== 'all' 
                ? 'No events match your current filters.' 
                : 'No events have been created yet.'}
            </p>
            <Button onClick={fetchEvents}>
              Refresh Events
            </Button>
          </Card>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredEvents.map((event) => (
              <Card key={event.id} className="hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <Badge 
                          variant="info" 
                          className={`bg-${getEventTypeColor(event.type)}-100 text-${getEventTypeColor(event.type)}-800`}
                        >
                          {event.type}
                        </Badge>
                        <Badge 
                          variant={
                            getEventStatus(event.date_time) === 'upcoming' ? 'success' :
                            getEventStatus(event.date_time) === 'ongoing' ? 'warning' : 'danger'
                          }
                        >
                          {getEventStatus(event.date_time)}
                        </Badge>
                      </div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-2">
                        {event.title}
                      </h3>
                      <p className="text-gray-600 text-sm line-clamp-2 mb-4">
                        {event.description}
                      </p>
                    </div>
                  </div>
                  
                  <div className="space-y-3 mb-4">
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Calendar size={16} />
                      <span>{formatDate(event.date_time)}</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <MapPin size={16} />
                      <span>{event.location || 'Online Event'}</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Users size={16} />
                      <span>Max {event.max_attendees} attendees</span>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      {event.author && (
                        <div className="flex items-center gap-2">
                          <div className="w-6 h-6 bg-gray-200 rounded-full"></div>
                          <span>{event.author.name}</span>
                        </div>
                      )}
                    </div>
                    <Button
                      size="sm"
                      className="flex items-center gap-1"
                    >
                      Join Event
                      <ArrowRight size={14} />
                    </Button>
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

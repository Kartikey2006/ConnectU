'use client'

import { useState, useEffect } from 'react'
import DashboardLayout from '@/components/layout/DashboardLayout'
import { supabase } from '@/lib/supabase'
import { MessageSquare, Send, User } from 'lucide-react'
import toast from 'react-hot-toast'
import { useAuth } from '@/components/providers/AuthProvider'

interface ChatMessage {
  id: number
  sender_id: number
  receiver_id: number
  message: string
  created_at: string
  sender?: {
    id: number
    name: string
    role: string
  }
  receiver?: {
    id: number
    name: string
    role: string
  }
}

export default function ChatPage() {
  const { user } = useAuth()
  const [messages, setMessages] = useState<ChatMessage[]>([])
  const [newMessage, setNewMessage] = useState('')
  const [selectedUser, setSelectedUser] = useState<number | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchMessages()
  }, [selectedUser])

  const fetchMessages = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user || !selectedUser) return

      const { data, error } = await supabase
        .from('chat_messages')
        .select(`
          *,
          sender:sender_id (name, role),
          receiver:receiver_id (name, role)
        `)
        .or(`and(sender_id.eq.${user?.id},receiver_id.eq.${selectedUser}),and(sender_id.eq.${selectedUser},receiver_id.eq.${user?.id})`)
        .order('created_at', { ascending: true })

      if (error) {
        console.error('Error fetching messages:', error)
        return
      }

      setMessages(data || [])
    } catch (error) {
      console.error('Error fetching messages:', error)
    } finally {
      setLoading(false)
    }
  }

  const sendMessage = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!newMessage.trim() || !selectedUser) return

    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { error } = await supabase
        .from('chat_messages')
        .insert({
          sender_id: user?.id,
          receiver_id: selectedUser,
          message: newMessage.trim()
        })

      if (error) {
        toast.error('Failed to send message')
        return
      }

      setNewMessage('')
      fetchMessages()
    } catch (error) {
      console.error('Error sending message:', error)
      toast.error('An error occurred')
    }
  }

  const getConnectedUsers = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return []

      const { data, error } = await supabase
        .from('chat_messages')
        .select(`
          sender:sender_id (id, name, role),
          receiver:receiver_id (id, name, role)
        `)
        .or(`sender_id.eq.${user?.id},receiver_id.eq.${user?.id}`)

      if (error) {
        console.error('Error fetching connected users:', error)
        return []
      }

      // Extract unique users
      const users = new Map()
      data?.forEach(msg => {
        if (msg.sender && (msg.sender as any).id !== user?.id) {
          users.set((msg.sender as any).id, msg.sender)
        }
        if (msg.receiver && (msg.receiver as any).id !== user?.id) {
          users.set((msg.receiver as any).id, msg.receiver)
        }
      })

      return Array.from(users.values())
    } catch (error) {
      console.error('Error fetching connected users:', error)
      return []
    }
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
          <div className="h-96 bg-gray-200 rounded"></div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Messages</h1>
          <p className="mt-1 text-sm text-gray-500">
            Connect and communicate with other platform users.
          </p>
        </div>

        <div className="bg-white rounded-lg shadow-md overflow-hidden">
          <div className="flex h-96">
            {/* Chat List */}
            <div className="w-1/3 border-r border-gray-200">
              <div className="p-4 border-b border-gray-200">
                <h3 className="text-lg font-medium text-gray-900">Conversations</h3>
              </div>
              <div className="overflow-y-auto h-full">
                {/* This would be populated with actual connected users */}
                <div className="p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer">
                  <div className="flex items-center">
                    <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                      <User className="h-5 w-5 text-primary-600" />
                    </div>
                    <div className="ml-3">
                      <p className="text-sm font-medium text-gray-900">Arjun Sharma</p>
                      <p className="text-xs text-gray-500">Alumni</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Chat Area */}
            <div className="flex-1 flex flex-col">
              {selectedUser ? (
                <>
                  {/* Chat Header */}
                  <div className="p-4 border-b border-gray-200">
                    <div className="flex items-center">
                      <div className="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center">
                        <User className="h-4 w-4 text-primary-600" />
                      </div>
                      <div className="ml-3">
                        <p className="text-sm font-medium text-gray-900">Selected User</p>
                        <p className="text-xs text-gray-500">Online</p>
                      </div>
                    </div>
                  </div>

                  {/* Messages */}
                  <div className="flex-1 overflow-y-auto p-4 space-y-4">
                    {messages.length === 0 ? (
                      <div className="text-center text-gray-500">
                        <MessageSquare className="mx-auto h-8 w-8 mb-2" />
                        <p>No messages yet. Start a conversation!</p>
                      </div>
                    ) : (
                      messages.map((message) => (
                        <div
                          key={message.id}
                          className={`flex ${message.sender_id === selectedUser ? 'justify-start' : 'justify-end'}`}
                        >
                          <div
                            className={`max-w-xs px-4 py-2 rounded-lg ${
                              message.sender_id === selectedUser
                                ? 'bg-gray-200 text-gray-900'
                                : 'bg-primary-600 text-white'
                            }`}
                          >
                            <p className="text-sm">{message.message}</p>
                            <p className={`text-xs mt-1 ${
                              message.sender_id === selectedUser ? 'text-gray-500' : 'text-primary-200'
                            }`}>
                              {new Date(message.created_at).toLocaleTimeString()}
                            </p>
                          </div>
                        </div>
                      ))
                    )}
                  </div>

                  {/* Message Input */}
                  <form onSubmit={sendMessage} className="p-4 border-t border-gray-200">
                    <div className="flex space-x-2">
                      <input
                        type="text"
                        value={newMessage}
                        onChange={(e) => setNewMessage(e.target.value)}
                        placeholder="Type a message..."
                        className="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500"
                      />
                      <button
                        type="submit"
                        disabled={!newMessage.trim()}
                        className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                      >
                        <Send className="h-4 w-4" />
                      </button>
                    </div>
                  </form>
                </>
              ) : (
                <div className="flex-1 flex items-center justify-center text-gray-500">
                  <div className="text-center">
                    <MessageSquare className="mx-auto h-12 w-12 mb-4" />
                    <p>Select a conversation to start messaging</p>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

import { render, screen, waitFor } from '@testing-library/react'
import StudentDashboard from '@/app/student/dashboard/page'
import AlumniDashboard from '@/app/alumni/dashboard/page'
import AdminDashboard from '@/app/admin/dashboard/page'
import { supabase } from '@/lib/supabase'

// Mock the DashboardLayout
jest.mock('@/components/layout/DashboardLayout', () => {
  return function MockDashboardLayout({ children }: { children: React.ReactNode }) {
    return <div data-testid="dashboard-layout">{children}</div>
  }
})

describe('Dashboard Pages', () => {
  beforeEach(() => {
    jest.clearAllMocks()
  })

  describe('Student Dashboard', () => {
    it('renders student dashboard correctly', async () => {
      const mockUser = { id: '1' }
      const mockSessions = []
      const mockWebinars = []
      const mockReferrals = []

      ;(supabase.auth.getUser as jest.Mock).mockResolvedValue({
        data: { user: mockUser }
      })

      ;(supabase.from as jest.Mock).mockImplementation((table: string) => {
        if (table === 'mentorship_sessions') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: mockSessions })
          }
        }
        if (table === 'webinar_registrations') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: mockWebinars })
          }
        }
        if (table === 'referrals') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: mockReferrals })
          }
        }
        if (table === 'alumnidetails') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            count: jest.fn().mockResolvedValue({ count: 10 })
          }
        }
        return {
          select: jest.fn().mockReturnThis(),
          eq: jest.fn().mockReturnThis(),
          then: (callback: any) => callback({ data: [] })
        }
      })

      render(<StudentDashboard />)

      await waitFor(() => {
        expect(screen.getByText('Student Dashboard')).toBeInTheDocument()
        expect(screen.getByText('Upcoming Sessions')).toBeInTheDocument()
        expect(screen.getByText('Available Mentors')).toBeInTheDocument()
        expect(screen.getByText('Registered Webinars')).toBeInTheDocument()
        expect(screen.getByText('Pending Referrals')).toBeInTheDocument()
      })
    })

    it('shows quick actions', async () => {
      render(<StudentDashboard />)

      await waitFor(() => {
        expect(screen.getByText('Quick Actions')).toBeInTheDocument()
        expect(screen.getByText('Book Mentorship')).toBeInTheDocument()
        expect(screen.getByText('Join Webinar')).toBeInTheDocument()
        expect(screen.getByText('Request Referral')).toBeInTheDocument()
      })
    })
  })

  describe('Alumni Dashboard', () => {
    it('renders alumni dashboard correctly', async () => {
      const mockUser = { id: '1' }
      const mockSessions = []
      const mockWebinars = []
      const mockTransactions = []

      ;(supabase.auth.getUser as jest.Mock).mockResolvedValue({
        data: { user: mockUser }
      })

      ;(supabase.from as jest.Mock).mockImplementation((table: string) => {
        if (table === 'mentorship_sessions') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: mockSessions })
          }
        }
        if (table === 'webinars') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: mockWebinars })
          }
        }
        if (table === 'transactions') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: mockTransactions })
          }
        }
        return {
          select: jest.fn().mockReturnThis(),
          eq: jest.fn().mockReturnThis(),
          then: (callback: any) => callback({ data: [] })
        }
      })

      render(<AlumniDashboard />)

      await waitFor(() => {
        expect(screen.getByText('Alumni Dashboard')).toBeInTheDocument()
        expect(screen.getByText('Students Mentored')).toBeInTheDocument()
        expect(screen.getByText('Active Sessions')).toBeInTheDocument()
        expect(screen.getByText('Upcoming Webinars')).toBeInTheDocument()
        expect(screen.getByText('Total Earnings')).toBeInTheDocument()
      })
    })
  })

  describe('Admin Dashboard', () => {
    it('renders admin dashboard correctly', async () => {
      ;(supabase.from as jest.Mock).mockImplementation((table: string) => {
        if (table === 'users') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            count: jest.fn().mockResolvedValue({ count: 100 })
          }
        }
        if (table === 'mentorship_sessions') {
          return {
            select: jest.fn().mockReturnThis(),
            count: jest.fn().mockResolvedValue({ count: 50 })
          }
        }
        if (table === 'webinars') {
          return {
            select: jest.fn().mockReturnThis(),
            count: jest.fn().mockResolvedValue({ count: 25 })
          }
        }
        if (table === 'transactions') {
          return {
            select: jest.fn().mockReturnThis(),
            then: (callback: any) => callback({ data: [{ amount: '100' }] })
          }
        }
        if (table === 'alumnidetails') {
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockReturnThis(),
            count: jest.fn().mockResolvedValue({ count: 5 })
          }
        }
        return {
          select: jest.fn().mockReturnThis(),
          count: jest.fn().mockResolvedValue({ count: 0 })
        }
      })

      render(<AdminDashboard />)

      await waitFor(() => {
        expect(screen.getByText('Admin Dashboard')).toBeInTheDocument()
        expect(screen.getByText('Total Users')).toBeInTheDocument()
        expect(screen.getByText('Students')).toBeInTheDocument()
        expect(screen.getByText('Alumni')).toBeInTheDocument()
        expect(screen.getByText('Mentorship Sessions')).toBeInTheDocument()
        expect(screen.getByText('Webinars')).toBeInTheDocument()
        expect(screen.getByText('Total Revenue')).toBeInTheDocument()
        expect(screen.getByText('Pending Verifications')).toBeInTheDocument()
        expect(screen.getByText('Active Users (30d)')).toBeInTheDocument()
      })
    })

    it('shows admin quick actions', async () => {
      render(<AdminDashboard />)

      await waitFor(() => {
        expect(screen.getByText('Admin Actions')).toBeInTheDocument()
        expect(screen.getByText('User Management')).toBeInTheDocument()
        expect(screen.getByText('Verify Alumni')).toBeInTheDocument()
        expect(screen.getByText('View Analytics')).toBeInTheDocument()
      })
    })
  })
})

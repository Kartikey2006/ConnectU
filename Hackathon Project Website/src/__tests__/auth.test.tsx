import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { useAuth } from '@/components/providers/AuthProvider'
import LoginForm from '@/components/auth/LoginForm'
import SignupForm from '@/components/auth/SignupForm'
import { supabase } from '@/lib/supabase'
import toast from 'react-hot-toast'

// Mock the AuthProvider
jest.mock('@/components/providers/AuthProvider')

describe('Authentication', () => {
  const mockUser = {
    id: '1',
    email: 'test@example.com',
    user_metadata: { role: 'student' }
  }

  beforeEach(() => {
    jest.clearAllMocks()
  })

  describe('LoginForm', () => {
    it('renders login form correctly', () => {
      render(<LoginForm />)
      
      expect(screen.getByText('Sign in to ConnectU')).toBeInTheDocument()
      expect(screen.getByPlaceholderText('Email address')).toBeInTheDocument()
      expect(screen.getByPlaceholderText('Password')).toBeInTheDocument()
      expect(screen.getByRole('button', { name: 'Sign in' })).toBeInTheDocument()
    })

    it('handles form submission', async () => {
      const mockSignIn = jest.fn().mockResolvedValue({
        data: { user: mockUser },
        error: null
      })
      
      ;(supabase.auth.signInWithPassword as jest.Mock).mockImplementation(mockSignIn)

      render(<LoginForm />)
      
      fireEvent.change(screen.getByPlaceholderText('Email address'), {
        target: { value: 'test@example.com' }
      })
      fireEvent.change(screen.getByPlaceholderText('Password'), {
        target: { value: 'password123' }
      })
      fireEvent.click(screen.getByRole('button', { name: 'Sign in' }))

      await waitFor(() => {
        expect(mockSignIn).toHaveBeenCalledWith({
          email: 'test@example.com',
          password: 'password123'
        })
      })
    })

    it('shows error message on login failure', async () => {
      const mockSignIn = jest.fn().mockResolvedValue({
        data: { user: null },
        error: { message: 'Invalid credentials' }
      })
      
      ;(supabase.auth.signInWithPassword as jest.Mock).mockImplementation(mockSignIn)

      render(<LoginForm />)
      
      fireEvent.change(screen.getByPlaceholderText('Email address'), {
        target: { value: 'test@example.com' }
      })
      fireEvent.change(screen.getByPlaceholderText('Password'), {
        target: { value: 'wrongpassword' }
      })
      fireEvent.click(screen.getByRole('button', { name: 'Sign in' }))

      await waitFor(() => {
        expect(toast.error).toHaveBeenCalledWith('Invalid credentials')
      })
    })
  })

  describe('SignupForm', () => {
    it('renders signup form correctly', () => {
      render(<SignupForm />)
      
      expect(screen.getByText('Join ConnectU')).toBeInTheDocument()
      expect(screen.getByPlaceholderText('Your full name')).toBeInTheDocument()
      expect(screen.getByPlaceholderText('your.email@example.com')).toBeInTheDocument()
      expect(screen.getByDisplayValue('student')).toBeInTheDocument()
      expect(screen.getByRole('button', { name: 'Create Account' })).toBeInTheDocument()
    })

    it('validates password confirmation', async () => {
      render(<SignupForm />)
      
      fireEvent.change(screen.getByPlaceholderText('Create a strong password'), {
        target: { value: 'password123' }
      })
      fireEvent.change(screen.getByPlaceholderText('Confirm your password'), {
        target: { value: 'differentpassword' }
      })
      fireEvent.click(screen.getByRole('button', { name: 'Create Account' }))

      await waitFor(() => {
        expect(toast.error).toHaveBeenCalledWith('Passwords do not match')
      })
    })

    it('handles successful signup', async () => {
      const mockSignUp = jest.fn().mockResolvedValue({
        data: { user: mockUser },
        error: null
      })
      const mockInsert = jest.fn().mockResolvedValue({
        data: {},
        error: null
      })
      
      ;(supabase.auth.signUp as jest.Mock).mockImplementation(mockSignUp)
      ;(supabase.from as jest.Mock).mockReturnValue({
        insert: jest.fn().mockReturnValue({
          then: (callback: any) => callback({ data: {}, error: null })
        })
      })

      render(<SignupForm />)
      
      fireEvent.change(screen.getByPlaceholderText('Your full name'), {
        target: { value: 'John Doe' }
      })
      fireEvent.change(screen.getByPlaceholderText('your.email@example.com'), {
        target: { value: 'john@example.com' }
      })
      fireEvent.change(screen.getByPlaceholderText('Create a strong password'), {
        target: { value: 'password123' }
      })
      fireEvent.change(screen.getByPlaceholderText('Confirm your password'), {
        target: { value: 'password123' }
      })
      fireEvent.click(screen.getByRole('button', { name: 'Create Account' }))

      await waitFor(() => {
        expect(mockSignUp).toHaveBeenCalledWith({
          email: 'john@example.com',
          password: 'password123',
          options: {
            data: {
              name: 'John Doe',
              role: 'student'
            }
          }
        })
      })
    })
  })

  describe('AuthProvider', () => {
    it('provides auth context', () => {
      const mockAuthContext = {
        user: mockUser,
        loading: false,
        signOut: jest.fn()
      }

      ;(useAuth as jest.Mock).mockReturnValue(mockAuthContext)

      const TestComponent = () => {
        const { user, loading } = useAuth()
        return (
          <div>
            {loading ? 'Loading...' : `Welcome ${user?.email}`}
          </div>
        )
      }

      render(<TestComponent />)
      expect(screen.getByText('Welcome test@example.com')).toBeInTheDocument()
    })
  })
})

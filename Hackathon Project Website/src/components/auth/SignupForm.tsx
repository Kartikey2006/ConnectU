'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { userManagement } from '@/lib/userManagement'
import { getDashboardRoute } from '@/lib/navigation'
import { Button } from '@/components/ui/Button'
import { Card, CardContent } from '@/components/ui/Card'
import toast from 'react-hot-toast'
import { Mail, Lock, User, Eye, EyeOff, ArrowRight } from 'lucide-react'

export default function SignupForm() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
    role: 'student' as 'student' | 'alumni',
  })
  const [loading, setLoading] = useState(false)
  const [errors, setErrors] = useState<{[key: string]: string}>({})
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const router = useRouter()

  const validateForm = () => {
    const newErrors: {[key: string]: string} = {}

    if (!formData.name.trim()) {
      newErrors.name = 'Please enter your full name'
    }

    if (!formData.email.trim()) {
      newErrors.email = 'Please enter your email address'
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = 'Please enter a valid email address'
    }

    if (!formData.password) {
      newErrors.password = 'Please enter a password'
    } else if (formData.password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters long'
    }

    if (!formData.confirmPassword) {
      newErrors.confirmPassword = 'Please confirm your password'
    } else if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setErrors({})

    // Validate form
    if (!validateForm()) {
      setLoading(false)
      return
    }

    try {
      // Sign up with Supabase Auth
      const { data, error } = await supabase.auth.signUp({
        email: formData.email,
        password: formData.password,
        options: {
          data: {
            name: formData.name.trim(),
            role: formData.role,
          }
        }
      })

      if (error) {
        toast.error(error.message)
        return
      }

      if (data.user) {
        console.log('Signup successful for user:', data.user.email)
        console.log('Creating profile for role:', formData.role)
        
        // Set the role in localStorage immediately for next steps
        localStorage.setItem('userRole', formData.role)
        
        // Create user profile with retry mechanism
        let success = false;
        let attempts = 0;
        const maxAttempts = 3;
        
        while (attempts < maxAttempts && !success) {
          try {
            console.log(`Attempting profile creation, attempt ${attempts + 1}/${maxAttempts}`);
            success = await userManagement.createUserProfile(data.user, formData.role);
            if (success) {
              console.log('Profile created successfully on attempt:', attempts + 1);
              break;
            } else {
              console.log(`Profile creation failed on attempt ${attempts + 1}, retrying...`);
              // Wait before retry
              await new Promise(resolve => setTimeout(resolve, 500));
            }
          } catch (profileError) {
            console.error(`Profile creation attempt ${attempts + 1} failed:`, profileError);
            await new Promise(resolve => setTimeout(resolve, 500));
          }
          attempts++;
        }
        
        // After signup, attempt auto-login to get authenticated session
        try {
          console.log('Attempting auto-login after signup...');
          const { data: loginData, error: loginError } = await supabase.auth.signInWithPassword({
            email: formData.email,
            password: formData.password
          });
          
          if (!loginError && loginData.user) {
            console.log('Auto-login successful, user is now authenticated:', loginData.user.email);
            
            // Ensure profile was created
            if (!success) {
              // Try one more time to create profile since user is now authenticated
              const finalSuccess = await userManagement.createUserProfile(data.user, formData.role);
              console.log('Final profile creation attempt:', finalSuccess);
            }
            
            // Force set the role in localStorage again (in case AuthProvider reset it)
            localStorage.setItem('userRole', formData.role)
            console.log('Set localStorage role to:', formData.role)
            
            // User is now signed in, redirect to dashboard
            const redirectUrl = getDashboardRoute(formData.role)
            console.log(`Redirecting to ${redirectUrl} for role: ${formData.role}`)
            toast.success('Welcome! Account created successfully. Redirecting to dashboard...')
            
            // Double-check the route before redirecting
            console.log('Dashboard route check:', formData.role, 'maps to', redirectUrl)
            
            // Give a moment for the login state to propagate
            setTimeout(() => {
              window.location.replace(redirectUrl)
            }, 500)
          } else {
            console.log('Auto-login failed, error:', loginError);
            // Check if user needs email verification
            if (loginError?.message?.includes('email') || loginError?.message?.includes('verify')) {
              toast.success('Account created! Please check your email to verify and sign in.')
            } else {
              toast.success('Account created successfully! Please sign in to continue.')
            }
            setTimeout(() => {
              router.push('/auth/login')
            }, 1500)
          }
        } catch (autoLoginError) {
          console.error('Auto-login error:', autoLoginError)
          toast.success('Account created! Please sign in to continue.')
          setTimeout(() => {
            router.push('/auth/login')
          }, 1500)
        }
      } else {
        // No user returned - might need email verification
        toast.success('Please check your email to verify your account, then sign in.')
        setTimeout(() => {
          router.push('/auth/login')
        }, 2000)
      }
    } catch (error) {
      console.error('Signup error:', error)
      toast.error('An unexpected error occurred. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex">
      {/* Left side - Image */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-green-600 to-blue-700 relative">
        <div 
          className="absolute inset-0 bg-cover bg-center bg-no-repeat opacity-20"
          style={{ backgroundImage: 'url(https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&w=2071&q=80)' }}
        />
        <div className="relative z-10 flex flex-col justify-center px-12 text-white">
          <h1 className="text-4xl font-bold mb-6">
            Join the ConnectU Community
          </h1>
          <p className="text-xl text-green-100 mb-8">
            Connect with successful alumni, get mentorship, and accelerate your career growth.
          </p>
          <div className="space-y-4">
            <div className="flex items-center">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center mr-3">
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <span>Free to join and start connecting</span>
            </div>
            <div className="flex items-center">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center mr-3">
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <span>Access to industry experts</span>
            </div>
            <div className="flex items-center">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center mr-3">
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <span>Exclusive mentorship opportunities</span>
            </div>
          </div>
        </div>
      </div>

      {/* Right side - Signup Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 bg-gray-50">
        <div className="max-w-md w-full">
          <Card className="shadow-2xl border-0">
            <CardContent className="p-8">
              <div className="text-center mb-8">
                <div className="mx-auto h-16 w-16 bg-gradient-to-r from-green-600 to-blue-600 rounded-2xl flex items-center justify-center mb-4">
                  <svg className="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                  </svg>
                </div>
                <h2 className="text-3xl font-bold text-gray-900 mb-2">
                  Join ConnectU
                </h2>
                <p className="text-gray-600">
                  Start your journey with alumni mentorship
                </p>
              </div>

              <form className="space-y-6" onSubmit={handleSignup}>
                <div className="space-y-4">
                  <div>
                    <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                      Full Name
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <User className="h-5 w-5 text-gray-400" />
                      </div>
                      <input
                        id="name"
                        name="name"
                        type="text"
                        required
                        className={`block w-full pl-10 pr-3 py-3 border text-gray-900 ${
                          errors.name ? 'border-red-300 focus:ring-red-500 focus:border-red-500' : 'border-gray-300 focus:ring-blue-500 focus:border-blue-500'
                        } rounded-xl transition-colors duration-200`}
                        placeholder="Enter your full name"
                        value={formData.name}
                        onChange={(e) => {
                          setFormData({ ...formData, name: e.target.value })
                          if (errors.name) {
                            setErrors({ ...errors, name: '' })
                          }
                        }}
                        style={{ color: '#111827' }}
                      />
                    </div>
                    {errors.name && (
                      <p className="mt-2 text-sm text-red-600">{errors.name}</p>
                    )}
                  </div>
                  
                  <div>
                    <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                      Email Address
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <Mail className="h-5 w-5 text-gray-400" />
                      </div>
                      <input
                        id="email"
                        name="email"
                        type="email"
                        required
                        className={`block w-full pl-10 pr-3 py-3 border text-gray-900 ${
                          errors.email ? 'border-red-300 focus:ring-red-500 focus:border-red-500' : 'border-gray-300 focus:ring-blue-500 focus:border-blue-500'
                        } rounded-xl transition-colors duration-200`}
                        placeholder="Enter your email"
                        value={formData.email}
                        onChange={(e) => {
                          setFormData({ ...formData, email: e.target.value })
                          if (errors.email) {
                            setErrors({ ...errors, email: '' })
                          }
                        }}
                        style={{ color: '#111827' }}
                      />
                    </div>
                    {errors.email && (
                      <p className="mt-2 text-sm text-red-600">{errors.email}</p>
                    )}
                  </div>

                  <div>
                    <label htmlFor="role" className="block text-sm font-medium text-gray-700 mb-2">
                      I am a
                    </label>
                    <select
                      id="role"
                      name="role"
                      className="block w-full px-4 py-3 border border-gray-300 bg-white rounded-xl shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 text-gray-900"
                      value={formData.role}
                      onChange={(e) => setFormData({ ...formData, role: e.target.value as 'student' | 'alumni' })}
                    >
                      <option value="student">Student</option>
                      <option value="alumni">Alumni</option>
                    </select>
                  </div>
                  
                  <div>
                    <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-2">
                      Password
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <Lock className="h-5 w-5 text-gray-400" />
                      </div>
                      <input
                        id="password"
                        name="password"
                        type={showPassword ? 'text' : 'password'}
                        required
                        minLength={6}
                        className={`block w-full pl-10 pr-12 py-3 border text-gray-900 ${
                          errors.password ? 'border-red-300 focus:ring-red-500 focus:border-red-500' : 'border-gray-300 focus:ring-blue-500 focus:border-blue-500'
                        } rounded-xl transition-colors duration-200`}
                        placeholder="Create a strong password"
                        value={formData.password}
                        onChange={(e) => {
                          setFormData({ ...formData, password: e.target.value })
                          if (errors.password) {
                            setErrors({ ...errors, password: '' })
                          }
                        }}
                        style={{ color: '#111827' }}
                      />
                      <button
                        type="button"
                        className="absolute inset-y-0 right-0 pr-3 flex items-center"
                        onClick={() => setShowPassword(!showPassword)}
                      >
                        {showPassword ? (
                          <EyeOff className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                        ) : (
                          <Eye className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                        )}
                      </button>
                    </div>
                    {errors.password ? (
                      <p className="mt-2 text-sm text-red-600">{errors.password}</p>
                    ) : (
                      <p className="mt-1 text-xs text-gray-500">Password must be at least 6 characters long</p>
                    )}
                  </div>
                  
                  <div>
                    <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700 mb-2">
                      Confirm Password
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <Lock className="h-5 w-5 text-gray-400" />
                      </div>
                      <input
                        id="confirmPassword"
                        name="confirmPassword"
                        type={showConfirmPassword ? 'text' : 'password'}
                        required
                        className={`block w-full pl-10 pr-12 py-3 border text-gray-900 ${
                          errors.confirmPassword ? 'border-red-300 focus:ring-red-500 focus:border-red-500' : 'border-gray-300 focus:ring-blue-500 focus:border-blue-500'
                        } rounded-xl transition-colors duration-200`}
                        placeholder="Confirm your password"
                        value={formData.confirmPassword}
                        onChange={(e) => {
                          setFormData({ ...formData, confirmPassword: e.target.value })
                          if (errors.confirmPassword) {
                            setErrors({ ...errors, confirmPassword: '' })
                          }
                        }}
                        style={{ color: '#111827' }}
                      />
                      <button
                        type="button"
                        className="absolute inset-y-0 right-0 pr-3 flex items-center"
                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      >
                        {showConfirmPassword ? (
                          <EyeOff className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                        ) : (
                          <Eye className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                        )}
                      </button>
                    </div>
                    {errors.confirmPassword && (
                      <p className="mt-2 text-sm text-red-600">{errors.confirmPassword}</p>
                    )}
                  </div>
                </div>

                <Button
                  type="submit"
                  loading={loading}
                  size="lg"
                  className="w-full"
                >
                  {loading ? 'Creating Account...' : 'Create Account'}
                  <ArrowRight className="w-4 h-4 ml-2" />
                </Button>
              </form>

              <div className="mt-6 text-center">
                <p className="text-sm text-gray-600">
                  Already have an account?{' '}
                  <Link 
                    href="/auth/login" 
                    className="font-medium text-blue-600 hover:text-blue-500 transition-colors"
                  >
                    Sign in here
                  </Link>
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
'use client'

import { useEffect } from 'react'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error('Error:', error)
  }, [error])

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="text-center max-w-md mx-auto px-6">
        <div className="mb-8">
          <div className="w-20 h-20 mx-auto mb-6 bg-gradient-to-r from-red-500 to-red-600 rounded-2xl flex items-center justify-center shadow-lg">
            <svg className="h-10 w-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.732-.833-2.5 0L4.268 18.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Oops! Something went wrong</h1>
          <p className="text-gray-600 mb-6">We encountered an unexpected error</p>
        </div>
        
        <div className="bg-white rounded-xl shadow-lg p-6 mb-6">
          <p className="text-gray-600 font-medium mb-4">Error Details</p>
          <p className="text-sm text-gray-500 mb-4 p-3 bg-gray-50 rounded border">
            {error?.message || 'An unknown error occurred'}
          </p>
          <div className="space-y-3">
            <button 
              onClick={reset}
              className="block w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 transition-colors"
            >
              Try Again
            </button>
            <a href="/landing" className="block w-full border border-blue-600 text-blue-600 py-3 px-4 rounded-lg hover:bg-blue-50 transition-colors">
              Go to Landing Page
            </a>
            <a href="/" className="block w-full border border-gray-300 text-gray-600 py-3 px-4 rounded-lg hover:bg-gray-50 transition-colors">
              Go Home
            </a>
          </div>
        </div>
        
        <div className="text-center">
          <p className="text-sm text-gray-500">
            Need help? 
            <a href="/landing" className="text-blue-600 hover:text-blue-800 font-medium ml-1">
              Contact Support
            </a>
          </p>
        </div>
      </div>
    </div>
  )
}

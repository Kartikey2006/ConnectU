'use client'

import { useAuth } from '@/components/providers/AuthProvider'
import { useRouter, usePathname } from 'next/navigation'
import { LogOut } from 'lucide-react'
import { getNavigationForRole } from '@/lib/navigation'
import { useMemo } from 'react'

export default function Sidebar() {
  const { user, userRole } = useAuth()
  const router = useRouter()
  const pathname = usePathname()
  
  // Stable role detection with memoization
  const currentRole = useMemo(() => {
    return userRole || 'student'
  }, [userRole])
  
  // Memoize navigation to prevent re-renders
  const navigation = useMemo(() => {
    return getNavigationForRole(currentRole)
  }, [currentRole])

  return (
    <div className="hidden md:flex md:w-64 md:flex-col">
      <div className="flex flex-col flex-grow pt-5 bg-white overflow-y-auto border-r border-gray-200">
        <div className="flex flex-col flex-grow">
          <nav className="flex-1 px-2 pb-4 space-y-1">
            {navigation.map((item) => {
              const isActive = pathname === item.href || pathname.startsWith(item.href + '/')
              return (
                <button
                  key={item.name}
                  onClick={() => router.push(item.href)}
                  title={item.description}
                  className={`${
                    isActive
                      ? 'bg-primary-100 text-primary-900'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                  } group flex items-center px-2 py-2 text-sm font-medium rounded-md w-full text-left`}
                >
                  <item.icon
                    className={`${
                      isActive ? 'text-primary-500' : 'text-gray-400 group-hover:text-gray-500'
                    } mr-3 flex-shrink-0 h-5 w-5`}
                  />
                  <span className="flex-1">{item.name}</span>
                  {item.badge && (
                    <span className="ml-auto bg-red-100 text-red-600 text-xs px-2 py-1 rounded-full">
                      {item.badge}
                    </span>
                  )}
                </button>
              )
            })}
          </nav>
        </div>
      </div>
    </div>
  )
}

import { 
  LayoutDashboard, 
  Users, 
  MessageSquare, 
  BookOpen, 
  User, 
  Bell, 
  Settings,
  Shield,
  BarChart3,
  UserCheck,
  Calendar,
  DollarSign,
  TrendingUp,
  FileText,
  Globe,
  Briefcase,
  FileText as Document,
  Heart,
  UserPlus,
  GraduationCap,
  Building2
} from 'lucide-react'

export interface NavigationItem {
  name: string
  href: string
  icon: any
  description: string
  roles: string[]
  badge?: string
  children?: NavigationItem[]
}

// Student-specific navigation
export const studentNavigation: NavigationItem[] = [
  {
    name: 'Dashboard',
    href: '/student/dashboard',
    icon: LayoutDashboard,
    description: 'Overview of your activities and progress',
    roles: ['student']
  },
  {
    name: 'Find Alumni',
    href: '/alumni',
    icon: UserPlus,
    description: 'Connect with alumni mentors',
    roles: ['student']
  },
  {
    name: 'Mentorship',
    href: '/mentorship',
    icon: Users,
    description: 'Find and connect with mentors',
    roles: ['student']
  },
  {
    name: 'Events',
    href: '/events',
    icon: Calendar,
    description: 'View upcoming events',
    roles: ['student']
  },
  {
    name: 'Webinars',
    href: '/webinars',
    icon: BookOpen,
    description: 'Attend educational webinars',
    roles: ['student']
  },
  {
    name: 'Forums',
    href: '/forums',
    icon: MessageSquare,
    description: 'Community discussion forums',
    roles: ['student']
  },
  {
    name: 'Job Opportunities',
    href: '/jobs',
    icon: Briefcase,
    description: 'Browse job opportunities',
    roles: ['student']
  },
  {
    name: 'Resume & Documents',
    href: '/documents',
    icon: Document,
    description: 'Manage your resume and documents',
    roles: ['student']
  },
  {
    name: 'Upcoming Events',
    href: '/upcoming-events',
    icon: Calendar,
    description: 'View all upcoming events',
    roles: ['student']
  },
  {
    name: 'Profile',
    href: '/profile',
    icon: User,
    description: 'Manage your profile and preferences',
    roles: ['student']
  },
  {
    name: 'Notifications',
    href: '/notifications',
    icon: Bell,
    description: 'View your notifications',
    roles: ['student']
  }
]

// Alumni-specific navigation
export const alumniNavigation: NavigationItem[] = [
  {
    name: 'Dashboard',
    href: '/alumni/dashboard',
    icon: LayoutDashboard,
    description: 'Overview of your mentorship activities',
    roles: ['alumni']
  },
  {
    name: 'Mentorship',
    href: '/alumni/mentorship-sessions',
    icon: Users,
    description: 'Manage mentorship sessions',
    roles: ['alumni']
  },
  {
    name: 'Students',
    href: '/alumni/students',
    icon: UserPlus,
    description: 'View and connect with students',
    roles: ['alumni']
  },
  {
    name: 'Referral Help',
    href: '/alumni/referral-requests',
    icon: Briefcase,
    description: 'Provide job referrals to students',
    roles: ['alumni']
  },
  {
    name: 'Webinars',
    href: '/alumni/webinars',
    icon: BookOpen,
    description: 'Create and host webinars',
    roles: ['alumni']
  },
  {
    name: 'Forums',
    href: '/forums',
    icon: MessageSquare,
    description: 'Community discussion forums',
    roles: ['alumni']
  },
  {
    name: 'Earnings',
    href: '/alumni/earnings',
    icon: DollarSign,
    description: 'View your earnings and payments',
    roles: ['alumni']
  },
  {
    name: 'Events',
    href: '/events',
    icon: Calendar,
    description: 'View and attend events',
    roles: ['alumni']
  },
  {
    name: 'Documents',
    href: '/alumni/documents',
    icon: Document,
    description: 'Manage documents and certificates',
    roles: ['alumni']
  },
  {
    name: 'Profile',
    href: '/profile',
    icon: User,
    description: 'Manage your profile and preferences',
    roles: ['alumni']
  },
  {
    name: 'Notifications',
    href: '/notifications',
    icon: Bell,
    description: 'View your notifications',
    roles: ['alumni']
  }
]

// Admin-specific navigation
export const adminNavigation: NavigationItem[] = [
  {
    name: 'Dashboard',
    href: '/admin/dashboard',
    icon: LayoutDashboard,
    description: 'Platform overview and management tools',
    roles: ['admin']
  },
  {
    name: 'User Management',
    href: '/admin/users',
    icon: Users,
    description: 'Manage user accounts and roles',
    roles: ['admin'],
    badge: '8 pending'
  },
  {
    name: 'Mentorship Sessions',
    href: '/admin/sessions',
    icon: MessageSquare,
    description: 'Monitor all mentorship sessions',
    roles: ['admin']
  },
  {
    name: 'Webinars',
    href: '/admin/webinars',
    icon: BookOpen,
    description: 'Manage webinars and events',
    roles: ['admin']
  },
  {
    name: 'Analytics',
    href: '/admin/analytics',
    icon: BarChart3,
    description: 'Platform performance metrics',
    roles: ['admin']
  },
  {
    name: 'Verifications',
    href: '/admin/verifications',
    icon: UserCheck,
    description: 'Approve alumni verifications',
    roles: ['admin'],
    badge: '3 pending'
  },
  {
    name: 'Settings',
    href: '/admin/settings',
    icon: Settings,
    description: 'Configure platform settings',
    roles: ['admin']
  },
  {
    name: 'Security',
    href: '/admin/security',
    icon: Shield,
    description: 'Security and access controls',
    roles: ['admin']
  }
]

// Get navigation based on user role
export function getNavigationForRole(role: string): NavigationItem[] {
  switch (role) {
    case 'student':
      return studentNavigation
    case 'alumni':
      return alumniNavigation
    case 'admin':
      return adminNavigation
    default:
      return []
  }
}

// Check if user has access to a specific route
export function hasAccessToRoute(userRole: string, route: string): boolean {
  const navigation = getNavigationForRole(userRole)
  return navigation.some(item => 
    item.href === route || 
    (item.children && item.children.some(child => child.href === route))
  )
}

// Get dashboard route for role
export function getDashboardRoute(role: string): string {
  switch (role) {
    case 'student':
      return '/student/dashboard'
    case 'alumni':
      return '/alumni/dashboard'
    case 'admin':
      return '/admin/dashboard'
    default:
      return '/auth/login'
  }
}

// Role-based feature flags
export const roleFeatures = {
  student: {
    canCreateWebinars: false,
    canManageUsers: false,
    canViewAnalytics: false,
    canApproveVerifications: false,
    canCreateMentorship: false,
    canRequestReferrals: true,
    canJoinWebinars: true,
    canViewAlumni: true,
    canEditProfile: true
  },
  alumni: {
    canCreateWebinars: true,
    canManageUsers: false,
    canViewAnalytics: false,
    canApproveVerifications: false,
    canCreateMentorship: true,
    canRequestReferrals: false,
    canJoinWebinars: true,
    canViewAlumni: true,
    canEditProfile: true
  },
  admin: {
    canCreateWebinars: true,
    canManageUsers: true,
    canViewAnalytics: true,
    canApproveVerifications: true,
    canCreateMentorship: true,
    canRequestReferrals: false,
    canJoinWebinars: true,
    canViewAlumni: true,
    canEditProfile: true
  }
}

// Check if user can access a specific feature
export function canAccessFeature(userRole: string, feature: keyof typeof roleFeatures.student): boolean {
  return roleFeatures[userRole as keyof typeof roleFeatures]?.[feature] || false
}

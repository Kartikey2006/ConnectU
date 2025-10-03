# Role-Based Dashboard System

## Overview

This document describes the comprehensive role-based system implemented to ensure data consistency and role-based dashboards across both the website and mobile app.

## 🏗️ System Architecture

### 1. Data Synchronization Layer
- **Real-time Updates**: All changes sync instantly between app and website
- **Single Source of Truth**: Supabase database as central data store
- **Event-Driven Updates**: Real-time subscriptions for immediate UI updates

### 2. Role Management System
- **Three User Roles**: Student, Alumni, Admin
- **Role Hierarchy**: Admin > Alumni > Student
- **Dynamic Role Changes**: Roles can be updated and sync across platforms

### 3. Dashboard Separation
- **Student Dashboard**: Mentorship requests, webinars, referrals, profile
- **Alumni Dashboard**: Mentorship management, webinar creation, earnings
- **Admin Dashboard**: User management, analytics, verifications, settings

## 📁 File Structure

```
src/
├── lib/
│   ├── userManagement.ts      # Centralized user management
│   ├── navigation.ts          # Role-based navigation system
│   └── supabase.ts           # Database connection
├── components/
│   ├── layout/
│   │   ├── AdminLayout.tsx   # Admin-specific layout
│   │   ├── DashboardLayout.tsx # Student/Alumni layout
│   │   └── Sidebar.tsx       # Role-based navigation
│   └── providers/
│       └── AuthProvider.tsx  # Authentication with role sync
├── hooks/
│   └── useRealtimeData.ts    # Real-time data synchronization
├── middleware.ts             # Route protection
└── app/
    ├── admin/               # Admin-only pages
    ├── student/             # Student-specific pages
    ├── alumni/              # Alumni-specific pages
    └── test-roles/          # Validation testing
```

## 🔐 Role-Based Access Control

### Student Role
**Access:**
- ✅ View mentorship sessions
- ✅ Request referrals
- ✅ Join webinars
- ✅ Browse alumni directory
- ✅ Edit own profile

**Restrictions:**
- ❌ Cannot create webinars
- ❌ Cannot manage users
- ❌ Cannot view analytics
- ❌ Cannot approve verifications

### Alumni Role
**Access:**
- ✅ Create and manage webinars
- ✅ Manage mentorship sessions
- ✅ View earnings
- ✅ Manage referral requests
- ✅ Edit own profile

**Restrictions:**
- ❌ Cannot manage users
- ❌ Cannot view platform analytics
- ❌ Cannot approve verifications

### Admin Role
**Access:**
- ✅ Full platform access
- ✅ User management
- ✅ Analytics dashboard
- ✅ Verification approval
- ✅ System settings
- ✅ All student and alumni features

## 🚀 Real-Time Synchronization

### Data Sync Features
1. **User Profile Updates**: Changes sync instantly across platforms
2. **Role Changes**: Immediate dashboard updates when role changes
3. **Session Management**: Real-time mentorship session updates
4. **Webinar Management**: Live webinar status updates
5. **Referral System**: Instant referral status changes

### Implementation
```typescript
// Subscribe to role changes
const roleChangeSubscription = userManagement.subscribeToRoleChanges((event) => {
  if (user?.id === event.user_id) {
    setUserRole(event.new_role)
    refreshUserProfile()
  }
})

// Real-time data hook
const { data, loading, error } = useRealtimeData('users')
```

## 🧭 Navigation System

### Role-Based Menu Generation
```typescript
// Get navigation based on user role
const navigation = getNavigationForRole(userRole)

// Check route access
const hasAccess = hasAccessToRoute(userRole, '/admin/dashboard')

// Feature access validation
const canCreate = canAccessFeature(userRole, 'canCreateWebinars')
```

### Navigation Items by Role

**Student Navigation:**
- Dashboard
- Find Mentors
- Webinars
- Referrals
- Alumni Network
- Profile
- Notifications

**Alumni Navigation:**
- Dashboard
- Mentorship
- Webinars
- Referrals
- Earnings
- Students
- Profile
- Notifications

**Admin Navigation:**
- Dashboard
- User Management
- Mentorship Sessions
- Webinars
- Analytics
- Verifications
- Settings
- Security

## 🔒 Route Protection

### Middleware Implementation
- **Automatic Redirects**: Users redirected to appropriate dashboard
- **Role Validation**: Database role check on each request
- **Session Management**: Secure token validation
- **Access Control**: Route-level permission checking

### Protected Routes
```typescript
const roleRoutes = {
  student: ['/student', '/mentorship', '/webinars', '/referrals', '/alumni', '/profile'],
  alumni: ['/alumni', '/mentorship', '/webinars', '/referrals', '/profile'],
  admin: ['/admin', '/mentorship', '/webinars', '/referrals', '/alumni', '/profile', '/analytics']
}
```

## 🧪 Testing & Validation

### Test Coverage
1. **Role-Based Navigation**: Verify correct menu items display
2. **Route Access**: Confirm proper access restrictions
3. **Feature Permissions**: Test feature-level access control
4. **Data Synchronization**: Validate real-time updates
5. **Database Connectivity**: Ensure Supabase connection
6. **Role Changes**: Test dynamic role updates

### Test Page
Access `/test-roles` to run comprehensive validation tests.

## 📊 Database Schema

### Users Table
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  role VARCHAR CHECK (role IN ('student', 'alumni', 'admin')),
  supabase_auth_id VARCHAR,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Role Change Log
```sql
CREATE TABLE role_change_log (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR NOT NULL,
  old_role VARCHAR,
  new_role VARCHAR NOT NULL,
  changed_at TIMESTAMP DEFAULT NOW()
);
```

## 🔄 Cross-Platform Sync

### Website Features
- Real-time role updates
- Instant navigation changes
- Live data synchronization
- Role-based UI rendering

### Mobile App Integration
- Same Supabase database
- Identical role system
- Shared authentication
- Synchronized user profiles

## 🚨 Security Considerations

### Data Protection
- Role-based access control
- Secure token validation
- Database-level permissions
- Audit logging for role changes

### Validation
- Input sanitization
- Role hierarchy enforcement
- Session timeout handling
- Cross-platform consistency

## 📈 Performance Optimizations

### Fast Loading
- Mock data for immediate display
- Background data fetching
- Optimized database queries
- Cached navigation items

### Real-Time Efficiency
- Selective subscriptions
- Efficient event handling
- Minimal re-renders
- Smart data updates

## 🎯 Usage Examples

### Check User Access
```typescript
const { userRole } = useAuth()
const canManageUsers = canAccessFeature(userRole, 'canManageUsers')
```

### Navigate Based on Role
```typescript
const dashboardRoute = getDashboardRoute(userRole)
router.push(dashboardRoute)
```

### Subscribe to Updates
```typescript
const { data: users } = useUsers()
const { profile } = useUserProfile(user.email)
```

## ✅ Validation Checklist

- [ ] Role-based navigation displays correctly
- [ ] Route access is properly restricted
- [ ] Feature permissions work as expected
- [ ] User profile data is synchronized
- [ ] Database connectivity is stable
- [ ] Real-time updates function properly
- [ ] Cross-platform consistency maintained
- [ ] Security measures are in place
- [ ] Performance is optimized
- [ ] Testing coverage is comprehensive

## 🔧 Maintenance

### Regular Tasks
1. Monitor role change logs
2. Validate cross-platform sync
3. Update navigation items as needed
4. Review and update permissions
5. Test real-time functionality

### Troubleshooting
- Check Supabase connection
- Verify user authentication
- Validate role assignments
- Review middleware logs
- Test navigation updates

This system ensures complete data consistency and role-based access control across both the website and mobile app, providing a seamless user experience regardless of platform.

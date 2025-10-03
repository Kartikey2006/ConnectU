# 🔐 Admin Access Guide

## Overview
This guide explains how to access and use the admin dashboard in the ConnectU Alumni Platform.

## Admin Dashboard Features

### 📊 Overview Tab
- **Dashboard Statistics**: View total users, active sessions, new posts, and reports
- **Recent Activity**: Monitor recent platform activity
- **Quick Actions**: Access common admin tasks

### 👥 Users Tab
- **User Management**: View, edit, and manage all platform users
- **Role Management**: Change user roles (student, alumni, admin)
- **User Suspension**: Suspend or unsuspend user accounts
- **Search & Filter**: Find users by name, email, or role

### 📝 Content Tab
- **Content Management**: Manage forum posts, events, webinars, and job postings
- **Content Moderation**: Review and approve/reject reported content
- **Bulk Actions**: Perform bulk operations on content

### 📈 Analytics Tab
- **User Growth**: Track user registration trends
- **Engagement Metrics**: Monitor user activity and engagement
- **Content Performance**: Analyze content metrics
- **System Health**: Monitor platform performance

### ⚙️ Settings Tab
- **General Settings**: Configure basic system settings
- **Email Configuration**: Setup email notifications
- **Security Settings**: Manage security policies
- **Backup & Restore**: Manage data backups
- **System Maintenance**: Schedule maintenance tasks
- **API Configuration**: Manage API settings

## Admin Permissions

### User Management
- ✅ View all users
- ✅ Edit user profiles
- ✅ Change user roles
- ✅ Suspend/unsuspend users
- ✅ Delete users
- ✅ View user activity logs

### Content Management
- ✅ View all content
- ✅ Moderate posts and comments
- ✅ Delete inappropriate content
- ✅ Manage events and webinars
- ✅ Manage job postings

### System Administration
- ✅ View system analytics
- ✅ Manage platform settings
- ✅ Create announcements
- ✅ View admin logs
- ✅ Perform system maintenance
- ✅ Manage backups

## Security Features

### Row Level Security (RLS)
- All admin functions are protected by RLS policies
- Only users with 'admin' role can access admin features
- All admin actions are logged for audit purposes

### Admin Action Logging
- Every admin action is automatically logged
- Logs include: action type, description, timestamp, and metadata
- Logs are stored in the `admin_actions` table

### Access Control
- Admin dashboard is only accessible to authenticated admin users
- All admin API endpoints require admin role verification
- Session management with automatic logout

## Getting Started

### 1. Admin Account Setup
1. **Create Admin User**: Use the database script to create an admin user
2. **Verify Role**: Ensure your user has 'admin' role in the database
3. **Login**: Login with your admin credentials

### 2. First Login
1. **Navigate to Admin Dashboard**: You'll be automatically redirected to `/admin-dashboard`
2. **Review Overview**: Check the dashboard overview for system status
3. **Configure Settings**: Set up basic platform settings

### 3. Daily Admin Tasks
1. **Check Reports**: Review any pending content reports
2. **Monitor Activity**: Check recent user activity and system health
3. **Moderate Content**: Review and moderate reported content
4. **User Management**: Handle user-related issues and requests

## Best Practices

### Security
- 🔒 Use strong passwords for admin accounts
- 🔒 Regularly review admin action logs
- 🔒 Limit admin access to trusted personnel only
- 🔒 Use two-factor authentication when available

### Content Moderation
- 📝 Review reported content promptly
- 📝 Provide clear reasons for content decisions
- 📝 Maintain consistency in moderation decisions
- 📝 Document moderation policies

### User Management
- 👥 Be cautious when changing user roles
- 👥 Document reasons for user suspensions
- 👥 Communicate with users about account changes
- 👥 Respect user privacy and data protection

### System Maintenance
- 🔧 Schedule maintenance during low-usage periods
- 🔧 Backup data before major changes
- 🔧 Test changes in a development environment first
- 🔧 Monitor system performance after changes

## Troubleshooting

### Common Issues

#### Cannot Access Admin Dashboard
- **Check Role**: Verify your user has 'admin' role in database
- **Check Authentication**: Ensure you're logged in
- **Check Permissions**: Verify RLS policies are correctly configured

#### Admin Actions Not Working
- **Check Logs**: Review admin action logs for errors
- **Check Database**: Verify database connections and permissions
- **Check RLS**: Ensure Row Level Security policies are active

#### Users Not Appearing
- **Check Filters**: Verify search and filter settings
- **Check Database**: Ensure users table is accessible
- **Check Permissions**: Verify admin has proper database permissions

### Getting Help
- 📧 Contact system administrator for technical issues
- 📚 Check database logs for error details
- 🔍 Review admin action logs for troubleshooting
- 💬 Use the platform's support system for user issues

## API Reference

### Admin Endpoints
- `GET /admin/users` - Get all users
- `PUT /admin/users/{id}/role` - Update user role
- `POST /admin/users/{id}/suspend` - Suspend user
- `GET /admin/content/reports` - Get reported content
- `POST /admin/content/{id}/moderate` - Moderate content
- `GET /admin/analytics/stats` - Get dashboard statistics
- `PUT /admin/settings` - Update platform settings

### Authentication
All admin endpoints require:
- Valid authentication token
- User with 'admin' role
- Proper RLS permissions

## Support

For technical support or questions about admin functionality:
- 📧 Email: admin@connectu.com
- 📱 Platform: Use the support system in the admin dashboard
- 📚 Documentation: Check the platform documentation
- 🔧 Technical Issues: Contact the development team

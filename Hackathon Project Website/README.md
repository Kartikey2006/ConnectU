# ConnectU Alumni Platform - Website

A production-ready Next.js website for the ConnectU Alumni Platform that connects students and alumni for mentorship, referrals, webinars, and career growth.

## 🚀 Features

### Core Functionality
- **Authentication System**: Student, Alumni, and Admin roles with secure login/signup
- **Mentorship Platform**: Book and manage mentorship sessions
- **Webinar Management**: Host and attend educational webinars
- **Referral System**: Connect students with industry professionals
- **Real-time Notifications**: Stay updated with platform activities
- **Profile Management**: Comprehensive user profiles and settings
- **Admin Dashboard**: Complete platform management and analytics

### User Roles
- **Students**: Book mentorship sessions, join webinars, request referrals
- **Alumni**: Host webinars, provide mentorship, verify student skills
- **Admin**: Platform management, user verification, analytics

## 🏗️ Technology Stack

- **Frontend**: Next.js 14 with App Router
- **Styling**: Tailwind CSS
- **Authentication**: Supabase Auth
- **Database**: Supabase (PostgreSQL)
- **State Management**: React Context + Zustand
- **Testing**: Jest + React Testing Library
- **TypeScript**: Full type safety

## 📁 Project Structure

```
src/
├── app/                    # Next.js App Router pages
│   ├── admin/             # Admin-specific pages
│   ├── alumni/            # Alumni-specific pages
│   ├── auth/              # Authentication pages
│   ├── student/           # Student-specific pages
│   ├── mentorship/        # Mentorship features
│   ├── webinars/          # Webinar features
│   ├── referrals/         # Referral features
│   └── profile/           # Profile management
├── components/            # Reusable components
│   ├── auth/             # Authentication components
│   ├── layout/           # Layout components
│   └── providers/        # Context providers
├── lib/                  # Utilities and configurations
└── __tests__/            # Test files
```

## 🛠️ Setup Instructions

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Supabase account

### Installation

1. **Clone and navigate to the project**
   ```bash
   cd "Hackathon Project Website"
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration**
   The `.env.local` file is already configured with the Supabase credentials:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://cudwwhohzfxmflquizhk.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMTU3ODIsImV4cCI6MjA3MTg5MTc4Mn0.dqjSaeIwtVvc3-D8Aa9_w5PTK47SbI-M-aXlxu3H_Yw
   ```

4. **Run the development server**
   ```bash
   npm run dev
   ```

5. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## 🗄️ Database Schema

The website connects to the same Supabase database as the Flutter app with the following key tables:

- `users` - User accounts and roles
- `studentdetails` - Student-specific information
- `alumnidetails` - Alumni-specific information
- `mentorship_sessions` - Mentorship bookings
- `webinars` - Webinar information
- `referrals` - Referral requests
- `notifications` - User notifications
- `transactions` - Payment tracking

## 🔐 Authentication Flow

1. **Sign Up**: Users can register as students or alumni
2. **Email Verification**: Supabase handles email verification
3. **Role-based Access**: Different dashboards based on user role
4. **Session Management**: Persistent authentication with automatic redirects

## 📱 User Flows

### Student Flow
1. Sign up → Email verification → Student Dashboard
2. Browse alumni directory → Book mentorship sessions
3. Register for webinars → Request job referrals
4. Manage profile and track progress

### Alumni Flow
1. Sign up → Profile completion → Alumni Dashboard
2. Create webinars → Accept mentorship requests
3. Review referral requests → Manage earnings
4. Verify profile with admin approval

### Admin Flow
1. Access admin dashboard → User management
2. Verify alumni profiles → Platform analytics
3. Monitor sessions and webinars → Manage system

## 🧪 Testing

### Run Tests
```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

### Test Coverage
- Authentication flows (login, signup, logout)
- Dashboard functionality
- User role management
- Database operations
- Component rendering

## 🚀 Deployment

### Build for Production
```bash
npm run build
npm start
```

### Environment Variables for Production
Ensure these are set in your production environment:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### Deployment Platforms
- **Vercel** (Recommended for Next.js)
- **Netlify**
- **AWS Amplify**
- **DigitalOcean App Platform**

## 🔧 Configuration

### Supabase Setup
The website is pre-configured to work with the existing Supabase project:
- Database: `cudwwhohzfxmflquizhk.supabase.co`
- Authentication: Email/password with role-based access
- Real-time subscriptions for notifications

### Customization
- **Theme**: Modify `tailwind.config.js` for colors and styling
- **Features**: Enable/disable features in component files
- **Database**: Extend types in `src/lib/supabase.ts`

## 📊 Features in Detail

### Authentication System
- Secure email/password authentication via Supabase
- Role-based access control (Student, Alumni, Admin)
- Session persistence and automatic redirects
- Profile completion flows

### Mentorship Platform
- Browse available alumni mentors
- Book mentorship sessions with scheduling
- Session management and status tracking
- Payment integration (ready for implementation)

### Webinar Management
- Create and host webinars (Alumni)
- Register and attend webinars (Students)
- Webinar scheduling and management
- Content sharing capabilities

### Referral System
- Request job referrals from alumni
- Alumni can accept/reject referral requests
- Status tracking and communication
- Integration with external job platforms

### Admin Dashboard
- User management and role assignment
- Alumni verification system
- Platform analytics and metrics
- System-wide notifications

## 🔒 Security Features

- **Supabase RLS**: Row-level security for data access
- **JWT Tokens**: Secure authentication tokens
- **Role-based Access**: Different permissions per user type
- **Input Validation**: Form validation and sanitization
- **CSRF Protection**: Built-in Next.js security features

## 📈 Performance Optimization

- **Next.js App Router**: Latest routing with performance benefits
- **Image Optimization**: Automatic image optimization
- **Code Splitting**: Automatic code splitting per route
- **Caching**: Built-in caching strategies
- **Bundle Analysis**: Optimized bundle sizes

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Check the documentation
- Review the test files for usage examples
- Contact the development team

## 🔮 Future Enhancements

- **Real-time Chat**: Direct messaging between users
- **Video Integration**: Built-in video calls for mentorship
- **Mobile App**: React Native version
- **AI Matching**: Smart mentor-student matching
- **Advanced Analytics**: Detailed platform insights
- **Payment Integration**: Stripe/PayPal integration
- **Email Notifications**: Automated email campaigns

---

**ConnectU Alumni Platform Website** - Building bridges between students and alumni for a brighter future! 🎓✨

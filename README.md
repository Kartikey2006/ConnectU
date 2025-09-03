# ConnectU Alumni Platform

A comprehensive Flutter application that connects students and alumni for mentorship, referrals, webinars, and career growth.

## 🚀 Features

### Core Functionality
- **Authentication System**: Student, Alumni, and Admin roles with secure login/signup
- **Mentorship Platform**: Book and manage mentorship sessions
- **Webinar Management**: Host and attend educational webinars
- **Referral System**: Connect students with industry professionals
- **Real-time Chat**: Direct messaging between users
- **Profile Management**: Comprehensive user profiles and settings
- **Notification System**: Real-time updates and alerts

### User Roles
- **Students**: Book mentorship sessions, join webinars, request referrals
- **Alumni**: Host webinars, provide mentorship, verify student skills
- **Admin**: Platform management, user verification, analytics

### Revenue Model
- Referral fees
- Webinar fees
- Mentorship fees
- Platform charges

## 🏗️ Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── models/             # Domain models
│   ├── routing/            # Navigation
│   └── theme/              # UI theming
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── dashboard/         # User dashboards
│   ├── mentorship/        # Mentorship system
│   ├── webinars/          # Webinar management
│   ├── referrals/         # Referral system
│   ├── chat/              # Messaging
│   ├── profile/           # User profiles
│   └── notifications/     # Notifications
└── main.dart              # App entry point
```

### Technology Stack
- **Frontend**: Flutter 3.0+
- **State Management**: Flutter Bloc
- **Backend**: Supabase (PostgreSQL)
- **Navigation**: Go Router
- **UI Components**: Material Design 3
- **Local Storage**: Hive
- **HTTP Client**: Dio

## 📱 Screenshots

The application includes the following key screens:
- Onboarding & Authentication
- Student/Alumni/Admin Dashboards
- Mentorship Booking
- Webinar Management
- Referral System
- Chat Interface
- Profile Management
- Notifications

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd connectu_alumni_platform
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a Supabase project
   - Update `lib/core/config/app_config.dart` with your credentials:
     ```dart
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
     ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Database Setup

The application uses the provided database schema. Ensure your Supabase project has the following tables:
- `users` - User accounts and roles
- `studentdetails` - Student-specific information
- `alumnidetails` - Alumni-specific information
- `mentorship_sessions` - Mentorship bookings
- `webinars` - Webinar information
- `referrals` - Referral requests
- `chat_messages` - Chat functionality
- `notifications` - User notifications
- `transactions` - Payment tracking
- `reviews_feedback` - User reviews

## 🔧 Configuration

### Environment Variables
- Supabase URL and API keys
- App configuration settings
- Feature flags

### Customization
- Theme colors and styling
- Feature enable/disable
- Payment gateway integration
- Push notification setup

## 📊 Features in Detail

### Authentication System
- Email/password authentication
- Google OAuth integration
- Role-based access control
- Secure token management

### Mentorship Platform
- Session booking and scheduling
- Video call integration
- Payment processing
- Session feedback and ratings

### Webinar Management
- Webinar creation and hosting
- Registration and attendance tracking
- Content sharing and recording
- Interactive features (Q&A, polls)

### Referral System
- Job referral requests
- Alumni verification
- Status tracking
- Communication tools

### Chat System
- Real-time messaging
- File sharing
- Group conversations
- Message history

## 🚀 Deployment

### Android Build
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Release Configuration
- Update version in `pubspec.yaml`
- Configure signing keys
- Set up Firebase/Google Play Console

## 🔒 Security Features

- Secure authentication with Supabase
- Role-based access control
- Data encryption
- Secure API communication
- Input validation and sanitization

## 📈 Performance Optimization

- Efficient state management with Bloc
- Optimized image loading
- Lazy loading for large lists
- Memory management
- Background processing

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔮 Future Enhancements

- AI-powered mentor matching
- Advanced analytics dashboard
- Mobile app for iOS
- Integration with LinkedIn
- Advanced payment systems
- Video conferencing features
- Learning management system
- Career path tracking

## 📞 Contact

- **Project Lead**: [Your Name]
- **Email**: [your.email@example.com]
- **GitHub**: [your-github-username]

---

**ConnectU Alumni Platform** - Building bridges between students and alumni for a brighter future! 🎓✨

class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://cudwwhohzfxmflquizhk.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMTU3ODIsImV4cCI6MjA3MTg5MTc4Mn0.dqjSaeIwtVvc3-D8Aa9_w5PTK47SbI-M-aXlxu3H_Yw';

  // ⚠️ SECRET: Service Role Key (NEVER expose publicly!)
  static const String supabaseServiceRoleKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjMxNTc4MiwiZXhwIjoyMDcxODkxNzgyfQ.i9OvwpovQTQ4W7tVl2S5igNY_YAoc5zQe-K9cNx_Gq4';

  // App Configuration
  static const String appName = 'ConnectU';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const int apiTimeout = 30000; // 30 seconds
  static const int maxRetries = 3;

  // Cache Configuration
  static const int cacheExpiryHours = 24;

  // Pagination
  static const int defaultPageSize = 20;

  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Notification Configuration
  static const int maxNotifications = 100;

  // Payment Configuration (for future implementation)
  static const double platformFeePercentage = 0.05; // 5%
  static const double referralFeePercentage = 0.10; // 10%
}

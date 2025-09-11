class AppConfig {
  static const String appName = 'UCI KIGALI';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // API Configuration
  static const String baseUrl = 'https://api.ucikigali.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Splash Screen
  static const Duration splashDuration = Duration(seconds: 3);
  
  // QR Code Configuration
  static const Duration qrScanTimeout = Duration(seconds: 10);
  static const double qrScanAreaSize = 250.0;
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  
  // Mock API Endpoints (for development)
  static const String mockLoginEndpoint = '/auth/login';
  static const String mockTicketEndpoint = '/tickets';
  static const String mockScanEndpoint = '/scan';
}

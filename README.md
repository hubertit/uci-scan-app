# UCI Kigali - Ticket Scanning App

A Flutter application for scanning QR codes from tickets, extracting ticket IDs, fetching information from an API, and displaying ticket details.

## Features

- **Splash Screen**: Animated welcome screen with UCI Kigali branding
- **Login System**: Secure authentication with email/password
- **QR Code Scanning**: Real-time QR code scanning with camera
- **Ticket Validation**: API integration for ticket verification
- **Ticket Details**: Comprehensive ticket information display
- **Responsive Design**: Optimized for various screen sizes
- **Light Mode Theme**: Clean, modern UI with UCI Kigali colors

## Color Scheme

- **Primary**: #2A7EC7 (Blue)
- **Secondary**: #FBDD00 (Yellow)
- **Accent**: #C61937 (Red)
- **Background**: Light theme with clean whites and grays

## Architecture

The app follows a clean architecture pattern with:

- **Core**: Theme, configuration, and app setup
- **Features**: Authentication, splash, and scanning modules
- **Shared**: Reusable widgets and utilities
- **State Management**: Flutter Riverpod for state management

## Dependencies

- `flutter_riverpod`: State management
- `google_fonts`: Typography
- `qr_code_scanner`: QR code scanning functionality
- `http` & `dio`: API communication
- `shared_preferences`: Local storage
- `package_info_plus`: App version information

## Getting Started

1. **Prerequisites**
   - Flutter SDK (>=3.4.3)
   - Dart SDK
   - Android Studio / VS Code
   - Physical device or emulator with camera

2. **Installation**
   ```bash
   git clone <repository-url>
   cd uci
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Demo Credentials

For testing purposes, use these credentials:
- **Email**: admin@ucikigali.com
- **Password**: password123

## Project Structure

```
lib/
├── core/
│   ├── app/
│   ├── config/
│   └── theme/
├── features/
│   ├── auth/
│   ├── splash/
│   └── scanning/
├── shared/
│   ├── widgets/
│   └── utils/
└── main.dart
```

## Features Overview

### Splash Screen
- Animated logo and branding
- Progress indicator
- Automatic navigation to login

### Login Screen
- Email/password authentication
- Form validation
- Remember me functionality
- Demo credentials display

### Scanning Home
- Welcome dashboard
- Feature overview
- Quick access to QR scanner

### QR Scanner
- Real-time camera scanning
- Visual scanning overlay
- Flashlight toggle
- Automatic ticket detection

### Ticket Details
- Comprehensive ticket information
- Validation status
- Event details
- Attendee information

## API Integration

The app is designed to integrate with a ticket validation API. Current implementation includes:
- Mock API responses for development
- Error handling and loading states
- Ticket validation workflow

## Permissions

The app requires the following permissions:
- **Camera**: For QR code scanning
- **Storage**: For caching and preferences

## Development

### Code Style
- Follows Flutter/Dart best practices
- Uses Material Design 3
- Responsive design principles
- Clean architecture patterns

### Testing
```bash
flutter test
```

### Building
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is proprietary software for UCI Kigali.

## Support

For support and questions, contact the development team.
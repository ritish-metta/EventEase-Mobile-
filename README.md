# 🎉 EventEase Mobile App

**A Professional Event Booking & Management Application**

Seamless event discovery, booking, and management with modern UI/UX, secure authentication, and real-time updates.

---

## 🔗 Quick Links

<div align="center">

[![Download APK](https://img.shields.io/badge/Download-APK-green?style=for-the-badge&logo=android)](https://drive.google.com/your-apk-link)
[![Watch Demo](https://img.shields.io/badge/Watch-Video%20Demo-red?style=for-the-badge&logo=youtube)](https://drive.google.com/your-video-link)
[![Backend API](https://img.shields.io/badge/Backend-API-blue?style=for-the-badge&logo=github)](https://github.com/ritish-metta/EventEase-Mobile-backend)

</div>

---

## 📸 Screenshots

<div align="center">

### User Interface Gallery

| | | |
|---|---|---|
| ![Language Selection](https://via.placeholder.com/150) | ![Registration](https://via.placeholder.com/150) | ![OTP Verification](https://via.placeholder.com/150) |
| **Language Selection** | **Registration Form** | **OTP Verification** |

| | | |![WhatsApp Image 2025-10-18 at 5 15 21 PM (1)](https://github.com/user-attachments/assets/e25638a0-b648-4fea-93c4-3c0238929e3a)

|---|---|---|
| ![Event Dashboard](https://via.placeholder.com/150) | ![Event Details](https://via.placeholder.com/150) | ![Booking Screen](https://via.placeholder.com/150) |
| **Event Dashboard** | **Event Details** | **Booking Screen** |

| | | |
|---|---|---|![Uploading WhatsApp Image 2025-10-18 at 5.15.21 PM.jpeg…]()

| ![My Bookings](https://via.placeholder.com/150) | ![Profile Settings](https://via.placeholder.com/150) | ![Search & Filter](https://via.placeholder.com/150) |
| **My Bookings** | **Profile Settings** | **Search & Filter** |

### Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

</div>

---

## 🌟 Overview

EventEase is a Flutter-based mobile application designed for seamless event discovery and booking. Built with clean architecture and modern design principles, it provides users with an intuitive platform to explore events, book tickets, and manage their bookings efficiently.

---

## 🎯 Why This App Stands Out

- **🌐 Multi-Language Support**: 9 languages including English, Hindi, Tamil, Telugu, and more
- **🔐 Secure Authentication**: Email-based OTP verification with JWT tokens
- **🎫 Smart Booking**: Real-time seat availability and instant confirmation
- **💳 Payment Integration**: Multiple payment options (Coming Soon)
- **📱 Modern UI/UX**: Material Design with smooth animations
- **💾 Offline Support**: Cached data for better performance
- **🔔 Push Notifications**: Real-time event updates and reminders
- **🔍 Advanced Search**: Filter by category, date, location, and price

---

## ✨ Features

### Core Features

| Feature | Description | Status |
|---------|-------------|--------|
| 🌍 **Language Selection** | Choose from 9 supported languages | ✅ |
| 📝 **User Registration** | Complete registration with email verification | ✅ |
| 🔑 **OTP Verification** | 6-digit email-based OTP system | ✅ |
| 🎪 **Event Discovery** | Browse and search thousands of events | ✅ |
| 🎫 **Ticket Booking** | Instant booking with seat selection | ✅ |
| 📊 **Booking History** | Track all your bookings in one place | ✅ |
| 👤 **User Profile** | Manage personal information and preferences | ✅ |
| 🔍 **Search & Filter** | Advanced filtering by multiple criteria | ✅ |
| ⭐ **Featured Events** | Curated list of trending events | ✅ |

### Premium Features

- **📍 Location-based Events** - Find events near you
- **🎨 Category Filters** - Music, Sports, Tech, Arts, Food, Party
- **💰 Price Comparison** - Find the best deals
- **📅 Calendar Integration** - Add events to your calendar
- **🔔 Event Reminders** - Never miss your favorite events
- **💬 Reviews & Ratings** - Share your experience
- **🎁 Promo Codes** - Get exclusive discounts

---

## 🏗️ Architecture

```
EventEase-Mobile/
├── 📱 lib/
│   ├── main.dart                       # App entry point
│   │
│   ├── 🔧 config/
│   │   └── api_constants.dart          # API endpoints configuration
│   │
│   ├── 💾 services/
│   │   ├── api_service.dart            # Authentication API calls
│   │   ├── event_data_service.dart     # Event management API
│   │   └── preferences_service.dart    # Local storage service
│   │
│   ├── 🗂️ models/
│   │   ├── user_model.dart             # User data model
│   │   ├── event_model.dart            # Event data model
│   │   └── booking_model.dart          # Booking data model
│   │
│   ├── 🖥️ screens/
│   │   ├── language_page.dart          # Language selection
│   │   ├── registration_page.dart      # User registration
│   │   ├── otp_screen.dart             # OTP verification
│   │   ├── staging_screen.dart         # Onboarding tutorial
│   │   ├── home_page.dart              # Main dashboard
│   │   ├── event_details_page.dart     # Event information
│   │   ├── booking_page.dart           # Ticket booking
│   │   └── my_bookings_page.dart       # Booking history
│   │
│   ├── 🎨 widgets/
│   │   ├── custom_button.dart          # Reusable button
│   │   ├── event_card.dart             # Event display card
│   │   ├── category_chip.dart          # Category filter chip
│   │   └── shimmer_loading.dart        # Loading placeholders
│   │
│   └── 🛣️ routes/
│       └── route_generator.dart        # Navigation routes
│
├── 📁 assets/
│   ├── images/                         # App images & icons
│   └── fonts/                          # Custom fonts
│
├── 🧪 test/
│   └── widget_test.dart                # Unit & widget tests
│
├── 📄 .env                             # Environment variables
├── 📄 .env.example                     # Env template
└── 📄 pubspec.yaml                     # Dependencies
```

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator
- Backend API running (see [backend repo](https://github.com/ritish-metta/EventEase-Mobile-backend))

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/ritish-metta/EventEase-Mobile-.git
cd EventEase-Mobile-
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Set up environment variables**

Create a `.env` file in the root directory:

```env
# API Configuration
BASE_URL=https://your-backend-url.com/api
AUTH_BASE_URL=https://your-backend-url.com/api/auth

# Timeout settings (in seconds)
API_TIMEOUT=30
```

4. **Add assets**

Ensure all images are placed in the `assets/images/` directory and listed in `pubspec.yaml`.

5. **Run the application**

```bash
# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

---

## 📋 Core Components

### 1. API Service (`api_service.dart`)

Handles all authentication-related API calls.

**Key Methods:**
```dart
register({username, email, password})     // User registration
sendOtp({email})                          // Send OTP to email
verifyOtp({email, otp})                   // Verify OTP code
login({email, password})                  // User login
resendOtp({email})                        // Resend OTP
```

**Response Format:**
```dart
{
  'success': true/false,
  'message': 'Response message',
  'data': { /* response data */ },
  'token': 'JWT token' // For login
}
```

---

### 2. Event Data Service (`event_data_service.dart`)

Manages all event-related operations.

**Key Methods:**
```dart
getAllEvents()                            // Fetch all events
getFeaturedEvents()                       // Get featured/upcoming events
getEventById(id)                          // Get single event details
searchEvents(query)                       // Search events by keyword
getEventsByCategory(category)             // Filter by category
addEvent(event, token)                    // Create new event (admin)
updateEvent(id, event, token)             // Update event (admin)
deleteEvent(id, token)                    // Delete event (admin)
```

**Event Data Format:**
```dart
{
  'id': 'event_id',
  'title': 'Event Title',
  'image': 'image_url',
  'startDate': DateTime,
  'endDate': DateTime,
  'location': 'Event Location',
  'category': 'Music/Sports/Tech/etc',
  'price': 50.00,
  'capacity': 1000,
  'bookedSeats': 450,
  'description': 'Event description'
}
```

---

### 3. Preferences Service (`preferences_service.dart`)

Manages local data persistence using SharedPreferences.

**Key Methods:**
```dart
saveUserData(name, email, mobile)         // Store user info
setAuthenticated(bool)                    // Set login status
getUserData()                             // Retrieve user data
clearUserData()                           // Clear all data
saveAuthToken(token)                      // Store JWT token
getAuthToken()                            // Get JWT token
```

**Stored Data:**
- `user_name` - User's display name
- `user_email` - User's email address
- `user_mobile` - User's phone number
- `is_authenticated` - Login status
- `auth_token` - JWT authentication token
- `selected_language` - User's language preference

---

### 4. API Constants (`api_constants.dart`)

Centralized API endpoint configuration using environment variables.

```dart
class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL'];
  static String authBaseUrl = dotenv.env['AUTH_BASE_URL'];
  
  // Booking endpoints
  static String createBooking = '$baseUrl/bookings';
  static String getBookings = '$baseUrl/bookings';
  static String cancelBooking(id) => '$baseUrl/bookings/$id/cancel';
  
  // Event endpoints
  static String allEvents = '$baseUrl/events';
  static String featuredEvents = '$baseUrl/events/featured/list';
  static String eventById(id) => '$baseUrl/events/$id';
}
```

---

## 📱 User Flow

```
Language Selection → Registration → OTP Verification → Staging → Event Dashboard → Event Details → Booking → Confirmation
```

### 1. Language Selection

**Features:**
- **9 Language Options**: English, Hindi, Bengali, Kannada, Punjabi, Tamil, Telugu, French, Spanish
- Native script display for each language
- Radio button selection with visual feedback
- Saves preference to local storage

**Languages Supported:**
```dart
English  - Welcome to EventEase
Hindi    - ईवेंटईज़ में आपका स्वागत है
Bengali  - ইভেন্টইজে আপনাকে স্বাগতম
Kannada  - ಈವೆಂಟ್‌ಈಸ್‌ಗೆ ನಿಮಗೆ ಸ್ವಾಗತ
Punjabi  - ਈਵੈਂਟਈਜ਼ ਵਿੱਚ ਤੁਹਾਡਾ ਸਵਾਗਤ ਹੈ
Tamil    - EventEase க்கு வரவேற்கிறோம்
Telugu   - EventEase కి స్వాగతం
French   - Bienvenue sur EventEase
Spanish  - Bienvenido a EventEase
```

---

### 2. Registration Page

**Input Fields:**
- Full Name (required, min 2 characters)
- Email Address (validated format)
- Password (minimum 6 characters, secure)
- Country Code (India +91 by default)
- Mobile Number (10 digits required)
- Terms & Conditions (mandatory checkbox)

**Validation Rules:**
```dart
✓ Name: Non-empty, alphabets only
✓ Email: Valid format (xxx@xxx.xxx)
✓ Password: Minimum 6 characters, strength indicator
✓ Mobile: Exactly 10 digits, numeric only
✓ Terms: Must be accepted before submission
```

**Registration Process:**
1. User fills all required fields
2. Client-side validation checks
3. API call: Register user
4. API call: Send OTP to email
5. Save user data to SharedPreferences
6. Navigate to OTP verification screen

**Error Handling:**
- Network errors with retry option
- Duplicate email detection
- Invalid input feedback
- Server error messages

---

### 3. OTP Verification Screen

**Features:**
- **6-Digit Input Boxes**: Separate input for each digit
- **Auto-Focus**: Automatically moves to next box
- **Backspace Support**: Returns to previous box
- **Visual Feedback**: Highlights active input box
- **Resend OTP**: Available after 60 seconds
- **Timer Display**: Countdown for OTP expiry (10 minutes)

**OTP Workflow:**
1. User receives 6-digit code via email
2. Enters code in input boxes
3. Auto-submit when all 6 digits entered
4. API validates OTP
5. Success → Navigate to staging screen
6. Failure → Clear inputs, show error, allow resend

**Security:**
- OTP expires after 10 minutes
- Maximum 3 resend attempts
- Rate limiting on verification attempts
- Secure transmission via HTTPS

---

### 4. Staging/Onboarding Screen

**Components:**
- **Welcome Header**: "Hello [UserName]!"
- **User Avatar**: Profile picture placeholder
- **Tutorial Video**: YouTube embedded player
- **Instructions**: First-time user guide
- **Quick Actions**: WhatsApp support, Start button

**Features:**
- Loads user name from local storage
- Video autoplay option
- Progress tracking
- Skip tutorial option
- Smooth animations

**Tutorial Topics:**
- How to browse events
- Booking process explained
- Payment methods
- Managing bookings
- App features overview

---

### 5. Event Dashboard (Home Page)

**Layout Sections:**

#### A. Header
- App logo and branding
- Search bar with icon
- Profile avatar (top-right)
- Notification bell icon

#### B. Category Filters
Horizontal scrollable chips:
```
🎵 Music  🏀 Sports  💻 Tech  🎨 Arts  🍕 Food  🎉 Party
```

#### C. Featured Events
- Carousel/slider of highlighted events
- Auto-scroll with indicators
- "Featured" badge overlay
- Quick booking CTA

#### D. Upcoming Events
Grid/list view with event cards:
```
┌─────────────────────────┐
│   [Event Image]         │
│                         │
│   Event Title           │
│   📅 Date  📍 Location  │
│   💰 Price  🎫 Available│
│   [Book Now Button]     │
└─────────────────────────┘
```

#### E. Categories Section
Browse by category with image tiles

#### F. Bottom Navigation
```
🏠 Home  🔍 Search  🎫 Bookings  👤 Profile
```

**Features:**
- Pull-to-refresh functionality
- Infinite scroll/pagination
- Shimmer loading effects
- Error state handling
- Empty state illustrations

---

### 6. Event Details Page

**Information Displayed:**
- Full-screen event banner image
- Event title and category badge
- Date, time, and duration
- Venue name and address
- Google Maps integration
- Ticket pricing tiers
- Available seats count
- Event description
- Organizer information
- Terms & conditions

**Interactive Elements:**
- Image gallery swipe
- Share event button
- Add to favorites
- Set reminder
- View on map
- Contact organizer
- **Book Tickets** (primary CTA)

**Booking Section:**
```
┌───────────────────────────┐
│  Select Number of Tickets │
│  [ - ]  [ 2 ]  [ + ]      │
│                           │
│  Total: ₹1000             │
│  [Book Now Button]        │
└───────────────────────────┘
```

---

### 7. Booking Page

**Step-by-Step Process:**

#### Step 1: Ticket Selection
- Number of tickets selector
- Seat type selection (if applicable)
- Price breakdown display
- Discount code input

#### Step 2: User Information
Pre-filled from profile:
- Full Name
- Email Address
- Phone Number
- Emergency Contact (optional)

#### Step 3: Payment (Coming Soon)
- Credit/Debit Card
- UPI Integration
- Net Banking
- Wallet Options
- Cash on Delivery (if applicable)

#### Step 4: Confirmation
- Review booking details
- Terms acceptance
- Final price confirmation
- **Confirm Booking** button

**Booking Summary:**
```
┌─────────────────────────────┐
│ Event: Music Festival 2024  │
│ Date: Dec 15, 2024          │
│ Time: 7:00 PM               │
│ Tickets: 2 × ₹500 = ₹1000   │
│ Booking Fee: ₹50            │
│ ─────────────────────────   │
│ Total: ₹1050                │
└─────────────────────────────┘
```

---

### 8. Booking Confirmation

**Success Screen:**
- ✅ Success animation
- Booking ID display
- QR code for entry
- Download ticket button
- Add to calendar
- Share booking

**Email Confirmation:**
- Booking details
- QR code ticket
- Venue directions
- Contact information
- Cancellation policy

---

### 9. My Bookings Page

**Tabs:**
- **Upcoming**: Future events
- **Past**: Completed events
- **Cancelled**: Cancelled bookings

**Booking Card:**
```
┌─────────────────────────────┐
│  [Event Image]              │
│  Event Title                │
│  Booking ID: BK123456       │
│  📅 Dec 15, 2024  ⏰ 7:00 PM│
│  🎫 2 Tickets  💰 ₹1050     │
│  Status: Confirmed          │
│  [View Details] [Cancel]    │
└─────────────────────────────┘
```

**Features:**
- Search bookings
- Filter by status
- Sort by date
- Download tickets
- Cancel bookings (with policy check)
- Rebook past events

---

### 10. User Profile

**Sections:**

#### Personal Information
- Profile picture upload
- Name, Email, Phone
- Date of Birth
- Gender
- Edit profile button

#### Account Settings
- Change password
- Email notifications toggle
- Push notifications toggle
- Language preference
- Privacy settings

#### Preferences
- Favorite event categories
- Location preferences
- Price range filters
- Event reminders

#### Support
- Help & FAQ
- Contact support
- Report an issue
- Rate the app

#### Legal
- Terms of Service
- Privacy Policy
- Refund Policy
- About EventEase

---

## 🎨 UI Components

### Custom Button Widget
```dart
CustomButton(
  text: 'Book Now',
  onPressedAsync: () async {
    await bookTicket();
  },
  isLoading: _isLoading,
  color: Colors.blue,
  textColor: Colors.white,
)
```

### Event Card Widget
```dart
EventCard(
  event: eventData,
  onTap: () => navigateToDetails(),
  showBookingButton: true,
)
```

### Shimmer Loading
```dart
ShimmerLoading(
  type: ShimmerType.eventCard,
  count: 5,
)
```

---

## 🛠️ Tech Stack & Dependencies

### Core Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| **flutter** | Framework | SDK |
| **http** | API requests | ^1.1.0 |
| **shared_preferences** | Local storage | ^2.2.2 |
| **go_router** | Navigation | ^12.0.0 |
| **flutter_dotenv** | Environment variables | ^5.1.0 |

### UI Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| **cached_network_image** | Image caching | ^3.3.0 |
| **shimmer** | Loading effects | ^3.0.0 |
| **flutter_svg** | SVG support | ^2.0.0 |
| **carousel_slider** | Image carousel | ^4.2.0 |
| **lottie** | Animations | ^2.7.0 |

### Utility Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| **intl** | Date formatting | ^0.18.1 |
| **url_launcher** | External links | ^6.2.0 |
| **share_plus** | Share functionality | ^7.2.0 |
| **image_picker** | Photo selection | ^1.0.0 |

---

## 🎨 Design System

### Color Palette
```dart
// Primary Colors
Primary Blue:     #2563EB  (37, 99, 235)
Dark Blue:        #1E40AF  (30, 64, 175)
Light Blue:       #DBEAFE  (219, 234, 254)

// Secondary Colors
Success Green:    #10B981  (16, 185, 129)
Warning Orange:   #F59E0B  (245, 158, 11)
Error Red:        #EF4444  (239, 68, 68)

// Neutral Colors
Background:       #FFFFFF / #F9FAFB
Text Primary:     #111827
Text Secondary:   #6B7280
Border:           #E5E7EB
```

### Typography
```dart
// Headings
H1: 32px, Bold (FontWeight.w700)
H2: 24px, Semi-bold (FontWeight.w600)
H3: 20px, Semi-bold (FontWeight.w600)

// Body
Body Large:  16px, Regular (FontWeight.w400)
Body:        14px, Regular (FontWeight.w400)
Caption:     12px, Regular (FontWeight.w400)
```

### Spacing System
```dart
XXS: 4px
XS:  8px
S:   12px
M:   16px
L:   24px
XL:  32px
XXL: 48px
```

### Border Radius
```dart
Small:  4px  (buttons, chips)
Medium: 8px  (cards, inputs)
Large:  12px (modals, dialogs)
XLarge: 16px (images, containers)
```

---

## 🗺️ Navigation Routes

### Route Configuration
```dart
final router = GoRouter(
  initialLocation: '/language',
  routes: [
    GoRoute(path: '/language', builder: (context, state) => LanguagePage()),
    GoRoute(path: '/registration', builder: (context, state) => RegistrationPage()),
    GoRoute(path: '/otp', builder: (context, state) => OtpScreen()),
    GoRoute(path: '/staging', builder: (context, state) => StagingScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/event/:id', builder: (context, state) => EventDetailsPage()),
    GoRoute(path: '/booking/:eventId', builder: (context, state) => BookingPage()),
    GoRoute(path: '/my-bookings', builder: (context, state) => MyBookingsPage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
  ],
);
```

---

## 🔐 Security Features

- **JWT Token Management**: Secure storage in SharedPreferences
- **OTP Verification**: Email-based two-factor authentication
- **Input Validation**: All fields validated before API calls
- **HTTPS Only**: Secure API communication
- **Token Refresh**: Automatic token renewal
- **Secure Storage**: Sensitive data encryption
- **Session Management**: Auto-logout on token expiry

---

## 📊 State Management

Currently using **StatefulWidget** with plans to migrate to:
- **Provider** for global state
- **Riverpod** for dependency injection
- **Bloc** for complex state logic

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

**Test Coverage:**
- Unit tests for services
- Widget tests for UI components
- Integration tests for user flows
- API mocking for reliable tests

---

## 📱 Build & Release

### Android APK
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# Split per ABI (smaller size)
flutter build apk --split-per-abi
```

### iOS Build
```bash
# Release build
flutter build ios --release

# Create IPA
flutter build ipa
```

### App Bundle (Play Store)
```bash
flutter build appbundle --release
```

---

## 🚀 Deployment Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update `.env` with production URLs
- [ ] Test all features on real devices
- [ ] Check API endpoint connectivity
- [ ] Verify OTP email delivery
- [ ] Test payment integration
- [ ] Generate release builds
- [ ] Create app store assets
- [ ] Write release notes
- [ ] Submit to app stores

---

## 🐛 Known Issues & Limitations

1. **Payment Integration**: Currently under development
2. **Push Notifications**: Setup required for FCM
3. **Offline Mode**: Limited offline functionality
4. **Maps Integration**: Google Maps API key needed
5. **Social Login**: Facebook/Google login coming soon

---

## 🔮 Roadmap

### Version 2.0 (Q1 2025)
- [ ] Payment gateway integration
- [ ] Social media login
- [ ] Push notifications
- [ ] Dark mode support
- [ ] Event recommendations AI

### Version 2.1 (Q2 2025)
- [ ] Live event streaming
- [ ] In-app chat with organizers
- [ ] Group booking features
- [ ] Loyalty points system
- [ ] Referral program

### Version 3.0 (Q3 2025)
- [ ] AR venue preview
- [ ] Voice search
- [ ] Multi-city support
- [ ] Event creation for users
- [ ] Analytics dashboard

---

## 📄 License

This project is licensed under the **MIT License** - see the LICENSE file for details.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style Guidelines
- Follow Dart/Flutter style guide
- Use meaningful variable names
- Add comments for complex logic
- Write tests for new features
- Update documentation

---

## 📧 Support & Contact

- **Developer**: Ritish Metta
- **Email**: ritishmetta@gmail.com
- **GitHub**: [@ritish-metta](https://github.com/ritish-metta)
- **Issues**: [Report a bug](https://github.com/ritish-metta/EventEase-Mobile-/issues)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Open source community for packages
- Backend API contributors
- Beta testers for valuable feedback
- UI/UX inspiration from modern booking apps

---

## ⭐ Star this repository if you found it helpful!

**Made with ❤️ using Flutter & Dart**


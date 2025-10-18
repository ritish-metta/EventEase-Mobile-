import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api';
  static String get authBaseUrl => dotenv.env['AUTH_BASE_URL'] ?? 'http://localhost:5000/api/auth';
  
  static Duration get timeout => Duration(
    seconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30')
  );
  
  // Booking endpoints
  static String get createBooking => '$baseUrl/bookings';
  static String get getBookings => '$baseUrl/bookings';
  static String cancelBooking(String bookingId) => '$baseUrl/bookings/$bookingId/cancel';
  
  // Event endpoints
  static String get allEvents => '$baseUrl/events';
  static String get featuredEvents => '$baseUrl/events/featured/list';
  static String eventById(String id) => '$baseUrl/events/$id';
  static String searchEvents(String query) => '$baseUrl/events?search=$query';
  static String eventsByCategory(String category) => '$baseUrl/events?category=$category';
}
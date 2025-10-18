

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api';
  static String get authBaseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api/auth';
  
  static Duration get timeout => Duration(
    seconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30')
  );
  
  // Booking endpoints
  static String get createBooking => '$baseUrl/api/bookings';
  static String get getBookings => '$baseUrl/api/bookings';
  static String cancelBooking(String bookingId) => '$baseUrl/api/bookings/$bookingId/cancel';
  
  // Event endpoints
  static String get allEvents => '$baseUrl/api/events';
  static String get featuredEvents => '$baseUrl/api/events/featured/list';
  static String eventById(String id) => '$baseUrl/api/events/$id';
  static String searchEvents(String query) => '$baseUrl/api/events?search=$query';
  static String eventsByCategory(String category) => '$baseUrl/api/events?category=$category';
}

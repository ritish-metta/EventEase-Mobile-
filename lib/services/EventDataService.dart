import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Centralized Event Data Service - Now fetches from API
class EventDataService {
  // Singleton pattern
  static final EventDataService _instance = EventDataService._internal();
  factory EventDataService() => _instance;
  EventDataService._internal();

  // API Configuration
 static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api';
  
  // Cache for events (optional - for offline support)
  List<Map<String, dynamic>> _cachedEvents = [];

  // Get all events from API
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/events'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _cachedEvents = List<Map<String, dynamic>>.from(
            data['data'].map((event) => _convertFromApi(event))
          );
          return _cachedEvents;
        }
      }
      throw Exception('Failed to load events');
    } catch (e) {
      print('Error fetching events: $e');
      // Return cached events if available
      return _cachedEvents;
    }
  }

  // Get featured events (upcoming events)
  Future<List<Map<String, dynamic>>> getFeaturedEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/events/featured/list'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(
            data['data'].map((event) => _convertFromApi(event))
          );
        }
      }
      throw Exception('Failed to load featured events');
    } catch (e) {
      print('Error fetching featured events: $e');
      return [];
    }
  }

  // Get event by ID
  Future<Map<String, dynamic>?> getEventById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/events/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return _convertFromApi(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }

  // Add a new event (requires authentication)
  Future<bool> addEvent(Map<String, dynamic> event, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(_convertToApi(event)),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error adding event: $e');
      return false;
    }
  }

  // Update an event (requires authentication)
  Future<bool> updateEvent(String id, Map<String, dynamic> event, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/events/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(_convertToApi(event)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  // Delete an event (requires authentication)
  Future<bool> deleteEvent(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/events/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }

  // Search events
  Future<List<Map<String, dynamic>>> searchEvents(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/events?search=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(
            data['data'].map((event) => _convertFromApi(event))
          );
        }
      }
      return [];
    } catch (e) {
      print('Error searching events: $e');
      return [];
    }
  }

  // Get events by category
  Future<List<Map<String, dynamic>>> getEventsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/events?category=$category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(
            data['data'].map((event) => _convertFromApi(event))
          );
        }
      }
      return [];
    } catch (e) {
      print('Error fetching events by category: $e');
      return [];
    }
  }

  // Convert API response to Flutter format
  Map<String, dynamic> _convertFromApi(Map<String, dynamic> apiEvent) {
    return {
      'id': apiEvent['_id'] ?? apiEvent['id'],
      'image': apiEvent['image'],
      'title': apiEvent['title'],
      'startDate': DateTime.parse(apiEvent['startDate']),
      'endDate': DateTime.parse(apiEvent['endDate']),
      'location': apiEvent['location'],
      'category': apiEvent['category'],
      'price': (apiEvent['price'] as num).toDouble(),
      'date': apiEvent['date'], // Formatted date from API
      'capacity': apiEvent['capacity'],
      'bookedSeats': apiEvent['bookedSeats'] ?? 0,
      'description': apiEvent['description'],
    };
  }

  // Convert Flutter format to API format
  Map<String, dynamic> _convertToApi(Map<String, dynamic> event) {
    return {
      'title': event['title'],
      'image': event['image'],
      'startDate': event['startDate'].toIso8601String(),
      'endDate': event['endDate'].toIso8601String(),
      'location': event['location'],
      'category': event['category'],
      'price': event['price'],
      'capacity': event['capacity'],
      'bookedSeats': event['bookedSeats'] ?? 0,
      'description': event['description'],
    };
  }
}
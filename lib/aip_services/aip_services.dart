import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Get base URL from environment variables
  static String get baseUrl => dotenv.env['AUTH_BASE_URL'] ?? 'http://localhost:5000/api/auth';
  
  // Connection timeout duration from environment
  static Duration get timeoutDuration => Duration(
    seconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30')
  );

  // Common headers for all requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      print('Registration Request:');
      print('   URL: $baseUrl/register');
      print('   Username: $username');
      print('   Email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      ).timeout(timeoutDuration);

      print('Registration Response:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Server returned HTML instead of JSON. Check API endpoint.',
        };
      }

      // Handle success responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'Registration successful',
            'data': data,
          };
        } on FormatException {
          return {
            'success': false,
            'message': 'Invalid response format from server',
          };
        }
      }

      // Handle error responses
      if (response.statusCode == 400 || response.statusCode == 409) {
        try {
          final errorData = json.decode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Registration failed',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Registration failed: ${response.statusCode}',
          };
        }
      }

      // Other status codes
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };

    } on http.ClientException catch (e) {
      print(' Network Error: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    } on FormatException catch (e) {
      print('Format Error: $e');
      return {
        'success': false,
        'message': 'Server returned invalid response',
      };
    } catch (e) {
      print('Unexpected Error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  /// Send OTP to email
  static Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    try {
      print(' Send OTP Request:');
      print('   URL: $baseUrl/send-otp');
      print('   Email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: _headers,
        body: json.encode({
          'email': email,
        }),
      ).timeout(timeoutDuration);

      print(' Send OTP Response:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Server returned HTML. Check OTP endpoint.',
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'OTP sent successfully',
            'data': data,
          };
        } on FormatException {
          return {
            'success': false,
            'message': 'Invalid response format from server',
          };
        }
      }

      // Handle errors
      try {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to send OTP',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Failed to send OTP: ${response.statusCode}',
        };
      }

    } catch (e) {
      print('Send OTP Error: $e');
      return {
        'success': false,
        'message': 'Failed to send OTP: $e',
      };
    }
  }

  /// Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      print(' Verify OTP Request:');
      print('   URL: $baseUrl/verify-otp');
      print('   Email: $email');
      print('   OTP: $otp');

      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'otp': otp,
        }),
      ).timeout(timeoutDuration);

      print(' Verify OTP Response:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Server error. Check verify-otp endpoint.',
        };
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'OTP verified successfully',
            'data': data,
          };
        } on FormatException {
          return {
            'success': false,
            'message': 'Invalid response format',
          };
        }
      }

      // Handle errors
      try {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Invalid OTP',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'OTP verification failed',
        };
      }

    } catch (e) {
      print(' Verify OTP Error: $e');
      return {
        'success': false,
        'message': 'Failed to verify OTP: $e',
      };
    }
  }

  /// Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print(' Login Request:');
      print('   URL: $baseUrl/login');
      print('   Email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeoutDuration);

      print(' Login Response:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Server error. Check login endpoint.',
        };
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'Login successful',
            'data': data,
            'token': data['token'],
            'user': data['user'],
          };
        } on FormatException {
          return {
            'success': false,
            'message': 'Invalid response format',
          };
        }
      }

      // Handle errors
      try {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Login failed',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Invalid credentials',
        };
      }

    } catch (e) {
      print(' Login Error: $e');
      return {
        'success': false,
        'message': 'Login failed: $e',
      };
    }
  }

  /// Resend OTP
  static Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    try {
      print(' Resend OTP Request:');
      print('   URL: $baseUrl/resend-otp');
      print('   Email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/resend-otp'),
        headers: _headers,
        body: json.encode({
          'email': email,
        }),
      ).timeout(timeoutDuration);

      print(' Resend OTP Response:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Server error. Check resend-otp endpoint.',
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'OTP resent successfully',
            'data': data,
          };
        } on FormatException {
          return {
            'success': false,
            'message': 'Invalid response format',
          };
        }
      }

      return {
        'success': false,
        'message': 'Failed to resend OTP',
      };

    } catch (e) {
      print(' Resend OTP Error: $e');
      return {
        'success': false,
        'message': 'Failed to resend OTP: $e',
      };
    }
  }
}
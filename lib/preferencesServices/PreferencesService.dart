import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyMobile = 'user_mobile';
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyAuthToken = 'auth_token';

  // Save user data
  static Future<bool> saveUserData({
    required String name,
    required String email,
    required String mobile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyName, name);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyMobile, mobile);
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  // Mark user as authenticated
  static Future<bool> setAuthenticated(bool isAuthenticated) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsAuthenticated, isAuthenticated);
      return true;
    } catch (e) {
      print('Error setting authentication status: $e');
      return false;
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAuthenticated) ?? false;
  }

  // Save auth token - CRITICAL METHOD
  static Future<bool> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print(' Saving token to SharedPreferences: ${token.substring(0, 20)}...');
      bool result = await prefs.setString(_keyAuthToken, token);
      
      // Verify it was saved
      String? savedToken = prefs.getString(_keyAuthToken);
      print('Token saved successfully: ${savedToken != null && savedToken.isNotEmpty}');
      
      return result;
    } catch (e) {
      print(' Error saving auth token: $e');
      return false;
    }
  }

  // Get auth token - CRITICAL METHOD
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(_keyAuthToken);
      
      if (token != null && token.isNotEmpty) {
        print(' Retrieved token from SharedPreferences: ${token.substring(0, 20)}...');
        return token;
      } else {
        print(' No token found in SharedPreferences');
        return null;
      }
    } catch (e) {
      print(' Error retrieving auth token: $e');
      return null;
    }
  }

  // Get user name
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  // Get user email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Get user mobile
  static Future<String?> getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMobile);
  }

  // Clear all user data (logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyName);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyMobile);
      await prefs.remove(_keyIsAuthenticated);
      await prefs.remove(_keyAuthToken);
      print('All user data cleared');
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  // Get all user data
  static Future<Map<String, String?>> getUserData() async {
    return {
      'name': await getName(),
      'email': await getEmail(),
      'mobile': await getMobile(),
    };
  }

  static Future<void> init() async {
    // Initialize SharedPreferences if needed
    await SharedPreferences.getInstance();
  }
}
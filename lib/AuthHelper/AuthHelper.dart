

import 'package:eventease/preferencesServices/PreferencesService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthHelper {
  // Logout function
  static Future<void> logout(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Clear all user data and authentication status
      await PreferencesService.clearUserData();
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Navigate to language/login screen
      if (context.mounted) {
        context.go('/language');
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }





  // Show logout confirmation dialog
  static Future<void> showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (result == true && context.mounted) {
      await logout(context);
    }
  }

  // Check authentication status
  static Future<bool> isUserAuthenticated() async {
    return await PreferencesService.isAuthenticated();
  }

  // Get user data
  static Future<Map<String, String?>> getUserData() async {
    return await PreferencesService.getUserData();
  }
}
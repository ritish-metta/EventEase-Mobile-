import 'package:eventease/auth_screens/otp_screen.dart';
import 'package:eventease/auth_screens/registration_page.dart';
import 'package:eventease/auth_screens/sigin.dart';
import 'package:eventease/eventscreens/HomeScreen.dart';
import 'package:eventease/eventscreens/NotificationsScreen.dart';
import 'package:eventease/eventscreens/ScheduleScreen.dart';
import 'package:eventease/eventscreens/SettingsScreen.dart';
import 'package:eventease/bottom_menu/BottomNav.dart';
import 'package:eventease/preferencesServices/PreferencesService.dart';
import 'package:eventease/routes/approutes.dart';


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

late final GoRouter routeGenerator;

Future<void> initializeRouter() async {
  // Check if user is already authenticated
  final isAuthenticated = await PreferencesService.isAuthenticated();
  
  routeGenerator = GoRouter(
    // Start at home if authenticated, otherwise registration
    initialLocation: isAuthenticated ? AppRoutes.home : AppRoutes.registration,
    
    // Redirect logic for authentication
    redirect: (context, state) async {
      final isAuthenticated = await PreferencesService.isAuthenticated();
      final isAuthRoute = state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.registration ||
          state.matchedLocation == AppRoutes.otp;

      // If authenticated and trying to access auth screens, redirect to home
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.home;
      }

      // If not authenticated and trying to access protected screens, redirect to sign in
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.signIn;
      }

      // No redirect needed
      return null;
    },
    
    routes: [
      // Auth routes (outside ShellRoute - no bottom nav)
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.registration,
        builder: (context, state) => const RegistrationPage(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            email: extra?['email'] ?? '',
            phoneNumber: extra?['phoneNumber'] ?? '',
          );
        },
      ),

      // Protected routes (inside ShellRoute - with bottom nav)
      ShellRoute(
        builder: (context, state, child) {
          return BottomNav(
            currentLocation: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.schedule,
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Route not found')),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatefulWidget {
  final Widget child;
  final String currentLocation;

  const BottomNav({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _getIndexFromLocation(widget.currentLocation);
  }

  @override
  void didUpdateWidget(BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocation != widget.currentLocation) {
      _selectedIndex = _getIndexFromLocation(widget.currentLocation);
    }
  }

  int _getIndexFromLocation(String location) {
    if (location.contains('/schedule')) return 1;
    if (location.contains('/notifications')) return 2;
    if (location.contains('/settings')) return 3;
    return 0; // home
  }

  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    final routes = ['/home', '/schedule', '/notifications', '/settings'];
    context.go(routes[index]);
  }

  // Check if current route should show bottom nav
  bool _shouldShowBottomNav() {
    final location = widget.currentLocation.toLowerCase();
    
    // List of routes that should NOT show bottom navigation
    final excludedRoutes = [
      '/signin',
      '/signup',
      '/register',
      '/registration',
      '/login',
      '/otp',
      '/forgot-password',
      '/reset-password',
      '/onboarding',
      '/splash',
      '/welcome',
    ];
    
    // Check if current location matches any excluded route
    for (final route in excludedRoutes) {
      if (location.contains(route)) {
        return false;
      }
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 360 ? 22.0 : 26.0;
    final padding = screenWidth < 360 ? 8.0 : 14.0;
    final showBottomNav = _shouldShowBottomNav();

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: showBottomNav
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.apps_rounded, 0, iconSize),
                      _buildNavItem(Icons.calendar_today_rounded, 1, iconSize),
                      _buildNavItem(Icons.notifications_none_rounded, 2, iconSize),
                      _buildNavItem(Icons.settings_outlined, 3, iconSize),
                    ],
                  ),
                ),
              ),
            )
          : null, // Don't show bottom nav on auth pages
    );
  }

  Widget _buildNavItem(IconData icon, int index, double iconSize) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
                  top: BorderSide(color: Color(0xFFFF6B3D), width: 1.5),
                )
              : null,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFFF6B3D) : const Color(0xFF8E8E93),
          size: iconSize,
        ),
      ),
    );
  }
}
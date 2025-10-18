import 'package:eventease/constants/api_constants.dart';
import 'package:eventease/preferencesServices/PreferencesService.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final String? token;

  const BookingScreen({
    super.key,
    required this.event,
    this.token,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _agreedToTerms = false;
  int _seatsToBook = 1;
  String? _authToken;
  bool _isTokenLoading = true; // Add this flag

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
    
    // Load token immediately
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    try {
      // Try to get token from widget parameter first
      if (widget.token != null && widget.token!.isNotEmpty) {
        setState(() {
          _authToken = widget.token;
          _isTokenLoading = false;
        });
        print('✅ Using token from widget parameter');
        return;
      }

      // Try to load from SharedPreferences
      final token = await PreferencesService.getAuthToken();
      
      if (mounted) {
        setState(() {
          _authToken = token;
          _isTokenLoading = false;
        });

        if (token == null || token.isEmpty) {
          print('❌ WARNING: No auth token available!');
          _showErrorSnackBar('Authentication error. Please login again.');
          // Optionally navigate back to login
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          });
        } else {
          print('✅ Auth token loaded: ${token.substring(0, 20)}...');
        }
      }
    } catch (e) {
      print('❌ Error loading token: $e');
      if (mounted) {
        setState(() {
          _isTokenLoading = false;
        });
        _showErrorSnackBar('Failed to load authentication token');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _confirmBooking() async {
    // Validate fields
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty) {
      _showErrorSnackBar('Please fill all fields');
      return;
    }

    if (!_agreedToTerms) {
      _showErrorSnackBar('Please agree to terms and conditions');
      return;
    }

    // Check if token is still loading
    if (_isTokenLoading) {
      _showErrorSnackBar('Please wait, loading authentication...');
      return;
    }

    // Check if we have a token
    if (_authToken == null || _authToken!.isEmpty) {
      _showErrorSnackBar('Authentication error. Please login again.');
      return;
    }

    // Extract event ID - try multiple possible keys
    final eventId = widget.event['_id'] ?? widget.event['id'];
    
    if (eventId == null) {
      print('❌ ERROR: Event ID is null!');
      print('Available event keys: ${widget.event.keys.toList()}');
      print('Event data: ${widget.event}');
      _showErrorSnackBar('Invalid event data. Please try again.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('=== BOOKING REQUEST ===');
      print('URL: ${ApiConstants.createBooking}');
      print('Token (first 20 chars): ${_authToken!.substring(0, 20)}...');
      print('Token length: ${_authToken!.length}');
      print('Event ID: $eventId');
      print('========================');

      final response = await http.post(
        Uri.parse(ApiConstants.createBooking),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'eventId': eventId,
          'seats': 1, // Fixed to 1 seat as per requirement
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        }),
      );

      print('=== BOOKING RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('========================');

      if (mounted) {
        setState(() => _isLoading = false);

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          _showSuccessDialog(responseData['data']);
        } else {
          try {
            final errorData = jsonDecode(response.body);
            _showErrorSnackBar(errorData['message'] ?? 'Booking failed');
          } catch (e) {
            _showErrorSnackBar('Server error: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      print('=== BOOKING ERROR ===');
      print('Exception: $e');
      print('======================');
      
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 66, 24, 102),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B3D).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                'Your ticket has been booked successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7546A8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Booking ID',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      booking['bookingId'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/my-bookings');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFFFF6B3D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'View Ticket',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableSeats = (widget.event['capacity'] ?? 0) - (widget.event['bookedSeats'] ?? 0);
    final totalPrice = (widget.event['price'] ?? 0) * _seatsToBook;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 24, 102),
      body: SafeArea(
        child: _isTokenLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading authentication...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7546A8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Book Event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7546A8),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.network(
                                          widget.event['image'] ?? '',
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            width: 90,
                                            height: 90,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.event['title'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_today, color: Color(0xFFD4C5E8), size: 14),
                                                const SizedBox(width: 6),
                                                Text(
                                                  widget.event['startDate']?.toString().split('T')[0] ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xFFD4C5E8),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on, color: Color(0xFFD4C5E8), size: 14),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    widget.event['location'] ?? '',
                                                    style: const TextStyle(
                                                      color: Color(0xFFD4C5E8),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: availableSeats > 100
                                          ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                                          : availableSeats > 50
                                              ? [const Color(0xFFFF9800), const Color(0xFFFFB74D)]
                                              : [const Color(0xFFF44336), const Color(0xFFEF5350)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.event_seat, color: Colors.white, size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Seats Available',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '$availableSeats / ${widget.event['capacity'] ?? 0}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),
                                const Text(
                                  'Your Information',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  icon: Icons.person,
                                  hint: 'Enter your full name',
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  icon: Icons.email,
                                  hint: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _phoneController,
                                  label: 'Phone Number',
                                  icon: Icons.phone,
                                  hint: 'Enter your phone number',
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B3D).withOpacity(0.3),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Number of Seats',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '$_seatsToBook Seat${_seatsToBook > 1 ? 's' : ''}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(color: Colors.white24, thickness: 1),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Amount',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            '\$${totalPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _agreedToTerms,
                                        onChanged: (value) {
                                          setState(() => _agreedToTerms = value!);
                                        },
                                        fillColor: WidgetStateProperty.resolveWith((states) {
                                          if (states.contains(WidgetState.selected)) {
                                            return const Color(0xFFFF6B3D);
                                          }
                                          return const Color(0xFF7546A8);
                                        }),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'I agree to the terms and conditions',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 66, 24, 102),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          top: false,
                          child: GestureDetector(
                            onTap: _isLoading ? null : _confirmBooking,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isLoading
                                      ? [Colors.grey[600]!, Colors.grey[500]!]
                                      : [const Color(0xFFFF6B3D), const Color(0xFFFF8A5C)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B3D).withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        'Confirm Booking',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF7546A8),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFD4C5E8),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
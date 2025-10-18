import 'package:eventease/aip_services/aip_services.dart';
import 'package:eventease/preferencesServices/PreferencesService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 24, 102),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue to your account',
                        style: TextStyle(
                          color: const Color(0xFFB8A0D4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Container
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.05),
                          
                          // Email Field
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Email Address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          
                          // Password Field
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF7546A8),
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Sign In Button
                          GestureDetector(
                            onTap: _isLoading ? null : _handleSignIn,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B3D).withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: _isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go('/registration');
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF7546A8),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF7546A8),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Signing you in...',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF2D1B4E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (!_isEmailValid(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🔐 === LOGIN ATTEMPT ===');
      print('Email: $email');
      
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      // CRITICAL DEBUG: Print the ENTIRE response structure
      print('📦 === FULL API RESPONSE ===');
      print('Result type: ${result.runtimeType}');
      print('Result keys: ${result.keys.toList()}');
      print('Full result: $result');
      
      if (result['data'] != null) {
        print('Data keys: ${result['data'].keys.toList()}');
        print('Data content: ${result['data']}');
      }
      print('================================');

      if (!mounted) return;
      
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        // Try to extract token from multiple possible locations
        String? token = _extractToken(result);

        if (token != null && token.isNotEmpty) {
          print('🔑 === TOKEN FOUND ===');
          print('Token length: ${token.length}');
          print('Token preview: ${token.substring(0, token.length > 30 ? 30 : token.length)}...');
          
          // Save authentication data
          final saveSuccess = await _saveAuthenticationData(token, email, result);
          
          if (saveSuccess) {
            print('🎉 LOGIN COMPLETE - Navigating to home');
            print('========================\n');
            
            // Small delay to ensure everything is saved
            await Future.delayed(const Duration(milliseconds: 300));
            
            if (mounted) {
              context.go('/home');
            }
          } else {
            _showError('Failed to save authentication data. Please try again.');
          }
        } else {
          print('❌ NO VALID TOKEN FOUND');
          _showError('Login failed: No authentication token received');
        }
      } else {
        print('❌ Login failed: ${result['message']}');
        _showError(result['message'] ?? 'Login failed. Please try again.');
      }
    } catch (e, stackTrace) {
      print('❌ === LOGIN ERROR ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('======================');
      
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('An error occurred: ${e.toString()}');
      }
    }
  }

  /// Extract token from various possible locations in the API response
  String? _extractToken(Map<String, dynamic> result) {
    print('🔍 Searching for token...');
    print('Available keys in result: ${result.keys.toList()}');
    
    // Check each location with detailed logging
    
    // Location 0: result['token']
    print('📍 Checking result[token]: ${result['token']}');
    if (result['token'] != null && result['token'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[token]');
      return result['token'].toString().trim();
    }
    
    // Location 1: result['data']['token']
    print('📍 Checking result[data][token]: ${result['data']?['token']}');
    if (result['data']?['token'] != null && result['data']['token'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[data][token]');
      return result['data']['token'].toString().trim();
    }
    
    // Location 2: result['user']['token']
    print('📍 Checking result[user][token]: ${result['user']?['token']}');
    if (result['user']?['token'] != null && result['user']['token'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[user][token]');
      return result['user']['token'].toString().trim();
    }
    
    // Location 3: result['data']['user']['token']
    print('📍 Checking result[data][user][token]: ${result['data']?['user']?['token']}');
    if (result['data']?['user']?['token'] != null && result['data']['user']['token'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[data][user][token]');
      return result['data']['user']['token'].toString().trim();
    }
    
    // Location 4: result['accessToken']
    print('📍 Checking result[accessToken]: ${result['accessToken']}');
    if (result['accessToken'] != null && result['accessToken'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[accessToken]');
      return result['accessToken'].toString().trim();
    }
    
    // Location 5: result['data']['accessToken']
    print('📍 Checking result[data][accessToken]: ${result['data']?['accessToken']}');
    if (result['data']?['accessToken'] != null && result['data']['accessToken'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[data][accessToken]');
      return result['data']['accessToken'].toString().trim();
    }
    
    // Location 6: result['data']['data']['token']
    print('📍 Checking result[data][data][token]: ${result['data']?['data']?['token']}');
    if (result['data']?['data']?['token'] != null && result['data']['data']['token'].toString().trim().isNotEmpty) {
      print('✅ Token found at result[data][data][token]');
      return result['data']['data']['token'].toString().trim();
    }

    print('❌ TOKEN NOT FOUND IN ANY EXPECTED LOCATION!');
    print('Full result structure: $result');
    if (result['data'] != null) {
      print('result[data] structure: ${result['data']}');
    }
    if (result['user'] != null) {
      print('result[user] structure: ${result['user']}');
    }
    
    return null;
  }

  /// Save all authentication data
  Future<bool> _saveAuthenticationData(String token, String email, Map<String, dynamic> result) async {
    try {
      print('💾 === SAVING AUTHENTICATION DATA ===');
      
      // 1. Save the token
      print('💾 Saving token...');
      bool tokenSaved = await PreferencesService.saveAuthToken(token);
      
      if (!tokenSaved) {
        print('❌ Failed to save token to SharedPreferences');
        return false;
      }
      
      // 2. Verify token was saved
      print('🔍 Verifying token...');
      String? retrievedToken = await PreferencesService.getAuthToken();
      
      if (retrievedToken == null || retrievedToken != token) {
        print('❌ TOKEN VERIFICATION FAILED!');
        print('Expected length: ${token.length}');
        print('Got length: ${retrievedToken?.length ?? 0}');
        return false;
      }
      
      print('✅ TOKEN SUCCESSFULLY SAVED AND VERIFIED!');
      
      // 3. Set authentication status
      await PreferencesService.setAuthenticated(true);
      print('✅ Set authenticated: true');
      
      // 4. Save user data
      if (result['data'] != null) {
        final userData = result['data'];
        await PreferencesService.saveUserData(
          name: userData['name']?.toString() ?? '',
          email: userData['email']?.toString() ?? email,
          mobile: userData['mobile']?.toString() ?? userData['phone']?.toString() ?? '',
        );
        print('✅ User data saved');
      }
      
      print('✅ ALL AUTHENTICATION DATA SAVED SUCCESSFULLY');
      print('=====================================\n');
      
      return true;
    } catch (e) {
      print('❌ Error saving authentication data: $e');
      return false;
    }
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFFF6B3D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8DFF5),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D1B4E),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFB8A0D4),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF7546A8),
            size: 22,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
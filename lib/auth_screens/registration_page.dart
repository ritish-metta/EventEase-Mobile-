import 'package:eventease/aip_services/aip_services.dart';
import 'package:eventease/preferencesServices/PreferencesService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _handleSignUp() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      _showError('Please enter a valid email address');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showError('Please enter your password');
      return;
    }
    if (_passwordController.text.trim().length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (_mobileController.text.trim().isEmpty) {
      _showError('Please enter your mobile number');
      return;
    }
    if (_mobileController.text.trim().length != 10) {
      _showError('Please enter a valid 10-digit mobile number');
      return;
    }
    if (!_agreedToTerms) {
      _showError('Please agree to the Terms and Conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Step 1: Register user
      final registerResult = await ApiService.register(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!registerResult['success']) {
        _showError(registerResult['message']);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Step 2: Send OTP
      final otpResult = await ApiService.sendOtp(
        email: _emailController.text.trim(),
      );

      if (!otpResult['success']) {
        _showError(otpResult['message']);
        setState(() {
          _isLoading = false;
        });
        return;
      }


      

      // Step 3: Save user data to SharedPreferences
      await PreferencesService.saveUserData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: '+91${_mobileController.text.trim()}',
      );

      setState(() {
        _isLoading = false;
      });

      // Step 4: Navigate to OTP screen
      if (mounted) {
        context.go('/otp', extra: {
          'email': _emailController.text.trim(),
          'phoneNumber': '+91 ${_mobileController.text.trim()}',
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('An error occurred: $e');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
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
                      Row(
                        children: [



                          IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => context.pop(),
    ),
    const Spacer(),


                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to discover amazing events',
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
                          const SizedBox(height: 8),
                          
                          // Name Field
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Full Name',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          
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
                            isPassword: true,
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
                          const SizedBox(height: 16),
                          
                          // Phone Number Field
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F4FC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE8DFF5),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: const Color(0xFFE8DFF5),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/320px-Flag_of_India.svg.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '+91',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D1B4E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _mobileController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2D1B4E),
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Mobile Number',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFB8A0D4),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 18,
                                      ),
                                      counterText: '',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.phone_outlined,
                                    color: const Color(0xFF7546A8),
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Terms and Conditions
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreedToTerms = value ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF7546A8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    const Text(
                                      'I agree to the ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to terms and conditions
                                      },
                                      child: const Text(
                                        'Terms and Conditions',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF7546A8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Sign Up Button
                          GestureDetector(
                            onTap: _isLoading ? null : _handleSignUp,
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
                                      'Sign Up',
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
                          
                          // Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go('/signin');
                                },
                                child: const Text(
                                  'Sign In',
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
                          'Creating your account...',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}
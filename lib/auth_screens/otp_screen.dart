import 'package:eventease/aip_services/aip_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    String otp = _getOtp();
    
    if (otp.length != 6) {
      _showError('Please enter complete OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.verifyOtp(
        email: widget.email,
        otp: otp,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          _showSuccess('OTP verified successfully!');
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.go('/home');
            }
          });
        }
      } else {
        _showError(result['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('An error occurred: $e');
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.sendOtp(email: widget.email);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        _showSuccess('OTP sent successfully!');
      } else {
        _showError(result['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('An error occurred: $e');
    }
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

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                      const Text(
                        'Verify OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the code sent to your email',
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
                          SizedBox(height: screenHeight * 0.04),
                          
                          // Email Display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F4FC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE8DFF5),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF7546A8),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    widget.email,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D1B4E),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.05),
                          
                          // OTP Input Fields
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return Container(
                                  width: 48,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F4FC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFE8DFF5),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF7546A8),
                                    ),
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) {
                                      _onOtpChanged(index, value);
                                      _onBackspace(index, value);
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.04),
                          
                          // Info Text
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Please ensure the number mentioned is valid\nas we have sent an OTP to your email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF64748B),
                                height: 1.5,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.04),
                          
                          // Resend OTP Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive OTP code? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              GestureDetector(
                                onTap: _isLoading ? null : _resendOtp,
                                child: Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _isLoading 
                                        ? const Color(0xFFB8A0D4)
                                        : const Color(0xFF7546A8),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: screenHeight * 0.05),
                          
                          // Verify Button
                          GestureDetector(
                            onTap: _isLoading ? null : _verifyOtp,
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
                              child: const Text(
                                'Verify & Continue',
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
                          'Verifying OTP...',
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
}
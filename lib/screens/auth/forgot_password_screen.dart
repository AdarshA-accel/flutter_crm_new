import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;

  void _sendCode() async {
    setState(() {
      _isSending = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSending = false;
    });

    // Navigate to OTP Verification Screen
    Navigator.pushReplacementNamed(context, '/otp_verification');
  }

  void _goToSignIn() {
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/sign_in');
                  },
                  child: Image.asset(
                    'assets/images/back.png',
                    width: 41,
                    height: 41,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Accelgrowth logo
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Image.asset(
                  'assets/images/accelgrowth_logo.png',
                  width: 182,
                  height: 42,
                ),
              ),
              const SizedBox(height: 24),
                    // Forgot password text image
                    Padding(
                padding: const EdgeInsets.only(top: 30, left: 10),
                      child: Image.asset(
                        'assets/images/Forgot Password_.png',
                        height: 24,
                        width: 168,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Don't worry text
const Padding(
  padding: EdgeInsets.only(top: 30, left: 10),
  child: SizedBox(
    width: 347, 
    child: Text(
      "Don't worry! It occurs. Please enter the email address linked with your account.",
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFFC9C9C9),
        fontFamily: 'PublicSans',
      ),
      textAlign: TextAlign.left,
    ),
  ),
),
const SizedBox(height: 32),

                    // Email input
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Enter email',
                        labelStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Send code button
                    SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7367F0), 
      foregroundColor: Colors.white, 
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: _isSending ? null : _sendCode,
    child: _isSending
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : const Text(
            'Send Code',
            style: TextStyle(
              fontFamily: 'PublicSans',
            ),
          ),
  ),
),
                    const SizedBox(height: 250),
                    // Remember Password? Login
                    Center(
                      child: SizedBox(
                        width: 202,
                        height: 20,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'PublicSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: 'Remember Password? '),
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  color: Color(0xFF7367F0),
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/sign_in');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;
  bool _obscurePassword = true;

  final String _correctEmail = 'user@example.com';
  final String _correctPassword = 'password123';

  // ignore: unused_element
  void _onLoginPressed() {
    setState(() {
      if (_emailController.text == _correctEmail &&
          _passwordController.text == _correctPassword) {
        _errorText = null;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _errorText = 'Password is incorrect';
      }
    });
  }

  Future<void> _launchGoogle() async {
    const url = 'https://www.google.com';
   if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google')),
      );
    }
  }

  Future<void> _launchMicrosoft() async {
    const url = 'https://www.microsoft.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Microsoft')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 67, left: 25),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/welcome');
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
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Image.asset(
                      'assets/images/accelgrowth_logo.png',
                      width: 182,
                      height: 42,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Welcome text
                  const Padding(
                    padding: EdgeInsets.only(left: 25, top: 24),
                    child: Text(
                      "Welcome to Accelgrowth!",
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFF7367F0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email field box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFC9C9C9), width: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter email',
                              hintStyle: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 16,
                                color: Color(0xFFC9C9C9),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password field box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFC9C9C9), width: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                              hintStyle: const TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 16,
                                color: Color(0xFFC9C9C9),
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgot_password');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF7367F0),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorText!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home_screen');
                      },
                      child: Image.asset(
                        'assets/images/Login Signin (Button).png',
                        width: 362,
                        height: 56,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // OR Sign In With and Icons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        // Divider text
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFDEE1E6), thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Or Sign In with',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFDEE1E6), thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Microsoft
                            GestureDetector(
                              onTap: () {
                                _launchMicrosoft();
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFC9C9C9), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  'assets/images/microsoft_signin.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Google
                            GestureDetector(
                              onTap: () {
                                _launchGoogle();
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFC9C9C9), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  'assets/images/google_signin.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),

            // Bottom Center Link
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const SizedBox(
                    width: 280,
                    height: 19,
                    child: Text(
                      'Sign In with Accelgrowth Username',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 14,
                        color: Color(0xFF7367F0),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF7367F0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

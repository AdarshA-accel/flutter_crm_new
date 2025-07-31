import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _obscurePassword = true;
  String? _errorText;

  void _goToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 45),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/sign_in');
                      },
                      child: Image.asset(
                        'assets/images/back.png',
                        width: 41,
                        height: 41,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/accelgrowth_logo.png',
                      width: 182,
                      height: 42,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Login to Accelgrowth!",
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFF7367F0),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 362,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 64,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFC9C9C9)),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: const TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Company domain name',
                                      hintStyle: TextStyle(
                                        fontFamily: 'PublicSans',
                                        fontSize: 14,
                                        color: Color(0xFFC9C9C9),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 64,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7367F0),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  '.sortboxs.com',
                                  style: TextStyle(
                                    fontFamily: 'PublicSans',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: 362,
                          child: Container(
                            height: 64,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFC9C9C9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14,
                                  color: Color(0xFFC9C9C9),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: 362,
                          child: Container(
                            height: 64,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFC9C9C9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                bool obscureText = true;
                                return TextField(
                                  obscureText: obscureText,
                                  decoration: InputDecoration(
                                    hintText: 'Enter password',
                                    hintStyle: const TextStyle(
                                      fontFamily: 'PublicSans',
                                      fontSize: 14,
                                      color: Color(0xFFC9C9C9),
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscureText = !obscureText;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Error text if needed
                    if (_errorText != null)
                      Text(
                        _errorText!,
                        style: const TextStyle(
                          fontFamily: 'PublicSans',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                    const SizedBox(height: 16),

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
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 200),
              child: GestureDetector(
                onTap: () => _goToSignIn(context),
                child: Center(
                  child: Image.asset(
                    'assets/images/Other login options.png',
                    height: 32,
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

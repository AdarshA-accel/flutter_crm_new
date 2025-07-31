import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorText;

  void _updatePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorText = "Passwords do not match.";
      });
    } else {
      setState(() {
        _errorText = null;
      });
      Navigator.pushReplacementNamed(context, '/password_changed');
    }
  }

  void _cancel() {
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                    padding: const EdgeInsets.only(top: 67, left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/sign_in');
                        },
                        child: Image.asset(
                          'assets/images/back.png',
                          width: 41,
                          height: 41,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Accelgrowth logo
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/accelgrowth_logo.png',
                          width: 182,
                          height: 42,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // OTP title image
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/Reset Your Password.png',
                          height: 24,
                          width: 196,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                // New Password
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  style: const TextStyle(
                    fontFamily: 'PublicSans',
                    fontWeight: FontWeight.w300, 
                  ),
                  decoration: InputDecoration(
                    hintText: 'New password',
                    hintStyle: const TextStyle(
                      fontFamily: 'PublicSans',
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.w300,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Confirm Password
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(
                    fontFamily: 'PublicSans',
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm new password',
                    hintStyle: const TextStyle(
                      fontFamily: 'PublicSans',
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.w300,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                if (_errorText != null) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Update Password Button
                GestureDetector(
                  onTap: _updatePassword,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Frame 11241.png',
                      height: 56,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                GestureDetector(
                  onTap: _cancel,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Frame 11242.png',
                      height: 56,
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
}

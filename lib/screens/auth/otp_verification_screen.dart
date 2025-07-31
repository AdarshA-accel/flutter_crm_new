import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  bool _isWrongCode = false;
  bool _isResending = false;

  final String _correctOtp = "3333"; // as per your Figma

  void _onVerify() {
    final enteredOtp = _otpControllers.map((e) => e.text).join();
    if (enteredOtp == _correctOtp) {
      Navigator.pushReplacementNamed(context, '/reset_password');
    } else {
      setState(() {
        _isWrongCode = true;
      });
    }
  }

  void _onResend() async {
    setState(() {
      _isResending = true;
      _isWrongCode = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isResending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent to your email.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 67, left: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/forgot_password');
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
                    padding: const EdgeInsets.only(top: 10, left: 25),
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
                    padding: const EdgeInsets.only(left: 24.0, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/OTP Verification.png',
                          height: 24,
                          width: 152,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // OTP Instruction Text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter the verification code we just sent on your email address',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC9C9C9),
                          fontFamily: 'PublicSans',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // OTP fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 48,
                        child: TextField(
                          controller: _otpControllers[index],
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isWrongCode = false;
                            });
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  if (_isWrongCode)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Code is wrong',
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  GestureDetector(
                    onTap: _onVerify,
                    child: Image.asset(
                      'assets/images/Frame verify.png',
                      height: 56,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Bottom resend
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: _isResending ? null : _onResend,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'PublicSans',
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: "Didn't receive the code? "),
                        TextSpan(
                          text: _isResending ? 'Resending...' : 'Resend',
                          style: TextStyle(
                            color: _isResending
                                ? Colors.grey
                                : const Color(0xFF7367F0),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'PublicSans',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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

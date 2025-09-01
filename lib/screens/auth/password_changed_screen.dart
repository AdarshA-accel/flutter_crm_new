import 'package:flutter/material.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Center Success mark image
            Positioned(
              top: 218,
              left: 156,
              child: Image.asset(
                'assets/images/Successmark.png',
                width: 100,
                height: 100,
              ),
            ),

            Positioned(
              top: 367,
              left: 75,
              child: Image.asset(
                'assets/images/Group 11256.png',
                width: 263,
                height: 86,
              ),
            ),

            Positioned(
              top: 490,
              left: 25,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                  width: 362,
                  height: 56,
                  padding: const EdgeInsets.fromLTRB(92, 17, 92, 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/back_to_login.png'),
                      fit: BoxFit.cover,
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

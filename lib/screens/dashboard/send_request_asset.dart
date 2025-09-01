import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'clock_out_screen.dart';
import 'home_screen.dart';

class SendRequestAssetScreen extends StatelessWidget {
  const SendRequestAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: Stack(
        children: [
          Positioned(
            top: 259,
            left: 151,
            child: Image.asset(
              'assets/images/tick.png', 
              width: 109,
              height: 109,
            ),
          ),

          const Positioned(
            top: 449,
            left: 83,
            child: SizedBox(
              width: 246,
              height: 31,
              child: Text(
                'Asset Request Sent',
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF444050),
                ),
              ),
            ),
          ),

          const Positioned(
            top: 495,
            left: 36,
            right: 36,
            child: Text(
              'The Process of Asset Request was Completed Successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PublicSans',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF6D6976),
              ),
            ),
          ),

          Positioned(
            top: 657,
            left: 22,
            child: GestureDetector(
              onTap: () {
                final clockIn = userProvider.clockInTime;
                final clockOut = userProvider.clockOutTime;

                if (clockIn != null && clockOut == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClockOutScreen(clockInTime: clockIn),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              },
              child: Container(
                width: 368,
                height: 61,
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 114,
                ),
                child: const Center(
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      color: Color(0xFF7367F0),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crm/providers/user_provider.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  static const String routeName = '/holidays';

  void handleBackNavigation(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (provider.clockInTime != null && provider.clockOutTime == null) {
      Navigator.pushReplacementNamed(context, '/clock_out', arguments: {
        'clockInTime': provider.clockInTime,
      });
    } else {
      Navigator.pushReplacementNamed(context, '/home_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 68, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => handleBackNavigation(context),
                  child: Image.asset(
                    'assets/images/back_profile.png',
                    width: 23,
                    height: 23,
                  ),
                ),
                const Text(
                  "Holidays",
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444050),
                  ),
                ),
                const SizedBox(width: 23), // Placeholder for alignment
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  'assets/images/holidays.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

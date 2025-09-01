import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Load saved token & user
    await userProvider.loadToken();
    await userProvider.loadUser();

    // Add splash delay
    await Future.delayed(const Duration(seconds: 2));

    bool valid = false;

    // Validate session if token exists
    if (userProvider.token != null && userProvider.token!.isNotEmpty) {
      valid = await userProvider.authenticateSession();
    }

    if (!mounted) return;

    if (valid) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      await userProvider.logout(); // clear invalid session
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/images/accelgrowth_logo.png'),
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

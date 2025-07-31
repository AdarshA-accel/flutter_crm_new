import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/home_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/password_changed_screen.dart';
import '../screens/dashboard/profile_screen.dart';
import '../screens/dashboard/clock_out_screen.dart';
import '../screens/dashboard/leave_screen.dart';
import '../screens/dashboard/apply_leave_screen.dart';
import '../screens/dashboard/send_leave_request_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case AppRoutes.signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());

      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case AppRoutes.passwordChanged:
        return MaterialPageRoute(builder: (_) => const PasswordChangedScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.leave:
        return MaterialPageRoute(builder: (_) => const LeaveScreen());

      case AppRoutes.applyLeave:
        return MaterialPageRoute(builder: (_) => const ApplyLeaveScreen());

      case AppRoutes.sendLeaveRequest:
        return MaterialPageRoute(builder: (_) => const SendLeaveRequestScreen());  

      case AppRoutes.clockOut:
        final args = settings.arguments as Map<String, dynamic>?;
        final clockInTime = args?['clockInTime'];

        if (clockInTime is DateTime) {
          return MaterialPageRoute(
            builder: (_) => ClockOutScreen(
              clockInTime: clockInTime,
            ),
          );
        } else {
          return _errorRoute("Invalid or missing clockInTime (expected DateTime).");
        }

      default:
        return _errorRoute("No route defined for ${settings.name}");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(message)),
      ),
    );
  }
}

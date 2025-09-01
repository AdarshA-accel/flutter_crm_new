import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _performLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Please enter username and password');
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    final provider = Provider.of<UserProvider>(context, listen: false);
    final position = await _determinePosition();

    debugPrint("Attempting login with username=$username");

    final success = await provider.login(
      username: username,
      password: password,
      ipAddress: "223.181.13.150",
      latitude: position?.latitude ?? 19.1823872,
      longitude: position?.longitude ?? 77.3193728,
      platform: "mobile",
      userAgent:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
    );

    if (!mounted) return;

    if (success) {
      debugPrint("Login success. Token: ${provider.token}");
      final valid = await provider.authenticateSession();
      if (valid) {
        debugPrint("Session verified successfully. User: ${provider.userName}");
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        debugPrint("Session verification failed. Token: ${provider.token}");
        setState(() => _errorText = "Failed to verify session.");
      }
    } else {
      debugPrint("Login failed for $username");
      setState(() => _errorText = "Invalid username or password");
    }

    setState(() => _loading = false);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                    },
                    child: Image.asset('assets/images/back.png',
                        width: 41, height: 41),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/accelgrowth_logo.png',
                    width: 182,
                    height: 42,
                    fit: BoxFit.contain,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 30),
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
                  _buildInputField(
                    controller: _usernameController,
                    hint: "Username",
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(),
                  const SizedBox(height: 8),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorText!,
                        style: const TextStyle(
                          fontFamily: 'PublicSans',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7367F0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 362,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _performLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7367F0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Log In',
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Row(
                    children: [
                      Expanded(
                          child: Divider(color: Color(0xFFDEE1E6), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Or Sign In with',
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6A707C),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Divider(color: Color(0xFFDEE1E6), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton("assets/images/microsoft_signin.png",
                          () => _launchUrl("https://www.microsoft.com")),
                      const SizedBox(width: 24),
                      _socialButton("assets/images/google_signin.png",
                          () => _launchUrl("https://www.google.com")),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      width: 362,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC9C9C9)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFFC9C9C9),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SizedBox(
      width: 362,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC9C9C9)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: StatefulBuilder(
          builder: (context, setStateSB) {
            return TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: const TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFC9C9C9),
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF6D6976),
                  ),
                  onPressed: () {
                    setStateSB(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _socialButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC9C9C9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

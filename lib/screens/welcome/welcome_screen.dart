import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../providers/user_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<List<String>> _imagePaths = [
    ['assets/images/At the office-amico 1.png', 'assets/images/Group 11246.png'],
    ['assets/images/Time management-amico 1.png', 'assets/images/Group 11248.png'],
    ['assets/images/usability testing-rafiki 1.png', 'assets/images/Group 11249.png'],
    ['assets/images/Team work-amico 1.png', 'assets/images/Group 11250.png'],
  ];

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    await provider.loadToken();
    await provider.loadUser();
    if (provider.isLoggedIn) {
      // Already logged in → go straight to home
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _imagePaths.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToLast() {
    _pageController.animateToPage(
      _imagePaths.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.27),
        Image.asset(
          _imagePaths[index][0],
          width: screenWidth * 0.8,
          height: screenWidth * 0.8,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Image.asset(
          _imagePaths[index][1],
          width: screenWidth * 0.7,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -h * 0.15,
              left: -w * 0.1,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFF3F2FF),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/Ellipse 1.png',
                  width: w * 1.05,
                  height: h * 0.35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: h * 0.025,
              left: w * 0.04,
              child: Image.asset(
                'assets/images/accelgrowth_logo.png',
                width: w * 0.7,
                fit: BoxFit.contain,
              ),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) => _buildPage(context, index),
            ),
            if (_currentPage == 0) ...[
              Positioned(
                bottom: h * 0.1,
                left: w * 0.06,
                right: w * 0.06,
                child: GestureDetector(
                  onTap: _nextPage,
                  child: Image.asset(
                    'assets/images/Login (Button).png',
                    width: w * 0.9,
                    height: h * 0.07,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: h * 0.05,
                left: w * 0.43,
                child: GestureDetector(
                  onTap: _skipToLast,
                  child: Image.asset(
                    'assets/images/Login (Button) (1).png',
                    width: w * 0.12,
                    height: h * 0.025,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ] else if (_currentPage == 1 || _currentPage == 2) ...[
              Positioned(
                bottom: h * 0.04,
                left: w * 0.1,
                right: w * 0.1,
                child: GestureDetector(
                  onTap: _nextPage,
                  child: Image.asset(
                    'assets/images/Login (Button) (2).png',
                    width: w * 0.8,
                    height: h * 0.065,
                  ),
                ),
              ),
            ] else if (_currentPage == 3) ...[
              Positioned(
                bottom: h * 0.04,
                left: w * 0.1,
                right: w * 0.1,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: Image.asset(
                    'assets/images/Login (Button) (4).png',
                    width: w * 0.8,
                    height: h * 0.065,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_crm/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasNotification = false;
  int selectedTabIndex = 0;
  late Timer _timer;
  String _currentFormattedTime = DateFormat('hh:mm:ss a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _resetIfNewDay();
    _startLiveClock();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadToken();
      await userProvider.loadUser();
      // also refresh profile from API if token exists
      if (userProvider.isLoggedIn) {
        await userProvider.authenticateSession();
      }
    });
  }

  void _startLiveClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentFormattedTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _resetIfNewDay() {
    final now = DateTime.now();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final clockIn = userProvider.clockInTime;

    if (clockIn != null &&
        (clockIn.day != now.day ||
            clockIn.month != now.month ||
            clockIn.year != now.year)) {
      userProvider.resetClockData();
    }
  }

  Future<void> handleClockIn() async {
    final now = DateTime.now();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Only allow clock in if not already clocked in
    if (userProvider.clockInTime == null) {
      await userProvider.syncClockIn(now);
    }
  }

  Future<void> handleClockOut() async {
    final now = DateTime.now();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Only allow clock out if already clocked in and not yet clocked out
    if (userProvider.clockInTime != null && userProvider.clockOutTime == null) {
      await userProvider.syncClockOut(now);
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('hh:mm a').format(time);
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return '--';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours:$minutes hrs";
  }

  void _onCategoryTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/payslip');
        break;
      case 1:
        Navigator.pushNamed(context, '/news');
        break;
      case 2:
        Navigator.pushNamed(context, '/holidays');
        break;
      case 3:
        Navigator.pushNamed(context, '/leave');
        break;
      case 4:
        Navigator.pushNamed(context, '/request');
        break;
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => selectedTabIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home_screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/leave');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  Future<void> _launchTeams() async {
    const url = 'https://teams.microsoft.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Microsoft Teams')),
      );
    }
  }

  ImageProvider<Object>? _avatarProvider(String path) {
    if (path.isNotEmpty && File(path).existsSync()) {
      return FileImage(File(path));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final clockInTime = userProvider.clockInTime;
    final clockOutTime = userProvider.clockOutTime;
    final workedDuration = userProvider.workedDuration;
    final now = DateTime.now();
    final avatar = _avatarProvider(user?.profileImage ?? "");

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo + notifications
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/accelgrowth_logo.png',
                      width: 200, height: 50),
                  Stack(
                    children: [
                      Image.asset('assets/images/notification_icon.png',
                          width: 20, height: 25),
                      if (hasNotification)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'PublicSans',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFBBB9BF)),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFBBB9BF)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Today Overview
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, top: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Today Overview',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'PublicSans',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF444050))),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/Today_overview'),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'PublicSans',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7367F0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _launchTeams,
                    child: Image.asset('assets/images/morning_scrum.png',
                        width: 368, height: 74, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Clock In/Out card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat('EEEE').format(now)}\n${clockOutTime != null ? formatDuration(workedDuration) : ''}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'PublicSans',
                            color: Color(0xFF6D6976)),
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: avatar,
                            child: avatar == null
                                ? const Icon(Icons.person,
                                    size: 50, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(user?.fullName ?? "Your Name"),
                        ],
                      ),
                      Text(
                        '${DateFormat('dd MMMM').format(now)}\n${DateFormat('yyyy').format(now)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'PublicSans',
                            color: Color(0xFF6D6976)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('Clock In',
                              style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6D6976))),
                          const SizedBox(height: 4),
                          Text(formatTime(clockInTime),
                              style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF12D419))),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 4),
                          Text(_currentFormattedTime,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF444050))),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Clock Out',
                              style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6D6976))),
                          const SizedBox(height: 4),
                          Text(formatTime(clockOutTime),
                              style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF1511B))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Swipe to Clock In / Clock Out
            GestureDetector(
              onHorizontalDragEnd: (_) {
                if (clockInTime == null) {
                  handleClockIn();
                } else if (clockOutTime == null) {
                  handleClockOut();
                }
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF7367F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/arrow_.png', width: 40),
                    const SizedBox(width: 8),
                    Text(
                      clockInTime == null
                          ? 'Swipe to Clock In'
                          : (clockOutTime == null
                              ? 'Swipe to Clock Out'
                              : 'Completed'),
                      style: const TextStyle(
                          fontFamily: 'PublicSans',
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/category_group.png',
                    width: 368,
                    height: 125,
                  ),
                  Positioned.fill(
                    child: Row(
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onCategoryTap(index),
                            child: Container(color: Colors.transparent),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 88,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/bottom_nav_group.png',
                    width: double.infinity,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Row(
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onBottomNavTap(index),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

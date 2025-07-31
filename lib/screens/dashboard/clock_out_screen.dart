import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_crm/providers/user_provider.dart';

class ClockOutScreen extends StatefulWidget {
  final DateTime clockInTime;

  const ClockOutScreen({required this.clockInTime, super.key});

  @override
  _ClockOutScreenState createState() => _ClockOutScreenState();
}

class _ClockOutScreenState extends State<ClockOutScreen> {
  late DateTime clockInDateTime;
  late Duration elapsed = Duration.zero;
  Timer? _timer;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    clockInDateTime = widget.clockInTime;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsed = DateTime.now().difference(clockInDateTime);
      });
    });
  }

  void _handleClockOut() {
    final clockOutTime = DateTime.now();
    final durationWorked = clockOutTime.difference(clockInDateTime);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setClockOutTime(clockOutTime);

    Navigator.pop(context, {
      'clockOutTime': clockOutTime,
      'workedDuration': durationWorked,
    });
  }

  String _formattedWorkedDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(elapsed.inHours);
    final minutes = twoDigits(elapsed.inMinutes.remainder(60));
    return '$hours:$minutes hrs';
  }

  String get _currentFormattedTime => DateFormat('hh:mm:ss a').format(DateTime.now());

  bool get hasNotification => false;

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
    final provider = Provider.of<UserProvider>(context, listen: false);
    switch (index) {
      case 0:
        if (provider.clockInTime != null && provider.clockOutTime == null) {
          Navigator.pushReplacementNamed(context, '/clock_out', arguments: {
            'clockInTime': provider.clockInTime,
          });
        } else {
          Navigator.pushReplacementNamed(context, '/home_screen');
        }
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final avatar = _avatarProvider(user.profileImagePath);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/accelgrowth_logo.png', width: 200, height: 50),
                  Stack(
                    children: [
                      Image.asset('assets/images/notification_icon.png', width: 20, height: 25),
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

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: const TextStyle(fontSize: 16, color: Color(0xFFB1B1B1)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Overview
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, top: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today Overview',
                        style: TextStyle(fontSize: 18, fontFamily: 'PublicSans', fontWeight: FontWeight.w600, color: Color(0xFF444050)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/Today_overview'),
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
                    child: Image.asset('assets/images/morning_scrum.png', width: 368, height: 74, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Expanded Body
            Expanded(
              child: Column(
                children: [
                  // Clock Container
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
                        // Clock Details Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateFormat('EEEE').format(DateTime.now())}\n${_formattedWorkedDuration()}',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF6D6976)),
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: avatar,
                            child: avatar == null
                                ? const Icon(Icons.person, size: 50, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(user.name),
                              ],
                            ),
                            Text(
                              '${DateFormat('dd MMMM').format(DateTime.now())}\n${DateFormat('yyyy').format(DateTime.now())}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14, fontFamily: 'PublicSans', color: Color(0xFF6D6976)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Clock In/Out Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Clock In', style: TextStyle(fontFamily: 'PublicSans', fontWeight: FontWeight.w500, color: Color(0xFF6D6976))),
                                const SizedBox(height: 4),
                                Text(DateFormat('hh:mm a').format(clockInDateTime), style: const TextStyle(fontFamily: 'PublicSans', fontWeight: FontWeight.w700, color: Color(0xFF12D419))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 4),
                                Text(_currentFormattedTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF444050))),
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Clock Out', style: TextStyle(fontFamily: 'PublicSans', fontWeight: FontWeight.w500, color: Color(0xFF6D6976))),
                                SizedBox(height: 4),
                                Text('--:--', style: TextStyle(color: Color(0xFFF1511B))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Swipe to Clock Out
                  GestureDetector(
                    onHorizontalDragEnd: (_) => _handleClockOut(),
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
                          const Text(
                            'Swipe to Clock Out',
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Icons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        Image.asset('assets/images/category_group.png', width: 368, height: 125),
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
                ],
              ),
            ),

            // Bottom Nav
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
                            child: Container(color: Colors.transparent),
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

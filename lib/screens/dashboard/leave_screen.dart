import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter_crm/providers/user_provider.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  int selectedTabIndex = 1;

  void _handleBackNavigation() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (provider.clockInTime != null && provider.clockOutTime == null) {
      Navigator.pushReplacementNamed(context, '/clock_out', arguments: {
        'clockInTime': provider.clockInTime,
      });
    } else {
      Navigator.pushReplacementNamed(context, '/home_screen');
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
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    int totalLeaves = 12;
    int takenLeaves = 0;
    double availablePercent = (1 - (takenLeaves / totalLeaves)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _handleBackNavigation,
                          child: Image.asset(
                            'assets/images/back_profile.png',
                            width: 23,
                            height: 23,
                          ),
                        ),
                        const Text(
                          "Leave",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF444050),
                          ),
                        ),
                        const SizedBox(width: 23),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Leave Balances',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'PublicSans',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444050),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/leave_balances'),
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
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    height: 179,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Paid Leave",
                                style: TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF444050),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Leaves taken = ${takenLeaves.toString().padLeft(2, '0')}\nTotal Leaves = $totalLeaves",
                                style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6D6976),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: LeaveBalanceGraph(percentage: availablePercent * 100),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/apply_leave');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 61,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7367F0),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Apply Leave',
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Leave History',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF444050),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 100,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'No leave history yet.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PublicSans',
                        color: Color(0xFF6D6976),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 88,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/bottom_nav_group_leave.png',
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
    );
  }
}

class LeaveBalanceGraph extends StatelessWidget {
  final double percentage;
  final double size;

  const LeaveBalanceGraph({super.key, required this.percentage, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlockCircularPainter(
        percentage: percentage,
        color: const Color(0xFF7367F0),
      ),
      size: Size(size, size),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Available",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              "${percentage.toInt()}%",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF444050)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockCircularPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _BlockCircularPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    const int totalBlocks = 60;
    final double filledBlocks = (percentage / 100 * totalBlocks).ceilToDouble();

    for (int i = 0; i < totalBlocks; i++) {
      double angle = 2 * pi * (i / totalBlocks);
      final double opacity = i < filledBlocks
          ? 1.0
          : 0.15 + (0.85 * (1 - ((i - filledBlocks) / (totalBlocks - filledBlocks)).clamp(0.0, 1.0)));

      final Paint paint = Paint()
        ..color = color.withOpacity(opacity)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      final double innerRadius = radius - 10;
      final double outerRadius = radius - 2;

      final Offset start = Offset(
        center.dx + innerRadius * cos(angle),
        center.dy + innerRadius * sin(angle),
      );

      final Offset end = Offset(
        center.dx + outerRadius * cos(angle),
        center.dy + outerRadius * sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

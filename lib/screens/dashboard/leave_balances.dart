import 'package:flutter/material.dart';
import 'dart:math';

class LeaveBalancesScreen extends StatelessWidget {
  const LeaveBalancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveData = [
      {'type': 'Paid Leave', 'total': 12, 'taken': 0, 'color': const Color(0xFF7367F0)},
      {'type': 'Sick Leave', 'total': 8, 'taken': 0, 'color': const Color(0xFF00CFE8)},
      {'type': 'Casual Leave', 'total': 5, 'taken': 0, 'color': const Color(0xFFFF9B34)},
      {'type': 'Medical Leave', 'total': 12, 'taken': 0, 'color': const Color(0xFFE290FF)},
      {'type': 'Paternity Leave', 'total': 15, 'taken': 0, 'color': const Color(0xFF00CFE8)},
      {'type': 'Bereavement Leave', 'total': 5, 'taken': 0, 'color': const Color.fromARGB(255, 234, 7, 7)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F5F8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Leave Balances',
          style: TextStyle(
            fontFamily: 'PublicSans',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xFF444050),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFC9C9C9), size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: leaveData.length,
          itemBuilder: (context, index) {
            final data = leaveData[index];
            final type = data['type'] as String;
            final total = data['total'] as int;
            final taken = data['taken'] as int;
            final color = data['color'] as Color;
            final availablePercent = (1 - (taken / total)).clamp(0.0, 1.0);

            return Container(
              width: 368,
              height: 179,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
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
                        Text(
                          type,
                          style: const TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444050),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Leaves taken = ${taken.toString().padLeft(2, '0')}\nTotal Leaves = $total",
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
                    child: LeaveBalanceGraph(
                      percentage: availablePercent * 100,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LeaveBalanceGraph extends StatelessWidget {
  final double percentage;
  final double size;
  final Color color;

  const LeaveBalanceGraph({
    super.key,
    required this.percentage,
    this.size = 100,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlockCircularPainter(
        percentage: percentage,
        color: color,
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444050),
              ),
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

  _BlockCircularPainter({
    required this.percentage,
    required this.color,
  });

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
          : 0.15 +
              (0.85 *
                  (1 - ((i - filledBlocks) / (totalBlocks - filledBlocks))
                      .clamp(0.0, 1.0)));

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

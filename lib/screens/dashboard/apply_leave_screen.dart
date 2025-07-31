import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _leaveType;
  final TextEditingController _descriptionController = TextEditingController();

  List<String> leaveTypes = [
    'Paid Leave',
    'Sick /Casual Leave',
    'Paternity Leave',
    'Bereavement Leave',
    'Floater Leave',
    'Special Leave',
    'Comp Offs',
    'Unpaid Leave',
  ];

  int get leaveDays {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  void _showCalendarPicker(bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7367F0),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _showLeaveTypeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Leave Type",
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFFC9C9C9),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: leaveTypes.map((type) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _leaveType = type;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F0FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF7367F0),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Apply Leave',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF444050),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle("Start Date"),
                  _buildDateField(_startDate, () => _showCalendarPicker(true)),
                  const SizedBox(height: 16),

                  _buildSectionTitle("End Date"),
                  _buildDateField(_endDate, () => _showCalendarPicker(false)),
                  const SizedBox(height: 16),

                  _buildSectionTitle("Leave Type"),
                  GestureDetector(
                    onTap: _showLeaveTypeSelector,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _leaveType ?? "Select Leave Type",
                            style: const TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC9C9C9),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle("Description"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Write a reason",
                        hintStyle: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 14,
                          color: Color(0xFFC9C9C9),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F0FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Leave Time",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6D6976),
                          ),
                        ),
                        Text(
                          leaveDays == 0
                              ? "--"
                              : "$leaveDays ${leaveDays == 1 ? 'Day' : 'Days'}",
                          style: const TextStyle(
                            fontFamily: 'PublicSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7367F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/send_leave_request');
                      },
                      child: const Text(
                        "SEND REQUEST",
                        style: TextStyle(
                          fontFamily: 'PublicSans',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Back Icon (Top Right)
            Positioned(
              top: 24,
              left: 343,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 51,
                  height: 51,
                  child: Icon(
                    Icons.close,
                    size: 28,
                    color: Color(0xFFC9C9C9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'PublicSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF444050),
      ),
    );
  }

  Widget _buildDateField(DateTime? date, VoidCallback onTap) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.only(left: 12, right: 50),
            alignment: Alignment.centerLeft,
            child: Text(
              date != null ? DateFormat('dd-MM-yyyy').format(date) : "DD-MM-YYYY",
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey,
                fontFamily: 'PublicSans',
                fontSize: 16,
              ),
            ),
          ),
        ),
        Positioned(
          top: 13,
          left: 310,
          child: GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 24,
              color: Color(0xFF7367F0),
            ),
          ),
        ),
      ],
    );
  }
}

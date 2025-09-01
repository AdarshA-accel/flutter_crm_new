import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crm/providers/user_provider.dart';

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

  Map<String, int> leaveTypes = {
    'Paid Leave': 3,
    'Sick /Casual Leave': 3,
    'Paternity Leave': 21,
    'Bereavement Leave': 7,
    'Floater Leave': 0,
    'Special Leave': 1,
    'Comp Offs': 0,
    'Unpaid Leave': 9999,
  };

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

  void _showLeaveTypeBottomSheet() {
    final types = leaveTypes.keys.toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 320,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Leave Type',
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF444050),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: types.map((key) {
                      final count = leaveTypes[key]!;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _leaveType = key;
                            if (count > 0 && count < 9999) {
                              leaveTypes[key] = count - 1;
                            }
                          });
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9E7FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  count == 9999
                                      ? '∞'
                                      : count.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                    color: Color(0xFF7367F0),
                                    fontFamily: 'PublicSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              key,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'PublicSans',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF444050),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitLeaveRequest() async {
    if (_startDate == null ||
        _endDate == null ||
        _leaveType == null ||
        leaveDays <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final provider = Provider.of<UserProvider>(context, listen: false);

    // ✅ Ensure token is loaded before calling API
    await provider.loadToken();

    if (provider.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session expired. Please log in again.")),
      );
      return;
    }

    final result = await provider.applyLeave(
      startDate: _startDate!,
      endDate: _endDate!,
      type: _leaveType!,
      reason: _descriptionController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"])),
    );

    if (result["success"]) {
      Navigator.pop(context, true);
    }
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
              date != null
                  ? DateFormat('dd-MM-yyyy').format(date)
                  : "DD-MM-YYYY",
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
          right: 12,
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
                    onTap: _showLeaveTypeBottomSheet,
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
                            style: TextStyle(
                              fontFamily: 'PublicSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _leaveType == null
                                  ? const Color(0xFFC9C9C9)
                                  : const Color(0xFF444050),
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
                      onPressed: _submitLeaveRequest,
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
            Positioned(
              top: 24,
              right: 16,
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crm/providers/user_provider.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  String? selectedMonth;
  String? selectedYear;
  String? selectedDownloadOption = '3';

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> years =
      List.generate(10, (index) => '${DateTime.now().year - index}');

  List<String> paySlipMonths = [];

  @override
  void initState() {
    super.initState();
    _generateInitialPaySlips();
  }

  void _generateInitialPaySlips() {
    final now = DateTime.now();
    List<String> generated = [];

    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month - i);
      generated.add("${months[date.month - 1]} ${date.year}");
    }

    setState(() {
      paySlipMonths = generated;
    });
  }

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

  void _filterPaySlips() {
    List<String> filtered = [];

    for (int year = DateTime.now().year; year >= DateTime.now().year - 10; year--) {
      for (int m = 12; m >= 1; m--) {
        final date = DateTime(year, m);
        final formatted = "${months[date.month - 1]} ${date.year}";

        if (selectedYear != null && selectedMonth != null) {
          if (date.year.toString() == selectedYear &&
              months[date.month - 1] == selectedMonth) {
            filtered.add(formatted);
          }
        } else if (selectedYear != null) {
          if (date.year.toString() == selectedYear) {
            filtered.add(formatted);
          }
        }
      }
    }

    setState(() {
      paySlipMonths = filtered;
    });
  }

  void _showDownloadConfirmation(String period) {
    String label = {
      '3': 'Last 3 Months Pay Slip',
      '6': 'Last 6 Months Pay Slip',
      '12': 'Last One Year Pay Slip',
    }[period]!;

    String message = 'Do you want to download ${label.toLowerCase()}?';
    String fontFamily = 'PublicSans';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Download $label',
                style: const TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444050),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: 'PublicSans',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF6D6976),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7367F0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Download',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

void _showDownloadOverlay() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xFFF6F5F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: StatefulBuilder(
          builder: (context, setInnerState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Download Pay Slip',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFF444050),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFFC9C9C9)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildOptionTile(context, setInnerState, '3', 'Last 3 Months Pay Slip'),
                const SizedBox(height: 12),
                _buildOptionTile(context, setInnerState, '6', 'Last 6 Months Pay Slip'),
                const SizedBox(height: 12),
                _buildOptionTile(context, setInnerState, '12', 'Last One Year Pay Slip'),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 150), () {
                        _showDownloadConfirmation(selectedDownloadOption ?? '3');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7367F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildOptionTile(BuildContext context, void Function(void Function()) setInnerState, String value, String label) {
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedDownloadOption = value;
      });
      setInnerState(() {}); // updates dialog UI
    },
    child: Container(
      height: 68,
      width: 368,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, // No highlight background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Image(
            image: AssetImage('assets/images/receipt.png'),
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'PublicSans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444050),
              ),
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedDownloadOption == value
                    ? const Color(0xFF7367F0)
                    : const Color(0xFFB8B8B8),
                width: 2,
              ),
            ),
            child: selectedDownloadOption == value
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7367F0),
                      ),
                    ),
                  )
                : null,
          )
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 68, 16, 16),
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
                      "Pay Slips",
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF444050),
                      ),
                    ),
                    const SizedBox(width: 23),
                  ],
                ),
              ),

              // Month & Year Dropdowns
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Select Month",
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFC9C9C9),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'PublicSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF444050),
                            ),
                            value: selectedMonth,
                            isExpanded: true,
                            onChanged: (val) {
                              setState(() => selectedMonth = val);
                              _filterPaySlips();
                            },
                            items: months.map((month) {
                              return DropdownMenuItem<String>(
                                value: month,
                                child: Text(month),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Select Year",
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFC9C9C9),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'PublicSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF444050),
                            ),
                            value: selectedYear,
                            isExpanded: true,
                            onChanged: (val) {
                              setState(() => selectedYear = val);
                              _filterPaySlips();
                            },
                            items: years.map((year) {
                              return DropdownMenuItem<String>(
                                value: year,
                                child: Text(year),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent Pay Slips",
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF444050),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Scrollable List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemCount: paySlipMonths.length,
                  itemBuilder: (context, index) {
                    final monthText = paySlipMonths[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/payslip_detail', arguments: {
                          'month': monthText,
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 68,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/images/receipt.png'),
                              width: 36,
                              height: 36,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                monthText,
                                style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF444050),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 24, 
                              color: Color(0xFFC9C9C9),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Floating download button
          Positioned(
            right: 20,
            bottom: 30,
            child: GestureDetector(
              onTap: _showDownloadOverlay,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7367F0),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage('assets/images/download.png'),
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

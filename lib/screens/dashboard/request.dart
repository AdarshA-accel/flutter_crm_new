import 'package:flutter/material.dart';
import 'send_request_asset.dart';

class RequestAssetScreen extends StatefulWidget {
  const RequestAssetScreen({super.key});

  @override
  State<RequestAssetScreen> createState() => _RequestAssetScreenState();
}

class _RequestAssetScreenState extends State<RequestAssetScreen> {
  String requestType = 'new';

  final TextEditingController assetNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _navigateToSendRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SendRequestAssetScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F5F8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Request Asset',
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Asset',
              style: TextStyle(
                fontFamily: 'PublicSans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444050),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.close, color: Color(0xFFF1511B)),
                  SizedBox(width: 12),
                  Text(
                    'No Asset Assigned Yet',
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF6D6976),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Asset Name',
              style: TextStyle(
                fontFamily: 'PublicSans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444050),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: assetNameController,
              decoration: InputDecoration(
                hintText: 'Enter Asset Name',
                hintStyle: const TextStyle(color: Color(0xFFC9C9C9),fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'PublicSans'),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontFamily: 'PublicSans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444050),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write a reason',
                hintStyle: const TextStyle(color: Color(0xFFC9C9C9),fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'PublicSans'),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildRadio('new', 'New Request', fontstyle: const TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 14,
              color: Color(0xFF444050),
            )),
            const SizedBox(height: 12),
            _buildRadio('replacement', 'Replacement Request', fontstyle: const TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 14,
              color: Color(0xFF444050),
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _navigateToSendRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7367F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SEND REQUEST',
                  style: TextStyle(
                    fontFamily: 'PublicSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String value, String label, {required TextStyle fontstyle}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          requestType = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: requestType == value ? const Color(0xFF7367F0) : const Color(0xFFB8B8B8),
                width: 2,
              ),
            ),
            child: requestType == value
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
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 14,
              color: Color(0xFF444050),
            ),
          ),
        ],
      ),
    );
  }
}

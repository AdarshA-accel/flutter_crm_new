import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crm/providers/user_provider.dart';
import 'package:flutter_crm/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  int selectedTabIndex = 3;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });

      final provider = Provider.of<UserProvider>(context, listen: false);
      final existing = provider.user;
      if (existing != null) {
        final updatedUser = existing.toJson();
        updatedUser["profileImage"] = picked.path;
        provider.updateUserFromMap(updatedUser);
      }
    }
  }

  void _openEditSheet() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    final user = provider.user;

    _nameController.text = user?.fullName ?? "";
    _designationController.text = user?.designation ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444050),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _designationController,
                decoration: const InputDecoration(
                  labelText: 'Designation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7367F0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    _saveProfile(
                      name: _nameController.text.trim(),
                      designation: _designationController.text.trim(),
                    );
                    Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile({required String name, required String designation}) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    final existing = provider.user;

    if (existing != null) {
      final updatedUser = existing.toJson();

      // split full name into first/last if possible
      final parts = name.split(" ");
      if (parts.isNotEmpty) {
        updatedUser["firstName"] = parts.first;
        updatedUser["lastName"] =
            parts.length > 1 ? parts.sublist(1).join(" ") : existing.lastName;
      }

      updatedUser["designation"] =
          designation.isNotEmpty ? designation : existing.designation;
      updatedUser["profileImage"] = _pickedImage?.path ?? existing.profileImage;

      provider.updateUserFromMap(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }

  void _handleLogout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final UserModel? user = provider.user;

    final imageProvider = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (user != null &&
                user.profileImage.isNotEmpty &&
                File(user.profileImage).existsSync()
            ? FileImage(File(user.profileImage))
            : null);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/home_screen'),
                          child: Image.asset(
                            'assets/images/back_profile.png',
                            width: 23,
                            height: 23,
                          ),
                        ),
                        const Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF444050)),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Image.asset(
                                  'assets/images/resign.png',
                                  width: 109,
                                  height: 49,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/3dot.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile image + name + designation
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: imageProvider,
                          child: imageProvider == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: _openEditSheet,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? "Unknown User",
                                style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF444050),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.designation.isNotEmpty == true
                                    ? user!.designation
                                    : "No Designation",
                                style: const TextStyle(
                                  fontFamily: 'PublicSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6D6976),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ACCOUNT SECTION
                  _buildSectionTitle("ACCOUNT"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        _buildImageIcon('assets/images/personal.png', '/personal'),
                        const SizedBox(height: 10),
                        _buildImageIcon('assets/images/education.png', '/education'),
                        const SizedBox(height: 10),
                        _buildImageIcon('assets/images/job.png', '/jobDetails'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SETTINGS SECTION
                  _buildSectionTitle("SETTINGS"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        _buildImageIcon('assets/images/privacy.png', '/privacy'),
                        const SizedBox(height: 10),
                        _buildImageIcon('assets/images/feedback.png', '/feedback'),
                        const SizedBox(height: 10),
                        _buildImageIcon('assets/images/logout.png', '',
                            onTap: _handleLogout),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM NAVIGATION BAR
          SizedBox(
            height: 88,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/bottom_nav_group_profile.png',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PublicSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF444050),
        ),
      ),
    );
  }

  Widget _buildImageIcon(String imagePath, String route,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pushNamed(context, route),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: 350,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

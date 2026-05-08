import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs =
    await SharedPreferences.getInstance();

    _nameController.text =
        prefs.getString('user_name') ?? 'Alif';

    _emailController.text =
        prefs.getString('user_email') ??
            'alif@example.com';

    setState(() {});
  }

  Future<void> _saveProfile() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'user_name',
      _nameController.text.trim(),
    );

    await prefs.setString(
      'user_email',
      _emailController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated'),
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle: GoogleFonts.dmSans(
        color: AppTheme.textMuted,
        fontSize: 14,
      ),

      filled: true,
      fillColor: AppTheme.cardBg,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.border,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,

        title: Text(
          'Edit Profile',
          style: GoogleFonts.dmSans(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 10),

            Center(
              child: Container(
                width: 100,
                height: 100,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primary,
                      AppTheme.accent,
                    ],
                  ),
                ),

                child: Center(
                  child: Text(
                    _nameController.text.isEmpty
                        ? 'A'
                        : _nameController.text[0]
                        .toUpperCase(),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Full Name',
              style: GoogleFonts.dmSans(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _nameController,

              style: GoogleFonts.dmSans(
                color: AppTheme.textPrimary,
              ),

              decoration:
              _inputDecoration('Enter your name'),
            ),

            const SizedBox(height: 20),

            Text(
              'Email',
              style: GoogleFonts.dmSans(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _emailController,

              style: GoogleFonts.dmSans(
                color: AppTheme.textPrimary,
              ),

              decoration:
              _inputDecoration('Enter your email'),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: _saveProfile,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppTheme.primary,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),

                child: Text(
                  'Save Changes',

                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
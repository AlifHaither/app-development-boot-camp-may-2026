import 'package:app_development_boot_camp_may_2026/screens/profile/currency_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_theme.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Alif';
  String userEmail = 'alif@example.com';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs =
    await SharedPreferences.getInstance();

    setState(() {
      userName =
          prefs.getString('user_name') ?? 'Alif';

      userEmail =
          prefs.getString('user_email') ??
              'alif@example.com';
    });
  }

  Widget _buildTile({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color: AppTheme.cardBg,

          borderRadius:
          BorderRadius.circular(16),

          border:
          Border.all(color: AppTheme.border),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.textSecondary,
              size: 20,
            ),

            const SizedBox(width: 14),

            Text(
              title,
              style: GoogleFonts.dmSans(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                'Profile',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 30),

              // Avatar
              Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primary,
                      AppTheme.accent,
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary
                          .withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),

                child: Center(
                  child: Text(
                    userName[0].toUpperCase(),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                userName,
                style: GoogleFonts.dmSans(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              Text(
                userEmail,
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 32),

              // Settings
              _buildTile(
                title: 'Profile Settings',
                icon: Icons.person_outline,

                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const EditProfileScreen(),
                    ),
                  );

                  _loadProfile();
                },
              ),

              _buildTile(
                title: 'Currency',
                icon:
                Icons.currency_exchange_outlined,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const CurrencyScreen(),
                    ),
                  );
                },
              ),

              _buildTile(
                title: 'Budget Limit',
                icon:
                Icons.account_balance_wallet_outlined,
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 10),

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.dark_mode_outlined,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),

                    const SizedBox(width: 14),

                    Text(
                      'Dark Mode',
                      style: GoogleFonts.dmSans(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Spacer(),

                    Switch(
                      value:
                      Theme.of(context).brightness ==
                          Brightness.dark,

                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),

              _buildTile(
                title: 'Logout',
                icon: Icons.logout,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
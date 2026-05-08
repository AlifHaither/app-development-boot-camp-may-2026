import 'package:app_development_boot_camp_may_2026/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() =>
      _CurrencyScreenState();
}

class _CurrencyScreenState
    extends State<CurrencyScreen> {
  String selectedCurrency = '৳ BDT';

  final List<String> currencies = [
    '৳ BDT',
    '\$ USD',
    '€ EUR',
    '₹ INR',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs =
    await SharedPreferences.getInstance();

    setState(() {
      selectedCurrency =
          prefs.getString('currency') ??
              '৳ BDT';
    });
  }

  Future<void> _saveCurrency(
      String currency) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'currency',
      currency,
    );

    setState(() {
      selectedCurrency = currency;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Currency Updated'),
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
          'Currency',
          style: GoogleFonts.dmSans(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),

        itemCount: currencies.length,

        itemBuilder: (_, index) {
          final currency = currencies[index];

          final selected =
              selectedCurrency == currency;

          return GestureDetector(
            onTap: () {
              _saveCurrency(currency);
            },

            child: Container(
              margin:
              const EdgeInsets.only(bottom: 12),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              decoration: BoxDecoration(
                color: AppTheme.cardBg,

                borderRadius:
                BorderRadius.circular(16),

                border: Border.all(
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.border,
                  width: selected ? 1.5 : 1,
                ),
              ),

              child: Row(
                children: [
                  Text(
                    currency,
                    style: GoogleFonts.dmSans(
                      color:
                      AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  if (selected)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../models/transaction.dart';
import '../../models/transaction_tile.dart';
import '../../providers/transaction_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';

  final TextEditingController _searchController =
  TextEditingController();

  String searchQuery = '';

  final List<String> _filters = [
    'All',
    'Income',
    'Expense',
  ];

  String _formatGroupKey(DateTime date) {
    final now = DateTime.now();

    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Today';

    if (diff == 1) return 'Yesterday';

    if (diff < 7) return 'This Week';

    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    List<Transaction> filtered;

    switch (_selectedFilter) {
      case 'Income':
        filtered = provider.transactions
            .where((t) => t.type == TransactionType.income)
            .toList();
        break;

      case 'Expense':
        filtered = provider.transactions
            .where((t) => t.type == TransactionType.expense)
            .toList();
        break;

      default:
        filtered = provider.transactions;
    }

    final grouped = <String, List<Transaction>>{};

    for (final t in filtered) {
      final key = _formatGroupKey(t.date);

      grouped.putIfAbsent(key, () => []).add(t);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All your transactions',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,

                      borderRadius:
                      BorderRadius.circular(14),

                      border:
                      Border.all(color: AppTheme.border),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppTheme.textMuted,
                          size: 20,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: TextField(
                            controller: _searchController,

                            onChanged: (value) {
                              setState(() {
                                searchQuery =
                                    value.toLowerCase();
                              });
                            },

                            style: GoogleFonts.dmSans(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                            ),

                            decoration: InputDecoration(
                              hintText:
                              'Search transactions...',

                              hintStyle: GoogleFonts.dmSans(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),

                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Filter chips
                  Row(
                    children: _filters.map((f) {
                      final selected =
                          _selectedFilter == f;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = f;
                          });
                        },
                        child: AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 200),
                          margin:
                          const EdgeInsets.only(right: 10),
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.cardBg,
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.border,
                            ),
                          ),
                          child: Text(
                            f,
                            style: GoogleFonts.dmSans(
                              color: selected
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 6),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.dmSans(
                                color:
                                AppTheme.textSecondary,
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppTheme.border,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ...entry.value.map(
                            (t) => TransactionTile(
                          transaction: t,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
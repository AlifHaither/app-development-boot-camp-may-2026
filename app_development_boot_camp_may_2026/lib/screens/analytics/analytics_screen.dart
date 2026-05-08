import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../constants/app_theme.dart'; // তোমার project এর path

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _touchedIndex = -1;

  final List<Color> _pieColors = [
    AppTheme.primary,
    AppTheme.accent,
    AppTheme.expense,
    const Color(0xFFFFB347),
    const Color(0xFF87CEEB),
    const Color(0xFFDDA0DD),
  ];

  // Last 7 days label (Mon, Tue ...)
  List<String> get _lastSevenDayLabels {
    final now = DateTime.now();
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return List.generate(
      7,
          (i) => labels[now.subtract(Duration(days: 6 - i)).weekday - 1],
    );
  }

  // Real bar data from provider transactions (last 7 days)
  List<BarChartGroupData> _buildBarGroups(TransactionProvider provider) {
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return List.generate(7, (i) {
      final day = days[i];

      final expense = provider.transactions
          .where((t) =>
      t.type == TransactionType.expense &&
          t.date.day == day.day &&
          t.date.month == day.month &&
          t.date.year == day.year)
          .fold(0.0, (sum, t) => sum + t.amount);

      final income = provider.transactions
          .where((t) =>
      t.type == TransactionType.income &&
          t.date.day == day.day &&
          t.date.month == day.month &&
          t.date.year == day.year)
          .fold(0.0, (sum, t) => sum + t.amount);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: expense,
            color: AppTheme.expense.withOpacity(0.85),
            width: 10,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: income,
            color: AppTheme.income.withOpacity(0.85),
            width: 10,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // ── Consumer: provider change হলে পুরো screen rebuild হবে ──────────────
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        // Live data from provider
        final breakdown = provider.categoryBreakdown;
        final total = breakdown.values.fold(0.0, (a, b) => a + b);
        final entries = breakdown.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)); // highest first

        final barGroups = _buildBarGroups(provider);
        final maxBarY = barGroups
            .expand((g) => g.barRods.map((r) => r.toY))
            .fold(0.0, (a, b) => a > b ? a : b);

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Header ─────────────────────────────────────────────────
                  Text(
                    'Analytics',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your spending insights',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Summary chips — live from provider ─────────────────────
                  Row(
                    children: [
                      _SummaryChip(
                        label: 'Income',
                        value: '\৳${provider.totalIncome.toStringAsFixed(0)}',
                        color: AppTheme.income,
                      ),
                      const SizedBox(width: 12),
                      _SummaryChip(
                        label: 'Expenses',
                        value: '\৳${provider.totalExpense.toStringAsFixed(0)}',
                        color: AppTheme.expense,
                      ),
                      const SizedBox(width: 12),
                      _SummaryChip(
                        label: 'Saved',
                        value: '\৳${provider.totalBalance.toStringAsFixed(0)}',
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Weekly Bar Chart — real transaction data ────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Overview',
                          style: GoogleFonts.dmSans(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Last 7 days' activity",
                          style: GoogleFonts.dmSans(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 180,
                          child: maxBarY == 0
                          // No data yet
                              ? Center(
                            child: Text(
                              'No activity in last 7 days',
                              style: GoogleFonts.dmSans(
                                  color: AppTheme.textMuted),
                            ),
                          )
                              : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxBarY * 1.3,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '\$${rod.toY.toStringAsFixed(0)}',
                                      GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        _lastSevenDayLabels[
                                        value.toInt()],
                                        style: GoogleFonts.dmSans(
                                          color: AppTheme.textSecondary,
                                          fontSize: 11,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                    sideTitles:
                                    SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles:
                                    SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles:
                                    SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (_) => FlLine(
                                  color: AppTheme.border,
                                  strokeWidth: 1,
                                ),
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: barGroups,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _LegendDot(
                                color: AppTheme.expense, label: 'Expenses'),
                            const SizedBox(width: 16),
                            _LegendDot(
                                color: AppTheme.income, label: 'Income'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Pie Chart — live category breakdown ────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spending by Category',
                          style: GoogleFonts.dmSans(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        entries.isEmpty
                            ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No expense data yet.\nAdd an expense to see breakdown.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                  color: AppTheme.textMuted,
                                  fontSize: 13),
                            ),
                          ),
                        )
                            : Row(
                          children: [
                            SizedBox(
                              height: 180,
                              width: 180,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                            .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse
                                                .touchedSection ==
                                                null) {
                                          _touchedIndex = -1;
                                          return;
                                        }
                                        _touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  sections:
                                  List.generate(entries.length, (i) {
                                    final isTouched = i == _touchedIndex;
                                    final pct =
                                        entries[i].value / total * 100;
                                    return PieChartSectionData(
                                      color: _pieColors[
                                      i % _pieColors.length],
                                      value: entries[i].value,
                                      title:
                                      '${pct.toStringAsFixed(0)}%',
                                      radius: isTouched ? 75 : 60,
                                      titleStyle: GoogleFonts.dmSans(
                                        fontSize: isTouched ? 14 : 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: List.generate(entries.length,
                                        (i) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: _pieColors[
                                                i % _pieColors.length],
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                entries[i].key,
                                                style: GoogleFonts.dmSans(
                                                  color:
                                                  AppTheme.textSecondary,
                                                  fontSize: 12,
                                                ),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '\$${entries[i].value.toStringAsFixed(0)}',
                                              style: GoogleFonts.dmSans(
                                                color: AppTheme.textPrimary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Top categories progress bars — live ────────────────────
                  if (entries.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Categories',
                            style: GoogleFonts.dmSans(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(entries.length.clamp(0, 5), (i) {
                            final pct = entries[i].value / total;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entries[i].key,
                                        style: GoogleFonts.dmSans(
                                          color: AppTheme.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '\৳${entries[i].value.toStringAsFixed(2)}',
                                        style: GoogleFonts.dmSans(
                                          color: AppTheme.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 6,
                                      backgroundColor: AppTheme.progressBg,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _pieColors[i % _pieColors.length],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }, // Consumer builder end
    ); // Consumer end
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.dmSans(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style:
          GoogleFonts.dmSans(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
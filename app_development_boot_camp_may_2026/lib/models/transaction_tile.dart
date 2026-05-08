import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../constants/app_theme.dart';
import '../providers/transaction_provider.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';

    return DateFormat('MMM d').format(date);
  }

  IconData getIcon(String icon) {
    switch (icon) {
      case 'shopping':
        return Icons.shopping_cart_outlined;

      case 'restaurant':
        return Icons.restaurant_outlined;

      case 'transport':
        return Icons.directions_car_outlined;

      case 'movie':
        return Icons.movie_outlined;

      case 'bag':
        return Icons.shopping_bag_outlined;

      case 'health':
        return Icons.favorite_border;

      case 'bolt':
        return Icons.bolt_outlined;

      case 'salary':
        return Icons.payments_outlined;

      case 'work':
        return Icons.work_outline;

      case 'gift':
        return Icons.card_giftcard_outlined;

      case 'investment':
        return Icons.trending_up_outlined;

      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Dismissible(
      key: Key(transaction.id),

      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        context
            .read<TransactionProvider>()
            .deleteTransaction(transaction.id);
      },

      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 24,
        ),
      ),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isIncome
                    ? AppTheme.income
                    : AppTheme.expense)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  getIcon(transaction.icon),
                  color: isIncome
                      ? AppTheme.primary
                      : Colors.black54,
                  size: 22,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${transaction.category} • ${_formatDate(transaction.date)}',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}৳${transaction.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.dmSans(
                    color: isIncome
                        ? AppTheme.income
                        : AppTheme.expense,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    context
                        .read<TransactionProvider>()
                        .deleteTransaction(transaction.id);
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
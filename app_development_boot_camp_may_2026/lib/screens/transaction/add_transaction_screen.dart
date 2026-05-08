import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../constants/app_theme.dart';

// Category options
const _expenseCategories = [
  ('Groceries', 'shopping'),
  ('Dining', 'restaurant'),
  ('Transport', 'transport'),
  ('Entertainment', 'movie'),
  ('Shopping', 'bag'),
  ('Health', 'health'),
  ('Utilities', 'bolt'),
  ('Other', 'wallet'),
];

const _incomeCategories = [
  ('Salary', 'salary'),
  ('Freelance', 'work'),
  ('Bonus', 'gift'),
  ('Investment', 'investment'),
  ('Other', 'wallet'),
];

void showAddTransactionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddTransactionSheet(),
  );
}

class _AddTransactionSheet extends StatefulWidget {
  const _AddTransactionSheet();

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  TransactionType _type = TransactionType.expense;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Groceries';

  String _selectedIcon = 'shopping';
  final _formKey = GlobalKey<FormState>();

  List<(String, String)> get _categories =>
      _type == TransactionType.expense ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    _resetCategory();
  }

  void _resetCategory() {
    _selectedCategory = _categories.first.$1;
    _selectedIcon = _categories.first.$2;
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
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TransactionProvider>();
    provider.addTransaction(Transaction(
      id: provider.generateId(),
      title: _titleController.text.trim(),
      category: _selectedCategory,
      amount: double.parse(_amountController.text.trim()),
      date: DateTime.now(),
      type: _type,
      icon: _selectedIcon,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              Text(
                'Add Transaction',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
          
              // Income / Expense toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _TypeTab(
                      label: 'Expense',
                      selected: _type == TransactionType.expense,
                      color: AppTheme.expense,
                      onTap: () => setState(() {
                        _type = TransactionType.expense;
                        _resetCategory();
                      }),
                    ),
                    _TypeTab(
                      label: 'Income',
                      selected: _type == TransactionType.income,
                      color: AppTheme.income,
                      onTap: () => setState(() {
                        _type = TransactionType.income;
                        _resetCategory();
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
          
              // Title field
              _InputLabel('Title'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.dmSans(color: AppTheme.textPrimary, fontSize: 14),
                decoration: _inputDecoration('e.g. Starbucks, Salary...'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Title required' : null,
              ),
              const SizedBox(height: 14),
          
              // Amount field
              _InputLabel('Amount (\৳)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.dmSans(color: AppTheme.textPrimary, fontSize: 14),
                decoration: _inputDecoration('0.00'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Amount required';
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 14),
          
              // Category picker
              _InputLabel('Category'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final selected = _selectedCategory == cat.$1;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategory = cat.$1;
                      _selectedIcon = cat.$2;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? (_type == TransactionType.expense
                            ? AppTheme.expense
                            : AppTheme.income)
                            .withOpacity(0.15)
                            : AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? (_type == TransactionType.expense
                              ? AppTheme.expense
                              : AppTheme.income)
                              : AppTheme.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getIcon(cat.$2),
                            size: 18,
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat.$1,
                            style: GoogleFonts.dmSans(
                              color: selected
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
          
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _type == TransactionType.expense
                        ? AppTheme.expense
                        : AppTheme.income,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add ${_type == TransactionType.expense ? 'Expense' : 'Income'}',
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
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(color: AppTheme.textMuted, fontSize: 14),
      filled: true,
      fillColor: AppTheme.cardBg,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.expense),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.expense),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;
  const _InputLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        color: AppTheme.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeTab({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: selected
                ? Border.all(color: color.withOpacity(0.5))
                : Border.all(color: Colors.transparent),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: selected ? color : AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
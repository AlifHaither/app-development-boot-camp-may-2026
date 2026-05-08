import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String icon;

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'icon': icon,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      icon: json['icon'],
    );
  }
}

// enum TransactionType { income, expense }
//
// class Transaction {
//   final String id;
//   final String title;
//   final String category;
//   final double amount;
//   final DateTime date;
//   final TransactionType type;
//   final String icon;
//
//   Transaction({
//     required this.id,
//     required this.title,
//     required this.category,
//     required this.amount,
//     required this.date,
//     required this.type,
//     required this.icon,
//   });
// }
//
// class AppData {
//   static final List<Transaction> transactions = [
//     Transaction(
//       id: '1',
//       title: 'Whole Foods Market',
//       category: 'Groceries',
//       amount: 142.50,
//       date: DateTime.now(),
//       type: TransactionType.expense,
//       icon: '🛒',
//     ),
//     Transaction(
//       id: '2',
//       title: 'The Botanical Cafe',
//       category: 'Dining',
//       amount: 45.00,
//       date: DateTime.now().subtract(const Duration(days: 1)),
//       type: TransactionType.expense,
//       icon: '🍽️',
//     ),
//     Transaction(
//       id: '3',
//       title: 'Freelance Project',
//       category: 'Income',
//       amount: 1200.00,
//       date: DateTime(2026, 4, 24),
//       type: TransactionType.income,
//       icon: '💼',
//     ),
//     Transaction(
//       id: '4',
//       title: 'Netflix',
//       category: 'Entertainment',
//       amount: 15.99,
//       date: DateTime(2026, 4, 22),
//       type: TransactionType.expense,
//       icon: '🎬',
//     ),
//     Transaction(
//       id: '5',
//       title: 'Salary',
//       category: 'Income',
//       amount: 5000.00,
//       date: DateTime(2026, 4, 20),
//       type: TransactionType.income,
//       icon: '💰',
//     ),
//     Transaction(
//       id: '6',
//       title: 'Uber Ride',
//       category: 'Transport',
//       amount: 22.50,
//       date: DateTime(2026, 4, 19),
//       type: TransactionType.expense,
//       icon: '🚗',
//     ),
//     Transaction(
//       id: '7',
//       title: 'Amazon Purchase',
//       category: 'Shopping',
//       amount: 89.99,
//       date: DateTime(2026, 4, 18),
//       type: TransactionType.expense,
//       icon: '📦',
//     ),
//     Transaction(
//       id: '8',
//       title: 'Gym Membership',
//       category: 'Health',
//       amount: 49.00,
//       date: DateTime(2026, 4, 17),
//       type: TransactionType.expense,
//       icon: '🏋️',
//     ),
//     Transaction(
//       id: '9',
//       title: 'Bonus',
//       category: 'Income',
//       amount: 1250.00,
//       date: DateTime(2026, 4, 15),
//       type: TransactionType.income,
//       icon: '🎁',
//     ),
//     Transaction(
//       id: '10',
//       title: 'Electric Bill',
//       category: 'Utilities',
//       amount: 78.00,
//       date: DateTime(2026, 4, 14),
//       type: TransactionType.expense,
//       icon: '⚡',
//     ),
//     Transaction(
//       id: '11',
//       title: 'Starbucks',
//       category: 'Dining',
//       amount: 6.50,
//       date: DateTime(2026, 4, 13),
//       type: TransactionType.expense,
//       icon: '☕',
//     ),
//     Transaction(
//       id: '12',
//       title: 'Book Store',
//       category: 'Shopping',
//       amount: 34.00,
//       date: DateTime(2026, 4, 12),
//       type: TransactionType.expense,
//       icon: '📚',
//     ),
//   ];
//
//   static double get totalIncome => transactions
//       .where((t) => t.type == TransactionType.income)
//       .fold(0, (sum, t) => sum + t.amount);
//
//   static double get totalExpense => transactions
//       .where((t) => t.type == TransactionType.expense)
//       .fold(0, (sum, t) => sum + t.amount);
//
//   static double get totalBalance => 24850.00;
//
//   static double get monthlyBudget => 4800.0;
//   static double get monthlySpent => 3120.0;
// }
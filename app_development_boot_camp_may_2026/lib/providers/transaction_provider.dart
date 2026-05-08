import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  static const String storageKey = 'transactions_data';

  final List<Transaction> _transactions = [];

  TransactionProvider() {
    loadTransactions();
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    saveTransactions();
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    saveTransactions();
    notifyListeners();
  }

  List<Transaction> get transactions {
    final list = [..._transactions];

    list.sort((a, b) => b.date.compareTo(a.date));

    return list;
  }

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  Map<String, double> get categoryBreakdown {
    final map = <String, double>{};

    for (final t
    in _transactions.where((t) => t.type == TransactionType.expense)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }

    return map;
  }

  static const double monthlyBudget = 20000.0;

  double get monthlySpent => _transactions
      .where((t) =>
  t.type == TransactionType.expense &&
      t.date.month == DateTime.now().month &&
      t.date.year == DateTime.now().year)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get budgetPercentage =>
      (monthlySpent / monthlyBudget).clamp(0.0, 1.0);

  // Future<void> addTransaction(Transaction transaction) async {
  //   _transactions.insert(0, transaction);
  //
  //   await saveTransactions();
  //
  //   notifyListeners();
  // }
  //
  // Future<void> deleteTransaction(String id) async {
  //   _transactions.removeWhere((t) => t.id == id);
  //
  //   await saveTransactions();
  //
  //   notifyListeners();
  // }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final data =
    _transactions.map((t) => jsonEncode(t.toJson())).toList();

    await prefs.setStringList(storageKey, data);
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(storageKey);

    if (data != null && data.isNotEmpty) {
      _transactions.clear();

      _transactions.addAll(
        data.map(
              (e) => Transaction.fromJson(jsonDecode(e)),
        ),
      );

      notifyListeners();
    } else {
      _loadDemoData();
    }
  }

  void _loadDemoData() {
    _transactions.addAll([
      Transaction(
        id: '1',
        title: 'Salary',
        category: 'Income',
        amount: 5000,
        date: DateTime.now(),
        type: TransactionType.income,
        icon: 'salary',
      ),
      Transaction(
        id: '2',
        title: 'Groceries',
        category: 'Groceries',
        amount: 120,
        date: DateTime.now(),
        type: TransactionType.expense,
        icon: 'shopping',
      ),
    ]);

    saveTransactions();
    notifyListeners();
  }
}
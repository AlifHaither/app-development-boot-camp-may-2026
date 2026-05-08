import 'package:app_development_boot_camp_may_2026/constants/app_theme.dart';
import 'package:app_development_boot_camp_may_2026/screens/transaction/add_transaction_screen.dart';
import 'package:app_development_boot_camp_may_2026/screens/analytics/analytics_screen.dart';
import 'package:app_development_boot_camp_may_2026/screens/history/history_screen.dart';
import 'package:app_development_boot_camp_may_2026/screens/home/home_screen.dart';
import 'package:app_development_boot_camp_may_2026/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import 'package:provider/provider.dart';
class BottomBar extends StatefulWidget {
  //static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  void onViewAllTap() {
    setState(() {
      _page = 1;
    });
  }



  void updatePage(int page){
    setState(() {
      _page = page;
    });
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(onViewAllTap: onViewAllTap),
      const HistoryScreen(),
      const AnalyticsScreen(),
      const ProfileScreen()
    ];
    //final userCartLen = context.watch<UserProvider>
    return Scaffold(
      body: pages[_page],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          showAddTransactionSheet(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: _page,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          iconSize: 28,
          onTap: updatePage,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: _page == 0
                            ? Colors.green
                            : Colors.white,
                        width: bottomBarBorderWidth,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.home_outlined),
                ),
              label: '',
            ),
            // Account
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page  == 1
                          ? Colors.green
                          : Colors.white,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(Icons.manage_history_outlined),
            ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 2
                          ? Colors.green
                          : Colors.white,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(Icons.analytics_outlined),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 3
                          ? Colors.green
                          : Colors.white,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(Icons.person_outline),
              ),
              label: '',
            ),
      ],
      ),
    );
  }
}
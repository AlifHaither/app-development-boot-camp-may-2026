import 'dart:async';
import 'package:app_development_boot_camp_may_2026/common/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 4), (){
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               HomeScreen()));
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffdff5ec),
                Color(0xfff4fbf8),
                Color(0xffffffff),
          ],
            stops: [0.0, 0.28, 0.35],
          ),
        ),
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/mExpenseLogo.png',
                          height: 45,
                          width: 45,
                        ),
                        //Image.asset() sudhu file jemon ache temon show kore
                        SizedBox(width: 5,),
                        Text(
                          "MExpense",
                          style: GoogleFonts.saira(
                            color: Colors.black,
                            fontSize: 35,
                            //fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  //SizedBox(height: 80,),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: Offset(0, 10),
                          ),
                        ]
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                          child: Image.asset(
                            'assets/images/mExpense.png',
                            width: 50,
                            height: 50,
                          ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 5,),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Financial clarity,\nsimplified.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Track, manage, and find peace of mind\nwith your daily expenses.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24,
                            right: 24,
                            bottom: 32
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const BottomBar(),
                                ),
                                    (route) => false,
                              );
                            }, child: const Text("Let's get started",
                            style: TextStyle(fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                            ),
                          ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff1f7a67),
                                padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}